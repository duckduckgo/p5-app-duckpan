package App::DuckPAN::TemplateSet;
# ABSTRACT: Set of templates an Instant Answer

# A group of templates is a template set. Conceptually this represents a
# sub-type of an instant answer type. For example, a Goodie can be a standard
# Goodie or a Cheat Sheet goodie, each of which corresponds to a template set.

use Moo;
use List::Util qw(all);
use namespace::clean;

has id => (
	is       => 'ro',
	required => 1,
	doc      => 'Unique ID of the template set',
);

has description => (
	is       => 'ro',
	required => 1,
	doc      => 'Description of the template set',
);

has templates => (
	is       => 'ro',
	required => 1,
	doc      => 'Templates that comprise the template set.',
);

# A TemplateSet supports an Instant Answer if all of its templates
# do.
sub supports {
	my ($self, $ia) = @_;
	return all { $_->supports($ia) } @{$self->templates};
}

sub generate {
	my ($self, %options) = @_;
	foreach my $template (@{$self->templates}) {
		$template->configure(%options);
	}
}

1;

