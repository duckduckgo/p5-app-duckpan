package App::DuckPAN::Cmd::Setup;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Term::UI;
use Term::ReadLine;

option override => ( is => 'ro' );

option user => (
	is => 'rw',
	lazy => 1,
	default => sub { shift->get_user }
);

sub get_user { shift->term->get_reply( prompt => 'What is your username on https://dukgo.com/ ? ' ) }

option pass => (
	is => 'rw',
	lazy => 1,
	default => sub { shift->get_pass }
);

sub get_pass {
	my $self = shift;
	$self->term->get_reply( prompt => 'What is your password on https://dukgo.com/ ? ' );
}

has term => (
	is => 'ro',
	lazy => 1,
	builder => '_build_term',
);

sub _build_term { Term::ReadLine->new('duckpan') }

sub run {
	my ( $self ) = @_;
	$self->app->check_requirements;
	print "\nGetting your https://dukgo.com/ user informations\n\n";
	$self->setup_dukgo;
	print "\nInitalizing DuckPAN Environment\n\n";
	$self->setup_configdir;
	print "\nInitalizing Dist::Zilla for Perl5\n";
	$self->app->perl->setup(
		dukgo_user => $self->user,
		dukgo_pass => $self->pass,
	);
}

sub setup_dukgo {
	my ( $self ) = @_;
	my $user = $self->get_user;
	my $pass = $self->get_pass;
	print "Checking your account on https://dukgo.com/... ";
	if ($self->app->checking_dukgo_user($user,$pass)) {
		print "success!\n";
		$self->user($user);
		$self->pass($pass);
	} else {
		print "failed!\n";
		if ($self->term->ask_yn( prompt => 'Wanna try again? ' )) {
			$self->setup_dukgo;
		} else {
			print "[ERROR] A login to https://dukgo.com/ is required to work with DuckPAN\n";
			exit 1;
		}
	}
}

sub setup_configdir {
	my ( $self ) = @_;
	my $configdir = $self->app->config_path;
	mkdir $configdir unless -d $configdir;
	
}

1;