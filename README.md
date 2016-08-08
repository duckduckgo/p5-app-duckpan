# DuckPAN and the DuckDuckHack Development Environment

[![Build Status](https://travis-ci.org/duckduckgo/p5-app-duckpan.png?branch=master)](https://travis-ci.org/duckduckgo/p5-app-duckpan)

DuckPAN is an application built to aid DuckDuckHack developers. It is mainly used to generate the required files for new Instant Answers (the developer must implement functionality) and also test both the triggering and visual display of Instant Answers.

Below are instructions to set up DuckPAN on various development environments.

_Currently DuckPAN supports **Goodie**, **Spice**, and **FatHead** Instant Answers_

Join us on Slack! [Request invite](mailto:QuackSlack@duckduckgo.com?subject=AddMe)

------

## Contents

- [Getting Started](#getting-started)
- [Disclaimer](#disclaimer)
- [DuckDuckHack Development Virtual Machine](#duckduckhack-development-virtual-machine)
    + [Installing the Virtual Machine](#installing-the-virtual-machine)
    + [Using the Virtual Machine](#using-the-virtual-machine)
- [Vagrant Virtual Environment](#vagrant-virtual-environment)
    + [Setup Instructions](#setup-instructions)
- [Installing DuckPAN Locally](#installing-duckpan-locally)
    + [Optional Dependencies](#optional-dependencies-for-staff-and-maintainers)
    + [Adding Shell Completion](#adding-shell-completion)
- [Using DuckPAN](#using-duckpan)
    + [Help](#help)
    + [For Instant Answer Developers](#for-instant-answer-developers)
    + [For DuckPAN Developers](#for-duckpan-developers)
    + [For DuckDuckHack Admins](#for-duckduckhack-admins)
    + [For Translation Managers Developers](#for-translation-managers-developers)
    + [Environment Variables](#environment-variables)

------
## Getting Started

Getting started with DuckPAN is easy! Here's a list of ways you can get DuckPAN up & running:

- [**Use our Codio Project Template** (main docs)](http://docs.duckduckhack.com/welcome/setup-dev-environment.html). We highly recommended this choice! It's *super* quick and easy.
- Use our DuckDuckHack development virtual machine image ([see below](#duckduckhack-development-virtual-machine))
- Use the Vagrant virtual environment ([see below](#vagrant-virtual-environment))
- Install DuckPAN locally ([see below](#installing-duckpan-locally)). Keep in mind, this **requires Linux or Mac OS X**. We suggest you install [Ubuntu](http://www.ubuntu.com/download).

After installing DuckPAN, be sure to checkout the [Using DuckPAN](#using-duckpan) section below!

------

## Disclaimer

### Operating Systems

Currently, DuckPAN has been developed on, and works well with **Ubuntu**. More specifically, we regularly build, test and run DuckPAN on **Ubuntu 12.04**. We have also successfully installed and run DuckPAN on older and newer Ubuntu releases, e.g. Ubuntu 10.04, 12.10, and 13.04.

Developers have also been successful running DuckPAN on other Linux distros (e.g. Arch, Debian) and on Mac OS X 10.8 and later, but **we make no promises that it will work outside of Ubuntu**.

As well, **there have been reported issues with installing DuckPAN on Windows**, so we don't recommend you go down that path.

That being said, we are more than willing to help you debug any installation problems, so please come to us with your problems and we'll try to get your issues sorted out. If you'd like some help from our community, feel free to engage with them on the [DuckDuckGo forum](http://duck.co/).

### Perl Versions

We run our DuckPAN tests against Perl 5.16 and 5.18 using Travis (https://travis-ci.org/duckduckgo/p5-app-duckpan). We suggest you install Perl 5.16 via Perlbrew for local development. The Codio boxes come with Perlbrew and Perl 5.18 already installed.

------

## DuckDuckHack Development Virtual Machine

The purpose of our DuckDuckHack VM is to provide a sandbox for DuckDuckGo Instant Answer development that is quick to set up and start working with.


#### DDH VM Breakdown

- Ubuntu 12.04 LTS
- Perl 5.16.3 (managed by Perlbrew)
- build-essential (for make, gcc, cc, etc)
- cpanminus (managed by Perlbrew)
- App::DuckPAN
- XFCE Window Manager
- SublimeText, vim, emacs
- Firefox (Configured via fixtracking.com)
- Platform specific virtualization guest tools (optimizes hardware emulation)


#### For VirtualBox hosts

https://ddg-community.s3.amazonaws.com/ddh-vbox-2014-12-23.ova

Filename: ddh-vbox-2014-12-23.ova

MD5: 02a0fb03db2b2466504bf9fbc894c7dd


#### For VMWare hosts

https://ddg-community.s3.amazonaws.com/ddh-vmw-2014-12-23.ova

Filename: ddh-vmw-2014-12-23.ova

MD5: 6ecdeb8ead2c2eb7a9aba1db22359c4b


#### Roadmap

- Docker support
- Public AMI for use on EC2


### Installing the Virtual Machine

To use the Virtual Machine, you will need to download and install **VirtualBox**, **VMWare Workstation** or **VMWare Player**, depending on your current OS.

Then you will need to import the VM.


#### VirtualBox (free)

Website: https://www.virtualbox.org/
Supports: Windows, OS X, Linux


##### Import the VM

1. Download the OVA
2. Open VirtualBox, click "File" and then click "Import Appliance"
3. Click "Open appliance..." and select the DuckDuckHack virtual appliance OVA file -- click "Next"
4. Click "Import"


#### VMWare Player (free)

Website: https://www.vmware.com/products/player/
Supports: Windows, Linux


##### Import the VM

1. Download the OVA
2. Open VMWare Player, and click "Open a Virtual Machine"
3. Choose a storage path for the Virtual Machine -- click "Import"


### Using the Virtual Machine


#### Logging into the VM

Once you have installed the virtual machine you should be able to start up the VM and login with the following credentials:
- **username** : `vagrant`
- **password** : `duckduckhack`


#### Cloning the repository on the VM

**The DuckPAN client has already been installed for you.** To use it, you must 1st clone your instant answer git repository.

If you haven't already done so, [Determine your Instant Answer Type](http://docs.duckduckhack.com/welcome/determining-ia-type.html) and follow GitHub's instructions to [fork](https://help.github.com/articles/fork-a-repo) the instant answer repository.

The instant answer repositories are:
+ [zeroclickinfo-goodies](https://github.com/duckduckgo/zeroclickinfo-goodies)
+ [zeroclickinfo-spice](https://github.com/duckduckgo/zeroclickinfo-spice)

Then, run the git clone command to clone the repository. The URL is the **SSH clone URL** listed on the right side of the github webpage for your forked repository. (You can also use the **HTTPS clone URL**.)

```
git clone URL
```

#### Happy Hacking!

See the instructions below on [Using DuckPAN](#using-duckpan).

------


## Vagrant Virtual Environment

The Vagrant-based DuckDuckHack virtual environment provides a similar sandbox to the DuckDuckHack VM, but rather than downloading a prebuilt VM, Vagrant creates an environment for you based on the defined configuration.  Vagrant is an awesome tool for building development environments.  One command - `vagrant up` - gets you a complete working environment in minutes.  Something go wrong with the environment?  No messing around with snapshots.  Tear the VM down and build a fresh environment.  The DuckDuckHack Vagrant environment uses Chef cookbooks and the DuckPAN installer script, so configuration is transparent and easily shared.

Through the Vagrant configuration, you can easily switch back and forth between a headless-mode and the traditional VirtualBox interface.  The configuration defaults to headless.


### Setup Instructions

Refer to [the duckpan-vagrant readme](https://github.com/shedd/duckpan-vagrant#installation) for installation instructions.

Once the environment has been built, **the DuckPAN client is installed and ready to go.** You can now clone the Instant Answer repos and start developing/testing.

If you run into any issues, please file an issue in the [duckpan-vagrant issue page](https://github.com/shedd/duckpan-vagrant/issues).


##### Quick Overview of key Vagrant CLI commands

There are a couple of key Vagrant commands that you'll use to manage your environment.

```
$ vagrant

up       - Build environment from Vagrantfile or resume a previously halted environment.
ssh      - Connect to your running VM via SSH.
suspend  - Pause the VM, storing its current state to disk.
resume   - Bring a suspended VM back to life.
reload   - The equivalent of running a halt followed by an up.  Use this when you make changes to Vagrantfile.
halt     - Shut down the VM. Tries to gracefully shutdown first; if that fails, it will forcefully shut the VM down.
destroy  - Stop the currently running VM and blow everything away.
```

Run these commands from the directory containing your `Vagrantfile`.

For more information, please see the (excellent) [Vagrant docs](https://www.vagrantup.com/docs/).

------


## Installing DuckPAN Locally

**Note**: You don't need to install DuckPAN locally if you're using our DuckDuckHack virtual machine or the Vagrant virtual environment. It's already installed for you!

To install DuckPAN, open your terminal and run:

```
curl http://duckpan.org/install.pl | perl
```

[This script](https://github.com/duckduckgo/p5-duckpan-installer) will setup [local::lib](https://metacpan.org/pod/local::lib), which is a way to install Perl modules without changing your base Perl installation. If you already use `local::lib` or [perlbrew](https://metacpan.org/pod/perlbrew), don't worry, this script will intelligently use what you already have.

If you didn't have a `local::lib` before running the install script, you will need to run the script twice. It should tell you when like this:

```
please now re-login to your user account and run it again!
```

If everything works, you should see this at the end:

```
EVERYTHING OK! You can now go hacking! :)
```

Note that with `local::lib` now installed, you can easily install [Perl modules](http://search.cpan.org/) with [cpanm](https://metacpan.org/pod/cpanm).

```
cpanm App::DuckPAN
App::DuckPAN is up to date.
```

### Additional Dependencies

DuckPAN requires a few other packages that are **not** hosted on CPAN. These are private DuckDuckGo packages hosted on DuckPAN.org.

You will need to run the following command from the root of the IA Repo (i.e. Goodie or Spice) to install these additional dependencies:

```shell
dzil authordeps | cpanm --mirror http://duckpan.org
```

#### SSL (for OSX)

Additionally you may run into issues with SSL Verification. In this case installing Mozilla::CA should solve your problems:

```shell
cpanm Mozilla::CA
```

### Optional Dependencies (for Staff and Maintainers)

DuckPAN now uses [**Node.js**](https://nodejs.org/), [**Handlebars.js**](http://handlebarsjs.com/), and [**Uglify.js**]() to build releases of the ZeroClickInfo repositories. Releases are only created and used by DuckDuckGo Staff and so these dependencies are **only required for DuckDuckGo Staff**. If you execute `dzil build`, `dzil install` or `dzil test` without these dependencies you will see errors.

#### Installing Node.js

Executables and binaries along with installation instructions can be found on the Node.js [download page](https://nodejs.org/download/).

#### Installing Handlebars.js and Uglify.js

Once you've installed Node, you'll also need to install Handlebars.js and Uglify.js by running:

```
npm install -g handlebars@1.3.0 uglifyjs
```

### Adding Shell Completion

Some of our awesome community members have written shell completion scripts for DuckPAN, which should save you tons of time. Feel free to improve these, or contribute new ones!


#### Bash

- Submitted by: [mattr555](https://github.com/mattr555)
- link: https://github.com/mattr555/dotfiles/blob/master/bin/duckpancomp.sh

#### Fish Shell

- Submitted by: [gabriellhrn](https://github.com/gabriellhrn)
- link: https://github.com/gabriellhrn/dotfiles/blob/master/fish/.config/fish/completions/duckpan-completion.fish

#### Z Shell

- Submitted by: [elebow](https://github.com/elebow)
- link: https://github.com/elebow/duckpan-completion


### Dealing With Installation Issues

If during the course of your DuckPAN install you run into errors, don't panic, there are a few things you can try.

First, try running the install command again (`curl http://duckpan.org/install.pl | perl`), this often solves issues related to any dependencies.

If that doesn't work, you should investigate the build.log and see what's wrong. It might be a dependency issue which you can resolve by manually installing whichever dependency is missing via `cpanm`.

If it still won't install with `cpanm` try adding `--notest` to the cpanm command:

```
cpanm Test::More --notest
```

If that still doesn't work, you can also try using `--force`:

```
cpanm Test::More --force
```

If this ***still*** doesn't work, please create a GitHub Issue in the DuckPAN Repo [here](https://github.com/duckduckgo/p5-app-duckpan/issues). Be sure to paste the contents of your `build.log` and also let us know the details of your OS (`$ uname -a` is great). Once you've made the issue, we'll work with you to try and solve any problems you're having.

------


## Using DuckPAN


### Help

```
duckpan [--verbose|-v]
```

```
duckpan help
```

```
man duckpan
```

Shows you the DuckPAN help page which briefly describes DuckPAN and its features.


### For Instant Answer Developers

```
duckpan new [instant_answer_name]
```

Generates all necessary files for a new Spice or Goodie Instant Answer (depending on the current repo). DuckPAN will prompt you for a package name and generate the required files. If the name is already in use, DuckPAN will let you know and no files will be created.

Example:

```
duckpan new
```

```
duckpan new MyFirst::Spice
```

---

```
duckpan query [name ... | id ...]
```

Test Goodie and Spice triggers interactively on the command line.

Arguments:

- `[name ...]` to load one or more Spice, or Goodie Instant Answers.
- `[id ...]` to load one or more Spice, or Goodie Instant Answers; Or load a single Fathead Instant Answer

Example:

```
duckpan query Npm
```

```
duckpan query Twitter IsItUp
```

```
duckpan query mdn_css
```

---

```
duckpan server [--port <number>] [name ... | id ...]
```

Test multiple Goodie or Spice, or individual Fathead Instant Answers on a local web server, which simulates the DuckDuckGo production environment. This should be used to ensure Goodie, Spice, and Fathead Instant Answers are displayed properly.

For Spice Instant Answers, you should use the DuckPAN Server to also test your JavaScript code and Handlebars templates. 

For Fathead Instant Answers, the specified Instant Answer ID must have a matching folder in the `/lib/fathead/` dir containing an **output.txt** file. 

Options:

- `--port`, `-p` to specify which port DuckPAN's server should run on (defaults to 5000).

Arguments:

- `[name ...]` to load one or more Spice, or Goodie Instant Answers.
- `[id ...]` to load one or more Spice, or Goodie Instant Answers; Or load a single Fathead Instant Answer

Example:

```
duckpan server Movie
```

```
duckpan server IDN Sort Morse
```

```
duckpan query mdn_css
```

---

```
duckpan installdeps
```

Install all requirements of the specific DuckDuckHack project (if
possible), like zeroclickinfo-spice, zeroclickinfo-goodie, duckduckgo
or community-platform.

---

```
duckpan check
```

Check if you fulfill all requirements for the development
environment.


### For DuckPAN Developers

```
duckpan reinstall
```

Force installation of the latest released versions of DuckPAN and DDG.

---

```
duckpan -I [filepath ...]
```

Loads the specified external libraries. This should be used to test changes made to `App::DuckPAN` and `DDG`.

Example:

```
duckpan -I../p5-app-duckpan/lib server
```


### For DuckDuckHack Admins


```
duckpan setup
```

Helps configure your environment so you can use `Dist::Zilla::Plugin::UploadToDuckPAN`, which is used by `duckpan release`.

---

```
duckpan roadrunner
```

Same as `installdeps`, but avoids testing anything. Useful for speed, but
not recommended unless you know what you are doing.


### For Translation Managers

```
duckpan poupload [--domain] filepath
```

Upload a `.po` file to the Community Platform.


### Environment Variables

```
duckpan env
```

```
duckpan env help
```

View `env` commands and shows command usage.

---

```
duckpan env set <name> <value>
```

Add an environment variable that duckpan will remember. Useful for
spice API keys. Variables are stored in `~/.duckpan/config/env.ini`.

---

```
duckpan env get <name>
```

Retrieve the matching key for a given env variable.

---

```
duckpan env rm <name>
```

Remove an environment variable from duckpan.

---

```
duckpan env list <name>
```

Lists all the env variables currently stored in `~/.duckpan/config/env.ini`.
