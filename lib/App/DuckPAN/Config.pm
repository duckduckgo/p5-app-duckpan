package App::DuckPAN::Config;

use Moo;
use Path::Class;
use Config::INI::Reader;
use Config::INI::Writer;

has config_path => (
	is => 'ro',
	lazy => 1,
	default => sub { defined $ENV{DUCKPAN_CONFIG_PATH} ? $ENV{DUCKPAN_CONFIG_PATH} : dir($ENV{HOME},'.duckpan') },
);

has config_file => (
	is => 'ro',
	lazy => 1,
	default => sub { defined $ENV{DUCKPAN_CONFIG_FILE} ? $ENV{DUCKPAN_CONFIG_FILE} : file(shift->config_path,'config.ini') },
);

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
