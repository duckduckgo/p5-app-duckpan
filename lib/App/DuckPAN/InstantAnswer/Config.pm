package App::DuckPAN::InstantAnswer::Config;
# ABSTRACT: Holds meta information about an Instant Answer being
# configured.

use Moo;

use App::DuckPAN::InstantAnswer::Util qw(find_ia_files is_cheat_sheet);
use App::DuckPAN::Template::Definitions;
use App::DuckPAN::Template::Set;

use Data::Dumper;

has meta => (
	is       => 'ro',
	required => 1,
	doc      => 'Instant Answer Metadata',
);

has files => (
	is      => 'rwp',
	builder => 1,
	lazy    => 1,
);

has repo => (
	is  => 'ro',
	doc => 'Instant Answer repository associated with the Instant Answer',
);

my $template_def = App::DuckPAN::Template::Definitions->new();
my $template_sets = App::DuckPAN::Template::Set->new();

sub _build_files {
	my $self = shift;
	my %files = find_ia_files($self->meta);
	return \%files;
}

$Data::Dumper::Terse = 1;
sub for_display {
	my ($self, $item) = @_;
	return Dumper($item);
}

sub get_available_templates {
	my $self = shift;
	return $template_def->lookup(sub { $_[0]->supports($_[1]) } => $self->meta);
}

sub get_available_template_sets {
	my $self = shift;
	return $template_sets->lookup(sub { $_[0]->supports($_[1]) } => $self->meta);
}

sub refresh {
	my $self = shift;
	$self->_set_files($self->_build_files);
}

1;

__END__
