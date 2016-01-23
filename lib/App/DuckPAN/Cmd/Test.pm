package App::DuckPAN::Cmd::Test;
# ABSTRACT: Command for running the tests of this library

use MooX;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

option full => (
	is      => 'ro',
	lazy    => 1,
	short   => 'f',
	default => sub { 0 },
	doc     => 'run full test suite via dzil',
);

sub run {
	my ($self, @args) = @_;

	my $ret = 0;

	if ($self->full) {
		$self->app->emit_error("Could not find dist.ini.") unless -e "dist.ini";
		$self->app->emit_error("Could not begin testing. Is Dist::Zilla installed?") if $ret = system("dzil test");
	}
	else {
		my @to_test = ("t") unless @args;
		foreach my $ia (@args) {
			if (-e "t/$ia.t") {
				push @to_test, "t/$ia.t";
			}
			elsif (-d "t/$ia") {
				push @to_test, "t/$ia";
			}
			else {
				$self->app->emit_and_exit(1, "Could not find any tests for $ia");
			}
		};
		$self->app->emit_error("Tests failed! See output above for details") if $ret = system("prove -lr @to_test");
	}

	return $ret;
}

1;

1;
