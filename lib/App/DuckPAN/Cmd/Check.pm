package App::DuckPAN::Cmd::Check;
# ABSTRACT: Command for checking the requirements

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ( $self ) = @_;
	$self->app->verify_versions;
	if ($self->app->check_requirements) {
		 $self->app->emit_and_exit(1, "Check for the requirements failed!! See instructions or reports above");
	} else {
		$self->app->emit_info("EVERYTHING OK! You can now go hacking! :)");
	}
}

1;
