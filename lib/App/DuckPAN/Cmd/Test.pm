package App::DuckPAN::Cmd::Test;

use Moo;
with qw( App::DuckPAN::Cmd );

use File::Spec;
use MooX::Options;
use Test::Harness;

sub run {
	my ( $self ) = @_;

	my @tests = <t/*.t>;
	my @paths = qw(lib blib/lib blib/arch);

	unshift @INC, map { File::Spec -> rel2abs($_) } @paths;

	runtests(@tests);
}

1;

