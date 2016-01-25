#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;
use File::Path qw(remove_tree);
use Path::Tiny;

my $TEMPLATE_OUT = 't/out';

# clear the test template output directory
sub clear_output_directory {
	remove_tree($TEMPLATE_OUT, { keep_root => 1 });
}

BEGIN {
	use_ok 'App::DuckPAN::TemplateDefinitions';
}

################################
# Parsing template definitions #
################################

my $template_defs =
	new_ok 'App::DuckPAN::TemplateDefinitions',
		[ templates_yml => 't/template/templates.yml' ];

# check templates
my @templates = $template_defs->get_templates;
my %template_map = map { $_->name => $_ } @templates;

# check if templates are instantiated
isa_ok $_, 'App::DuckPAN::Template'
	for @templates;

# check if all the templates have been read
is_deeply [ sort map { $_->name } @templates ],
	[qw(complex_out_dir css js no_input no_write_perm pm test)],
	'template defs: read all templates';

# check template sets
my @template_sets = $template_defs->get_template_sets;
my %template_set_map = map { $_->name => $_ } @template_sets;

# check if template sets are instantiated
isa_ok $_, 'App::DuckPAN::TemplateSet'
	for @template_sets;

# check if all the template sets have been read
is_deeply [ sort map { $_->name } @template_sets ],
	[qw(all_optional errors required_and_optional subdir_support_not_defined subdir_support_specified)],
	'template defs: read all template sets';

###############################
# Template definitions errors #
###############################

throws_ok {
		my $templates_defs = App::DuckPAN::TemplateDefinitions->new(
			templates_yml => 't/template/templates-nonexistent.yml'
		);
	} qr/Error loading/,
	'template defs: non-existent template definitions file throws error';

########################
# Individual Templates #
########################

# check if all fields of a template are read
is $template_map{pm}->label, 'Perl Module',
	'template defs: set template label field';
is $template_map{pm}->input_file, 't/template/lib/DDG/Default.pm',
	'template defs: set template input field';
is $template_map{pm}->output_file, 't/out/lib/DDG/<:$package_name:>.pm',
	'template defs: set template output field';

# output directory computation
is $template_map{pm}->output_directory, 't/out/lib/DDG',
	'template: output directory generated';
is $template_map{complex_out_dir}->output_directory, 't/out/share/text',
	'template: output directory generated (complex)';

#################
# Template Sets #
#################

# check if all fields of a template set are read
my $template_set_ro = $template_set_map{required_and_optional};

is $template_set_ro->description, 'Template set with required and optional templates',
	'template defs: set template_set description';
is_deeply $template_set_ro->required_templates, [@template_map{qw(pm test)}],
	'template defs: set template_set required templates';
is_deeply $template_set_ro->optional_templates, [@template_map{qw(js css)}],
	'template defs: set template_set optional templates';

ok !$template_set_map{subdir_support_specified}->subdir_support, 'Template set with subdir support explicitly disabled';
ok $template_set_map{subdir_support_not_defined}->subdir_support, 'Template set with subdir support implicitly enabled';

{
	# check template combinations that we should show to the user
	my $combinations = $template_set_map{all_optional}->optional_template_combinations;

	# for neater code
	my %tm = %template_map;

	# combinations must be in a particular order
	is_deeply $combinations,
		[
			[ $tm{js}   ],
			[ $tm{pm}   ],
			[ $tm{test} ],
			[ $tm{js},  $tm{pm}   ],
			[ $tm{js},  $tm{test} ],
			[ $tm{pm},  $tm{test} ],
			[ $tm{js},  $tm{pm},  $tm{test} ],
		],
		'template set: all optional template combinations generated correctly';
}

##################################
# File generation from templates #
##################################

my $package_name = 'MyInstantAnswer';
my $ia_id = 'my_instant_answer';
my %vars = (
	package_name => $package_name,
	ia_id	 => $ia_id,
);
my $pm_out_file   = "$TEMPLATE_OUT/lib/DDG/$package_name.pm";
my $test_out_file = "$TEMPLATE_OUT/t/$package_name.test";
my $js_out_file   = "$TEMPLATE_OUT/share/javascript/$ia_id.js";
my $css_out_file  = "$TEMPLATE_OUT/share/css/$ia_id.css";

clear_output_directory();

$template_map{pm}->generate(\%vars);

# check if output file is correct
ok -f "$pm_out_file", 'template: file generated from template';

my $pm_file_content = path($pm_out_file)->slurp;

# check the content of the output file using all variables
is $pm_file_content, <<EOT, 'template: generated file content is as expected';
package $package_name;
my \$id = '$ia_id';
EOT

#########################################
# File generation errors from templates #
#########################################

# overwriting file
throws_ok {
		$template_map{pm}->generate(\%vars);
	} qr/already exists/,
	'template: overwriting generated file throws error';

# input file not present
throws_ok { $template_map{no_input}->generate(\%vars) }
	qr/not found/,
	'template: non-existent template file throws error';


# create a directory with no write access
mkdir "$TEMPLATE_OUT/readonly", 0500;
throws_ok {
		$template_map{no_write_perm}->generate(\%vars)
	}
	qr/Error creating output/,
	'template: failure creating template output file throws error';

{
	my $got_warning;
	local $SIG{__WARN__} = sub { $got_warning = 1 };

	clear_output_directory();

	# all variables were passed to template; no warnings should be shown
	$template_map{pm}->generate(\%vars);
	ok !$got_warning, 'template: no warning when all variables are passed to template';

	clear_output_directory();

	# some or all variables were missing; show warnings
	$template_map{pm}->generate({});
	ok $got_warning, 'template: show warning when not all variables are passed to template';
}

######################################
# File generation from template sets #
######################################
my %generate_res;

clear_output_directory();
%generate_res = $template_set_map{required_and_optional}->generate(\%vars, [ $template_map{js} ]);

is_deeply [ sort @{$generate_res{created_files}} ],
	[ $pm_out_file, $js_out_file, $test_out_file ],
	'template set: return value has all the created files';

ok !$generate_res{error}, 'template set: no errors when succesfully generating files';

# verify all required files have been generated
ok -f $_, "template set: required file '$_' generated from template set"
	for ($pm_out_file, $test_out_file);

ok  -f $js_out_file,  "template set: selected optional file '$js_out_file' generated from template set";
ok !-f $css_out_file, "template set: unselected optional file '$css_out_file' not generated from template set";

#############################################
# File generation errors from template sets #
#############################################

clear_output_directory();
throws_ok {
		$template_set_map{required_and_optional}->generate(\%vars, [ $template_map{pm} ])
	}
	qr/Unknown template/,
	'template set: die when invalid templates passed in optional templates list';

# individual template errors while generating output
%generate_res = $template_set_map{errors}->generate(\%vars, [ $template_map{no_input} ]);

# required files are generated before optional files, thus we get the .pm file
# in the created files list. Feel free to change this behaviour and update the
# test if necessary.
is_deeply $generate_res{created_files}, [ $pm_out_file ],
	'template set: successfully generated file added to "created_files" list';

# the optional template failed to generate the output
ok scalar($generate_res{error} =~ /Template input file.*not found/),
	'template set: error message set for failed template';

#############################################

clear_output_directory();

done_testing;

