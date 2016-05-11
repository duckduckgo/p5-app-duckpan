package App::DuckPAN::Lookup::Util;
# ABSTRACT: Utilities for standardized lookups.

BEGIN {
	require Exporter;

	our @ISA = qw(Exporter);

	our @EXPORT_OK = qw(lookup);
}

use List::Util qw(pairs);

sub satisfy {
	my ($parent, $by, $lookup) = @_;
	my $pby = ref $parent eq 'HASH'
		? $parent->{$by} : $parent->$by;
	ref $lookup eq 'CODE' ? $lookup->($pby) : $pby eq $lookup;
}

sub lookup {
	my ($lookup_vals, $lookup_id, @lookups) = @_;
	my @items = @$lookup_vals;
	return @items unless @lookups;
	my %results;
	foreach (pairs @lookups) {
		my ($by, $lookup) = @$_;
		map { $results{$_->{$lookup_id}} = $_ }
			grep { satisfy($_, $by, $lookup) } @items;
	}
	return values %results;
}

1;

__END__
