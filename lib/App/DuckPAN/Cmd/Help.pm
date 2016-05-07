package App::DuckPAN::Cmd::Help;
# ABSTRACT: Launch help page

use Moo;
with qw( App::DuckPAN::Option::Global );

use MooX::Options protect_argv => 0;
use Pod::Usage qw(pod2usage);

sub run {
	my ($self, $short_output, $no_exit) = @_;

	$no_exit &&= 'NOEXIT';
	my $verbosity = $short_output ? 1 : 2;
	pod2usage(-verbose => $verbosity, -exitval => $no_exit);
}

1;
