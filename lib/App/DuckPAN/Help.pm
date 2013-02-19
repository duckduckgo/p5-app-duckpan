package App::DuckPAN::Help;
# ABSTRACT: Contains the main help page

use Moo;

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

sub help { return shift->header().<<'__EOT__'; }
Usage:

- duckpan check
    Check if you fulfill all requirements for the development
    environment (this is run automatically during setup)

duckpan installdeps
-------------------
 Install all requirements of the specific DuckDuckHack project (if
 possible), like zeroclickinfo-spice, zeroclickinfo-goodie, duckduckgo
 or community-platform

duckpan query
-------------
 Test goodies and spice interactively on the command line

duckpan server
--------------
 Test spice on a local web server

duckpan env <name> <value>
--------------------------
 Add an environment variable that duckpan will remember. Useful for
 spice API keys. Variables are stored in ~/.duckpan/env.ini

duckpan env rm <name>
---------------------
 Remove an environment variable from duckpan

duckpan release
---------------
 Release the project of the current directory to DuckPAN [TODO]

duckpan test
------------
 Test your release (this will run automatically before a release)

duckpan release
---------------
 Release the project of the current directory to DuckPAN

__EOT__

1;
