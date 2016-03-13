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
		$self->app->emit_error('Could not find dist.ini.') unless -e 'dist.ini';
		$self->app->emit_error('Could not begin testing. Is Dist::Zilla installed?') if $ret = system('dzil test');
	}
	else {
		my @to_test = ('t') unless @args;
		my @test_paths = map { $_ =~ s#t/([^\.]+)(?:\.t)?+#$1#r } glob "t/*";
		my @cheat_sheet_tests;
		foreach my $ia (@args) {
			if ($ia =~ /_cheat_sheet$/ && -d 't/CheatSheets') {
				$ia =~ s/_cheat_sheet$//;
				$ia =~ s/_/-/g;
				push @cheat_sheet_tests, $ia;
				next;
			}
			if ($ia =~ /_|^[a-z]+$/) {
				my $name = lc $ia =~ s/_//gr;
				if (my @f = grep { lc $_ eq $name } @test_paths) {
					$ia = "@f";
				}
			}
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
		$self->app->emit_error('Tests failed! See output above for details') if @to_test           and $ret = system("prove -lr @to_test");
		$self->app->emit_error('Tests failed! See output above for details') if @cheat_sheet_tests and $ret = system("prove -lr t/CheatSheets/CheatSheetsJSON.t :: @cheat_sheet_tests");
	}

	return $ret;
}

1;
