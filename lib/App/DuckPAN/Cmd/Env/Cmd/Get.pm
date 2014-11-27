package App::DuckPAN::Cmd::Env::Cmd::Get;
# ABSTRACT: Gets the specified env variable

use Moo;
with qw( App::DuckPAN::Cmd::Env::Cmd );

use MooX::Options protect_argv => 0;

sub run {
    my ($self, $name) = @_;
    $self->env->help("<name>") if !$name;
    my $data = $self->env->load_env_ini;
    $name = uc $name;
    $data->{$name} ? $self->root->emit_info("export ". $name ."=". $data->{$name}) : $self->root->emit_error("'". $name ."' is not set!");
}

1;
