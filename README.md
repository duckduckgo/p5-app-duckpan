# The DuckDuckGo Plugin Tool

DuckPAN is an application built to provide developers a testing environment for the ZeroClickInfo Plugins. It allows users to test plugin triggers, and lets you preview their visual design. 

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

    duckpan env rm <name>
Remove an environment variable from duckpan

    duckpan release
Release the project of the current directory to DuckPAN
