package App::DuckPAN::Cmd::Test;
# ABSTRACT: Command for running the tests of this library

use MooX;
with qw( App::DuckPAN::Cmd );

use File::Find::Rule;

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

	my $ia_type = $self->app->get_ia_type->{name};

	my $ret = 0;

	if ($self->full) {
		$self->app->emit_error('Could not find dist.ini.') unless -e 'dist.ini';
		$self->app->emit_error('Could not begin testing. Is Dist::Zilla installed?') if $ret = system('dzil test');
	}
	else {
		my @to_test = ('t') unless @args;
		my @cheat_sheet_tests;
		foreach my $ia (@args) {
			if ($ia =~ /_cheat_sheet$/) {
				$self->app->emit_and_exit(1, 'Cheat sheets can only be tested in Goodies')
					unless $ia_type eq 'Goodie';
				$ia =~ s/_cheat_sheet$//;
				$ia =~ s/_/-/g;
				push @cheat_sheet_tests, $ia;
				next;
			}
			my $name = $self->app->normalize_ia_name($ia);
			$ia = $name if $name;
			if (-d "t/$ia") {
				push @to_test, "t/$ia";
			}
			elsif (my @test_file = File::Find::Rule->name("$ia.t")->in('t')) {
				push @to_test, "@test_file";
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
