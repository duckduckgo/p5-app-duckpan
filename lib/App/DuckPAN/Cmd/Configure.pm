package App::DuckPAN::Cmd::Configure;
# ABSTRACT: Configure an existing Instant Answer.

use Moo;

use MooX::Options protect_argv => 0;
use Try::Tiny;
use List::MoreUtils 'any';
use Path::Tiny;
use JSON::MaybeXS qw(decode_json);

use App::DuckPAN::InstantAnswer::Util qw(is_cheat_sheet);
use App::DuckPAN::InstantAnswer::Config;

with qw(
	App::DuckPAN::Cmd
	App::DuckPAN::InstantAnswer::Cmd
);

has _prev_menu => (
	is => 'rwp',
	doc => 'CODE reference representing the previous menu. ' .
	       'The previous menu should not require reconfirmation.',
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

sub _display_list {
	my ($self, @items) = @_;
	map { $self->app->emit_info($_) } @items;
}

sub _configure_list {
	my ($self, $list, %options) = @_;
	my @items = @$list;
	my @display = map { $self->ia->for_display($_) } @$list;
	my $adder = $options{add} // sub {
		my ($self, @items) = @_;
		my $item = $self->_get_menu_choice(
			prompt => "Enter Item"
		);
		push @items, $item;
		return @items;
	};
	my $i = -1;
	my %members = map { do { $i++; $_ => $i } } @display;
	if (@items < 20) {
		$self->_display_list(@display);
	} else {
		$self->_display_list(@display[1..19]);
		$self->app->emit_info('Large number of items detected; showing first 20');
	}
	my $action = $self->_get_menu_choice(
		prompt  => "What do you want to do?",
		choices => [
			'List Items', 'Configure Item', 'Delete Item', 'Add Item'
		],
	);
	if ($action eq 'List Items') {
		$self->_display_list(@display);
	} elsif ($action eq 'Configure Item') {
		my $item = $self->_get_menu_choice(
			prompt => "What do you want to configure?",
			choices => \@display,
		);
		my $pos = $members{$item};
		my $configured = $self->_configure_item($items[$pos]);
		$items[$pos] = $configured;
	} elsif ($action eq 'Add Item') {
		@items = $adder->($self, @items);
	} elsif ($action eq 'Delete Item') {
		my @to_delete = $self->_get_menu_choice(
			prompt  => "Which Items?",
			choices => \@items, multi => 1,
		);
		foreach my $item (@to_delete) {
			$members{$item} = undef;
		}
		@items = sort { $members{$b} <=> $members{$a} }
			grep { $members{$_} } keys %members;
	}
	return \@items;
}

sub _configure_scalar {
	my ($self, $item) = @_;
	$self->app->emit_info("Current Value: $item");
	return $self->_get_menu_choice(
		prompt => "Enter new value"
	);
}

sub _configure_hash {
	my ($self, $hash) = @_;
	my %hash = %$hash;
	my @choices = sort keys %hash;
	my $to_configure = $self->_get_menu_choice(
		prompt  => "What would you like to configure?",
		choices => \@choices,
	);
	my $current = $hash{$to_configure};
	my $new_val = $self->_configure_item($current);
	$hash{$to_configure} = $new_val;
	return \%hash;
}

sub _configure_item {
	my ($self, $item) = @_;
	if (ref $item eq 'ARRAY') {
		return $self->_configure_list($item);
	} elsif (ref $item eq 'HASH') {
		return $self->_configure_hash($item);
	} else {
		return $self->_configure_scalar($item);
	}
}

sub _configure_cheat_sheet {
	my $self = shift;
	my $ia = $self->ia->meta;
	my $cheat_file;
	unless ($cheat_file = $self->ia->files->{named}{cheat_sheet}) {
		$self->app->emit_info("Could not find an appropriate file to configure");
		return;
	}
	my $json = JSON::MaybeXS->new(utf8 => 1, pretty => 1);
	my $data = decode_json($cheat_file->slurp())
		or $self->app->emit_and_exit(-1, "Invalid JSON");
	$data = $self->_configure_hash($data);
	my $encoded = $json->encode($data);
	$cheat_file->spew_utf8($encoded);
}

sub run {
	my ($self, @args) = @_;
	$self->_initialize_ia(no_exit => 1);
	$self->_run_configure();
}

sub _exit {
	my $self = shift;
	$self->app->emit_and_exit(0, 'Goodbye!');
}

sub _run_configure {
	my $self = shift;
	my $to_do = $self->_get_main_option();
	my $resp = $self->$to_do();
	$self->_run_configure();
}

sub _display_files {
	my $self = shift;
	my @files = @{$self->ia->files->{all}};
	foreach my $file (sort @files) {
		$self->app->emit_info($file);
	}
}

sub _configure_ia {
	my $self = shift;
	if (is_cheat_sheet($self->ia->meta)) {
		$self->_configure_cheat_sheet();
	} else {
		$self->app->emit_info("Nothing to configure");
	}
}

sub _configure_templates {
	my $self = shift;
	my $ia = $self->ia;
	my @templates = $ia->get_available_templates();
	unless (@templates) {
		$self->app->emit_info('No templates available');
		return;
	}
	my %template_map = map { $_->label => $_ } @templates;
	my @labels = sort keys %template_map;
	my $to_configure = $self->_get_menu_choice(
		prompt => 'Which template to configure?',
		choices => \@labels,
	);
	my $template = $template_map{$to_configure};
	$template->configure(
		app => $self->app,
		ia  => $self->ia->meta,
	);
	$self->ia->refresh();
	return;
}

my %main_options = (
	'Display Files' => \&_display_files,
	'Exit'          => \&_exit,
	'Configure'     => \&_configure_ia,
	'Configure Templates' => \&_configure_templates,
);

my @option_order = (
	'Display Files',
	'Configure',
	'Configure Templates',
	'Exit',
);

sub _get_main_option {
	my $self = shift;
	my $opt = $self->_get_menu_choice(
		prompt  => "What do you want to do?",
		choices => \@option_order,
	);
	return $main_options{$opt};
}
1;
