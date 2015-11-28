package App::DuckPAN::Cmd::New;
# ABSTRACT: Take a name as input and generates a new, named Goodie or Spice instant answer skeleton

# See the template/templates.yml file in the Goodie or Spice repository for the
# list of template-sets and files generated for them

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;
use Try::Tiny;

use App::DuckPAN::TemplateDefinitions;

# A 'template' for the user is equivalent to a 'template-set' for the program
option template => (
	is      => 'ro',
	format  => 's',
	default => 'default',
	doc     => 'template used to generate the instant answer skeleton (default: default)',
);

option list_templates => (
	is  => 'ro',
	doc => 'list the available instant answer templates and exit',
);

has _template_defs => (
	is       => 'ro',
	init_arg => undef,
	lazy     => 1,
	builder  => 1,
	doc      => 'template definitions for the templates for the current IA type',
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
		} else {
			$self->app->emit_and_exit(-1, $error);
		}
	};

	return $template_defs;
}

sub run {
	my ($self, @args) = @_;

	# Check which IA repo we're in...
	my $type = $self->app->get_ia_type();

	# Process the --list-templates option: List the template-set names and exit with success
	$self->app->emit_and_exit(0, $self->_available_templates_message)
		if $self->list_templates;

	# Get the template-set instance based on the command line arguments.
	my $template_set = $self->_get_template_set();

	$self->app->emit_info("Creating a new " . $template_set->description . "...");

	# Instant Answer name as parameter
	my $entered_name = (@args) ? join(' ', @args) : $self->app->get_reply('Please enter a name for your Instant Answer: ');
	$self->app->emit_and_exit(-1, "Must supply a name for your Instant Answer.") unless $entered_name;
	$entered_name =~ s/\//::/g;    #change "/" to "::" for easier handling

	my $package_name = $self->app->phrase_to_camel($entered_name);
	my ($name, $separated_name, $path, $lc_path) = ($package_name, $package_name, "", "");

	$separated_name =~ s/::/ /g;

	if ($package_name =~ m/::/) {
		my @path_parts = split(/::/, $package_name);
		if (scalar @path_parts > 1) {
			$name    = pop @path_parts;
			$path    = join("/", @path_parts);
			$lc_path = join("/", map { $self->app->camel_to_underscore($_) } @path_parts);
		} else {
			$self->app->emit_and_exit(-1, "Malformed input. Please provide a properly formatted package name for your Instant Answer.");
		}
	}

	my $lc_name     = $self->app->camel_to_underscore($name);
	my $filepath    = ($path eq "") ? $name : "$path/$name";
	my $lc_filepath = ($lc_path eq "") ? $lc_name : "$lc_path/$lc_name";
	if (scalar $lc_path) {
		$lc_path =~ s/\//_/g;    #safe to modify, we already used this in $lc_filepath
		$lc_name = $lc_path . "_" . $lc_name;
	}

	my %vars = (
		ia_package_name   => $package_name,
		ia_name_separated => $separated_name,
		ia_id             => $lc_name,
		ia_path           => $filepath,
		ia_path_lc        => $lc_filepath,
	);

	# Ask which optional templates to create
	my @optional_templates;

	for my $template (@{$template_set->optional_templates}) {
		if ($self->app->ask_yn('Create ' . $template->description . '?',
				default => 0)) {
			push @optional_templates, $template;
		}
		print "\n";
	}

	# Generate the instant answer files. The return value is a hash with
	# information about the created files and any error that was encountered.
	my %generate_result = $template_set->generate(\%vars, \@optional_templates);

	# Show the list of files that were successfully created
	my @created_files = @{$generate_result{created_files}};
	$self->app->emit_info("Created files:");
	$self->app->emit_info("    $_")     for    @created_files;
	$self->app->emit_info("    (none)") unless @created_files; # possible on error

	if (my $error = $generate_result{error}) {
		# Remove the line number information if not in verbose mode.
		# This error message would be seen mostly by users writing IAs
		# for whom the line numbers don't add much value.
		$error =~ s/.*\K at .* line \d+\.$//
		    unless $self->app->verbose;

		$self->app->emit_and_exit(-1, $error)
	}

	$self->app->emit_info("Successfully created " . $type->{name} . ": $package_name");
}

# Get the template-set from the '--template' command line argument
sub _get_template_set {
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
