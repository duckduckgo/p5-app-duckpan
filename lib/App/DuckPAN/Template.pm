package App::DuckPAN::Template;
# ABSTRACT: Template to generate one file of an Instant Answer

# An Instant Answer has multiple templates, each of which can be used
# to generate one output file.

use Moo;

use Try::Tiny;
use Text::Xslate;
use Path::Tiny qw(path);
use Carp;

use namespace::clean;

has name => (
	is       => 'ro',
	required => 1,
	doc      => 'Name of the template',
);

has label => (
	is       => 'ro',
	required => 1,
	doc      => 'Label of the template',
);

has input_file => (
	is       => 'ro',
	required => 1,
	doc      => 'Path of the input file for the template',
);

has output_file => (
	is       => 'ro',
	required => 1,
	doc      => 'Path of the output file for the template. ' .
	            'This string is rendered through Text::Xslate to get the final path.',
);

has output_directory => (
	is       => 'ro',
	init_arg => undef,
	lazy     => 1,
	builder  => 1,
	doc      => 'Directory known to contain all of the generated template output files and subdirectories',
);

sub _build_output_directory {
	my ($self) = @_;
	my $out_dir = path($self->output_file);

	# Get the directory that is certain to be the closest ancestor of the
	# output file i.e., keep removing directory parts from the right till the
	# path does not contain any Text::Xslate syntax.
	$out_dir = $out_dir->parent while $out_dir =~ /<:/;

	return $out_dir;
}

# Create the output file from the input file
sub generate {
	my ($self, $vars) = @_;

	# Increased verbosity to help while writing templates
	my $tx = Text::Xslate->new(type => 'text', verbose => 2);
	my $input_file = path($self->input_file);

	# (should not occur for users)
	die "Template input file '$input_file' not found" unless $input_file->exists;

	# The output file path is a Text::Xslate template, so we generate the
	# actual path here
	my $output_file = path($tx->render_string($self->output_file, $vars));

	croak("Template output file $output_file already exists") and return if $output_file->exists;

	my $content = $tx->render($input_file, $vars);

	try {
	    path($output_file)->touchpath->spew_utf8($content);
	} catch {
	    croak "Error creating output file '$output_file' from template: $_";
	};

	return $output_file;
}

1;

