package App::DuckPAN::Config;
# ABSTRACT: Configuration class of the duckpan client

use Moo;
use MooX::HasEnv;
use Path::Class;
use Config::INI::Reader;
use Config::INI::Writer;

has_env config_path => DUCKPAN_CONFIG_PATH => dir($ENV{HOME},'.duckpan');
has config_file => (
	is => 'ro',
	lazy => 1,
	default => sub { file(shift->config_path,'config.ini') },
);
has_env cache_path => DUCKPAN_CACHE_PATH => dir($ENV{HOME},'.duckpan','cache');

sub set_config {
	my ( $self, $config ) = @_;
	$self->config_path->mkpath unless -d $self->config_path;
	Config::INI::Writer->write_file($config,$self->config_file);
}

sub get_config {
	my ( $self ) = @_;
	return unless -d $self->config_path && -f $self->config_file;
	Config::INI::Reader->read_file($self->config_file);
}

1;
