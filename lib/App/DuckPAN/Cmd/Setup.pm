package App::DuckPAN::Cmd::Setup;
# ABSTRACT: Setting up your duck.co Account on your duckpan client

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

sub get_user { shift->app->get_reply( 'What is your username on https://duck.co/ ? ' ) }

option pass => (
	is => 'rw',
	lazy => 1,
	predicate => 'has_pass',
	default => sub { shift->get_pass }
);

sub get_pass { shift->app->get_reply( 'What is your password on https://duck.co/ ? ' ) }

option name => (
	is => 'rw',
	lazy => 1,
	predicate => 'has_name',
	default => sub { shift->get_name }
);

sub get_name { shift->app->get_reply( 'What is your name (real name not required) ? ' ) }

option email => (
	is => 'rw',
	isa => sub { Email::Valid->address(shift); },
	lazy => 1,
	predicate => 'has_email',
	default => sub { shift->get_email }
);

sub get_email { shift->app->get_reply( 'What is your email (public in your release) ? ' ) }

sub run {
	my ( $self ) = @_;
	$self->app->check_requirements; # Exits on missing requirements.
	if (my $dzil_config = $self->app->perl->get_dzil_config) {
		$self->app->emit_info("Found existing Dist::Zilla config!");
		my $name = $dzil_config->{'%User'}->{name};
		my $email = $dzil_config->{'%User'}->{email};
		my $user = $dzil_config->{'%DUKGO'}->{username};
		my $pass = $dzil_config->{'%DUKGO'}->{password};
		$self->app->emit_info("Name: ".$name) if $name;
		$self->app->emit_info("Email: ".$email) if $email;
		$self->app->emit_info("Username at https://duck.co/: ".$user) if $user;
		$self->app->emit_info("Password at https://duck.co/: ".$pass) if $pass;
		if ($name || $email || $user || $pass) {
			if ($self->app->term->ask_yn( prompt => 'Do you wanna use those? ', default => 'y' )) {
				if ($user && $pass) {
					$self->app->emit_info("Checking your account on https://duck.co/...");
					if ($self->app->checking_dukgo_user($user,$pass)) {
						$self->user($user);
						$self->pass($pass);
					}
				}
				$self->name($name) if $name;
				$self->email($email) if $email;
			}
		}
	}
	unless ($self->has_name && $self->has_email) {
		$self->app->emit_info("We require some general information about you");
		$self->setup_name unless $self->has_name;
		$self->setup_email unless $self->has_email;
	}
	unless ($self->has_user && $self->has_pass) {
		$self->app->emit_info("Getting your https://duck.co/ user information");
		$self->setup_dukgo;
	}
	my %vars = (
		user => $self->user,
		pass => $self->pass,
		name => $self->name,
		email => $self->email,
	);
	$self->app->emit_info("Initalizing DuckPAN environment");
	$self->setup(%vars);
	$self->app->emit_info("Initalizing Dist::Zilla");
	$self->app->perl->setup(%vars);
	$self->app->emit_info("Installing DDG base Perl modules from DuckPAN");
	$self->app->perl->duckpan_install('DDG');
	$self->app->emit_info("Setup complete.");
}

sub setup_name {
	my ( $self ) = @_;
	my $name = $self->get_name;
	if ($name) {
		$self->name($name);
	} else {
		$self->app->emit_info("We need some kind of name!");
		if ($self->app->term->ask_yn( prompt => 'Wanna try again? ', default => 'y' )) {
			$self->setup_name;
		} else {
			$self->app->emit_and_exit(1, "A name is required to work with DuckPAN");
		}
	}
}

sub setup_email {
	my ( $self ) = @_;
	my $email = $self->get_email;
	if (Email::Valid->address($email)) {
		$self->email($email);
	} else {
		$self->app->emit_info("No valid email given!");
		if ($self->app->term->ask_yn( prompt => 'Wanna try again? ', default => 'y' )) {
			$self->setup_email;
		} else {
			$self->app->emit_and_exit(1, "An email is required to work with DuckPAN");
		}
	}
}

sub setup_dukgo {
	my ( $self ) = @_;
	my $user = $self->has_user ? $self->user : $self->get_user;
	my $pass = $self->get_pass;
	$self->app->emit_info("Checking your account on https://duck.co/... ");
	if ($self->app->checking_dukgo_user($user,$pass)) {
		$self->user($user);
		$self->pass($pass);
	} else {
		$self->app->emit_info("Account lookup failed!");
		if ($self->app->term->ask_yn( prompt => 'Wanna try again? ', default => 'y' )) {
			$self->clear_user if $self->has_user;
			$self->setup_dukgo;
		} else {
			$self->app->emit_and_exit(1, "A login to https://duck.co/ is required to work with DuckPAN");
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
