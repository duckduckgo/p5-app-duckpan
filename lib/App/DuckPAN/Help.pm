package App::DuckPAN::Help;

use Moo;

has version => ( is => 'ro', required => 1 );

sub header { my $version = shift->version; return <<"__EOT__"; }

  ____    V$version   _    ____   _    _   _
 |  _ \\ _   _  ___| | _|  _ \\ / \\  | \\ | |
 | | | | | | |/ __| |/ / |_) / _ \\ |  \\| |
 | |_| | |_| | (__|   <|  __/ ___ \\| |\\  |
 |____/ \\__,_|\\___|_|\\_\\_| /_/   \\_\\_| \\_|

  Contributing to https://duckduckgo.com/
  =======================================

__EOT__

sub help { return shift->header().<<'__EOT__'; }
=> You need an account at https://dukgo.com/

duckpan setup
-------------
 Initialize your DuckPAN development environment

duckpan check
-------------
 Check if you fulfill all requirements for the development
 environment (will automatically gets fired on setup)

duckpan new <language>-<component> <projectname>
------------------------------------------------
 Startup a new project for development
 
duckpan release
---------------
 Release the project of the current directory to DuckPAN

duckpan test
------------
 Test your release (will automatically gets fired before release)

duckpan help <command>
----------------------
 More help about the specific commands

duckpan faq
-----------
 Frequently asked questions

__EOT__

1;
