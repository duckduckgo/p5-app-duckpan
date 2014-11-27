package App::DuckPAN::Cmd::Env;
# ABSTRACT: Env command class

use Moo;
use MooX::Cmd;

with qw( App::DuckPAN::Cmd );

use Config::INI;

has env_ini => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

sub _build_env_ini {
    my ( $self ) = @_;
    $self->command_chain->[0]->root->cfg->config_path->child('env.ini') 
}

sub load_env_ini {
    my ( $self ) = @_;
    if ($self->env_ini->is_file) {
        my $data = Config::INI::Reader->read_file($self->env_ini)->{_};
        defined $data ? $data : {}
    } else {
        {}
    }
}

sub save_env_ini {
    my ( $self, $data ) = @_;
    Config::INI::Writer->write_file({ _ => $data }, $self->env_ini);
}

sub help {
    my ( $self, $cmd_input ) = @_;
    my $help_msg = "Available Commands:\n\t get:  duckpan env get <name>\n\t help: duckpan env help\n\t ".
                   "list: duckpan env list\n\t rm:   duckpan env rm  <name>\n\t set:  duckpan env set <name> <value>";

    if($cmd_input) {
        $self->command_chain->[0]->root->emit_and_exit(1, "Missing arguments!\n\t Usage:\tduckpan env ". $self->command_name ." ". $cmd_input) if $self->command_name;
        $self->app->emit_and_exit(1, "Command '". $cmd_input ."' not found\n". $help_msg);
    }

    $self->command_name ? $self->command_chain->[0]->root->emit_info($help_msg) : $self->app->emit_info($help_msg);
}

sub run {
    my ( $self, $name ) = @_;
    $self->help($name) if !$self->command_name;
    exit 0;
}

1;
