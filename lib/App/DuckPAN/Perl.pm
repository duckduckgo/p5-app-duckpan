package App::DuckPAN::Perl;

use Moo;
with 'App::DuckPAN::HasApp';

use Config::INI;
use Dist::Zilla::Util;
use Path::Class;
use Config::INI::Reader;
use Config::INI::Writer;
use Data::Dumper;
use LWP::Simple;
use File::Temp qw/ :POSIX /;
use version;
use Class::Load ':all';

sub dzil_root { Dist::Zilla::Util->_global_config_root }
sub dzil_config { file(shift->dzil_root,'config.ini') }

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
	# TODO
}

sub cpanminus_install_error {
	print_text(
		"[ERROR] Failure on installation of modules!",
		"This could have several reasons, for first you can just restart this installer, cause it could be a pure download problem. If this isnt the case, please read the build.log mentioned on the errors and see if you can fix the problem yourself. Otherwise, please report the problem via email to use at open\@duckduckgo.com with the build.log attached. If there is no build.log mentioned, just attach the output you see.",
	);
	exit 1;	
}

sub duckpan_install {
	my ( $self, @modules ) = @_;
	my $mirror = $self->app->duckpan;
	my $modules_string = join(' ',@modules);
	my $tempfile = tmpnam;
	if (is_success(getstore($self->app->duckpan_packages,$tempfile))) {
		my $packages = Parse::CPAN::Packages::Fast->new($tempfile);
		my @to_install;
		my $error = 0;
		for (@modules) {
			my $module = $packages->package($_);
			if ($module) {
				# TODO
				# my $localver = get_local_version($_);
				# if ($localver && version->parse($localver) == version->parse($module->version)) {
					# print "You already have latest version of ".$_." with ".$localver."\n";
				# } else {
					my $latest = $self->app->duckpan.'authors/id/'.$module->distribution->pathname;
					push @to_install, $latest unless grep { $_ eq $latest } @to_install;
				# }
			} else {
				print "[ERROR] Can't find package ".$_." on ".$self->app->duckpan."\n";
				$error = 1;
			}
		}
		return 1 if $error;
		return system("cpanm ".join(" ",@to_install));
	} else {
		print "[ERROR] Can't reach duckpan at ".$self->app->duckpan."!\n";
		return 1;
	}
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
