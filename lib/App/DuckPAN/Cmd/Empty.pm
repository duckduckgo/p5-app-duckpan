package App::DuckPAN::Cmd::Empty;
# ABSTRACT: Install the distribution in current directory

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ( $self, @args ) = @_;
	$self->app->empty_cache();
}

1;
