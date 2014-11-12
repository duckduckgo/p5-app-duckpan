package App::DuckPAN::Perl;
# ABSTRACT: Perl related functionality for duckpan

use Moo;
with 'App::DuckPAN::HasApp';

use Config::INI;
use Dist::Zilla::Util;
use Path::Tiny;
use Config::INI::Reader;
use Config::INI::Writer;
use Data::Dumper;
use LWP::UserAgent;
use List::MoreUtils qw/ uniq /;
use List::Util qw/ first /;
use File::Temp qw/ :POSIX /;
use version;
use Parse::CPAN::Packages::Fast;
use Class::Load ':all';

sub dzil_root { Dist::Zilla::Util->_global_config_root }
sub dzil_config { path(shift->dzil_root,'config.ini') }

sub setup {
	my ( $self, %params ) = @_;
	my $config_root = Dist::Zilla::Util->_global_config_root;
	my $config = $self->get_dzil_config;
	$config = {} unless $config;
	$config->{'%Rights'} = {
		license_class => 'Perl_5',
		copyright_holder => $params{name},
	} unless defined $config->{'%Rights'};
	$config->{'%User'} = {
		email => $params{email},
		name => $params{name},
	} unless defined $config->{'%User'};
	$config->{'%DUKGO'} = {
		username => $params{user},
		password => $params{pass},
	};
	$self->set_dzil_config($config);
}

sub get_local_version {
	my ($self, $module) = @_;
	require Module::Data;
	my $v;
	{
		local $@;
		eval {
			my $m = Module::Data->new($module);
			$m->require;
			$v = $m->version;
			1;
		} or return;
	};

	return unless defined $v;
	return version->parse($v) unless ref $v;
	return $v;
}

sub cpanminus_install_error {
	shift->app->emit_and_exit(1,
		"Failure on installation of modules!",
        "There are several possible explanations and fixes for this error:",
        "1. The download from CPAN was unsuccessful - Please restart this installer.",
        "2. Some other error occured - Please read the `build.log` mentioned in the errors and see if you can fix the problem yourself.",
        "If you are unable to solve the problem, please let us know by making a GitHub Issue in the DuckPAN Repo:",
        "https://github.com/duckduckgo/p5-app-duckpan/issues",
        "Make sure to attach the `build.log` file if it exists. Otherwise, copy/paste the output you see."
	);
}

sub duckpan_install {
	my ($self, @modules) = @_;
	my $mirror = $self->app->duckpan;
	my $reinstall;
	if ($modules[0] eq 'reinstall') {
		# We sent in a signal to force reinstallation
		$reinstall = 1;
		shift @modules;
	}
	my $packages = $self->app->duckpan_packages;
	my @to_install;
	for (@modules) {
		my $module = $packages->package($_);
		$self->app->emit_and_exit(1, "Can't find package " . $_ . " on " . $self->app->duckpan) unless $module;

		my $package = $module->package;    # Probably $_, but maybe they'll normalize or something someday.

		# see if we have an env variable for this module
		my $sp = $package;
		$sp =~ s/\:\:/_/g;

		# special case: check for a pinned verison number
		my $pin_version            = $ENV{$sp};
		my $localver               = $self->get_local_version($package);
		my $duckpan_module_version = version->parse($module->version);
		my $duckpan_module_url     = $self->app->duckpan . 'authors/id/' . $module->distribution->pathname;

		$localver ||= 1e-6 if ($pin_version); # a silly, but true, value if missing and we need to compare with pinned.

		my ($install_it, $message);
		if ($reinstall || !$localver) {    # Note the ignored pinning.
			$install_it = 1;
		} elsif ($pin_version) {
			$self->app->emit_info("$package: $localver installed, $pin_version pin, $duckpan_module_version latest");
			if ($pin_version != $localver) {
				#  We continue here, even if the version is larger than latest released,
				#  on the premise that there might exist unreleased development versions.
				if ($pin_version == $duckpan_module_version || ($duckpan_module_url = $self->find_previous_url($module, $pin_version))) {
					$reinstall  = 1;       # Let us roll back, if necessary. Multiple packages may confuse this, but little harm.
					$install_it = 1;
				} else {
					$message    = 'Could not locate version ' . $pin_version . ' of  ' . $package;
					$install_it = 0;
				}
			}
		} elsif ($localver == $duckpan_module_version) {
			$message = "You already have latest ($localver) version of $package";
		} elsif ($localver > $duckpan_module_version) {
			$message = "You have a newer ($localver) version of $package than duckpan ($duckpan_module_version)";
		} else {
			$install_it = 1;
		}
		$self->app->emit_info($message);
		push @to_install, $duckpan_module_url if ($install_it && !(first { $_ eq $duckpan_module_url } @to_install));
	}

	return 0 unless @to_install;
	unshift @to_install, '--reinstall' if ($reinstall);    # cpanm will do the actual forcing.
	return system("cpanm " . join(" ", @to_install));
}

sub find_previous_url {
	my ($self, $module, $desired_version) = @_;

	# Shaky premise #1: the author of our previous version is a current author.
	# Shaky premise #2: the directory structure is always like this.
	my @cpan_dirs = map { join('/', substr($_, 0, 1), substr($_, 0, 2), $_) } uniq map { $_->cpanid } ($self->app->duckpan_packages->distributions);
	# Shaky premise #3: things never change distributions.
	my $dist     = $module->distribution;
	my $filename = $dist->filename;
	# Shaky premise #4: the distribution version will match package version.
	my $version = $dist->version;
	# Shaky premise #5: the version for which they are asking is well-formed.
	$filename =~ s/$version/$desired_version/;
	my @urls = map { $self->app->duckpan . 'authors/id/' . $_ . '/' . $filename } @cpan_dirs;
	$self->app->emit_debug("Checking up to " . scalar @urls . " distributions for pinned version...");

	# Shaky premise #6: our network works well enough to make this a definitive test
	my $ua = LWP::UserAgent->new(
		agent                 => 'DPPF/0.001a',
		requests_redirectable => []);

	return first { $ua->head($_)->is_success } @urls;
}

sub set_dzil_config {
	my ( $self, $config ) = @_;
	$self->dzil_root->mkpath unless -d $self->dzil_root;
	Config::INI::Writer->write_file($config,$self->dzil_config);
}

sub get_dzil_config {
	my ( $self ) = @_;
	return unless -d $self->dzil_root && -f $self->dzil_config;
	Config::INI::Reader->read_file($self->dzil_config);
}

1;
