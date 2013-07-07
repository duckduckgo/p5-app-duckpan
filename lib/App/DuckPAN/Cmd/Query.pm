package App::DuckPAN::Cmd::Query;
# ABSTRACT: Command line tool for testing queries and see triggered plugins

use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_app_duckpan;
	exit 1 unless $self->app->check_ddg;

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	require App::DuckPAN::Query;
	exit App::DuckPAN::Query->run($self->app, @blocks);

}

1;
