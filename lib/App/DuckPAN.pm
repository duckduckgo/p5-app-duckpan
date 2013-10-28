package App::DuckPAN;
# ABSTRACT: The DuckDuckGo DuckPAN client


use Moo;
use MooX::Cmd;
use MooX::Options;
use App::DuckPAN::Config;
use App::DuckPAN::Help;
use File::Which;
use Class::Load ':all';
use HTTP::Request::Common qw( GET POST );
use HTTP::Status;
use LWP::UserAgent;
use LWP::Simple;
use Parse::CPAN::Packages::Fast;
use File::Temp qw/ :POSIX /;
use Class::Load ':all';
use Term::UI;
use Term::ReadLine;
use Carp;
use Encode;
use Path::Class;

our $VERSION ||= '9.999';

option dukgo_login => (
	is => 'ro',
	lazy => 1,
	default => sub { 'https://dukgo.com/my/login' }
);

option no_check => (
	is => 'ro',
	lazy => 1,
	default => sub { 0 }
);

option duckpan_packages => (
	is => 'ro',
	lazy => 1,
	default => sub { shift->duckpan.'/modules/02packages.details.txt.gz' }
);

option duckpan => (
	is => 'ro',
	lazy => 1,
	default => sub { 'http://duckpan.org/' }
);

sub _ua_string {
  my ($self) = @_;
  my $class   = ref $self || $self;
  my $version = $class->VERSION;
 
  return "$class/$version";
}

option http_proxy => (
	is => 'ro',
	predicate => 1,
);

option config => (
	is => 'ro',
	predicate => 1,
);

option cache => (
	is => 'ro',
	predicate => 1,
);

has term => (
	is => 'ro',
	lazy => 1,
	builder => '_build_term',
);

sub _build_term { Term::ReadLine->new('duckpan') }

sub get_reply {
	my ( $self, $prompt, %params ) = @_;
	my $return = $self->term->get_reply( prompt => $prompt, %params );
	Encode::_utf8_on($return);
	return $return;
}

has http => (
	is => 'ro',
	builder => '_build_http',
	lazy => 1,
);

sub _build_http {
	my ( $self ) = @_;
	my $agent = LWP::UserAgent->new;
	$agent->agent($self->_ua_string);
	$agent->env_proxy;
	$agent->proxy( http => $self->http_proxy ) if $self->has_http_proxy;
	return $agent;
}

has server_hostname => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_server_hostname { defined $ENV{APP_DUCKPAN_SERVER_HOSTNAME} ? $ENV{APP_DUCKPAN_SERVER_HOSTNAME} : 'duckduckgo.com' }

has cfg => (
	is => 'ro',
	lazy => 1,
	builder => 1,
	handles => [qw(
		config_path
		config_file
		set_config
		get_config
	)]
);

sub _build_cfg {
	my ( $self ) = @_;
	App::DuckPAN::Config->new(
		$self->has_config ? ( config_path => $self->config ) : (),
		$self->has_cache ? ( cache_path => $self->cache ) : (),
	);
}

has help => (
	is => 'ro',
	builder => '_build_help',
	lazy => 1,
);

sub _build_help { App::DuckPAN::Help->new( version => $VERSION ) }

has perl => (
	is => 'ro',
	builder => '_build_perl',
	lazy => 1,
);

sub _build_perl { 
	load_class('App::DuckPAN::Perl');
	App::DuckPAN::Perl->new( app => shift );
}

has ddg => (
	is => 'ro',
	builder => '_build_ddg',
	lazy => 1,
);

sub _build_ddg { 
	load_class('App::DuckPAN::DDG');
	App::DuckPAN::DDG->new( app => shift );
}

sub execute {
	my ( $self, $args, $chain ) = @_;
	my @arr_args = @{$args};
	if (@arr_args) {
		my @modules;
		my @left_args;
		for (@arr_args) {
			if ($_ =~ /^ddg/i || $_ =~ /^app::duckpan/i) {
				push @modules, $_;
			} elsif (lc($_) eq 'duckpan' or lc($_) eq 'upgrade') {
				push @modules, 'App::DuckPAN';
				push @modules, 'DDG' if lc($_) eq 'upgrade';
			} else {
				push @left_args, $_;
			}
		}
		exit $self->perl->duckpan_install(@modules) unless @left_args;
	}
	print $self->help->help;
	exit 0;
}

sub print_text {
	shift;
	for (@_) {
		print "\n";
		my @words = split(/\s+/,$_);
		my $current_line = "";
		for (@words) {
			if ((length $current_line) + (length $_) < 79) {
				$current_line .= " " if length $current_line;
				$current_line .= $_;
			} else {
				print $current_line."\n";
				$current_line = $_;
			}
		}
		print $current_line."\n" if length $current_line;
	}
	print "\n";
}

sub camel_to_underscore {
 my ($self, $name) = @_;
	# Replace first capital by lowercase
	# if followed my lowercase.
	$name =~ s/^([A-Z])([a-z])/lc($1).$2/e;
	# Substitute camelCase to camel_case
	$name =~ s/([a-z])([A-Z])/$1.'_'.lc($2)/ge;
	return lc $name;
}

sub check_requirements {
	my ( $self ) = @_;
	my $fail = 0;
	print "\nChecking your environment for the DuckPAN requirements\n\n";
	#$fail = 1 unless $self->check_locallib;
	$fail = 1 unless $self->check_ddg;
	$fail = 1 unless $self->check_git;
	$fail = 1 unless $self->check_ssh;
	if ($fail) {
		return 1;
	}
	return 0;
}

sub check_git {
	my ( $self ) = @_;
	my $ok = 1;
	print "Checking for git... ";
	if (my $git = which('git')) {
		my $version_string = `$git --version`;
		if ($version_string =~ m/git version (\d+)\.(\d+)/) {
			if ($1 <= 1 && $2 < 7) {
				print "require minimum 1.7"; $ok = 0;
			} else {
				print $git;
			}
		} else {
			print "Unknown version!"; $ok = 0;
		}
	} else {
		print "No!"; $ok = 0;
	}
	print "\n";
	return $ok;
}

sub check_ssh {
	my ( $self ) = @_;
	my $ok = 1;
	print "Checking for ssh... ";
	if (my $ssh = which('ssh')) {
		print $ssh;
	} else {
		print "No!"; $ok = 0;
	}
	print "\n";
	return $ok;
}

sub get_local_ddg_version {
	my ( $self ) = @_;
	return $self->perl->get_local_version('DDG');
}

sub get_local_app_duckpan_version {
	my ( $self ) = @_;
	return $self->perl->get_local_version('App::DuckPAN');
}

sub check_app_duckpan {
	my ( $self ) = @_;
	my $ok = 1;
	my $installed_version = $self->get_local_app_duckpan_version;
	return $ok if $installed_version && $installed_version == '9.999';
	print "Checking for latest App::DuckPAN ... ";
	my $tempfile = tmpnam;
	if (is_success(getstore($self->duckpan_packages,$tempfile))) {
		my $packages = Parse::CPAN::Packages::Fast->new($tempfile);
		my $module = $packages->package('App::DuckPAN');
		my $latest = $self->duckpan.'authors/id/'.$module->distribution->pathname;
		if ($installed_version && version->parse($installed_version) >= version->parse($module->version)) {
			print $installed_version;
			print " (duckpan has ".$module->version.")" if $installed_version ne $module->version;
		} else {
			if ($installed_version) {
				print "You have version ".$installed_version.", latest is ".$module->version."!\n";
			}
			print "[ERROR] Please install the latest App::DuckPAN package with: duckpan upgrade\n";
			$ok = 0;
		}
	} else {
		print "[ERROR] Can't download ".$self->duckpan_packages;
		$ok = 0;
	}
	print "\n";
	return $ok;
}

sub check_ddg {
	my ( $self ) = @_;
	my $ok = 1;
	my $installed_version = $self->get_local_ddg_version;
	return $ok if $installed_version && $installed_version == '9.999';
	print "Checking for latest DDG Perl package... ";
	my $tempfile = tmpnam;
	if (is_success(getstore($self->duckpan_packages,$tempfile))) {
		my $packages = Parse::CPAN::Packages::Fast->new($tempfile);
		my $module = $packages->package('DDG');
		my $latest = $self->duckpan.'authors/id/'.$module->distribution->pathname;
		if ($installed_version && version->parse($installed_version) >= version->parse($module->version)) {
			print $installed_version;
			print " (duckpan has ".$module->version.")" if $installed_version ne $module->version;
		} else {
			if ($installed_version) {
				print "You have version ".$installed_version.", latest is ".$module->version."!\n";
			} else {
				print "You don't have DDG installed! Latest is ".$module->version."!\n";
			}
			print "[ERROR] Please install the latest DDG package with: duckpan DDG\n";
			$ok = 0;
		}
	} else {
		print "[ERROR] Can't download ".$self->duckpan_packages;
		$ok = 0;
	}
	print "\n";
	return $ok;
}

sub checking_dukgo_user {
	my ( $self, $user, $pass ) = @_;
	my $response = $self->http->request(POST($self->dukgo_login, Content => {
		username => $user,
		password => $pass,
	}));
	$response->code == 302 ? 1 : 0; # workaround, need something in dukgo
}

sub BUILD {
	my ( $self ) = @_;
	if ($^O eq 'MSWin32') {
		print "\n[ERROR] We dont support Win32\n\n";
		exit 1;
	}
    my $env_config = file($self->cfg->config_path, 'env.ini');
    if (-e $env_config) {
        my $env = Config::INI::Reader->read_file(file($self->cfg->config_path, 'env.ini'));
        map { $ENV{$_} = $env->{'_'}{$_}; } keys %{$env->{'_'}} if $env->{'_'};
    }
}

1;

=encoding utf8

=head1 SYNPOSIS

L<DuckDuckGo|http://duckpan.org/> is a release platform for
L<DuckDuckGo|https://duckduckgo.com/> open source code.

DuckPAN also contains a suite of tools for testing and debugging ZeroClickInfo
plugins.

=head2 INSTALL COMMANDS

DuckPAN is an application built to provide developers a testing environment
for the ZeroClickInfo Plugins. It allows users to test plugin triggers,
and lets you preview their visual design. 

  duckpan installdeps
  # Install all requirements of the specific DuckDuckHack project (if
  # possible), like zeroclickinfo-spice, zeroclickinfo-goodie, duckduckgo
  # or community-platform

  duckpan check
  # Check if you fulfill all requirements for the development
  # environment (this is run automatically during setup)

=head2 PLUGIN TESTING

  duckpan query
  # Test goodies and spice triggers interactively on the command line

  duckpan server
  # Test spice plugins on a local web server (for design/layout purposes)

=head2 ADVANCED FEATURES

  duckpan env
  # View env commands and also shows the env variables currently stored in ~/.duckpan/env.ini

  duckpan env <name> <value>
  # Add an environment variable that duckpan will remember. Useful for
  # spice API keys. Variables are stored in ~/.duckpan/env.ini

  duckpan env <name>
  # Retrieve the matching key for a given env variable.

  duckpan env rm <name>
  # Remove an environment variable from duckpan

  # For the followings you need an account at L<https://dukgo.com/>

  duckpan release
  # Release the project of the current directory to DuckPAN

  duckpan setup
  # BETA FEATURE
  # Setup your environment for using Dist::Zilla::Plugin::UploadToDuckPAN

=head1 SUPPORT
 
Issue Tracker: L<https://github.com/duckduckgo/p5-app-duckpan/issues>

IRC: #duckduckgo on irc.freenode.net (join us!)

=head1 CONTRIBUTE

Pull requests and additional contributors are welcome

L<https://github.com/duckduckgo/p5-app-duckpan>

=head1 SEE ALSO

L<https://duckduckgo.com>

L<https://github.com/duckduckgo>

L<https://dukgo.com>

L<http://duckpan.org>
