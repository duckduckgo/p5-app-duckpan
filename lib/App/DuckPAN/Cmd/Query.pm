package App::DuckPAN::Cmd::Query;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Data::Printer;

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_ddg;

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	print "\n(Empty query for ending test)\n";
	while (my $query = $self->app->term->get_reply( prompt => 'Query: ' ) ) {
		my $request = DDG::Request->new( query_raw => $query );
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
	}
	print "\n\n\\_o< Thanks for testing!\n\n";
	exit 0;
}

1;
