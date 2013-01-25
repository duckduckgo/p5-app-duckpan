package App::DuckPAN::Cmd::Env;

use Path::Class;
use Config::INI;
use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
	my ( $self, $name, $key ) = @_;

    if (not defined $name or not defined $key) {
      print STDERR "Usage: duckpan env <name> <value>";
      exit 1;
    }

    my $config = { '_' => { "$name" => "$key" } };

    open my $file, '>>', file($self->app->cfg->cache_path, 'env.ini');

    Config::INI::Writer->write_handle($config, $file);

    print "Added '$name = $key' to duckpan env\n";

    exit 0;

}

1;
