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

duckpan query
-------------
 Test your plugins if they match a specific query (interactive)

duckpan goodie
--------------
 More help there about DDG::Goodie

duckpan release
---------------
 Release the project of the current directory to DuckPAN [TODO]

duckpan test
------------
 Test your release (will automatically gets fired before release) [TODO]

duckpan help <command>
----------------------
 More help about the specific commands

duckpan faq
-----------
 Frequently asked questions

__EOT__

1;

sub goodie { return shift->header().<<'__EOT__'; }
duckpan goodie test [all|List of DDG::Goodie to test]
------------------------------------------------
 Test your goodie (use it in your repository root), if you give
 all parameter then all findable modules in DDG::Goodie:: namespace
 are used. If a list of modules are given, those are used. If
 nothing is given, then it tries to find DDG::Goodie::* in the lib/ of the
 current directory.

duckpan goodie new MyGoodie
------------------------------------------------
 Starts a new goodie 'DDG::Goodie::MyGoodie' in 'p5-ddg-goodie-mygoodie'
 (may be renamed, will check if setup was run)

__EOT__

1;
