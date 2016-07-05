package App::DuckPAN::Cmd::Query;
# ABSTRACT: Command line tool for testing queries and see triggered instant answers

use MooX;
with qw( App::DuckPAN::Cmd App::DuckPAN::Restart );

use MooX::Options protect_argv => 0;

option 'output_txt' => (
	is => 'ro',
	format => 's',
	lazy => 1,
	short => 'o',
	default => sub { undef },
	doc  => 'Set location for the output.txt file to load',
);


sub run {
	my ($self, @args) = @_;

	exit $self->run_restarter(\@args);
}

sub _run_app {
	my ($self, $args) = @_;

	# pass along Fathead output.txt arg
	$self->app->fathead->output_txt( $self->output_txt );

	$self->app->check_requirements;    # Will exit if missing
	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@$args)};

	require App::DuckPAN::Query;
	App::DuckPAN::Query->run($self->app, \@blocks);
}

1;
