package App::DuckPAN::Template::Set;
# ABSTRACT: TemplateSet definitions

use App::DuckPAN::TemplateSet;
use App::DuckPAN::Template::Definitions;
use Moo;
with qw( App::DuckPAN::Lookup );

my $template_defs = App::DuckPAN::Template::Definitions->new();

my %default_template_sets = (
	goodie_standard => {
		description => 'Standard Goodie Instant Answer',
		templates    => [
			map { $template_defs->lookup(id => $_) } qw(pm test),
		],
	},
	cheat_sheet => {
		description => 'Cheat Sheet Instant Answer',
		templates   => [
			$template_defs->lookup(id => 'cheat_sheet'),
		],
	},
);

has definitions => (
	is      => 'ro',
	default => sub { \%default_template_sets },
);

has template_sets => (
	is      => 'ro',
	builder => 1,
);

sub _lookup {
	my $self = shift;
	return $self->template_sets;
}

sub _lookup_id {
	return qw( id );
}

sub _build_template_sets {
	my $self = shift;
	my @template_sets;
	while (my ($template, $definition) = each %{$self->definitions}) {
		my $template_set = App::DuckPAN::TemplateSet->new(
			id => $template,
			%$definition,
		);
		push @template_sets, $template_set;
	}
	return \@template_sets;
}

1;

__END__
