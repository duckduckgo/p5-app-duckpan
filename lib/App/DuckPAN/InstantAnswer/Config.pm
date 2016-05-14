package App::DuckPAN::InstantAnswer::Config;
# ABSTRACT: Holds meta information about an Instant Answer being
# configured.

use Moo;

use App::DuckPAN::InstantAnswer::Util qw(find_ia_files is_cheat_sheet);

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

sub refresh {
	my $self = shift;
	$self->_set_files($self->_build_files);
}

1;

__END__
