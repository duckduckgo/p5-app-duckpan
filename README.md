# DuckPAN [![Build Status](https://travis-ci.org/duckduckgo/p5-app-duckpan.png?branch=master)](https://travis-ci.org/duckduckgo/p5-app-duckpan)

**The DuckDuckHack Developer Tool**

DuckPAN is an application built to aid DuckDuckHack developers. It is mainly used to generate the required files for new Instant Answers (the devloper must implement functionality) and also test both the triggering and visual display of Instant Answers.

**Currently DuckPAN only supports Goodie and Spice Instant Answers.**

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


## Index

- [Getting Started](#getting-started)
- [Using the Codio Project Template](#using-the-codio-project-template)
- [DuckDuckHack Development Virtual Machine](#duckduckhack-development-virtual-machine)
    + [Using the Virtual Machine](#using-the-virtual-machine)
- [Vagrant Virtual Environment](#vagrant-virtual-environment)
    + [Setup Instructions](#setup-instructions-2)
- [Installing DuckPAN Locally](#installing-duckpan-locally)
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

- **Use our Codio Project Template ([see below](#using-the-codio-project-template))**. We highly recommended this choice! It's *super* quick and easy.
- Use our DuckDuckHack development virtual machine image ([see below](#duckduckhack-development-virtual-machine))
- Use the Vagrant virtual environment ([see below](#vagrant-virtual-environment))
- Install DuckPAN locally ([see below](#installing-duckpan-locally)). Keep in mind, this **requires Linux or Mac OS X**. We suggest you install [Ubuntu](http://www.ubuntu.com/download).

After installing DuckPAN, be sure to checkout the [Using DuckPAN](#using-duckpan) section below!

------


## Using the Codio Project Template

1. Create an account on [Codio](https://codio.com/).
2. Go to https://codio.com/duckduckgo/duckduckhack and fork the project. Make sure to fork the project and the box.
![Codio Fork](https://raw.githubusercontent.com/duckduckgo/duckduckgo-documentation/master/duckpan/assets/codio_fork.png)
![Codio Fork Both](https://raw.githubusercontent.com/duckduckgo/duckduckgo-documentation/master/duckpan/assets/codio_fork_both.png)
3. Visit one of our Instant Answer repositories (such as https://github.com/duckduckgo/zeroclickinfo-spice), and follow GitHub's instructions to first [fork](https://help.github.com/articles/fork-a-repo) the repository. You can then clone the repo into your Codio machine (You need to open the Terminal for this).
![Codio Terminal](https://raw.githubusercontent.com/duckduckgo/duckduckgo-documentation/master/duckpan/assets/codio_terminal.png)
4. Go into the directory (by typing in `cd zeroclickinfo-spice`) and run `duckpan server`. Click on "DuckPAN Server" to view the webpage.
![Codio Server](https://raw.githubusercontent.com/duckduckgo/duckduckgo-documentation/master/duckpan/assets/codio_server.png)
5. You're all set!
![Codio Success](https://raw.githubusercontent.com/duckduckgo/duckduckgo-documentation/master/duckpan/assets/codio_success.png)

Try typing in queries like "define hello," and see if it works for you. You might be wondering why there are no search results in the page. It's because DuckPAN isn't configured to work with search results—it's only for testing Instant Answers.

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

ddh-vbox.rar
MD5: 1734373cbecc5820bb7d18406eb42854
https://ddg-community.s3.amazonaws.com/ddh-vbox.rar


#### For VMWare hosts

ddh-vmw.rar:
MD5: 95ad9acfacadb4b0cb0cf23ffaa3516e
https://ddg-community.s3.amazonaws.com/ddh-vmw.rar


#### Roadmap

- Docker support
- Public AMI for use on EC2

### Using the Virtual Machine

To use the Virtual Machine, you will need to download and install **VirtualBox**, **VMWare Workstation** or **VMWare Player**, depending on your current OS.


#### VirtualBox (free)

Website: https://www.virtualbox.org/
Supports: Windows, OS X, Linux


##### Setup Instructions

1. Download the rar and verify the checksum--decompress: This archive contains the VMDK (Virtual Machine Disk) and OVF (Open Virtualization Format) files.
2. Open VirtualBox, click "File" and then click "Import Appliance"
3. Click "Open appliance..." and select the DuckDuckHack virtual appliance -- click "Next"
4. Click "Import"


#### VMWare Player (free)

Website: https://www.vmware.com/products/player/
Supports: Windows, Linux


##### Setup Instructions

1. Download the rar and verify the checksum--decompress: This contains the VMDK (Virtual Machine Disk) and OVF (Open Virtualization Format) files.
2. Open VMWare Player, and click "Open a Virtual Machine"
3. Choose a storage path for the Virtual Machine -- click "Import"


#### Happy Hacking!

Once you have installed the virtual machine you should be able to start up the VM and login with the following credentials:
- **username** : `dax`
- **password** : `duckduckhack`

**The DuckPAN client has already been installed for you.** You can now clone the Instant Answer repos and start developing/testing.

------


## Vagrant Virtual Environment

The Vagrant-based DuckDuckHack virtual environment provides a similar sandbox to the DuckDuckHack VM, but rather than downloading a prebuilt VM, Vagrant creates an environment for you based on the defined configuration.  Vagrant is an awesome tool for building development environments.  One command - `vagrant up` - gets you a complete working environment in minutes.  Something go wrong with the environment?  No messing around with snapshots.  Tear the VM down and build a fresh environment.  The DuckDuckHack Vagrant environment uses Chef cookbooks and the DuckPAN installer script, so configuration is transparent and easily shared.

Through the Vagrant configuration, you can easily switch back and forth between a headless-mode and the traditional VirtualBox interface.  The configuration defaults to headless.


### Setup Instructions

1. Install: [Vagrant](http://docs.vagrantup.com/v2/installation/index.html) and [Bundler](http://bundler.io/#getting-started)
2. Clone the [duckpan-vagrant](https://github.com/shedd/duckpan-vagrant) repo, which contains the `Vagrantfile` and Chef cookbooks you'll need
3. Run `bundle install` to install Berkshelf, a Chef cookbook manager.
4. Run `vagrant plugin install vagrant-berkshelf` to hook Berkshelf into Vagrant.
5. Review the CUSTOM_CONFIG settings at the top of `Vagrantfile`.  You will want to customize the value of the synced directory to point to your local directory containing the DuckDuckGo code you wish to test.  By default, Vagrant will load a [VirtualBox Precise64](http://files.vagrantup.com/precise64.box) machine image.  If you change this, [Ubuntu is recommended](https://github.com/duckduckgo/p5-app-duckpan#disclaimer).
6. Run `vagrant up`

The box takes some time to stand up as the duckpan-install script runs.  Refer to [the duckpan-vagrant readme](https://github.com/shedd/duckpan-vagrant#installation) for more info.

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

For more information, please see the (excellent) [Vagrant docs](http://docs.vagrantup.com/).

------


## Installing DuckPAN Locally

**Note**: You don't need to install DuckPAN locally if you're using our DuckDuckHack virtual machine or the Vagrant virtual environment. It's already installed for you!

To install DuckPAN, open your terminal and run:

```
curl http://duckpan.org/install.pl | perl
```

[This script](https://github.com/duckduckgo/p5-duckpan-installer) will setup [local::lib](https://metacpan.org/module/local::lib), which is a way to install Perl modules without changing your base Perl installation. If you already use `local::lib` or [perlbrew](https://metacpan.org/module/perlbrew), don't worry, this script will intelligently use what you already have.

If you didn't have a `local::lib` before running the install script, you will need to run the script twice. It should tell you when like this:

```
please now re-login to your user account and run it again!
```

If everything works, you should see this at the end:

```
EVERYTHING OK! You can now go hacking! :)
```

Note that with `local::lib` now installed, you can easily install [Perl modules](http://search.cpan.org/) with [cpanm](https://metacpan.org/module/cpanm).

```
cpanm App::DuckPAN
App::DuckPAN is up to date.
```


### Adding Shell Completion

Some of our awesome community members have written shell completion scripts for DuckPAN, which should save you tons of time. Feel free to improve these, or contribute new ones!


#### Bash

- Submitted by: [mattr555](https://github.com/mattr555)
- link: https://github.com/mattr555/dotfiles/blob/master/bin/duckpancomp.sh


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
duckpan query [package_name ...]
```

Test Goodie and Spice triggers interactively on the command line.

Arguments:

- `[package_name ...]` to load only the specified Spice or Goodie Instant Answers.

Example:

```
duckpan query Npm
```

```
duckpan query Twitter IsItUp
```

---

```
duckpan server [--port <number>] [package_name ...]
```

Test Goodie and Spice Instant Answers on a local web server, which replicates the DuckDuckGo production environment. This should be used to ensure Spice and Goodies are displayed properly. For Spice Instant Answers, you should use the DuckPAN Server to also test your JavaScript code and Handlebars templates.

Options:

- `--port`, `-p` to specify which port DuckPAN's server should run on (defaults to 5000).

Arguments:

- `[package_name ...]` to load only the specified Spice or Goodie Instant Answers.

Example:

```
duckpan server Movie
```

```
duckpan server IDN Sort Morse
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
duckpan release
```

Release the distribution of the current directory. Used to issue new releases for the following repos: zeroclickinfo-spice, zeroclickinfo-goodies, p5-app-duckpan, duckduckgo-publisher, duckduckgo.

---

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
