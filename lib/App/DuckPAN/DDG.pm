package App::DuckPAN::DDG;
# ABSTRACT: DDG related functionality of duckpan

use Moo;
with 'App::DuckPAN::HasApp';

use Module::Pluggable::Object;
use Class::Load ':all';

sub get_dukgo_user_pass {
	my ( $self ) = @_;
	my $config = $self->app->perl->get_dzil_config;
	unless (defined $config->{'%DUKGO'}) {
		shift->app->print_text(
			"[ERROR] No configuration found for your https://duck.co/ username and password, please use: 'dzil setup' first!",
		);
		exit 1;
	}
	return $config->{'%DUKGO'}->{username}, $config->{'%DUKGO'}->{password};
}

sub get_blocks_from_current_dir {
	my ( $self, @args ) = @_;
	unless ($self->app->get_local_ddg_version) {
		print "\n[ERROR] You need to have the DDG distribution installed\n";
		print "\nTo get the installation command, please run: duckpan check\n\n";
		exit 1;
	}
	my $finder = Module::Pluggable::Object->new(
		search_path => ['lib/DDG/Spice','lib/DDG/Goodie','lib/DDG/Fathead','lib/DDG/Longtail'],
	);
	if (scalar @args == 0) {
		my @plugins = $finder->plugins;
		push @args, sort { $a cmp $b } @plugins;
	} else {
		@args = map { $_ = "lib::DDG::$_" unless m,^lib(::|/)DDG,; $_; } @args;
	}
	@args = map {
		$_ =~ s!/!::!g;
		my @parts = split('::',$_);
		shift @parts;
		join('::',@parts);
	} @args;
	unless (@args) {
		print "\n[ERROR] No DDG::Goodie::*, DDG::Spice::*, DDG::Fathead::* or DDG::Longtail::* packages found\n";
		print "\nHint: You must be in the root of your repository so that this works.\n\n";
		exit 1;
	}
	require lib;
	lib->import('lib');
	print "\nUsing the following DDG instant answers:\n\n";
    
	foreach my $class (@args) {
            load_class($class);
            print " - ".$class;
            print " (".$class->triggers_block_type.")\n";
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
		push @blocks, $block_class->new( plugins => $blocks_plugins{$_}, return_one => 0 );
	}
	load_class('DDG::Request');
	return \@blocks;
}

1;
