package App::DuckPAN::Cmd::Setup;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

option override => ( is => 'ro' );

sub run {
	my ( $self ) = @_;
	$self->app->check_requirements;
	print "Initalizing DuckPAN Environment\n";
	$self->setup_configdir;
	print "Initalizing Dist::Zilla for Perl5\n";
	$self->app->perl->setup;
}

sub setup_configdir {
	my ( $self ) = @_;
	my $configdir = $self->app->config_path;
	mkdir $configdir unless -d $configdir;
	
}

1;