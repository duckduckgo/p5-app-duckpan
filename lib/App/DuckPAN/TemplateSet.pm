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
use Algorithm::Combinatorics qw(combinations);

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

has optional_template_combinations => (
    is       => 'ro',
    lazy     => 1,
    builder  => 1,
    init_arg => undef,
    doc      => 'Arrayref of possible optional template combinations, ' .
                'which themselves are arrayrefs of templates.',
);

# All possible template combinations are generated from the list in the
# 'optional_templates' attribute. They are sorted by the following rules:
#
#   1. Combinations are sorted by length (ascending)
#   2. In each combination, the templates are sorted in the same order that
#      they appear in the 'optional_templates' attribute
#   3. Combinations of the same length are then sorted based on the same rule
sub _build_optional_template_combinations {
    my $self = shift;
    my @templates = @{$self->optional_templates};

    # Map of template -> position in template list
    my %template_pos = map { ($templates[$_] => $_) } 0..$#templates;

    # All combinations of all lengths; sorted
    my @template_combinations;

    for my $length (1..@templates) {
        # Generate all combinations of length $length
        my @combinations = combinations(\@templates, $length);

        # Sort the tempates in each combination
        for my $combination (@combinations) {
            @$combination = sort { $template_pos{$a} <=> $template_pos{$b} } @$combination;
        }

        # Sort the array of combinations
        @combinations = sort {
            # The comparison function compares two arrayrefs of templates.
            # Templates from both the arrayrefs are compared one by one and the
            # function returns the value when it finds a difference.
            for my $i (0..$length-1) {
                my $cmp = $template_pos{$a->[$i]} <=> $template_pos{$b->[$i]};

                return $cmp;
            }
        } @combinations;

        push @template_combinations, @combinations;
    }

    return \@template_combinations;
}

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

