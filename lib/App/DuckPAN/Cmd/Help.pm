package App::DuckPAN::Cmd::Help;
# ABSTRACT: Launch help page

use Moo;
with qw( App::DuckPAN::Cmd );
use Pod::Usage qw(pod2usage);

sub run {
	my ($self, $short_output) = @_;


	pod2usage(-verbose => 2) unless $short_output;
	pod2usage(-verbose => 1);
}

1;