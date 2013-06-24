DuckPAN is an application built to provide developers a testing environment for the ZeroClickInfo Plugins. It allows users to test plugin triggers, and lets you preview their visual design. 

# Installing DuckPAN

```bash
curl http://duckpan.org/install.pl | perl
```

[This script](https://github.com/duckduckgo/p5-duckpan-installer) will setup [local::lib](https://metacpan.org/module/local::lib), which is a way to install Perl modules without changing your base Perl installation. (If you already use local::lib or [perlbrew](https://metacpan.org/module/perlbrew), don't worry, this script will intelligently use what you already have).

If you didn't have a local::lib before running the install script, you will need to run the script twice. It should tell you when like this:

```txt
please now re-login to your user account and run it again!
```

If everything works, you should see this at the end:

```bash
EVERYTHING OK! You can now go hacking! :)
```

Note that with local::lib now installed, you can easily install [Perl modules](http://search.cpan.org/) with [cpanm](https://metacpan.org/module/cpanm).

```bash
cpanm App::DuckPAN
App::DuckPAN is up to date.
```

# Using DuckPAN

## Install commands

    duckpan installdeps
Install all requirements of the specific DuckDuckHack project (if
possible), like zeroclickinfo-spice, zeroclickinfo-goodie, duckduckgo
or community-platform

    duckpan check
Check if you fulfill all requirements for the development
environment (this is run automatically during setup)

## Plugin testing

    duckpan query
Test goodies and spice triggers interactively on the command line

    duckpan server
Test spice plugins on a local web server (for design/layout purposes)

## Advanced features 

    duckpan env
View env commands and also shows the env variables currently stored in ~/.duckpan/env.ini

    duckpan env <name> <value>
Add an environment variable that duckpan will remember. Useful for
spice API keys. Variables are stored in ~/.duckpan/env.ini

    duckpan env <name>
Retrieve the matching key for a given env variable.

    duckpan env rm <name>
Remove an environment variable from duckpan

    duckpan release
Release the project of the current directory to DuckPAN
