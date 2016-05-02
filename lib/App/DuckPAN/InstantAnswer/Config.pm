package App::DuckPAN::InstantAnswer::Config;
# ABSTRACT: Holds meta information about an Instant Answer being
# configured.

use Moo;

use App::DuckPAN::InstantAnswer::Util qw(find_ia_files);

has ia => (
	is       => 'ro',
	doc      => 'Instant Answer being configured.',
	required => 1,
);

has files => (
	is      => 'ro',
	builder => 1,
	lazy    => 1,
);

sub _build_files {
	my $self = shift;
	my %files = find_ia_files($self->ia);
	return \%files;
}

1;

__END__
