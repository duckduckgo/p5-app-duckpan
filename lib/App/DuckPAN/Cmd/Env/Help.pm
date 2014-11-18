package App::DuckPAN::Cmd::Env::Help;
# ABSTRACT: List commands and usage

use Moo;

sub execute {
    my ($class, $self, $cmd_input, $cmd_params) = @_;
    my $help_msg = "Available Commands:\n\t get:  duckpan env get <name>\n\t help: duckpan env help\n\t ".
                   "list: duckpan env list\n\t rm:   duckpan env rm  <name>\n\t set:  duckpan env set <name> <value>";

    if($cmd_input) {
        $self->app->emit_and_exit(1, "Missing arguments!\n\t Usage:\tduckpan env ". $cmd_input ." ". $cmd_params) if(grep{$_ eq $cmd_input} @{$self->_commands});
        $self->app->emit_and_exit(1, "Command '". $cmd_input ."' not found\n". $help_msg);
    }

    $self->app->emit_info($help_msg);
}

1;
