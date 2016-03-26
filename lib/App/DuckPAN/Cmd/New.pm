package App::DuckPAN::Cmd::New;
# ABSTRACT: Take a name as input and generates a new, named Goodie or Spice instant answer skeleton

# See the template/templates.yml file in the Goodie or Spice repository for the
# list of template-sets and files generated for them

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;
use Try::Tiny;
use List::MoreUtils 'any';

use App::DuckPAN::TemplateDefinitions;

no warnings 'uninitialized';
##########################
# Command line arguments #
##########################

# A 'template' for the user is equivalent to a 'template-set' for the program
option template => (
	is      => 'rwp',
	format  => 's',
	default => 'default',
	short   => 't',
	doc     => 'template used to generate the instant answer skeleton (default: default)',
);

option list_templates => (
	is    => 'ro',
	short => 'l',
	doc   => 'list the available instant answer templates and exit',
);

option cheatsheet => (
	is    => 'ro',
	short => 'c',
	doc   => "create a Cheat Sheet (short for `--template cheatsheet'; valid only for Goodies)",
);

option no_optionals => (
	is  => 'ro',
	short => 'N',
	doc => 'do not create any optional files from the chosen template',
);

##############
# Attributes #
##############

has _template_defs => (
	is       => 'ro',
	init_arg => undef,
	lazy     => 1,
	builder  => 1,
	doc      => 'Template definitions for the templates for the current IA type',
);

sub _build__template_defs {
	my $self = shift;
	my $template_defs;

	# Read the templates.yml file
	try {
		$template_defs = App::DuckPAN::TemplateDefinitions->new;
	} catch {
		my $error = $_;

		if ($error =~ /no such file/i) {
			# Handle the 'no such file or directory' exception
			# specially to show more information since it can be a
			# common error for users with an older IA repository
			my $type = $self->app->get_ia_type();

			$self->app->emit_and_exit(-1,
				"Template definitions file not found for " . $type->{name} .
				" Instant Answers. You may need to pull the latest version " .
				"of this repository.");
		}
		else {
			$self->app->emit_and_exit(-1, $error);
		}
	};

	return $template_defs;
}

has _template_set => (
	is       => 'ro',
	init_arg => undef,
	lazy     => 1,
	builder  => 1,
	doc      => 'The template set chosen by the user',
);

sub _build__template_set {
	my $self = shift;
	my $type = $self->app->get_ia_type();
	my $template_defs = $self->_template_defs;

	# Get the template chosen by the user
	my $template_set = $template_defs->get_template_set($self->template);

	unless ($template_set) {
		# We didn't find the template-set by the name. This could mean
		# that there was a typo in the name or the user has an older IA
		# repo and it not present in that version.
		$self->app->emit_and_exit(-1,
			"'" . $self->template . "' is not a valid template for a " .
			$type->{name} . " Instant Answer. You may need to update " .
			"your repository to get the latest templates.\n" .
			$self->_available_templates_message);
	}

	return $template_set;
}

###########
# Methods #
###########

# Copy of @ARGV before MooX::Options processes it
my @ORIG_ARGV;

before new_with_options => sub { @ORIG_ARGV = @ARGV };

sub run {
	my ($self, @args) = @_;

	# Check which IA repo we're in...
	my $type = $self->app->get_ia_type();

	my $no_handler = 0;
	# Process the --cheatsheet option
	if ($self->cheatsheet || $self->template eq 'cheatsheet') {
		if ($type->{name} ne 'Goodie') {
			$self->app->emit_and_exit(-1,
				"Cheat Sheets can be created only in the Goodie " .
				"Instant Answer repository.");
		}

		$self->_set_template('cheatsheet');
		$no_handler = 1;
	}

	# Process the --list-templates option: List the template-set names and exit with success
	$self->app->emit_and_exit(0, $self->_available_templates_message)
		if $self->list_templates;

	# Gracefully handle the case where '--template' is the last argument
	$self->app->emit_and_exit(
		1,
		"Please specify the template for your Instant Answer.\n" .
		$self->_available_templates_message
	) if ($ORIG_ARGV[$#ORIG_ARGV] // '') eq '--template';

	# Get the template-set instance based on the command line arguments.
	my $template_set = $self->_template_set();

	$self->app->emit_info('Creating a new ' . $template_set->description . '...');

	# Instant Answer name as parameter
	my $entered_name = (@args) ? join(' ', @args) : $self->app->get_reply('Please enter a name for your Instant Answer: ');

	if (my $normalized = $self->app->normalize_ia_name($entered_name)) {
		$self->app->emit_and_exit(-1, "An instant answer with the name '$normalized' already exists");
	}

	# Validate the entered name
	$self->app->emit_and_exit(-1, 'Must supply a name for your Instant Answer.') unless $entered_name;
	$self->app->emit_and_exit(-1,
		"'$entered_name' is not a valid name for an Instant Answer. " .
		'Please run the program again and provide a valid name.'
	) unless $entered_name =~ m@^( [a-zA-Z0-9\s] | (?<![:/])(::|/)(?![:/]) )+$@x;
	$self->app->emit_and_exit(-1,
		'The name for this type of Instant Answer cannot contain package or path separators. ' .
		'Please run the program again and provide a valid name.'
	) if !$template_set->subdir_support && $entered_name =~ m![/:]!;

	$entered_name =~ s/\//::/g;    #change "/" to "::" for easier handling

	my $package_name = $self->app->phrase_to_camel($entered_name);
	my ($name, $separated_name, $path, $lc_path) = ($package_name, $package_name, '', '');

	$separated_name =~ s/::/ /g;

	if ($package_name =~ m/::/) {
		my @path_parts = split(/::/, $package_name);
		if (scalar @path_parts > 1) {
			$name    = pop @path_parts;
			$path    = join("/", @path_parts);
			$lc_path = join("/", map { $self->app->camel_to_underscore($_) } @path_parts);
		}
		else {
			$self->app->emit_and_exit(-1, "Malformed input. Please provide a properly formatted package name for your Instant Answer.");
		}
	}

	my $lc_name     = $self->app->camel_to_underscore($name);
	my $filepath    = $path ? "$path/$name" : $name;
	my $lc_filepath = $lc_path ? "$lc_path/$lc_name" : $lc_name;
	if (scalar $lc_path) {
		$lc_path =~ s/\//_/g;    #safe to modify, we already used this in $lc_filepath
		$lc_name = $lc_path . '_' . $lc_name;
	}

	my @optional_templates = $self->_ask_optional_templates
		unless $self->no_optionals;

	my %vars = (
		ia_package_name   => $package_name,
		ia_name_separated => $separated_name,
		ia_id             => $lc_name,
		ia_path           => $filepath,
		ia_path_lc        => $lc_filepath,
	);

	# If the Perl module every becomes optional, this should only run if the user
	# requests one
	unless($no_handler){
		%vars = (%vars, %{$self->_config_handler});
	}

	# Generate the instant answer files. The return value is a hash with
	# information about the created files and any error that was encountered.
	my %generate_result = $template_set->generate(\%vars, \@optional_templates);

	# Show the list of files that were successfully created
	my @created_files = @{$generate_result{created_files}};
	$self->app->emit_info('Created files:');
	$self->app->emit_info("    $_")     for    @created_files;
	$self->app->emit_info('    (none)') unless @created_files; # possible on error

	if (my $error = $generate_result{error}) {
		# Remove the line number information if not in verbose mode.
		# This error message would be seen mostly by users writing IAs
		# for whom the line numbers don't add much value.
		$error =~ s/.*\K at .* line \d+\.$//
			unless $self->app->verbose;

		$self->app->emit_and_exit(-1, $error)
	}

	$self->app->emit_info('Success!');
}

# Allow user to choose a handler
sub _config_handler {
	my $self = shift;

	my @handlers = (
		# Scalar-based
		'remainder: (default) The query without the trigger words, spacing and case are preserved.',
		'query_raw: Like remainder but with trigger words intact',
		'query: Full query normalized with a single space between terms',
		'query_lc: Like query but in lowercase',
		'query_clean: Like query_lc but with non-alphanumeric characters removed',
		'query_nowhitespace: All whitespace removed',
		'query_nowhitespace_nodash: All whitespace and hyphens removed',
		# Array-based
		'matches: Returns an array of captured expression from a regular expression trigger',
		'words: Like query_clean but returns an array of the terms split on whitespace',
		'query_parts: Like query but returns an array of the terms split on whitespace',
		'query_raw_parts: Like query_parts but array contains original whitespace elements'
	);

	my $res = $self->app->get_reply(
		'Which handler would you like to use to process the query?',
		choices => \@handlers,
		default => $handlers[0]
	);

	unless($res =~ /^([^:]+)/){
		$self->app->emit_and_exit(-1, "Failed to extract handler from response: $res");
	}
	my $handler = $1;
	my $var = (any {$handler eq $_} qw(words query_parts query_raw_parts matches)) ? '@' : '$';
	my $trigger = $handler eq 'matches'
		? q{query => qr/trigger regex/}
		: q{any => 'triggerword', 'trigger phrase'};

	return {
		ia_handler => $handler,
		ia_handler_var => $var,
		ia_trigger => $trigger
	};
}

# Ask the user for which optional templates they want to use and return a list
# of the chosen templates
sub _ask_optional_templates {
	my $self = shift;
	my $template_set = $self->_template_set;
	my $combinations = $template_set->optional_template_combinations;

	# no optional templates; nothing to do
	return unless @$combinations;

	my $show_optional_templates = $self->app->ask_yn(
		'Would you like to configure optional templates?',
		default => 0,
	);

	if ($show_optional_templates) {
		# The choice strings to show to the user
		my @choices;
		# Mapping from a choice string to the corresponding template combination
		my %choice_combinations;

		for my $combination (@$combinations) {
			# Label of every template in the combination
			my @labels = map { $_->label } @$combination;
			my $choice = join(', ', @labels);

			push @choices, $choice;
			$choice_combinations{$choice} = $combination;
		}

		my $reply = $self->app->get_reply(
			'Choose configuration',
			choices => \@choices,
			default => $choices[0],
		);

		return @{$choice_combinations{$reply}};
	}

	return;
}

# Create a message with the list of available template-sets for this IA type
sub _available_templates_message {
	my $self = shift;
	my $template_defs = $self->_template_defs;
	# template-sets, sorted by name
	my @template_sets =
		sort { $a->name cmp $b->name } $template_defs->get_template_sets;

	my $message = "Available templates:";

	for my $template_set (@template_sets) {
		$message .= sprintf("\n    %10s - %s",
			$template_set->name,
			$template_set->description,
		);
	}

	return $message;
}

1;
