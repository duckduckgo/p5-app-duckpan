package App::DuckPAN::Cmd::Query;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Data::Printer;

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_ddg;

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	require DDG;
	DDG->import;
	require DDG::Request;
	DDG::Request->import;
	require DDG::Test::Location;
	DDG::Test::Location->import;
	require DDG::Test::Language;
	DDG::Test::Language->import;

	print "\n(Empty query for ending test)\n";
	while (my $query = $self->app->get_reply( 'Query: ' ) ) {
		eval {
			my $request = DDG::Request->new(
				query_raw => $query,
				location => test_location_by_env(),
				language => test_language_by_env(),
			);
			my $hit;
			for (@blocks) {
				my ($result) = $_->request($request);
				if ($result) {
					$hit = 1;
					print "\n";
					p($result);
					print "\n";
					last;
				}
			}
			unless ($hit) {
				print "\nSorry, no hit on your plugins\n\n";
			}
		};
		if ($@) {
			my $error = $@;
			if ($error =~ m/Malformed UTF-8 character/) {
				print "\n[WARNING] You got a malformed utf8 error message, which normally means\n";
				print "that you try to entered a special character on the query prompt, but your\n";
				print "interface is not proper configured towards utf8. Please checkout the\n";
				print "documentation of your terminal, ssh client or whatever client you use\n";
				print "to access the shell of this system\n\n";
				print "Here the original error message:\n\n";
			} else {
				print "\nCatched error:\n\n";
			}
			print $error."\n";
		}
	}
	print "\n\n\\_o< Thanks for testing!\n\n";
	exit 0;
}

1;
