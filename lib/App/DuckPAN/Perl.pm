package App::DuckPAN::Perl;

use Moo;
with 'App::DuckPAN::HasApp';

use Config::INI;
use Dist::Zilla::Util;

sub setup {
	my ( $self ) = @_;
	my $config_root = Dist::Zilla::Util->_global_config_root;
	$config_root->mkpath unless -d $config_root;
}

1;
