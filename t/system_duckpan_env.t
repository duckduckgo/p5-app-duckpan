#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Script::Run;
use File::chdir;
use File::HomeDir 'home';
use File::FindLib '../lib';
use Path::Class;
use Dir::Self;
use Data::Dumper;

chdir( __DIR__ );

my $query = join ' ', Test::Script::Run::get_perl_cmd('duckpan', 'env');

my $config_file = dir(home, '.duckpan', 'env.ini');
my $test_var = 'DUCKPAN_TEST_VAR';
my $test_val = 'duckpan_test_val';

sub callDuckPAN { unshift @_, 'env'; run_script( 'duckpan', \@_ ) }

sub grepEnv {
  my ( $var, $val, $needle, $count, $msg ) = @_;
  open my $ini, '<', $config_file;
  my @new_env = map { chomp } grep /$var = $val/, <$ini>;
  ok( scalar @new_env == $count, $msg );
  close $ini;
}

callDuckPAN($test_var, $test_val);
grepEnv($test_var, $test_val, "$test_var = $test_val", 1,
        'added new environment variable to ~/.duckpan/env.ini');

my ($return, $out, $err) = callDuckPAN();
open my $ini, '<', $config_file;
my $expected = join "", "# ENV variables added so far:\n",
                 (map { s/ = (.*)$/='$1'/; "export $_" } <$ini>), "\n";
my $usage = "Usage:\n"
          . "      add ENV:\tduckpan env <name> <value>\n"
          . "      get ENV:\tduckpan env <name>\n"
          . "   remove ENV:\tduckpan rm <name>\n";
is($out, $expected, 'got current env variables from `duckpan show`');
is($err, $usage, 'got usage from `duckpan show` on stderr');
close $ini;

callDuckPAN('rm', $test_var);
grepEnv($test_var, $test_val, "$test_var = $test_val", 0,
        'deleted new environment variable from ~/.duckpan/env.ini');

done_testing;
