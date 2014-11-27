package App::DuckPAN::Cmd::Env::Cmd::Help;
# ABSTRACT: List commands and usage

use Moo;
with qw( App::DuckPAN::Cmd::Env::Cmd );

use MooX::Options protect_argv => 0;

sub run {
    my ( $self ) = @_;
    $self->env->help();
}

1;
