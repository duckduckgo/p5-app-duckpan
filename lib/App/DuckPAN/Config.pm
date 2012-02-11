package App::DuckPAN::Config;

use Moo;
use Path::Class;

has config_path => (
	is => 'ro',
	default => sub { defined $ENV{DUCKPAN_CONFIG_PATH} ? $ENV{DUCKPAN_CONFIG_PATH} : dir($ENV{HOME},'.duckpan') },
);

1;
