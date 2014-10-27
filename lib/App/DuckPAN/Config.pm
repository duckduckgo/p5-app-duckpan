package App::DuckPAN::Config;
# ABSTRACT: Configuration class of the duckpan client

use Moo;
use MooX::HasEnv;
use Path::Tiny;
use Config::INI::Reader;
use Config::INI::Writer;

has_env config_path => DUCKPAN_CONFIG_PATH => path($ENV{HOME},'.duckpan');
has config_file => (
	is => 'ro',
	lazy => 1,
	default => sub { shift->config_path->child('config.ini') },
);
has_env cache_path => DUCKPAN_CACHE_PATH => path($ENV{HOME},'.duckpan','cache');

sub set_config {
	my ( $self, $config ) = @_;
	$self->config_path->mkpath unless $self->config_path->is_dir;
	Config::INI::Writer->write_file($config,$self->config_file);
}

sub get_config {
	my ( $self ) = @_;
	return unless $self->config_path->is_dir && $self->config_file->is_file;
	Config::INI::Reader->read_file($self->config_file);
}

1;
