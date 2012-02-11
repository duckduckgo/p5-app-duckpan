package App::DuckPAN::Cmd::Check;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

sub run {
	my ( $self ) = @_;
	$self->app->check_requirements;
}

1;