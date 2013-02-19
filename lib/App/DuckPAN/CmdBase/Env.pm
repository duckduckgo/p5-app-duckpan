package App::DuckPAN::CmdBase::Env;
# ABSTRACT: Base class for ENV related functionality of duckpan (duckpan env and duckpan rm)

use MooX qw( Options );
use Path::Class;
use Config::INI;

has env_ini => (
  is => 'ro',
  lazy => 1,
  builder => 1,
);

sub _build_env_ini { file(shift->app->cfg->config_path, 'env.ini') }

sub load_env_ini {
  my ( $self ) = @_;
  if (-f $self->env_ini) {
    my $data = Config::INI::Reader->read_file(shift->env_ini)->{_};
    defined $data ? $data : {}
  } else {
    {}
  }
}
sub save_env_ini {
  my ( $self, $data ) = @_;
  Config::INI::Writer->write_file({ _ => $data },$self->env_ini);
}

sub set_env {
  my ( $self, $name, $value ) = @_;
  $name = uc($name);
  my %data = %{$self->load_env_ini};
  $data{$name} = $value;
  $self->save_env_ini(\%data);
}

sub get_env {
  my ( $self, $name ) = @_;
  $name = uc($name);
  my %data = %{$self->load_env_ini};
  $data{$name};
}

sub rm_env {
  my ( $self, $name ) = @_;
  $name = uc($name);
  my %data = %{$self->load_env_ini};
  delete $data{$name} if defined $data{$name};
  $self->save_env_ini(\%data);
}

sub show_env {
  my ( $self, $name ) = @_;
  if ($self->get_env($name)) {
    print 'export '.$name.'=\''.$self->get_env($name).'\''."\n";
  } else {
    print '# '.$name.' is not set'."\n";
  }
}

sub show_usage {
  my ( $self ) = @_;
  if (keys %{$self->load_env_ini}) {
    print STDOUT "# ENV variables added so far:\n";
    $self->show_env($_) for (sort keys %{$self->load_env_ini});
    print STDOUT "\n";
  }
  printf STDERR "Usage:\n";
  printf STDERR "  %12s\tduckpan env <name> <value>\n", "add ENV:";
  printf STDERR "  %12s\tduckpan env <name>\n", "get ENV:";
  printf STDERR "  %12s\tduckpan rm <name>\n", "remove ENV:";
  exit 1;
}

1;
