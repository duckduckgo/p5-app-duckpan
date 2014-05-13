package App::DuckPAN::Cmd::Installdeps;
# ABSTRACT: Regular way to install requirements with tests

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ( $self, @args ) = @_;
    print 'Everything fine!' if $self->app->install_deps == 0;
}

1;
