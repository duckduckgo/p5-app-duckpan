#!/usr/bin/env perl

use strict;
use Test::More;
use Test::Deep;
use App::DuckPAN::Template;

my $fake_goodie = {
	id   => 'fake_goodie',
	repo => 'goodies',
};

my $fake_spice = {
	id   => 'fake_spice',
	repo => 'spice',
};

my $fake_cheat_sheet = {
	id   => 'fake_cheat_sheet',
	repo => 'goodies',
};

# Testing templates indexed by id.
my %fake_templates = map { $_->{id} => $_ } (
	$fake_goodie, $fake_spice, $fake_cheat_sheet,
);

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
	my $allow_test = sub {
		my %options = @_;
		my $allow_sub = $options{allow};
		my @allows = @{$options{allows}};
		my %should_allow = map { $_ => 0 } keys %fake_templates;
		map { $should_allow{$_} = 1 } @allows;
		return sub {
			my $template = App::DuckPAN::Template->new(
				%template_args,
				allow => $allow_sub,
			);
			foreach (keys %should_allow) {
				cmp_deeply($template->supports($fake_templates{$_}), bool($should_allow{$_}));
			}
		};
	};
	subtest template_all => $allow_test->(
		allow => sub { 1 },
		allows => [qw(fake_goodie fake_spice fake_cheat_sheet)],
	);
	subtest template_spice => $allow_test->(
		allow => sub { $_[0]->{repo} eq 'spice' },
		allows => [qw(fake_spice)],
	);
	subtest allow_multiple => $allow_test->(
		allow => [
			sub { $_[0]->{repo} eq 'spice' },
			sub { $_[0]->{id} =~ /_cheat_sheet$/ },
		],
		allows => [qw(fake_spice fake_cheat_sheet)],
	);
};

done_testing;

1;
