package App::DuckPAN::Cmd::Env::Cmd::Rm;
# ABSTRACT: Removes the specified env variable

use Moo;
with qw( App::DuckPAN::Cmd::Env::Cmd );

use MooX::Options protect_argv => 0;

sub run {
    my ( $self, $name ) = @_;
    $self->env->help("<name>") if !$name;
    my $data = $self->env->load_env_ini;
    $name = uc $name;
    defined $data->{$name} ? delete $data->{$name} && $self->root->emit_info("Successfully removed '". $name ."'!") : $self->root->emit_error("'". $name ."' not found!");
    $self->env->save_env_ini($data);
}

1;
