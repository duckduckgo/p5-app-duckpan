package App::DuckPAN::Cmd::Goodie;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Module::Pluggable::Object;
use Class::Load ':all';
use Data::Printer;

sub run {
	my ( $self, @args ) = @_;
        print "\n[DEPRECATED] Please use \"duckpan query\"!\n";
        exit 1;
}

1;
