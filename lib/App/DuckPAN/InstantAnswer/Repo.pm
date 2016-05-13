package App::DuckPAN::InstantAnswer::Repo;
# ABSTRACT: Instant Answer Repository information.

use strict;
use warnings;

use Path::Tiny;

use Moo;

with qw( App::DuckPAN::Lookup );

my $repos = [
	{
		name          => 'Goodie',
		lib           => path('lib'),
		supported     => 1,
		template_dir  => path('goodie'),
		path_basename => 'zeroclickinfo-goodies',
		share_name    => 'goodie',
		repo          => 'goodies',
	},
	{
		name          => 'Spice',
		lib           => path('lib'),
		supported     => 1,
		path_basename => 'zeroclickinfo-spice',
		template_dir  => path('spice'),
		share_name    => 'spice',
		repo          => 'spice',
	},
	{
		name          => 'Fathead',
		lib           => path('lib'),
		supported     => 0,
		path_basename => 'zeroclickinfo-fathead',
		repo          => 'fathead',
	},
	{
		name          => 'Longtail',
		lib           => path('lib'),
		supported     => 0,
		path_basename => 'zeroclickinfo-longtail',
		repo          => 'longtail',
	},
];

sub _lookup { $repos }
sub _lookup_id { 'repo' }

1;

__END__
