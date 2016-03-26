package App::DuckPAN;
# ABSTRACT: The DuckDuckGo DuckPAN client

use feature 'state';

use Moo;
use MooX::Cmd;
use MooX::Options;
use App::DuckPAN::Config;
use File::Which;
use File::Basename;
use File::Find::Rule;
use Class::Load ':all';
use HTTP::Request::Common qw( GET POST );
use HTTP::Status;
use List::Util qw( first max );
use LWP::UserAgent;
use LWP::Simple;
use Parse::CPAN::Packages::Fast;
use File::Temp qw/ :POSIX /;
use Term::ANSIColor;
use Term::UI;
use Term::ReadLine;
use Carp;
use Encode;
use Perl::Version;
use Path::Tiny;
use open qw/:std :utf8/;
use App::DuckPAN::Cmd::Help;

no warnings 'uninitialized';

option dev_version => (
	is => 'ro',
	default => 9.999,
	doc => 'Version used when using unreleased code, e.g. git repos'
);

option dukgo_my_account => (
	is => 'ro',
	lazy => 1,
	default => sub { 'https://duck.co/my/account' },
	doc => 'Account page URI - you need to be authed to get HTTP 200',
);

option dukgo_login => (
	is => 'ro',
	lazy => 1,
	default => sub { 'https://duck.co/my/login' },
	doc => 'URI to log into community platform. defaults to "https://duck.co/my/login"',
);

option check => (
	is          => 'ro',
	lazy        => 1,
	negativable => 1,
	default     => sub { 1 },
	doc         => 'perform requirements checks. turn off with --no-check',
);

option 'empty' => (
	is          => 'ro',
	lazy        => 1,
	short       => 'e',
	default     => sub { 0 },
	doc         => 'empty duckpan cache at start-up',
);

has cachesec => (
	is      => 'ro',
	lazy    => 1,
	default => sub { 60 * 60 * 4 },    # 4 hours by default
);

option colors => (
	is          => 'ro',
	lazy        => 1,
	negativable => 1,
	default     => sub { 1 },
	doc         => 'use color output. turn off with --no-colors',
);

option verbose => (
	is      => 'ro',
	lazy    => 1,
	short   => 'v',
	default => sub { 0 },
	doc     => 'provide expanded output during operation',
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
		$self->emit_and_exit(-1, "Cannot download $package_url");
	}

	return Parse::CPAN::Packages::Fast->new($mirror_to->stringify);
}

option duckpan => (
	is => 'ro',
	lazy => 1,
	default => sub { 'http://duckpan.org/' },
	doc => 'URI for the duckpan package server. defaults to "https://duckpan.org/"',
);

sub _ua_string {
	my ($self) = @_;
	my $class   = ref $self || $self;
	my $version = $class->VERSION || $self->dev_version;
	return "$class/$version";
}

option http_proxy => (
	is => 'ro',
	predicate => 1,
	doc => 'proxy to use for outbound HTTP requests',
);

option config => (
	is => 'ro',
	predicate => 1,
	doc => 'path to config directory. defaults to "~/.duckpan/config"',
);

option cache => (
	is => 'ro',
	predicate => 1,
	doc => 'path to cache directory. defaults to "~/.duckpan/cache"',
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

sub ask_yn {
	my ( $self, $prompt, %params ) = @_;

	return $self->term->ask_yn( prompt => $prompt, %params );
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
	my @arr_args = grep { $_ !~ /^-/} @{$args}; # Command line switches make it here, so we try to remove
	App::DuckPAN::Cmd::Help->run(1) if scalar @arr_args == 0;
	if (@arr_args) {
		my (@modules, @left_args, $ddg);
		for (@arr_args) {
			if (/^www/i ||
				/^dist/i ||
				/^(ddg)$/i ||
				/(opensourceduckduckgo)$/i ||
				/^(goodie)$/i || /^(spice)$/i || /^(fathead)$/i || /^(longtail)$/i ||
				/^ddgc?::/i ||
				/^app/i) {
				my $m = lc $1;

				if($m eq 'goodie' or $m eq 'spice' or $m eq 'fathead' or $m eq 'longtail'){
					$_ = 'DDG::' . ucfirst($m) . 'Bundle::OpenSourceDuckDuckGo';
					$m = 'opensourceduckduckgo';
				}

				if($m eq 'opensourceduckduckgo' && !$ddg){
					unshift @modules, 'DDG';
					$ddg = 1;
				}
				elsif($m eq 'ddg' && $ddg){ next }
				push @modules, $_;
			}
			elsif (m/^duckpan|update|(upgrade|(reinstall|latest))$/i) {
				my ($all_modules, $reinstall_latest) = map { lc } ($1, $2);
				$self->empty_cache unless $self->empty;
				push @modules, 'App::DuckPAN';
				if($all_modules){
					push @modules, 'DDG';
					unshift @modules, $reinstall_latest if $reinstall_latest;
				}
			}
			else {
				push @left_args, $_;
			}
		}
		exit $self->perl->duckpan_install(@modules) unless @left_args;
	}
	$self->emit_and_exit(0, "Unknown command. Use `duckpan help` to see the list of available DuckPAN commands.");
}

has standard_prefix_width => (
	is      => 'ro',
	default => sub { 9 },
);

sub _output_prefix {
	my ($self, $word, $color) = @_;

	my $extra_spaces = max(0, $self->standard_prefix_width - length($word) - 2 ); # 2 []s to be added.

	my $full_prefix = '[' . uc $word . ']' . (' ' x $extra_spaces);

	return ($self->colors) ? colored($full_prefix, $color) : $full_prefix;
}

sub emit_info {
	my ($self, @msg) = @_;

	$self->_print_msg(*STDOUT, '', @msg);
}

sub emit_error {
	my ($self, @msg) = @_;

	state $prefix = $self->_output_prefix('ERROR', 'red bold');

	$self->_print_msg(*STDERR, $prefix, @msg);
}

sub emit_and_exit {
	my ($self, $exit_code, @msg) = @_;

	state $prefix = $self->_output_prefix('FATAL', 'bright_red bold');

	if ($exit_code == 0) {      # This is just an info message.
		$self->emit_info(@msg);
	}
	else {                    # But if it's an unhappy exit
		$self->_print_msg(*STDERR, $prefix, @msg);
	}

	exit $exit_code;
}

sub emit_debug {
	my ($self, @msg) = @_;

	return unless $self->verbose;    # only show messages in verbose mode.

	return $self->_print_msg(*STDOUT, '', @msg);
}

sub emit_notice {
	my ($self, @msg) = @_;

	state $prefix = $self->_output_prefix('NOTICE', 'yellow bold');

	$self->_print_msg(*STDOUT, $prefix, @msg);
}

sub _print_msg {
	my ($self, $fh, $prefix, @lines) = @_;

	foreach my $line (map { $prefix . $_ } grep { $_ } @lines) {
		print $fh $line . "\n";
	}
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
	my $camel = $phrase;

	$camel =~ s/
		(?:           # if a character:
			  \s+     # - follows spaces
			| (?<=::) # - or follows ::
			| ^       # - or is the first character
		)(.)          # (the character)
		/\U$1/gx;     # then uppercase it (preceding spaces are removed)

	# remove trailing spaces
	$camel =~ s/\s+$//;

	return $camel;
}

has _ia_names => (
	is      => 'ro',
	lazy    => 1,
	builder => '_build_ia_names',
);

sub _build_ia_names {
	my $self = shift;
	my @test_paths = File::Find::Rule->name('*.t')->in('t');
	my @names = map { scalar(fileparse($_, qr/\.[^.]*/)) } @test_paths;
	return \@names;
}

# Normalize an Instant Answer name to a standard form.
# Returns undef if an IA matching the given name cannot be found.
sub normalize_ia_name {
	my ($self, $name) = @_;
	$name =~ s/_//g;
	$name = lc $self->phrase_to_camel($name);
	my $known_ias = $self->_ia_names();
	return first { lc $_ eq $name } @$known_ias;
}

sub check_requirements {
		my ($self) = @_;

		if (!$self->check) {
				$self->emit_notice("Requirements checking was disabled...");
				return 1;
		}
		my $signal_file = $self->cfg->cache_path->child('perl_checked');
		my $last_checked_perl = ($signal_file->exists) ? $signal_file->stat->mtime : 0;
		if ((time - $last_checked_perl) <= $self->cachesec) {
				$self->emit_debug("Perl module versions recently checked, skipping requirements check...");
		}
		else {
				$self->emit_info("Checking for DuckPAN requirements...");

				$self->emit_and_exit(1, 'Requirements check failed')
				  unless (
						$self->check_perl &&
						$self->check_app_duckpan &&
						$self->check_ddg &&
						$self->check_ssh &&
						$self->check_git);
		}
		$signal_file->touch;

		return 1;
}

sub get_local_ddg_version {
	my ( $self ) = @_;
	return $self->perl->get_local_version('DDG');
}

sub get_local_app_duckpan_version {
	my ( $self ) = @_;
	return $self->perl->get_local_version('App::DuckPAN');
}


sub check_git {
	my ( $self ) = @_;
	my $ok = 0;
	$self->emit_info("Checking for git...");
	if (my $git = which('git')) {
		my $version_string = `$git --version`;
		if ($version_string =~ m/git version (\d+)\.(\d+)/) {
			if ($1 <= 1 && $2 < 7) {
				$self->emit_error("require minimum git 1.7");
			}
			else {
				$self->emit_debug($git);
				$ok = 1;
			}
		}
		else {
			$self->emit_error("Unknown git version!");
		}
	}
	else {
		$self->emit_error("git not found");
	}
	return $ok;
}

sub check_ssh {
	my ( $self ) = @_;
	my $ok = 0;
	$self->emit_info("Checking for ssh...");
	if (my $ssh = which('ssh')) {
		$self->emit_debug($ssh);
		$ok = 1;
	}
	else {
		$self->emit_error('ssh not found');
	}
	return $ok;
}

my %perl_versions = (
	required    => Perl::Version->new('v5.14'),
	recommended => Perl::Version->new('v5.16'),
);

sub check_perl {
	my ($self) = @_;

	$self->emit_info("Checking perl version... ");
	my $installed_version = Perl::Version->new($]);

	my $ok = 1;
	if ($installed_version->vcmp($perl_versions{required}) < 0) {
		$self->emit_error('perl ' . $perl_versions{required}->normal . ' or higher is required. ', $installed_version->normal . ' is installed.');
		$ok = 0;
	}
	elsif ($installed_version->vcmp($perl_versions{recommended}) < 0) {
		$self->emit_notice('perl ' . $perl_versions{recommended}->normal . ' or higher is recommended. ',
			$installed_version->normal . " is installed.");
	}
	else {
		$self->emit_debug($installed_version->normal);
	}

	return $ok;
}

sub check_app_duckpan {
	my ($self) = @_;
	my $ok                = 1;
	my $pin_version       = $ENV{"DuckPAN"} || undef;
	my $installed_version = $self->get_local_app_duckpan_version;
	return $ok if $installed_version && $installed_version == $self->dev_version;
	$self->emit_info("Checking for latest App::DuckPAN... ");
	my $packages = $self->duckpan_packages;
	my $module   = $packages->package('App::DuckPAN');
	my $latest   = $self->duckpan . 'authors/id/' . $module->distribution->pathname;
	my $latest_version = version->parse($module->version);

	if ($installed_version >= $latest_version) {
		my $msg = "App::DuckPAN version: $installed_version";
		$msg .= " (duckpan has " . $module->version . ")" if $installed_version ne $module->version;
		$self->emit_debug($msg);
	}
	else {
		my @msg = (
			"You have version $installed_version, latest is " . $module->version . "!",
			"Please install the latest App::DuckPAN package with: duckpan upgrade"
		);
		$self->emit_notice(@msg);
	}
	return $ok;
}

sub check_ddg {
	my ($self) = @_;
	my $ok                = 1;
	my $pin_version       = $ENV{"DDG"} || undef;
	my $installed_version = $self->get_local_ddg_version;
	return $ok if $installed_version && $installed_version == $self->dev_version;
	warn "installing DDG";
	$self->emit_info("Checking for latest DDG Perl package...");
	my $packages = $self->duckpan_packages;
	my $module   = $packages->package('DDG');
	my $latest   = $self->duckpan . 'authors/id/' . $module->distribution->pathname;
	my $latest_version = version->parse($module->version);

	if ($installed_version >= $latest_version) {
		my $msg = "DDG version: $installed_version";
		$msg .= " (duckpan has $latest_version )" if $installed_version ne $latest_version;
		$self->emit_debug($msg);
	}
	elsif ($pin_version && $pin_version < $latest_version){
			my @msg = (
				"A newer version of DDG exists: $latest_version.",
				"You have the version pinned to: $pin_version. Please update your version pin!"
			);
			$self->emit_notice(@msg);
	}
	else {
		if ($installed_version) {
			my @msg = (
				"You have version $installed_version, latest is " . $module->version . "!",
				"Please install the latest DDG package with: duckpan DDG"
			);
			$self->emit_notice(@msg);
		}
		else {
			$self->perl->duckpan_install('DDG');
		}
	}
	return $ok;
}

sub checking_dukgo_user {
	my ( $self, $user, $pass ) = @_;
	my $request = GET( $self->dukgo_my_account );
	$request->authorization_basic( $user, $pass );
	my $response = $self->http->request( $request );
	return ( $response->code == 200 );
}

sub get_ia_type {
	my ($self) = @_;

	my $ia_type = first { $_->{dir}->is_dir } @{$self->ia_types};

	$self->emit_and_exit(-1, 'Must be run from the root of a checked-out Instant Answer repository.') unless ($ia_type);
	$self->emit_and_exit(-1, "Sorry, DuckPAN does not support " . $ia_type->{name} . " yet!") if $ia_type->{supported} == 0;

	return $ia_type;
}

sub empty_cache {
	my ($self) = @_;
	# Clear cache so share files are written into cache
	my $cache = $self->cfg->cache_path;
	$self->emit_info("Emptying DuckPAN cache...");
	$cache->remove_tree({keep_root => 1});
	$self->emit_info("DuckPAN cache emptied");
}

sub BUILD {
	my ($self) = @_;

	$self->emit_and_exit(1, 'We dont support Win32') if ($^O eq 'MSWin32');
	my $env_config = $self->cfg->config_path->child('env.ini');
	$self->empty_cache if $self->empty;
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
