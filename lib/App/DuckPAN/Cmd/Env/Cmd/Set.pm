package App::DuckPAN::Cmd::Env::Cmd::Set;
# ABSTRACT: Sets the specified env variable value

use Moo;
with qw( App::DuckPAN::Cmd::Env::Cmd );

use MooX::Options protect_argv => 0;

sub run {
    my ($self, $name, @params) = @_;
    $self->env->help("<name> <value>") if !@params || !$name;
    my $data = $self->env->load_env_ini;
    $name = uc $name;
    $data->{$name} = join(" ", @params);
    eval { $self->env->save_env_ini($data) };
    $self->root->emit_and_exit(1,"Please ensure that you are passing a valid value for the variable '". $name ."'!") if $@;
    $self->root->emit_info("Successfully set '". $name ."=". $data->{$name} ."'!");
}

1;
