package App::DuckPAN::Cmd;

use Moo::Role;

requires 'run';

has app => (
	is => 'rw',
);

sub execute {
	my ( $self, $args, $chain ) = @_;
	my $app = shift @{$chain};
	$self->app($app);
	$self->run(@{$args});
}

1;
