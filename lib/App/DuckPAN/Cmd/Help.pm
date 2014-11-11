package App::DuckPAN::Cmd::Help;
# ABSTRACT: Launch help page

use Moo;
with qw( App::DuckPAN::Cmd );
use Pod::Usage;

sub run { pod2usage(-verbose => 2) }

1;
