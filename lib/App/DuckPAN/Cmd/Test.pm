package App::DuckPAN::Cmd::Test;
# ABSTRACT: Command for running the tests of this library

use MooX;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

option full => (
	is          => 'ro',
	lazy        => 1,
	short       => 'f',
	default     => sub { 0 },
	doc         => 'run full test suite via dzil',
);

sub run {
	my ( $self ) = @_;

	my $ret = 0;

	if ($self->full) {
		$self->app->emit_error("Could not find dist.ini.") unless -e "dist.ini";
		$self->app->emit_error("Could not begin testing. Is Dist::Zilla installed?") if $ret = system("dzil test");
	} else {
		$self->app->emit_error("Tests failed! See output above for details") if $ret = system("prove -lr t");
	}

	return $ret;
}

1;
