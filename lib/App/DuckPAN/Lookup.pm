package App::DuckPAN::Lookup;
# ABSTRACT: Role for standardized lookups.

use App::DuckPAN::Lookup::Util;

use Moo::Role;

requires '_lookup';

sub lookup {
	my ($self, @lookups) = @_;
	return App::DuckPAN::Lookup::Util::lookup(
		$self->_lookup(), @lookups,
	);
}

1;

__END__
