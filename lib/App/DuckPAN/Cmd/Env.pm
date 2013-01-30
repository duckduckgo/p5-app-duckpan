package App::DuckPAN::Cmd::Env;

use Path::Class;
use Config::INI;
use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self, $name, $key ) = @_;

    my $config_file = file($self->app->cfg->config_path, 'env.ini');

    if (not -e $config_file) {
      open my $config, '>', $config_file;
      close $config;
    }

    if (defined $name ) {
      my $config = Config::INI::Reader->read_file($config_file);
      if ($name eq 'key') {
        map { print "$_ = $config->{'_'}{$_}\n" } keys %{$config->{'_'}};
        exit 0;
      } elsif ($name eq 'rm') {
         if ($config->{'_'} and grep {$_ eq $key} keys %{$config->{'_'}}) {
           delete $config->{'_'}{$key};
           open my $output, '>', $config_file;
           Config::INI::Writer->write_handle(%{$config}, $output);
           exit 0;
         }
         exit 0 if defined $key;
      } elsif ($config->{'_'} and grep {$_ eq $name} keys %{$config->{'_'}}) {
        print STDERR "$name is already defined in env.ini\n";
        exit 1;
      }
    }

    if (not defined $name or not defined $key) {
      printf STDERR "Usage:\n";
      printf STDERR "  %10s\tduckpan env <name> <value>\n", "to add:";
      printf STDERR "  %10s\tduckpan rm <name>\n", "to remove:";
      printf STDERR "  %10s\tduckpan env key\n", "to view:";
      exit 1;
    }

    my $config = { '_' => { "$name" => "$key" } };
    open my $output, '>>', $config_file;
    Config::INI::Writer->write_handle($config, $output);

    exit 0;

}

1;
