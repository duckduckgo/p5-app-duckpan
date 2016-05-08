package App::DuckPAN::InstantAnswer::Cmd::Multi;
# ABSTRACT: Role for commands that handle multiple Instant
# Answers

use App::DuckPAN::InstantAnswer::Util qw(get_ia);
use App::DuckPAN::InstantAnswer::Config;

use namespace::clean;

use Moo::Role;

requires qw(initialize app args);

has ias => (
	is      => 'rwp',
	default => sub { [] },
);

# Get *configured*, *valid*, Instant Answers from the CL arguments
# or current repo.
after initialize => sub {
	my $self = shift;
	my @args = @{$self->args};
	my $repo = $self->app->repository;
	my @ias = @args
		? map { $self->app->get_ia_by_name($_) } @args
		: grep { $_->is_configured }
				map { App::DuckPAN::InstantAnswer::Config->new(
					meta => $_) } get_ia(repo => $repo->{repo});
	$self->_set_ias(\@ias);
	return @ias;
};

1;

__END__
