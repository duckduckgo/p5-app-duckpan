package App::DuckPAN::Cmd::Static;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

use Plack::Handler::Starman;

sub run {
	my ( $self, @args ) = @_;

	print "\n\nStarting up static webserver...";
	print "\n\nYou can stop the webserver with Ctrl-C";
	print "\n\n";

	require App::DuckPAN::WebStatic;

	my %sites = (
		duckduckgo => {
			port => 5000,
			url => "http://duckduckgo.com",
		},
		dontbubbleus => {
			port => 5001,
			url => "http://dontbubble.us",
		},
		donttrackus => {
			port => 5002,
			url => "http://donttrack.us",
		},
	);

	for (keys %sites) {
		print "Serving ".$sites{$_}->{url}." on ".$sites{$_}->{port}."\n";
	}

	print "\n\n";

	my $web = App::DuckPAN::WebStatic->new(
		sites => \%sites,
	);
	my @ports = map { $sites{$_}->{port} } keys %sites; 
	exit Plack::Handler::Starman->new(listen => [ map { ":$_" } @ports ])->run(sub { $web->run_psgi(@_) });
}

1;
