package App::DuckPAN::HasApp;

use Moo::Role;

has app => (
	is => 'rw',
	required => 1,
);

1;
