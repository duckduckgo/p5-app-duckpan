package App::DuckPAN::Cmd::Env;
# ABSTRACT: Get or set ENV variables for instant answers

use Moo;
extends 'App::DuckPAN::CmdBase::Env';

with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self, $name, @value ) = @_;
    my @commands = ('get','set','rm','list','help');
    $self->help if (!defined $name || !(my ($command) = grep{$_ eq $name} @commands));
    $self->$command(@value);
    exit 0;
}

1;
