package App::DuckPAN::Cmd::Env;
# ABSTRACT: Base class for Env command

use App::DuckPAN::Cmd::Env::Get;
use App::DuckPAN::Cmd::Env::Help;
use App::DuckPAN::Cmd::Env::List;
use App::DuckPAN::Cmd::Env::Rm;
use App::DuckPAN::Cmd::Env::Set;

use Moo;
with qw( App::DuckPAN::Cmd );

use Config::INI;

has env_ini => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

sub _build_env_ini { shift->app->cfg->config_path->child('env.ini') }

has _commands => (
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

sub help {
    my ( $self, $name ) = @_;
    App::DuckPAN::Cmd::Env::Help->execute( $self, $name );
}

sub run {
    my ( $self, $name, @value ) = @_;
    $self->help($name) if (!defined $name || !(my ($command) = grep{$_ eq $name} @{$self->_commands}));
    $command = ucfirst($command) if $command;
    ('App::DuckPAN::Cmd::Env::'. $command)->execute($self, @value) if $command;
    exit 0;
}

1;
