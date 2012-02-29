package App::DuckPAN::Cmd::Goodie;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Module::Pluggable::Object;
use Class::Load ':all';
use Data::Printer;

sub run {
	my ( $self, @args ) = @_;
	if (defined $args[0]) {
		unless ($self->app->get_local_ddg_version) {
			print "\n[ERROR] You need to have the DDG distribution installed\n";
			print "\nTo get the installation command, please run: duckpan check\n\n";
			exit 1;
		}
		if ($args[0] eq 'test') {
			shift @args;
			if (defined $args[0] and $args[0] eq 'all') {
				my $finder = Module::Pluggable::Object->new(
					search_path => ['DDG::Goodie'],
				);
				@args = $finder->plugins;
				unless (@args) {
					print "\n[ERROR] No DDG::Goodie::* packages found\n";
					print "\nHint: The 'all' parameter does not automatically include your lib path.\n\n";
					exit 1;
				}
			} elsif (!@args) {
				my $finder = Module::Pluggable::Object->new(
					search_path => ['lib/DDG/Goodie'],
				);
				@args = $finder->plugins;
				@args = map {
					$_ =~ s!/!::!g;
					my @parts = split('::',$_);
					shift @parts;
					join('::',@parts);
				} @args;
				require lib;
				lib->import('lib');
			}
			unless (@args) {
				print "\n[ERROR] No DDG::Goodie::* packages found\n";
				print "\nHint: You must be in the root of your repository so that this works.\n\n";
				exit 1;
			}
			print "\nUsing the following DDG::Goodie plugins:\n\n";
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
					print "\nSorry, no hit on your goodies\n\n";
				}
			}
			print "\n\n\\_o< Thanks for testing!\n\n";
			exit 0;
		} elsif ($args[0] eq 'new') {
			unless ($self->app->get_config) {
				print "\n[ERROR] Please run 'duckpan setup' first\n\n";
				exit 1;				
			}
			shift @args;
			if (scalar @args != 1) {
				print "\n[ERROR] You need to give the name of your Goodie (no spaces allowed, please uppercase first letter)\n\n";
				exit 1;
			}
			my $name = shift @args;
			$name = ucfirst($name);
			my $package = 'DDG::Goodie::'.$name;
			my $dir = 'p5-ddg-goodie-'.lc($name);
			print "\nGenerating ".$package." in ".$dir." ...\n\n";
			exit 0;
		}
	} 
	print $self->app->help->goodie;
}

1;