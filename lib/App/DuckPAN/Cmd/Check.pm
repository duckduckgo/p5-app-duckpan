package App::DuckPAN::Cmd::Check;
# ABSTRACT: Command for checking the requirements

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ($self) = @_;

	$self->app->empty_cache;
	$self->app->check_requirements; # Exits on missing requirements.
	$self->app->emit_info("EVERYTHING OK! You can now go hacking! :)");
	exit 0;
}

1;
