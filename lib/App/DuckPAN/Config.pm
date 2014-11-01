package App::DuckPAN::Config;
# ABSTRACT: Configuration class of the duckpan client

use Moo;
use File::HomeDir;
use Path::Tiny;
use Config::INI::Reader;
use Config::INI::Writer;

has config_path => (
	is      => 'ro',
	lazy    => 1,
	default => sub { _path_for('config') },
);
has config_file => (
	is      => 'ro',
	lazy    => 1,
	default => sub { shift->config_path->child('config.ini') },
);
has cache_path => (
	is      => 'ro',
	lazy    => 1,
	default => sub { _path_for('cache') },
);

sub _path_for {
	my $which = shift;

	my $from_env = $ENV{'DUCKPAN_' . uc $which . '_PATH'};
	my $path = ($from_env) ? path($from_env) : path(File::HomeDir->my_home, '.duckpan');
	$path->mkpath unless $path->exists;
	return $path;
}

sub set_config {
	my ( $self, $config ) = @_;
	Config::INI::Writer->write_file($config,$self->config_file);
}

sub get_config {
	my ( $self ) = @_;
	return unless $self->config_file->is_file;
	Config::INI::Reader->read_file($self->config_file);
}

1;
