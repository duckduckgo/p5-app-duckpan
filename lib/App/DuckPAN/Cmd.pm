package App::DuckPAN::Cmd;
# ABSTRACT: Base class for commands of DuckPAN

use Moo::Role;

requires 'run';

has app => (
	is => 'rw',
);

sub initialize {
	my $self = shift;
	$self->app->initialize_working_directory();
}

sub execute {
	my ( $self, $args, $chain ) = @_;
	my $app = shift @{$chain};
	$self->app($app);
	$self->initialize();
	$self->run(@{$args});
}

1;
