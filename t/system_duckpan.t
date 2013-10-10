#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Script::Run;
use File::Temp qw/ tempdir /;
use IO::All;
use Path::Class;

use App::DuckPAN;

my $version = $App::DuckPAN::VERSION;

{
	my ( $return, $out, $err ) = run_script( 'duckpan', [] );

	like($out,qr/DUCKPAN/, 'duckpan without arguments gives out usage');
	like($out,qr/$version/, 'duckpan without arguments gives out right version');

	is($err,"",'duckpan gives out nothing on STDERR');
	is($return,1,'duckpan gives back exit code 1');
}

{
	my $tempdir = tempdir( CLEANUP => 1 );
	$ENV{DUCKPAN_CONFIG_PATH} = "$tempdir";

	run_ok( 'duckpan', [qw( env test me )], 'setting duckpan env test to me');

	is(io(file($tempdir,'env.ini'))->slurp,"TEST = me\n",'checking content of env.ini');

	my ( undef, $getenvout, $getenverr ) = run_script( 'duckpan', [qw( env test )]);

	like($getenvout,qr/TEST='me'/,'getting test env from duckpan');
	is($getenverr,'','no error output on test env from duckpan');

	run_ok( 'duckpan', [qw( rm test )], 'removing duckpan env test to me');

	is(io(file($tempdir,'env.ini'))->slurp,"",'checking content of env.ini');

	( undef, $getenvout, $getenverr ) = run_script( 'duckpan', [qw( env test )]);

	like($getenvout,qr/TEST is not set/,'getting test env from duckpan after removing it');
	is($getenverr,'','no error output on test env from duckpan after removing it');
}

done_testing;
