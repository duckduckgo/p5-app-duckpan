package App::DuckPAN::Cmd::Test;

use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self ) = @_;

    my $ret = 0;

    if (-e 'dist.ini') {
      $ret = system('dzil test');
      print STDERR '[ERROR] Could not begin testing. Is Dist::Zilla installed?'
        if $ret == -1;
    } else {
      print STDERR "[WARNING] Could not find dist.ini.\n";
      $ret = system('prove -Ilib');
    }

    return $ret;
}

1;
