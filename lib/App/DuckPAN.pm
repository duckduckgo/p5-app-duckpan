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
use List::Util qw( first );
use LWP::UserAgent;
use LWP::Simple;
use Parse::CPAN::Packages::Fast;
use File::Temp qw/ :POSIX /;
use Term::UI;
use Term::ReadLine;
use Carp;
use Encode;
use Perl::Version;
use Path::Tiny;

our $VERSION ||= '9.999';

option dukgo_login => (
	is => 'ro',
	lazy => 1,
	default => sub { 'https://duck.co/my/login' }
);

option no_check => (
	is => 'ro',
	lazy => 1,
	default => sub { 0 }
);

option verbose => (
	is      => 'ro',
	lazy    => 1,
	short   => 'v',
	default => sub { 0 },
);

has duckpan_packages => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_duckpan_packages {
	my $self = shift;

	my $gz         = '02packages.details.txt.gz';
	my $package_url = join('/', $self->duckpan, 'modules', $gz);
	my $mirror_to   = $self->cfg->cache_path->child($gz);

	if (is_error(mirror($package_url, $mirror_to))) {
		$self->exit_with_msg(-1, "Cannot download $package_url");
	}

	return Parse::CPAN::Packages::Fast->new($mirror_to->openr);
}

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

has ia_types => (
	is => 'ro',
	lazy => 1,
	builder => '_build_ia_types',
);

sub _build_ia_types {
    my $ddg_path = path('lib', 'DDG');
    my $t_dir = path('t');
    return [{
            name      => 'Goodie',
            dir       => $ddg_path->child('Goodie'),
            supported => 1,
            templates => {
                code => {
                    in  => path('template', 'lib', 'DDG', 'Goodie', 'Example.pm'),
                    out => $ddg_path->child('Goodie')
                },
                test => {
                    in  => path('template', 't', 'Example.t'),
                    out => $t_dir
                },
            },
        },
        {
            name      => 'Spice',
            dir       => $ddg_path->child('Spice'),
            supported => 1,
            templates => {
                code => {
                    in  => path('template', 'lib', 'DDG', 'Spice', 'Example.pm'),
                    out => $ddg_path->child('Spice')
                },
                test => {
                    in  => path('template', 't', 'Example.t'),
                    out => $t_dir
                },
                handlebars => {
                    in  => path('template', 'share', 'spice', 'example', 'example.handlebars'),
                    out => path('share',    'spice')
                },
                js => {
                    in  => path('template', 'share', 'spice', 'example', 'example.js'),
                    out => path('share',    'spice')
                },
            },
        },
        {
            name      => 'Fathead',
            dir       => $ddg_path->child('Fathead'),
            supported => 0
        },
        {
            name      => 'Longtail',
            dir       => $ddg_path->child('Longtail'),
            supported => 0
        },
    ];
}

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

sub _build_help { App::DuckPAN::Help->new( ) }

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
			if ($_ =~ /^www/i ||
				$_ =~ /^dist/i ||
				$_ =~ /^ddg/i ||
				$_ =~ /^app/i) {
				push @modules, $_;
			} elsif ($_ =~ m/^(duckpan|upgrade|update|reinstall)$/i) {
				$self->empty_cache();
				push @modules, 'App::DuckPAN';
				push @modules, 'DDG' if $_ =~ /^(?:upgrade|reinstall)$/i;
				unshift @modules, 'reinstall' if lc($_) eq 'reinstall';
			} else {
				push @left_args, $_;
			}
		}
		exit $self->perl->duckpan_install(@modules) unless @left_args;
	}
	$self->exit_with_msg(0, "Unknown command. Use `duckpan help` to see the list of available DuckPAN commands.");
}

sub show_msg { shift->_print_msg(*STDOUT, @_); }

sub _print_msg {
	my ($self, $fh, @lines) = @_;

	foreach my $line (grep { $_ } @lines) {
		print $fh $line . "\n";
	}
}

sub error_msg {
	my ($self, @msg) = @_;

	$self->_print_msg(*STDERR, map { '[ERROR] ' . $_ } grep { $_ } @msg);
}

sub exit_with_msg {
	my ($self, $exit_code, @msg) = @_;

	my $which_way = *STDOUT;    # By default, print to STDOUT before exit;

	if ($exit_code != 0) {      # But if it's an unhappy exit
		$which_way = *STDERR;                                     # Print to STDERR
		@msg = map { '[FATAL ERROR] ' . $_ } grep { $_ } @msg;    # And append error warning
	}

	$self->_print_msg($which_way, @msg);
	exit $exit_code;
}

sub verbose_msg {
	my ($self, @lines) = @_;

	return unless $self->verbose && @lines;    # only show actual messages in verbose mode.

	# Someday we may wish to do something more with these, but for now it's just show_msg.
	return $self->_print_msg(*STDOUT, @lines);
}

sub warning_msg {
	my ($self, @msg) = @_;

	$self->_print_msg(*STDOUT, map { '[NOTICE] ' . $_ } grep { $_ } @msg);
}

sub camel_to_underscore {
 my ($self, $name) = @_;
	# Replace first capital by lowercase
	# if followed my lowercase.
	$name =~ s/^([A-Z])([a-z])/lc($1).$2/ge;
	# Substitute camelCase to camel_case
	$name =~ s/([a-z])([A-Z])/$1.'_'.lc($2)/ge;
	return lc $name;
}

sub phrase_to_camel {
 my ($self, $phrase) = @_;
	# Other things imply camelCase, we're going with CamelCase, kinda.
	return join('', map { ucfirst $_; } (split /\s+/, $phrase));
}

sub check_requirements {
	my ( $self ) = @_;
	my $fail = 0;
	$self->show_msg("Checking your environment for the DuckPAN requirements");
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
	my $ok = 0;
	$self->show_msg("Checking for git... ");
	if (my $git = which('git')) {
		my $version_string = `$git --version`;
		if ($version_string =~ m/git version (\d+)\.(\d+)/) {
			if ($1 <= 1 && $2 < 7) {
				$self->show_msg("require minimum 1.7");
			} else {
				$self->show_msg($git);
				$ok = 1;
			}
		} else {
			$self->show_msg("Unknown version!");
		}
	} else {
		$self->show_msg("No!");
	}
	return $ok;
}

sub check_ssh {
	my ( $self ) = @_;
	my $ok = 0;
	$self->show_msg("Checking for ssh... ");
	if (my $ssh = which('ssh')) {
		$self->show_msg($ssh);
		$ok = 1;
	} else {
		$self->show_msg("No!");
	}
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

my %perl_versions = (
    required    => Perl::Version->new('v5.14'),
    recommended => Perl::Version->new('v5.16'),
);

sub verify_versions {
	my ($self) = @_;

	my $installed_version = Perl::Version->new($]);

	$self->exit_with_msg(1, 'perl ' . $perl_versions{required}->normal . ' or higher is required. ', $installed_version->normal . ' is installed.')
	  if ($installed_version->vcmp($perl_versions{required}) < 0);
	$self->warning_msg('perl ' . $perl_versions{recommended}->normal . ' or higher is recommended. ', $installed_version->normal . " is installed.")
	  if ($installed_version->vcmp($perl_versions{recommended}) < 0);
	$self->exit_with_msg(1, 'App::DuckPAN check failed') unless $self->check_app_duckpan;
	$self->exit_with_msg(1, 'DDG check failed')          unless $self->check_ddg;

	return;
}

sub check_app_duckpan {
	my ($self) = @_;
	return 1 if $self->no_check;
	my $ok                = 1;
	my $installed_version = $self->get_local_app_duckpan_version;
	return $ok if $installed_version && $installed_version == '9.999';
	$self->show_msg("Checking for latest App::DuckPAN... ");
	my $packages = $self->duckpan_packages;
	my $module   = $packages->package('App::DuckPAN');
	my $latest   = $self->duckpan . 'authors/id/' . $module->distribution->pathname;
	if ($installed_version && version->parse($installed_version) >= version->parse($module->version)) {
		my $msg = "App::DuckPAN version: $installed_version";
		$msg .= " (duckpan has " . $module->version . ")" if $installed_version ne $module->version;
		$self->verbose_msg($msg);
	} else {
		my @msg = ("Please install the latest App::DuckPAN package with: duckpan upgrade");
		unshift @msg, "You have version " . $installed_version . ", latest is " . $module->version . "!" if ($installed_version);
		$self->warning_msg(@msg);
		$ok = 0;
	}
	return $ok;
}

sub check_ddg {
	my ($self) = @_;
	return 1 if $self->no_check;
	my $ok                = 1;
	my $installed_version = $self->get_local_ddg_version;
	return $ok if $installed_version && $installed_version == '9.999';
	$self->show_msg("Checking for latest DDG Perl package...");
	my $packages = $self->duckpan_packages;
	my $module   = $packages->package('DDG');
	my $latest   = $self->duckpan . 'authors/id/' . $module->distribution->pathname;
	if ($installed_version && version->parse($installed_version) >= version->parse($module->version)) {
		my $msg = "DDG version: $installed_version";
		$msg .= " (duckpan has " . $module->version . ")" if $installed_version ne $module->version;
		$self->verbose_msg($msg);
	} else {
		my @msg = ("Please install the latest DDG package with: duckpan DDG");
		if ($installed_version) {
			unshift @msg, "You have version " . $installed_version . ", latest is " . $module->version . "!";
		} else {
			unshift @msg, "You don't have DDG installed! Latest is " . $module->version . "!";
		}
		$self->warning_msg(@msg);
		$ok = 0;
	}
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

sub get_ia_type {
	my ($self) = @_;

	my $ia_type = first { $_->{dir}->is_dir } @{$self->ia_types};

	$self->exit_with_msg(-1, 'Must be run from the root of a checked-out Instant Answer repository.') unless ($ia_type);
	$self->exit_with_msg(-1, "Sorry, DuckPAN does not support " . $ia_type->{name} . " yet!") if $ia_type->{supported} == 0;

	return $ia_type;
}

sub empty_cache {
	my ($self) = @_;
	# Clear cache so share files are written into cache
	my $cache = $self->cfg->cache_path;
	$self->show_msg("Emptying DuckPAN cache...");
	$cache->remove_tree({keep_root => 1});
	$self->show_msg("DuckPAN cache emptied");
}

sub BUILD {
	my ($self) = @_;

	$self->exit_with_msg(1, 'We dont support Win32') if ($^O eq 'MSWin32');
	my $env_config = $self->cfg->config_path->child('env.ini');
	if ($env_config->exists) {
		my $env = Config::INI::Reader->read_file($env_config);
		map { $ENV{$_} = $env->{'_'}{$_}; } keys %{$env->{'_'}} if $env->{'_'};
	}
}

1;

=pod

=head1 DuckPAN

The DuckDuckHack Testing Tool

=head2 SYNPOSIS

DuckPAN is an application built to provide developers a testing environment for DuckDuckHack Instant Answers. It allows you to test instant answer triggers and preview their visual design and output.

C<duckpan help> provides more detailed information.

=head1 SEE ALSO

=over 4

=item L<https://github.com/duckduckgo/p5-app-duckpan/>

=item L<https://github.com/duckduckgo/>

=item L<https://duckduckgo.com/>

=item L<https://duck.co/>

=item L<http://duckpan.org/>

=back

=head1 CONTRIBUTION

To contribute to DuckPAN, please visit L<https://github.com/duckduckgo/p5-app-duckpan>. We also welcome and encourage contributions from our community. Please visit L<http://duckduckhack.com/> to contribute new instant answers, or visit L<https://duck.co/ideas> to share your ideas and instant answer source suggestions.

=head1 SUPPORT

B<IRC>:

    We invite you to join us at B<#duckduckgo> on B<irc.freenode.net> for any queries and lively discussion.

B<Repository>:

    L<https://github.com/duckduckgo/p5-app-duckpan>

B<Issue Tracker>:

    L<https://github.com/duckduckgo/p5-app-duckpan/issues>

=cut
