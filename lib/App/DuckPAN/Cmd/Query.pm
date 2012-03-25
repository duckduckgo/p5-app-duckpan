package App::DuckPAN::Cmd::Query;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Module::Pluggable::Object;
use Class::Load ':all';
use Data::Printer;

sub run {
	my ( $self, @args ) = @_;
	unless ($self->app->get_local_ddg_version) {
		print "\n[ERROR] You need to have the DDG distribution installed\n";
		print "\nTo get the installation command, please run: duckpan check\n\n";
		exit 1;
	}
	my $finder = Module::Pluggable::Object->new(
		search_path => ['lib/DDG/Spice','lib/DDG/Goodie'],
	);
	@args = $finder->plugins;
	@args = map {
		$_ =~ s!/!::!g;
		my @parts = split('::',$_);
		shift @parts;
		join('::',@parts);
	} @args;
	unless (@args) {
		print "\n[ERROR] No DDG::Goodie::* or DDG::Spice::* packages found\n";
		print "\nHint: You must be in the root of your repository so that this works.\n\n";
		exit 1;
	}
	require lib;
	lib->import('lib');
	print "\nUsing the following DDG plugins:\n\n";
	for (@args) {
		load_class($_);
		print " - ".$_;
		print " (".$_->triggers_block_type.")\n";
	}
	my %blocks_plugins;
	for (@args) {
		unless ($blocks_plugins{$_->triggers_block_type}) {
			$blocks_plugins{$_->triggers_block_type} = [];
		}
		push @{$blocks_plugins{$_->triggers_block_type}}, $_;
	}
	my @blocks;
	for (keys %blocks_plugins) {
		my $block_class = 'DDG::Block::'.$_;
		load_class($block_class);
		push @blocks, $block_class->new( plugins => $blocks_plugins{$_} );
	}
	load_class('DDG::Request');
	print "\n(Empty query for ending test)\n";
	while (my $query = $self->app->term->get_reply( prompt => 'Query: ' ) ) {
		my $request = DDG::Request->new( query_raw => $query );
		my $hit;
		for (@blocks) {
			my ($result) = $_->request($request);
			if ($result) {
				$hit = 1;
				print "\n";
				p($result);
				print "\n";
				last;
			}
		}
		unless ($hit) {
			print "\nSorry, no hit on your spices\n\n";
		}
	}
	print "\n\n\\_o< Thanks for testing!\n\n";
	exit 0;
}

1;