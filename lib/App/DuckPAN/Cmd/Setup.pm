package App::DuckPAN::Cmd::Setup;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Email::Valid;

option override => ( is => 'ro' );

option user => (
	is => 'rw',
	lazy => 1,
	predicate => 'has_user',
	clearer => 'clear_user',
	default => sub { shift->get_user }
);

sub get_user { shift->app->term->get_reply( prompt => 'What is your username on https://dukgo.com/ ? ' ) }

option pass => (
	is => 'rw',
	lazy => 1,
	predicate => 'has_pass',
	default => sub { shift->get_pass }
);

sub get_pass { shift->app->term->get_reply( prompt => 'What is your password on https://dukgo.com/ ? ' ) }

option name => (
	is => 'rw',
	lazy => 1,
	predicate => 'has_name',
	default => sub { shift->get_name }
);

sub get_name { shift->app->term->get_reply( prompt => 'What is your name (real name not required) ? ' ) }

option email => (
	is => 'rw',
	isa => sub { Email::Valid->address(shift); },
	lazy => 1,
	predicate => 'has_email',
	default => sub { shift->get_email }
);

sub get_email { shift->app->term->get_reply( prompt => 'What is your email (public in your release) ? ' ) }

sub run {
	my ( $self ) = @_;
	exit 1 unless $self->app->check_requirements;
	if (my $dzil_config = $self->app->perl->get_dzil_config) {
		print "\nFound existing Dist::Zilla config!\n\n";
		my $name = $dzil_config->{'%User'}->{name};
		my $email = $dzil_config->{'%User'}->{email};
		my $user = $dzil_config->{'%DUKGO'}->{username};
		my $pass = $dzil_config->{'%DUKGO'}->{password};
		print "Name: ".$name."\n" if $name;
		print "Email: ".$email."\n" if $email;
		print "Username at https://dukgo.com/: ".$user."\n" if $user;
		print "Password at https://dukgo.com/: ".$pass."\n" if $pass;
		if ($name || $email || $user || $pass) {
			print "\n";
			if ($self->app->term->ask_yn( prompt => 'Do you wanna use those? ', default => 'y' )) {
				if ($user && $pass) {
					print "\nChecking your account on https://dukgo.com/... ";
					if ($self->app->checking_dukgo_user($user,$pass)) {
						print "success!\n";
						$self->user($user);
						$self->pass($pass);
					} else {
						print "failed!\n";
					}
				}
				$self->name($name) if $name;
				$self->email($email) if $email;
			}
		}
	}
	unless ($self->has_name && $self->has_email) {
		print "\nWe require some general information about you\n\n";
		$self->setup_name unless $self->has_name;
		$self->setup_email unless $self->has_email;
	}
	unless ($self->has_user && $self->has_pass) {
		print "\nGetting your https://dukgo.com/ user informations\n\n";
		$self->setup_dukgo;
	}
	my %vars = (
		user => $self->user,
		pass => $self->pass,
		name => $self->name,
		email => $self->email,
	);
	print "\nInitalizing DuckPAN environment\n\n";
	$self->setup(%vars);
	print "\nInitalizing Dist::Zilla for Perl5\n\n";
	$self->app->perl->setup(%vars);
	print "Installing DDG base Perl modules from DuckPAN\n\n";
	$self->app->perl->duckpan_install('DDG');
	print "\nSetup complete.\n\n";
}

sub setup_name {
	my ( $self ) = @_;
	my $name = $self->get_name;
	if ($name) {
		$self->name($name);
	} else {
		print "We need some kind of name!\n";
		if ($self->app->term->ask_yn( prompt => 'Wanna try again? ', default => 'y' )) {
			$self->setup_name;
		} else {
			print "[ERROR] A name is required to work with DuckPAN\n";
			exit 1;
		}
	}
}

sub setup_email {
	my ( $self ) = @_;
	my $email = $self->get_email;
	if (Email::Valid->address($email)) {
		$self->email($email);
	} else {
		print "No valid email given!\n";
		if ($self->app->term->ask_yn( prompt => 'Wanna try again? ', default => 'y' )) {
			$self->setup_email;
		} else {
			print "[ERROR] An email is required to work with DuckPAN\n";
			exit 1;
		}
	}
}

sub setup_dukgo {
	my ( $self ) = @_;
	my $user = $self->has_user ? $self->user : $self->get_user;
	my $pass = $self->get_pass;
	print "\nChecking your account on https://dukgo.com/... ";
	if ($self->app->checking_dukgo_user($user,$pass)) {
		print "success!\n";
		$self->user($user);
		$self->pass($pass);
	} else {
		print "failed!\n";
		if ($self->app->term->ask_yn( prompt => 'Wanna try again? ', default => 'y' )) {
			$self->clear_user if $self->has_user;
			$self->setup_dukgo;
		} else {
			print "[ERROR] A login to https://dukgo.com/ is required to work with DuckPAN\n";
			exit 1;
		}
	}
}

sub setup {
	my ( $self, %params ) = @_;
	my $config = $self->app->get_config;
	$config = {} unless $config;
	$config->{USERINFO} = {} unless defined $config->{USERINFO};
	$config->{DUKGO} = {} unless defined $config->{DUKGO};
	for (qw( name email )) {
		$config->{USERINFO}->{$_} = $params{$_} if defined $params{$_};
	}
	for (qw( user pass )) {
		$config->{DUKGO}->{$_} = $params{$_} if defined $params{$_};
	}
	$self->app->set_config($config);
}

1;
