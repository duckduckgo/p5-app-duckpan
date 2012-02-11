package App::DuckPAN;

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

our $VERSION ||= '0.000';

option dukgo_login => (
	is => 'ro',
	lazy => 1,
	default => sub { 'https://dukgo.com/my/login' }
);

sub _ua_string {
  my ($self) = @_;
  my $class   = ref $self || $self;
  my $version = $class->VERSION;
 
  return "$class/$version";
}

option http_proxy => (
	is => 'ro',
	predicate => 'has_http_proxy',
);

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

has config => (
	is => 'ro',
	builder => '_build_config',
	lazy => 1,
	handles => [qw(
		config_path
	)]
);

sub _build_config { App::DuckPAN::Config->new }

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

sub execute {
	my ( $self, $args, $chain ) = @_;
	print $self->help->help;
}

sub check_requirements {
	my ( $self ) = @_;
	my $fail = 0;
	print "Checking your environment for the DuckPAN requirements\n";
	#$fail = 1 unless $self->check_locallib;
	$fail = 1 unless $self->check_git;
	$fail = 1 unless $self->check_wget;
}

sub check_git {
	my ( $self ) = @_;
	my $ok = 1;
	print "Checking for git... ";
	if (my $git = which('git')) {
		my $version_string = `$git --version`;
		if ($version_string =~ m/git version (\d+)\.(\d+)\.(\d+)\.(\d+)/) {
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

sub check_wget {
	my ( $self ) = @_;
	my $ok = 1;
	print "Checking for wget... ";
	if (my $wget = which('wget')) {
		print $wget;
	} else {
		print "No!"; $ok = 0;
	}
	print "\n";
	return $ok;
}

# sub check_locallib {
	# my ( $self ) = @_;
	# my $ok = 1;
	# print "Checking for local::lib installation... ";
	# if (my $perl5lib = $ENV{PERL5LIB}) {
		# my @paths = split(/:/,$perl5lib);
		# print "Yes";
	# } else {
		# print "No!"; $ok = 1;
	# }
	# print "\n";
	# return $ok;
# }

sub checking_dukgo_user {
	my ( $self, $user, $pass ) = @_;
	my $response = $self->http->request(POST($self->dukgo_login, Content => {
		username => $user,
		password => $pass,
	}));
	$response->code == 302 ? 1 : 0; # workaround, need something in dukgo
}

1;
