package App::DuckPAN::Query;

use Moo;

my $query;
my $history_path;

use Data::Printer;
use POE qw( Wheel::ReadLine );

sub run {
	my ( $self, @blocks ) = @_;

	require DDG;
	DDG->import;
	require DDG::Request;
	DDG::Request->import;
	require DDG::Test::Location;
	DDG::Test::Location->import;
	require DDG::Test::Language;
	DDG::Test::Language->import;

	# $history_path = $self->app->cache_path."/query_history";
	# warn $self->app->cache_path;

	print "\n(Empty query for ending test)\n";
	# while (my $query = $self->app->get_reply( 'Query: ' ) ) {
	while (1) {
		
		POE::Session->create(
	      inline_states=> {
	        _start => \&setup_console,
	        got_user_input => \&handle_user_input,
	      }
	    );

	    POE::Kernel->run();

	    last unless $query;
		
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
	return 0;
}

sub handle_user_input {
  my ($input, $exception) = @_[ARG0, ARG1];
  my $console = $_[HEAP]{console};

  unless (defined $input) {
    $_[KERNEL]->signal($_[KERNEL], "UIDESTROY");
    return;
  }

  unless ($input eq ""){
    $console->put("  You entered: $input");
    $console->addhistory($input);
    $console->write_history($history_path);
  }
  $query = $input;
}
 
sub setup_console {
  $_[HEAP]{console} = POE::Wheel::ReadLine->new(
    InputEvent => 'got_user_input'
  );
  $_[HEAP]{console}->read_history($history_path);
  $_[HEAP]{console}->get("Query: ");
}


1;