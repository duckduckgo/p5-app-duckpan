#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Expect;
use Dir::Self;

my $duckpan   = __DIR__ . '/../bin/duckpan';
my $test_dist = __DIR__ . '/test_dist';

expect_run(
  command => "cd $test_dist && $duckpan query",
  prompt  => 'Query: ',
  quit    => '',
);

expect_run(
  command => "cd $test_dist && $duckpan query Goodie::TwoShoes",
  prompt  => 'Query: ',
  quit    => '',
);

expect_run(
  command => "cd $test_dist && $duckpan query Spice::NagaBhutJolokiaDax",
  prompt  => 'Query: ',
  quit    => '',
);

done_testing;
