#!/usr/bin/perl

use strict;
use warnings;
use Test::LoadAllModules;

BEGIN {
	all_uses_ok( search_path => 'App::DuckPAN' );
}

