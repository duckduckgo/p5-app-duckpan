package App::DuckPAN::Cmd::Check;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

sub run {
	my ( $self ) = @_;
	if ($self->app->check_requirements) {
		print "\n[ERROR] Check for the requirements failed!! See instructions or reports above\n\n";
		exit 1;
	} else {
		print "\nEVERYTHING OK! You can now go hacking! :)\n\n";
	}
}

1;
