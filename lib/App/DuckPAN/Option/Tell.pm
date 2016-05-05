package App::DuckPAN::Option::Tell;
# ABSTRACT: Commands that can emit info to users.

use Moo::Role;
use MooX::Options;

requires 'app';

option verbose => (
	is      => 'ro',
	lazy    => 1,
	short   => 'v|debug',
	default => sub { 0 },
	doc     => 'provide expanded output during operation',
);

before run => sub {
	my $self = shift;
	if ($self->verbose) {
		$self->app->verbose(1);
	}
};

1;

__END__
