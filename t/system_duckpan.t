#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Script::Run;
use Path::Tiny;

use App::DuckPAN;

subtest 'no arguments' => sub {
	my ($return, $out, $err) = run_script('duckpan', []);

	like($out, qr/Commands include/, 'DuckPAN without arguments shows Help text');
	is($return, 1, 'DuckPAN gives back exit code 1');
};

subtest 'bad include paths' => sub {
	my $fake_dir = 'fake-directory';
	my ($return, $out, $err) = run_script('duckpan', ['-I' . $fake_dir]);

	ok($return, 'DuckPAN with non-existent include path exits with an error');
	like($err, qr/Missing include path.*$fake_dir/, ' after showing the bad path message');

	$fake_dir = '../fake-directory/even-faker';
	($return, $out, $err) = run_script('duckpan', ['-I' . $fake_dir]);
	ok($return, 'DuckPAN with non-existent multi-way include path exits with an error');
	like($err, qr/Missing include path.*$fake_dir/, ' after showing the bad path message');
};

TODO: {

    # These tests intermittently fails for some users
    # The cause is still unknown, but it's related to the temporary dirs/files
    local $TODO = "Ensure tempdir and env.ini are reliably created";

    subtest 'env' => sub {
        my $tempdir = Path::Tiny->tempdir(CLEANUP => 1);
        $ENV{DUCKPAN_CONFIG_PATH} = "$tempdir";

        run_ok('duckpan', [qw( env set test me )], 'setting DuckPAN env test to me');

        is($tempdir->child('env.ini')->slurp, "TEST = me\n", 'checking content of env.ini');

        my (undef, $getenvout, $getenverr) = run_script('duckpan', [qw( env get test )]);

        like($getenvout, qr/export TEST=me/, 'getting test env from DuckPAN');
        is($getenverr, '', 'no error output on test env from DuckPAN');

        (undef, $getenvout, $getenverr) = run_script('duckpan', [qw( env list )]);

        like($getenvout, qr/export TEST=me/, 'listing everything from env.ini');
        is($getenverr, '', 'no error output on test env from DuckPAN');

        run_ok('duckpan', [qw( env rm test )], 'removing DuckPAN env test to me');

        is($tempdir->child('env.ini')->slurp, "", 'checking content of env.ini');

        (undef, $getenvout, $getenverr) = run_script('duckpan', [qw( env get test )]);

        is($getenvout, '', 'trying to get test env from DuckPAN');
        like($getenverr, qr/'TEST' is not set!/, 'error output on test env from DuckPAN');

        (undef, $getenvout, $getenverr) = run_script('duckpan', [qw( env help )]);

        is($getenvout, "Available Commands:\n\t get:  duckpan env get <name>\n\t help: duckpan env help\n\t ".
                           "list: duckpan env list\n\t rm:   duckpan env rm  <name>\n\t set:  duckpan env set <name> <value>\n"
                           , 'listing available commands from DuckPAN for env');
        is($getenverr, '', 'no error output on env help from DuckPAN');

        (undef, $getenvout, $getenverr) = run_script('duckpan', [qw( env randomcmd )]);

        is($getenvout,'', 'checking an unsupported command for env from DuckPAN');
        like($getenverr, qr/Command 'randomcmd' not found/, 'error output on using unsupported command for env from DuckPAN');

        (undef, $getenvout, $getenverr) = run_script('duckpan', [qw( env get )]);

        is($getenvout, '' , 'calling env get with no arguments from DuckPAN');
        like($getenverr, qr/Missing arguments!/, 'error output on env get with no arguments from DuckPAN');
    }
};

subtest 'duckpan help' => sub {
	my ($return, $out, $err) = run_script('duckpan', ['help']);

	like($out, qr/The DuckDuckHack Developer Tool/, '`duckpan help` shows Help text');
};

done_testing;
