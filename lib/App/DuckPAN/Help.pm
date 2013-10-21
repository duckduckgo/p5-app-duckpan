package App::DuckPAN::Help;
# ABSTRACT: Contains the main help page

use Moo;
use Pod::Usage;

has version => ( is => 'ro', required => 1 );

sub header { my $version = shift->version; return <<"__EOT__"; }

 ____   V$version    _    ____   _    _   _
|  _ \\ _   _  ___| | _|  _ \\ / \\  | \\ | |
| | | | | | |/ __| |/ / |_) / _ \\ |  \\| |
| |_| | |_| | (__|   <|  __/ ___ \\| |\\  |
|____/ \\__,_|\\___|_|\\_\\_| /_/   \\_\\_| \\_|

 Contributing to https://duckduckgo.com/
 =======================================

__EOT__

sub help { pod2usage(verbose => 2); }

1;
