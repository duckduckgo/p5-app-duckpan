package App::DuckPAN::TemplateSet;
# ABSTRACT: Set of templates an Instant Answer

# A group of templates is a template set. Conceptually this represents a
# sub-type of an instant answer type. For example, a Goodie can be a standard
# Goodie or a Cheat Sheet goodie, each of which corresponds to a template set.
#
# Each template set can have required and optional templates. 'required' templates
# are always used to generate output files, while the user's confirmation is
# needed before each optional template is processed.

use Moo;

use Try::Tiny;
use List::Util qw(all);

use namespace::clean;

has name => (
    is       => 'ro',
    required => 1,
    doc      => 'Name of the template set',
);

has description => (
    is       => 'ro',
    required => 1,
    doc      => 'Description of the template set',
);

has required_templates => (
    is       => 'ro',
    required => 1,
    doc      => 'Arrayref of App::DuckPAN::Template instances that represent mandatory templates',
);

has optional_templates => (
    is       => 'ro',
    required => 1,
    doc      => 'Arrayref of App::DuckPAN::Template instances that represent optional templates',
);

# check if all templates in the array @templates are optional
sub _are_templates_optional {
    my ($self, @templates) = @_;
    my %optional_templates = map { ($_ => 1) } @{$self->optional_templates};

    return all { $optional_templates{$_} } @templates;
}

# Use the template to generate necessary files. Takes 2 parameters:
# $vars: variables to substitute in the templates
# $optional_templates: arrayref of template instances taken from $self->optional_templates
sub generate {
    my ($self, $vars, $optional_templates) = @_;
    my @created_files;
    my $error;

    # Verify that $optional_templates has templates from within $self->optional_templates
    $self->_are_templates_optional(@$optional_templates)
	or die "Unknown template(s) in \$optional_templates";
	
    for my $template (@{$self->required_templates}, @$optional_templates) {
	try {
	    push @created_files, $template->generate($vars);
	} catch {
	    $error = $_;
	};

	last if $error;
    }

    return (created_files => [ @created_files ], error => $error);
}

1;

