package App::DuckPAN::Cmd::Publisher;
# ABSTRACT: Starting up the publisher test webserver

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

use Path::Class;
use Plack::Handler::Starman;

for (qw( duckduckgo dontbubbleus donttrackus whatisdnt fixtracking )) {
	option $_ => (
		is => 'ro',
		format => 's',
		predicate => 1,
	);
}

option dontbubbleus => (
	is => 'ro',
	format => 's',
	predicate => 1,
);

option donttrackus => (
	is => 'ro',
	format => 's',
	predicate => 1,
);

option domain => (
	is => 'ro',
	format => 's',
	predicate => 1,
);

sub run {
	my ( $self, @args ) = @_;

	print "\n\nChecking for Publisher...\n";

	my $publisher_pm = file('lib','DDG','Publisher.pm')->absolute;
	die "You must be in the root of the duckduckgo-publisher repository" unless -f $publisher_pm;

	print "\n\nStarting up publisher webserver...";
	print "\n\nYou can stop the webserver with Ctrl-C";
	print "\n\n";

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
	);

	for (keys %sites) {
		print "Serving ".$sites{$_}->{url}." on ".$sites{$_}->{port}."\n";
	}

	print "\n\n";

	require App::DuckPAN::WebPublisher;
	my $web = App::DuckPAN::WebPublisher->new(
		app => $self->app,
		sites => \%sites,
	);
	my @ports = map { $sites{$_}->{port} } keys %sites; 
	exit Plack::Handler::Starman->new(listen => [ map { ":$_" } @ports ])->run(sub { $web->run_psgi(@_) });
}

1;
