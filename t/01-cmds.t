#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Expect;

expect_run(
  command => "cd t/test_dist && ../../bin/duckpan query",
  prompt  => 'Query: ',
  quit    => '',
);

expect_run(
  command => "cd t/test_dist && ../../bin/duckpan query Goodie::TwoShoes",
  prompt  => 'Query: ',
  quit    => '',
);

expect_run(
  command => "cd t/test_dist && ../../bin/duckpan query Spice::NagaBhutJolokiaDax",
  prompt  => 'Query: ',
  quit    => '',
);

done_testing;
