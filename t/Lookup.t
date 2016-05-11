#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use App::DuckPAN::Lookup::Util qw(lookup);

my $foo = {
	id          => 'foo',
	description => 'A metasyntactic variable',
	foo_or_bar  => 1,
	numeric     => 0,
};

my $bar = {
	id          => 'bar',
	description => 'A metasyntactic variable',
	foo_or_bar  => 1,
	numeric     => 1,
};

my $baz = {
	id          => 'baz',
	description => 'A metasyntactic variable',
	foo_or_bar  => 0,
	numeric     => 2,
};

my $lookups = [ $foo, $bar, $baz ];

subtest 'lookup' => sub {
	my $look = sub { lookup($lookups, @_) };
	cmp_deeply([$look->()], bag(@$lookups), 'no lookups specified');
	subtest 'single lookup' => sub {
		my @id = $look->(id => 'foo');
		cmp_deeply(\@id, [$foo], 'lookup with unique key');
		my @desc = $look->(description => 'A metasyntactic variable');
		cmp_deeply(\@desc, bag($foo, $bar, $baz), 'lookup with non-unique key');
		my @gte1 = $look->(numeric => sub { $_[0] >= 1 });
		cmp_deeply(\@gte1, bag($bar, $baz), 'with $by as a subroutine');
	};
	subtest 'multi lookup' => sub {
		my @foo_bar_baz = $look->(id => 'bar', foo_or_bar => 1);
		cmp_deeply(\@foo_bar_baz, [$bar], 'with overlapping values');
		my @id_foo_bar = $look->(id => 'foo', id => 'bar');
		cmp_deeply(\@id_foo_bar, [], 'with 2 unique keys');
		my @desc_foo_bar = $look->(description => 'A metasyntactic variable', foo_or_bar => 1);
		cmp_deeply(\@desc_foo_bar, bag($foo, $bar), 'with overlapping values (multiple)');
	};
};

done_testing;

1;

__END__
