package App::DuckPAN::Cmd::Query;
# ABSTRACT: Command line tool for testing queries and see triggered instant answers

use MooX;
use MooX::Options protect_argv => 0;
with qw( App::DuckPAN::Cmd );

sub run {
	my ($self, @args) = @_;

	$self->app->check_requirements;    # Will exit if missing
	my $loader = $self->app->ddg->blocks_loader(@args);
	$loader->();
	require App::DuckPAN::Query;
	exit App::DuckPAN::Query->run($self->app, $loader);
}

1;
