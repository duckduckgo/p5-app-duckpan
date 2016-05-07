package App::DuckPAN::Lookup;
# ABSTRACT: Role for standardized lookups.

use List::Util qw(pairs);

sub satisfy {
	my ($parent, $by, $lookup) = @_;
	if (ref $by eq 'CODE') {
		return $by->($parent, $lookup);
	}
	my $pby = ref $parent eq 'HASH'
		? $parent->{$by} : $parent->$by;
	ref $pby eq 'CODE' ? $pby->($lookup) : $pby eq $lookup;
}

use Moo::Role;

requires '_lookup';
# Unique value that can be used to distinguish lookup items.
requires '_lookup_id';

sub lookup {
	my ($self, @lookups) = @_;
	my @items = @{$self->_lookup()};
	return @items unless @lookups;
	my %results;
	my $id = $self->_lookup_id();
	foreach (pairs @lookups) {
		my ($by, $lookup) = @$_;
		map { $results{$_->{$id}} = $_ }
			grep { satisfy($_, $by, $lookup) } @items;
	}
	return values %results;
}

1;

__END__
