package App::DuckPAN::Cmd::Publisher;
# ABSTRACT: Starting up the publisher test webserver

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

use Path::Tiny;
use Plack::Handler::Starman;

for (qw( duckduckgo dontbubbleus donttrackus whatisdnt fixtracking duckduckhack )) {
	option $_ => (
		is => 'ro',
		format => 's',
		predicate => 1,
	);
}

sub run {
	my ( $self, @args ) = @_;

	$self->app->show_msg("Checking for Publisher...");

	my $publisher_pm = path('lib','DDG','Publisher.pm');
	$self->add->exit_with_msg(1, "You must be in the root of the duckduckgo-publisher repository") unless $publisher_pm->exists;

	$self->app->show_msg("Starting up publisher webserver...", "You can stop the webserver with Ctrl-C");

	my %sites = (
		duckduckgo => {
			port => 5000,
			url => $self->has_duckduckgo ? $self->duckduckgo : "http://duckduckgo.com/",
		},
		dontbubbleus => {
			port => 5001,
			url => $self->has_dontbubbleus ? $self->dontbubbleus : "http://dontbubble.us/",
		},
		donttrackus => {
			port => 5002,
			url => $self->has_donttrackus ? $self->donttrackus : "http://donttrack.us/",
		},
		whatisdnt => {
			port => 5003,
			url => $self->has_whatisdnt ? $self->whatisdnt : "http://whatisdnt.com/",
		},
		fixtracking => {
			port => 5004,
			url => $self->has_fixtracking ? $self->fixtracking : "http://fixtracking.com/",
		},
		duckduckhack => {
			port => 5005,
			url => $self->has_duckduckhack ? $self->duckduckhack : "http://duckduckhack.com/",
		},
	);

	for (sort { $sites{$a}->{port} <=> $sites{$b}->{port} } keys %sites) {
		$self->app->show_msg("Serving on port ".$sites{$_}->{port}.": ".$sites{$_}->{url});
	}

	require App::DuckPAN::WebPublisher;
	my $web = App::DuckPAN::WebPublisher->new(
		app => $self->app,
		sites => \%sites,
	);
	my @ports = map { $sites{$_}->{port} } keys %sites;
	exit Plack::Handler::Starman->new(listen => [ map { ":$_" } @ports ])->run(sub { $web->run_psgi(@_) });
}

1;
