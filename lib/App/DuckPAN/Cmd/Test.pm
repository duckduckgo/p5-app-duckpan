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

no warnings 'uninitialized';

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
		foreach my $ia_name (@args) {
			if ($ia_name =~ /_cheat_sheet$/) {
				$self->app->emit_and_exit(1, 'Cheat sheets can only be tested in Goodies')
					unless $ia_type eq 'Goodie';
				$ia_name =~ s/_cheat_sheet$//;
				$ia_name =~ s/_/-/g;
				push @cheat_sheet_tests, $ia_name;
				next;
			}
			# Unfortunately we can't just use the name, because some have
			# spaces - thus we grab the end of the package name.
			my $ia = $self->app->get_ia_by_name($ia_name);
			$self->app->emit_and_exit(1, "Could not find an Instant Answer with name '$ia_name'") unless $ia;
			my $id = $ia->{id};

			if (my ($perl_module) = $ia->{perl_module} =~ /::(\w+)$/) {
				if (-d "t/$perl_module") {
					push @to_test, "t/$perl_module";
				}
				elsif (my @test_file = File::Find::Rule->name("$perl_module.t")->in('t')) {
					push @to_test, "@test_file";
				}
			}
			if ($ia_type eq 'Fathead') {
				my $path = "lib/fathead/$id/output.txt";
				if (-f $path) {
					$ENV{'DDG_TEST_FATHEAD'} = $id;
					push @to_test, "t/validate_fathead.t";
				} else {
					$self->app->emit_and_exit(1, "Could not find output.txt for $id in $path");
				}
			}
			else {
				$self->app->emit_and_exit(1, "Could not find any tests for $id");
			}
		};
		$self->app->emit_error('Tests failed! See output above for details') if @to_test           and $ret = system("prove -lr @to_test");
		$self->app->emit_error('Tests failed! See output above for details') if @cheat_sheet_tests and $ret = system("prove -lr t/CheatSheets/CheatSheetsJSON.t :: @cheat_sheet_tests");
	}

	return $ret;
}

1;
