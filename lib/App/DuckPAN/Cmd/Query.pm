package App::DuckPAN::Cmd::Query;
# ABSTRACT: Command line tool for testing queries and see triggered plugins

use MooX;
use MooX::Options protect_argv => 0;
with qw( App::DuckPAN::Cmd );

sub run {
	my ( $self, @args ) = @_;

	$self->verify_versions;
	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	require App::DuckPAN::Query;
	exit App::DuckPAN::Query->run($self->app, @blocks);

}

1;
