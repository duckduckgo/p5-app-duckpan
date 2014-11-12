package App::DuckPAN::Cmd::Release;
# ABSTRACT: Release the distribution of the current directory

use MooX;
use MooX::Options protect_argv => 0;
with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self ) = @_;

    my $ret = system('dzil release');

    $self->app->error_msg('Could not begin release. Is Dist::Zilla installed?') if $ret == -1;

    return $ret;
}

1;
