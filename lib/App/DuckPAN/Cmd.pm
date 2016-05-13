package App::DuckPAN::Cmd;
# ABSTRACT: Base class for commands of DuckPAN

use Moo::Role;

requires 'run';

has app => (
	is  => 'rw',
	doc => 'duckpan base app',
);

has args => (
	is      => 'rwp',
	default => sub { [] },
	doc     => 'command-line arguments passed to command',
);

sub initialize {
	my ($self, @args) = @_;
	$self->_set_args(\@args);
	$self->app->initialize_working_directory();
}

sub execute {
	my ( $self, $args, $chain ) = @_;
	my $app = shift @{$chain};
	$self->app($app);
	$self->initialize(@$args);
	$self->run(@{$args});
}

1;
