package App::DuckPAN::CmdBase::Env;
# ABSTRACT: Base class for ENV related functionality of duckpan

use MooX qw( Options );
use Config::INI;

has env_ini => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

sub _build_env_ini { shift->app->cfg->config_path->child('env.ini') }

has commands => (
    is => 'ro',
    default => sub { ['get','help','list','rm','set'] }
);


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

sub set {
    my ( $self, $name, @params ) = @_;
    $self->help('set', "<name> <value>") if !@params || !$name;
    my $data = $self->load_env_ini;
    $data->{uc $name} = join(" ", @params);
    $self->save_env_ini($data);
}

sub get {
    my ( $self, $name ) = @_;
    $self->help('get', "<name>") if !$name;
    my $data = $self->load_env_ini;
    $name = uc $name;
    $data->{$name} ? $self->app->emit_info("export ". $name ."=". $data->{$name}) : $self->app->emit_info("'". $name ."' is not set.");
}

sub rm {
    my ( $self, $name ) = @_;
    $self->help('rm', "<name>") if !$name;
    my $data = $self->load_env_ini;
    delete $data->{uc $name} if defined $data->{uc $name};
    $self->save_env_ini($data);
}

sub list {
    my ($self)  = @_;
    my $data = $self->load_env_ini;
    if (keys %{$data}) {
        $self->app->emit_info("export ". $_ ."=". $data->{$_} ) for (sort keys %{$data});
    }
}

sub help {
    my ($self, $cmd_input, $cmd_params) = @_;
    my $help_msg = "Available Commands:\n\t get:  duckpan env get <name>\n\t help: duckpan env help\n\t ".
                   "list: duckpan env list\n\t rm:   duckpan env rm  <name>\n\t set:  duckpan env set <name> <value>";
    
    if($cmd_input) {
        $self->app->emit_and_exit(1, "Missing arguments!\n\t Usage:\tduckpan env ". $cmd_input ." ". $cmd_params) if(grep{$_ eq $cmd_input} @{$self->commands});
        $self->app->emit_and_exit(1, "Command '". $cmd_input ."' not found\n". $help_msg);
    }

    $self->app->emit_info($help_msg);
}

1;
