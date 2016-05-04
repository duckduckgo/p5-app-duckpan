package App::DuckPAN::InstantAnswer::Config;
# ABSTRACT: Holds meta information about an Instant Answer being
# configured.

use Moo;

use App::DuckPAN::InstantAnswer::Util qw(find_ia_files is_cheat_sheet);
use App::DuckPAN::Template::Definitions;

use Data::Dumper;

has ia => (
	is       => 'ro',
	doc      => 'Instant Answer being configured.',
	required => 1,
);

has files => (
	is      => 'rwp',
	builder => 1,
	lazy    => 1,
);

my $template_def = App::DuckPAN::Template::Definitions->new();

sub _build_files {
	my $self = shift;
	my %files = find_ia_files($self->ia);
	return \%files;
}

$Data::Dumper::Terse = 1;
sub for_display {
	my ($self, $item) = @_;
	return Dumper($item);
}

sub get_available_templates {
	my $self = shift;
	return $template_def->get_templates(allow => $self->ia);
}

sub refresh {
	my $self = shift;
	$self->_set_files($self->_build_files);
}

1;

__END__
