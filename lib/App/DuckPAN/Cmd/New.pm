package App::DuckPAN::Cmd::New;
# ABSTRACT: Take a name as input and generates a new, named Goodie or Spice instant answer skeleton

# See the template/templates.yml file in the Goodie or Spice repository for the
# list of template-sets and files generated for them

use Moo;
with qw( App::DuckPAN::Cmd App::DuckPAN::Option::Tell );

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

option id => (
	is     => 'ro',
	format => 's',
	doc    => 'ID of Instant Answer to configure',
);

option list_templates => (
	is    => 'ro',
	short => 'l',
	doc   => 'list the available instant answer templates and exit',
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
		$template_defs = App::DuckPAN::TemplateDefinitions->new(
			template_type => lc $self->app->get_ia_type->{name},
		);
	} catch {
		my $error = $_;
		$self->app->emit_and_exit(-1, $error);
#		}
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

sub _ask_ia {
	my $self = shift;
	my $ia;
	my $check = sub {
		my $name = shift;
		$ia = $self->app->get_ia_by_name($name, no_fail => 1);
		return 1 if defined $ia;
	};
	$self->app->get_reply("Enter Name", allow => $check);
	return $ia;
}

my @cheat_sheet_templates = (
	'code', 'keyboard', 'language', 'link', 'reference', 'terminal',
);

sub _get_config_cheat_sheet {
	my ($self, %vars) = @_;
	my $ia = $vars{ia};
	my $name = $ia->{name} =~ s/\s*cheat\s*sheet\s*$//ri;
	my $id = $ia->{id};
	my $fname = $id =~ s/_cheat_sheet$//r;
	$fname =~ s/_/-/g;
	$fname .= '.json';
	my $cheat_sheet_template = $self->app->get_reply(
		"Template type", choices => \@cheat_sheet_templates,
	);
	$self->_set_template('cheatsheet');
	return (%vars,
		ia_name_normalized  => $name,
		template_type => $cheat_sheet_template,
		file_name => $fname,
	);
}

sub _get_config_generic_vars {
	my $self = shift;
	my $ia;
	if ($self->id) {
		$ia = $self->app->get_ia_by_name($self->id);
	} else {
		unless ($self->app->ask_yn(
				'Have you already created an Instant Answer page?',
				default => 'y')
		) {
			$self->app->emit_and_exit(-1,
				"Please create an Instant Answer page before running duckpan new");
		}
		$ia = $self->_ask_ia();
	}
	my $required_repo = $ia->{repo};
	unless ($required_repo eq $self->app->get_ia_type->{repo}) {
		$self->app->emit_and_exit(-1,
			"Wrong repository for $ia->{id}, expecting '$required_repo'");
	}
	return (
		ia => $ia,
	);
}

sub _get_config_user {
	my ($self) = @_;
	my %vars = $self->_get_config_generic_vars();
	my $ia = $vars{ia};
	if ($ia->{id} =~ /_cheat_sheet$/) {
		return $self->_get_config_cheat_sheet(%vars);
	} else {
		return $self->_get_config_instant_answer(%vars);
	}
}

# Copy of @ARGV before MooX::Options processes it
my @ORIG_ARGV;

before new_with_options => sub { @ORIG_ARGV = @ARGV };

sub _get_config_instant_answer {
	my ($self, %vars) = @_;
	# Process the --list-templates option: List the template-set names and exit with success
	$self->app->emit_and_exit(0, $self->_available_templates_message)
		if $self->list_templates;

	my $ia = $vars{ia};

	my $package_name = $ia->{perl_module};
	my @separated_package = split '::', $package_name;
	my @base_parts = @separated_package[2..$#separated_package];
	my $ia_lib_path = join '/', @separated_package;
	my $ia_package_base_path = join '/', @base_parts;

	my $type = $self->app->get_ia_type();
	my $ia_share_path = join '/',
		('share', lc $type->{name}, $ia->{id});

	my %handler_config = $self->_config_handler();

	return (%vars, %handler_config,
		ia_lib_path          => $ia_lib_path,
		ia_package_base_path => $ia_package_base_path,
		ia_share_path        => $ia_share_path,
		ia_package_name      => $package_name,
	);
}

###########
# Methods #
###########

sub run {
	my ($self, @args) = @_;

	my $no_handler = 0;
	my %vars = $self->_get_config_user();

	# Get the template-set instance based on the command line arguments.
	my $template_set = $self->_template_set();

	$self->app->emit_info('Creating a new ' . $template_set->description . '...');

	my @optional_templates = $self->_ask_optional_templates
		unless $self->no_optionals;

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

	return (
		ia_handler => $handler,
		ia_handler_var => $var,
		ia_trigger => $trigger
	);
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
