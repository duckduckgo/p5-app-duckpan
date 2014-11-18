package App::DuckPAN::Cmd::Env;
# ABSTRACT: Get or set ENV variables for instant answers

use Moo;
extends 'App::DuckPAN::CmdBase::Env';

with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self, $name, @value ) = @_;
    $self->help($name) if (!defined $name || !(my ($command) = grep{$_ eq $name} @{$self->commands}));
    $self->$command(@value) if $command;
    exit 0;
}

1;
