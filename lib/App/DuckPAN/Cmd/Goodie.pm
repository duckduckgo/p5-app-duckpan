package App::DuckPAN::Cmd::Goodie;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Module::Pluggable::Object;
use Class::Load ':all';
use Data::Printer;

sub run {
	my ( $self, @args ) = @_;
	if (defined $args[0]) {
		unless ($self->app->get_local_ddg_version) {
			print "\n[ERROR] You need to have the DDG distribution installed\n";
			print "\nTo get the installation command, please run: duckpan check\n\n";
			exit 1;
		}
		if ($args[0] eq 'test') {
			print "\n[DEPRECATED] Please use \"duckpan query\"!\n";
			exit 1;
		}
	} 
	print $self->app->help->goodie;
}

1;
