package App::DuckPAN::Cmd::Global;
# ABSTRACT: Commands that can be run from anywhere.

use Moo::Role;

with qw( App::DuckPAN::Cmd );

around initialize => sub { return; };

1;

__END__
