#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Expect;
use Test::Script::Run;
use File::chdir;
use Dir::Self;

use Data::Dumper;

my $query = join ' ', Test::Script::Run::get_perl_cmd('duckpan', 'query');

chdir(__DIR__);

expect_run(
  command => $query,
  prompt  => 'Query: ',
  quit    => '',
);

expect_run(
  command => "$query Goodie::TwoShoes",
  prompt  => 'Query: ',
  quit    => '',
);

expect_run(
  command => "$query Spice::NagaBhutJolokiaDax",
  prompt  => 'Query: ',
  quit    => '',
);

done_testing;
