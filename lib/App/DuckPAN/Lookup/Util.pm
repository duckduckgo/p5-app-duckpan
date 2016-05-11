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
	my %results = map { $_->{$lookup_id} => $_ } @$lookup_vals;
	my @results = values %results;
	foreach (pairs @lookups) {
		return () unless @results;
		my ($by, $lookup) = @$_;
		@results = grep { satisfy($_, $by, $lookup) } @results;
	}
	return @results;
}

1;

__END__
