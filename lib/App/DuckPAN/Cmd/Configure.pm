package App::DuckPAN::Cmd::Configure;
# ABSTRACT: Configure an existing Instant Answer.

use Moo;
with qw( App::DuckPAN::Cmd );
with qw( App::DuckPAN::InstantAnswer::Cmd );

use MooX::Options protect_argv => 0;
use Try::Tiny;
use List::MoreUtils 'any';
use Path::Tiny;
use JSON::MaybeXS qw(decode_json);

no warnings 'uninitialized';

sub is_cheat_sheet {
	my $ia = shift;
	return $ia->{id} =~ /_cheat_sheet$/;
}

# TODO: Make this work with other cheat sheets.
sub _get_cheat_sheet_file {
	return path('share/goodie/cheat_sheets/json/vim.json');
}

sub _configure_list {
	my ($self, $list) = @_;
	my @items = @$list;
	my $i = -1;
	my %members = map { do { $i++; $_ => $i } } @items;
	my $action = $self->app->get_reply("What do you want to do?",
		choices => ['Delete Item', 'Add Item'],
	);
	if ($action eq 'Add Item') {
		my $item = $self->app->get_reply("Enter Item");
		push @items, $item;
	} elsif ($action eq 'Delete Item') {
		my @to_delete = $self->app->get_reply("Which Items?",
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
	return $self->app->get_reply("Enter new value");
}

sub _configure_item {
	my ($self, $item) = @_;
	if (ref $item eq 'ARRAY') {
		return $self->_configure_list($item);
	} else {
		return $self->_configure_scalar($item);
	}
}

sub _configure_cheat_sheet {
	my ($self, $ia) = @_;
	my $json = JSON::MaybeXS->new(utf8 => 1, pretty => 1);
	my $cheat_file = $self->_get_cheat_sheet_file($ia);
	my $data = decode_json($cheat_file->slurp())
		or $self->app->emit_and_exit(-1, "Invalid JSON");
	my @choices = sort keys %$data;
	my $to_configure = $self->app->get_reply("What would you like to configure?",
		choices => \@choices,
	);
	my $current = $data->{$to_configure};
	my $new_val = $self->_configure_item($current);
	$data->{$to_configure} = $new_val;
	my $encoded = $json->encode($data);
	$cheat_file->spew_utf8($encoded);
}

sub run {
	my ($self, @args) = @_;
	my $ia = $self->_ask_ia_check();
	$self->app->emit_and_exit(-1,
		"Currently do not support non-cheat-sheet Instant Answers")
		unless is_cheat_sheet($ia);
	$self->app->emit_info('Configuring ' . $ia->{id});
	$self->_configure_cheat_sheet($ia);
}

1;
