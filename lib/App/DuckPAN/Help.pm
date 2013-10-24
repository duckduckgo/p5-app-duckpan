package App::DuckPAN::Help;
# ABSTRACT: Contains the main help page

use Moo;
use Pod::Usage;

sub help { pod2usage(verbose => 2); }

1;
