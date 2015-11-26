package App::DuckPAN::Cmd::Publisher;
# ABSTRACT: Starting up the publisher test webserver

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;
use Path::Tiny;
use Plack::Handler::Starman;

for (qw( duckduckgo dontbubbleus donttrackus duckduckhack )) {
	option $_ => (
		is => 'ro',
		format => 's',
		predicate => 1,
	);
}

sub run {
	my ( $self, @args ) = @_;

	$self->app->emit_info("Checking for Publisher...");

	my $publisher_pm = path('lib','DDG','Publisher.pm');
	$self->add->emit_and_exit(1, "You must be in the root of the duckduckgo-publisher repository") unless $publisher_pm->exists;

	$self->app->emit_info("Starting up publisher webserver...", "You can stop the webserver with Ctrl-C");

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
		duckduckhack => {
			port => 5005,
			url => $self->has_duckduckhack ? $self->duckduckhack : "http://duckduckhack.com/",
		},
	);

	for (sort { $sites{$a}->{port} <=> $sites{$b}->{port} } keys %sites) {
		$self->app->emit_info("Serving on port ".$sites{$_}->{port}.": ".$sites{$_}->{url});
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
