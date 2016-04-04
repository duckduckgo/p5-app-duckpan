package App::DuckPAN::Cmd::Env::Cmd;
# ABSTRACT: Base class for Env commands

use Moo::Role;

requires 'run';

has env => (
	is => 'rw',
);

has root => (
	    is => 'rw',
);

sub execute {
	    my ( $self, $args, $chain ) = @_;
	    my $root = shift @{$chain};
	    $self->root($root);
	    my $env = shift @{$chain};
	    $self->env($env);
	    $self->run(@{$args});
}

1;
