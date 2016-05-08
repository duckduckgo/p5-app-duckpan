#!/usr/bin/env perl

use strict;
use Test::More;
use Test::Deep;
use App::DuckPAN::Template;

my $fake_goodie = {
	id => 'test_ia',
	repo => 'goodies',
};
my $fake_spice = {
	id => 'test_ia_spice',
	repo => 'spice',
};

my %template_args = (
	id                 => 'test_template',
	allow              => sub { 1 },
	input_file         => 'test_template.tx',
	label              => "Test Template",
	output_file        => "test_file",
	template_directory => 'templates',
);

subtest new => sub {
	my $template = App::DuckPAN::Template->new(
		%template_args,
	);
	isa_ok($template, 'App::DuckPAN::Template', 'new template');
};

subtest supports => sub {
	subtest template_all => sub {
		my $template_all = App::DuckPAN::Template->new(
			%template_args,
			allow => sub { 1 },
		);
		cmp_deeply($template_all->supports($fake_goodie), bool(1));
		cmp_deeply($template_all->supports($fake_spice), bool(1));
	};
	subtest template_spice => sub {
		my $template_spice = App::DuckPAN::Template->new(
			%template_args,
			allow => sub { $_[0]->{repo} eq 'spice' },
		);
		cmp_deeply($template_spice->supports($fake_goodie), bool(0));
		cmp_deeply($template_spice->supports($fake_spice), bool(1));
	};
};

done_testing;

1;
