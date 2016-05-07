package App::DuckPAN::Lookup;
# ABSTRACT: Role for standardized lookups.

use List::Util qw(pairs);
use App::DuckPAN::Lookup::Util;

use Moo::Role;

requires '_lookup';
# Unique value that can be used to distinguish lookup items.
requires '_lookup_id';

sub lookup {
	my ($self, @lookups) = @_;
	return App::DuckPAN::Lookup::Util::lookup(
		$self->_lookup(), $self->_lookup_id(), @lookups,
	);
}

1;

__END__
