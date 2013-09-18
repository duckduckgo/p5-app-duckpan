# DuckPAN
**The DuckDuckHack Testing Tool**

DuckPAN is an application built to provide developers a testing environment for the DuckDuckHack Instant Answers. It allows users to test instant answer triggers, and lets you preview their visual design and output.

## Disclaimer
Currently, DuckPAN has been developed on, and works well with **Ubuntu**. More specifically we regularly build, test and run DuckPAN on **Ubuntu 10.04**. We have also successfully installed and run DuckPAN on newer Ubuntu releases ie. Ubuntu 12.04, 12.10, and 13.04.

Developers have also been successful running DuckPAN on other Linux distros (eg. Arch, Debian), but **we make no promises that it will work outside of Ubuntu**.

As well, there have been reported issues with installing DuckPAN on Mac OSX, so we don't recommend you go down that path.

That being said, we are more than willing to help you debug any installation problems, so please come to us with your problems and we'll try to get your issues sorted out.

## Getting Started
The easiest way to get started with DuckPAN is to either:

- Use our DuckDuckHack development virtual machine image (see below)
- Download and install [Ubuntu](http://www.ubuntu.com/download) yourself
- or download and install a different Linux distro, but as mentioned, you may run into issues

If you're going to use our VM please continue reading, if not, go setup you OS and continue with the DuckPAN [installation instructions](#installing-duckpan) below.

## DuckDuckHack Development Virtual Machine
The purpose of our DuckDuckHack VM is to provide a sandbox for instant answer development that is quick to set up and start working on.

#### DDH VM Breakdown
- Ubuntu 12.04 LTS
- Perl 5.16.3 (managed by Perlbrew)
- Perlbrew
- build-essential (for make, gcc, cc, etc)
- cpanminus (managed by Perlbrew)
- App::DuckPAN
- XFCE Window Manager
- SublimeText, vim, emacs
- Firefox (Configured via fixtracking.com)
- Platform specific virtualization guest tools (optimizes hardware emulation)

#### For VirtualBox hosts
ddh-vbox.rar  
MD5: 1734373cbecc5820bb7d18406eb42854  
https://ddg-community.s3.amazonaws.com/ddh-vbox.rar

#### For VMWare hosts
ddh-vmw.rar:  
MD5: 95ad9acfacadb4b0cb0cf23ffaa3516e  
https://ddg-community.s3.amazonaws.com/ddh-vmw.rar

#### Coming Soon
- Headless virtual machine
- Vagrant support
- Docker support
- Public AMI for use on EC2

## Using the Virtual Machine
To use the Virtual Machine you will need to download and install **VirtualBox**, **VMWare Workstation** or **VMWare Player**, depending on your current OS.

#### VirtualBox (free)
Website: https://www.virtualbox.org/  
Supports: Windows, OSX, Linux

##### Setup Instructions
1. Download the rar and verify the checksum--decompress: This archive contains the VMDK (Virtual Machine Disk) and OVF (Open Virtualization Format) files. 

2. Open VirtualBox, click "File" and then click "Import Appliance"

3. Click "Open appliance..." and select the DuckDuckHack virtual appliance -- click "Next"

4. Click "Import"

#### VMWare Player (free)
Website: https://www.vmware.com/products/player/  
Supports: Windows, Linux

##### Setup Instructions
1.Download the rar and verify the checksum--decompress: This contains the VMDK (Virtual Machine Disk) and OVF (Open Virtualization Format) files.

2.Open VMWare Player, and click "Open a Virtual Machine"

3.Choose a storage path for the Virtual Machine -- click "Import"

#### Happy Hacking!
Once you have installed the virtual machine you should be able to startup the VM and login. The **username** is `dax` and the **password** is `duckduckhack`.

**The DuckPAN client has already been installed for you. ** You can now clone the instant answer repos and start developing/testing.

## Installing DuckPAN

**\*\*Note**: You don't need to install DuckPAN if you're using our DuckDuckHack virtual machine. It's already installed for you!

To install DuckPan, open your terminal and run:

```shell
curl http://duckpan.org/install.pl | perl
```

[This script](https://github.com/duckduckgo/p5-duckpan-installer) will setup [local::lib](https://metacpan.org/module/local::lib), which is a way to install Perl modules without changing your base Perl installation. If you already use local::lib or [perlbrew](https://metacpan.org/module/perlbrew), don't worry, this script will intelligently use what you already have.

If you didn't have a local::lib before running the install script, you will need to run the script twice. It should tell you when like this:

```txt
please now re-login to your user account and run it again!
```

If everything works, you should see this at the end:

```shell
EVERYTHING OK! You can now go hacking! :)
```

Note that with local::lib now installed, you can easily install [Perl modules](http://search.cpan.org/) with [cpanm](https://metacpan.org/module/cpanm).

```shell
cpanm App::DuckPAN
App::DuckPAN is up to date.
```

### Dealing With Installation Issues
If during the course of your DuckPAN install you run into errors, don't panic, there's a few things you can try.

First, try running the install command again (`curl http://duckpan.org/install.pl | perl`), this often solves issues related to any dependencies.

If that doesn't work you can either investigate the build.log and see what's wrong. It might be a depencency issue which you can resolve by manually installing whichever deepenciy is missing via `cpanm` .

If you're unsure about the build.log or you still can't get it to work try add `--notest` to the DuckPAN install comman:

```shell
curl http://duckpan.org/install.pl | perl --notest
```

If that still doesn't work you can also try using `--force`:
```shell
curl http://duckpan.org/install.pl | perl --force
```

If this ***still*** doesn't work, please create a GitHub Issue in the DuckPAN Repo [here](https://github.com/duckduckgo/p5-app-duckpan/issues). Be sure to paste the contents of your `build.log` and we'll work with you to try and solve any problem.

## Using DuckPAN

### Install Commands

```shell
duckpan installdeps
```
Install all requirements of the specific DuckDuckHack project (if
possible), like zeroclickinfo-spice, zeroclickinfo-goodie, duckduckgo
or community-platform

```shell
duckpan check
```
Check if you fulfill all requirements for the development
environment (this is run automatically during setup)

### Plugin Testing

```shell
duckpan query
```
Test goodies and spice triggers interactively on the command line

```shell
duckpan server
```
Test spice plugins on a local web server (for design/layout purposes)

### Advanced Features 

```shell
duckpan env
```
View env commands and also shows the env variables currently stored in ~/.duckpan/env.ini

```shell
duckpan env <name> <value>
```
Add an environment variable that duckpan will remember. Useful for
spice API keys. Variables are stored in ~/.duckpan/env.ini

```shell
duckpan env <name>
```
Retrieve the matching key for a given env variable.

```shell
duckpan env rm <name>
```
Remove an environment variable from duckpan

```shell
duckpan release
```
Release the project of the current directory to DuckPAN
