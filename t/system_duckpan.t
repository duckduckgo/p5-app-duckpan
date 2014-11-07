#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Script::Run;
use Path::Tiny;

use App::DuckPAN;

my $version = $App::DuckPAN::VERSION;

subtest 'no arguments' => sub {
	my ($return, $out, $err) = run_script('duckpan', []);

	like($out, qr/DuckPAN/, 'DuckPAN without arguments gives out usage');
	is($return, 1, 'DuckPAN gives back exit code 1');
};

subtest 'bad include paths' => sub {
	my $fake_dir = 'fake-directory';
	my ($return, $out, $err) = run_script('duckpan', ['-I' . $fake_dir]);

	ok($return, 'DuckPAN with non-existent include path exits with an error');
	like($out, qr/Missing include path.*$fake_dir/, ' after showing the bad path message');

	$fake_dir = '../fake-directory/even-faker';
	($return, $out, $err) = run_script('duckpan', ['-I' . $fake_dir]);
	ok($return, 'DuckPAN with non-existent multi-way include path exits with an error');
	like($out, qr/Missing include path.*$fake_dir/, ' after showing the bad path message');
};

subtest 'env' => sub {
	my $tempdir = Path::Tiny->tempdir(CLEANUP => 1);
	$ENV{DUCKPAN_CONFIG_PATH} = "$tempdir";

	run_ok('duckpan', [qw( env test me )], 'setting DuckPAN env test to me');

	is($tempdir->child('env.ini')->slurp, "TEST = me\n", 'checking content of env.ini');

	my (undef, $getenvout, $getenverr) = run_script('duckpan', [qw( env test )]);

	like($getenvout, qr/TEST='me'/, 'getting test env from DuckPAN');
	is($getenverr, '', 'no error output on test env from DuckPAN');

	run_ok('duckpan', [qw( rm test )], 'removing DuckPAN env test to me');

	is($tempdir->child('env.ini')->slurp, "", 'checking content of env.ini');

	(undef, $getenvout, $getenverr) = run_script('duckpan', [qw( env test )]);

	like($getenvout, qr/TEST is not set/, 'getting test env from DuckPAN after removing it');
	is($getenverr, '', 'no error output on test env from DuckPAN after removing it');
};

done_testing;
