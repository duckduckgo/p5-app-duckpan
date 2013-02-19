package App::DuckPAN::HasApp;
# ABSTRACT: Simple role for classes which carry an object of App::DuckPAN

use Moo::Role;

has app => (
	is => 'rw',
	required => 1,
);

1;
