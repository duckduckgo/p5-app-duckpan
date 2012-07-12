package App::DuckPAN::Cmd::Query;

use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_ddg;

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	require App::DuckPAN::Query;
	exit App::DuckPAN::Query->run(@blocks);

}

1;
