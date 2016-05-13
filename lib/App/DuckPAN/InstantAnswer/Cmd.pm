package App::DuckPAN::InstantAnswer::Cmd;
# ABSTRACT: Role for requesting Instant Answers.

use Moo::Role;
use MooX::Options protect_argv => 0;

requires 'app';

option id => (
	is     => 'ro',
	format => 's',
	doc    => 'ID of Instant Answer to configure',
);

has ia => (
	is  => 'rwp',
	doc => 'Instant Answer the command is running on',
);

sub _ask_ia {
	my $self = shift;
	my $ia;
	my $check = sub {
		my $name = shift;
		$ia = $self->app->get_ia_by_name($name, no_fail => 1);
		return 1 if defined $ia;
	};
	$self->app->get_reply("Enter Name", allow => $check);
	return $ia;
}

sub _ask_ia_check {
	my ($self, %options) = @_;
	my $ia;
	if ($self->ia) {
		return;
	}
	elsif ($self->id) {
		$ia = $self->app->get_ia_by_name($self->id);
	} else {
		unless ($self->app->ask_yn(
				'Have you already created an Instant Answer page?',
				default => 'y')
		) {
			$self->app->emit_and_exit(-1,
				"Please create an Instant Answer page before running duckpan new")
			unless $options{no_exit};
			return;
		}
		$ia = $self->_ask_ia();
	}
	my $required_repo = $ia->meta->{repo};
	unless ($required_repo eq $self->app->repository->{repo}) {
		my $message = "Wrong repository for $ia->{id}, expecting '$required_repo'";
		if ($options{no_exit}) {
			$self->app->emit_info($message);
			$ia = undef;
		}
		else {
			$self->app->emit_and_exit(-1, $message);
		}
	}
	return $ia;
}

sub _initialize_ia {
	my ($self, %options) = @_;
	my $ia = $self->_ask_ia_check(%options);
	$self->_set_ia($ia) if $ia;
	return $ia;
}

1;
