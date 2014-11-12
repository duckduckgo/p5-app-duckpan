package App::DuckPAN::Cmd::Test;
# ABSTRACT: Command for running the tests of this library

use MooX;
use MooX::Options protect_argv => 0;
with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self ) = @_;

    my $ret = 0;

    if (-e 'dist.ini') {
      $ret = system('dzil test');
      $self->app->emit_error('Could not begin testing. Is Dist::Zilla installed?') if $ret == -1;
    } else {
      $self->app->emit_notice("Could not find dist.ini.");
      $ret = system('prove -Ilib');
    }

    return $ret;
}

1;
