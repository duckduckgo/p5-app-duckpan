package App::DuckPAN::Cmd::Test;

use Moo;
with qw( App::DuckPAN::Cmd );

use File::Spec;
use MooX::Options;
use Test::Harness;

sub run {
	my ( $self, @args ) = @_;

	my @tests;

	if (@args) {
		map { my $t = "t/$_.t"; push @tests, $t if -f $t } @args;
	} else {
		@tests = <t/*.t>;
	}

	my @paths = qw(lib blib/lib blib/arch);

	$ENV{HARNESS_OPTIONS} = 'c';

	unshift @INC, map { File::Spec -> rel2abs($_) } @paths;

	runtests(@tests);
}

1;
