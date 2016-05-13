package App::DuckPAN::Cmd::Test;
# ABSTRACT: Command for running the tests of this library

use File::Find::Rule;
use MooX;
use MooX::Options protect_argv => 0;

use App::DuckPAN::InstantAnswer::Util qw(is_cheat_sheet);

with qw(
	App::DuckPAN::Cmd
	App::DuckPAN::InstantAnswer::Cmd::Multi
);

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
		my @ias = @{$self->ias};
		my @to_test = ('t') unless @ias;
		my @cheat_sheet_tests;
		foreach my $ia (@ias) {
			if (is_cheat_sheet($ia->meta)) {
				my $dash_name = $ia->files->{named}{cheat_sheet}->basename('.json');
				push @cheat_sheet_tests, $dash_name;
				next;
			}
			my $test_f = $ia->files->{named}{directories}{test}
				// $ia->files->{named}{test};
			$self->app->emit_info(
				"No tests found for @{[$ia->meta->{id}]}"
			) and next unless defined $test_f;
			push @to_test, $test_f;
		}
		$self->app->emit_error('Tests failed! See output above for details') if @to_test           and $ret = system("prove -lr @to_test");
		$self->app->emit_error('Tests failed! See output above for details') if @cheat_sheet_tests and $ret = system("prove -lr t/CheatSheets/CheatSheetsJSON.t :: @cheat_sheet_tests");
	}
	return $ret;
}

1;
