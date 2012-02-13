package App::DuckPAN::Cmd::Check;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

sub run {
	my ( $self ) = @_;
	exit 1 unless $self->app->check_requirements;
}

1;