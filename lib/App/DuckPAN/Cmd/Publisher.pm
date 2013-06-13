package App::DuckPAN::Cmd::Publisher;
# ABSTRACT: Starting up the publisher test webserver

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

use Path::Class;
use Plack::Handler::Starman;

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
			url => "http://duckduckgo.com/",
		},
		dontbubbleus => {
			port => 5001,
			url => "http://dontbubble.us/",
		},
		donttrackus => {
			port => 5002,
			url => "http://donttrack.us/",
		},	
		whatisdnt => {
			port => 5003,
			url => "http://whatisdnt.com/",
		},
		#fixtracking => {
		#	port => 5004,
		#	url => "http://fixtracking.com/",
		#},
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
