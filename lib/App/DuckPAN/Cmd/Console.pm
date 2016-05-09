package App::DuckPAN::Cmd::Console;
# ABSTRACT: CLI prompt-based access to DuckPAN commands.

use Moo;

use MooX::Options protect_argv => 0;

use App::DuckPAN::Cmd::Help;
use App::DuckPAN::Cmd::Configure;

with qw(
	App::DuckPAN::Cmd
	App::DuckPAN::InstantAnswer::Cmd
);

sub _get_menu_choice {
	my ($self, %options) = @_;
	my $back = delete $options{menu_back};
	my $prompt = delete $options{prompt};
	unless (%options) {
		return $self->app->get_reply($prompt);
	}
	if ($options{multi}) {
		return $self->app->get_reply($prompt, %options);
	}
	my @choices = @{$options{choices}};
	push @choices, 'Go Back' if $back;
	my $response = $self->app->get_reply($prompt,
		%options, choices => \@choices,
	);
	if ($response eq 'Go Back') {
		$self->$back();
	}
	return $response;
}

sub run {
	my ($self, @args) = @_;
	$self->_run_console();
}

sub _exit {
	my $self = shift;
	$self->app->emit_and_exit(0, 'Goodbye!');
}

sub _run_console {
	my $self = shift;
	my $to_do = $self->_get_main_option();
	my $resp = $self->$to_do();
	$self->_run_console();
}

sub _display_help {
	App::DuckPAN::Cmd::Help->run(0, 1);
}

# Initialize Instant Answer if it is not already specified.
sub check_ia {
	my $self = shift;
	return 1 if $self->ia;
	$self->app->emit_info(
		'An Instant Answer is required to run this command'
	);
	$self->_initialize_ia(no_exit => 1) or return 0;
	return 1;
}

sub _run_requires_ia {
	my ($self, $cmd) = @_;
	my $package = "App::DuckPAN::Cmd::$cmd";
	if ($self->check_ia) {
		my $command = $package->new(
			app => $self->app,
			ia  => $self->ia,
		);
		$command->run();
	}
	else {
		$self->app->emit_info('No Instant Answer specified');
	}
}

sub _configure_ia {
	my $self = shift;
	$self->_run_requires_ia(q(Configure));
}

my @main_options = (
	'Display Help'             => \&_display_help,
	'Configure Instant Answer' => \&_configure_ia,
	'Exit'                     => \&_exit,
);

sub _get_main_option {
	my $self = shift;
	return $self->_get_menu_choice(
		prompt  => 'What do you want to do?',
		choices => \@main_options,
		hash    => 1,
	);
}
1;
