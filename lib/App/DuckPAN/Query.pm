package App::DuckPAN::Query;
# ABSTRACT: Main application/loop for duckpan query

use Moo;

my $query;
my $history_path;

use Data::Printer;
use POE qw( Wheel::ReadLine );

sub run {
	my ( $self, $app, @blocks ) = @_;

	require DDG;
	DDG->import;
	require DDG::Request;
	DDG::Request->import;
	require DDG::Test::Location;
	DDG::Test::Location->import;
	require DDG::Test::Language;
	DDG::Test::Language->import;

	$history_path = $app->cfg->cache_path->child("query_history");

	$app->emit_info('(Empty query for ending test)');
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
			for my $b (@blocks) {
				for ($b->request($request)) {
					$hit = 1;
					$app->emit_info('---', p($_, colored => 1), '---');
				}
			}
			unless ($hit) {
				$app->emit_info("Sorry, no hit on your instant answer")
			}
		};
		if ($@) {
			my $error = $@;
			if ($error =~ m/Malformed UTF-8 character/) {
				$app->emit_info(
					"You got a malformed utf8 error message, which normally means that you try to entered a special character on the query prompt, but your interface is not properly configured for utf8. Please check out the documentation of your terminal, ssh client or whatever client you use to access the shell of this system"
				);
			}
			$app->emit_info("Caught error:", $error);
		}
	}
	$app->emit_info("\\_o< Thanks for testing!");
	return 0;
}

sub handle_user_input {
  my ($input, $exception) = @_[ARG0, ARG1];
  my $console = $_[HEAP]{console};

  exit 0 unless defined $input;

  unless ($input eq ""){
    $console->put("  You entered: $input");
    $console->addhistory($input);
    $console->write_history($history_path);
  }
  $query = $input;
}
 
sub setup_console {
  my $powh_readline = POE::Wheel::ReadLine->new(
    InputEvent => 'got_user_input'
  );
  $powh_readline->bind_key("C-\\", "interrupt");
  $_[HEAP]{console} = $powh_readline;
  $_[HEAP]{console}->read_history($history_path);
  $_[HEAP]{console}->get("Query: ");
}


1;
