package App::DuckPAN::DDG;
use Data::Dumper;
BEGIN {
  $App::DuckPAN::DDG::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::DDG::VERSION = '0.116';
}
# ABSTRACT: DDG related functionality of duckpan

use Moo;
with 'App::DuckPAN::HasApp';

use Module::Pluggable::Object;
use Class::Load ':all';
use Module::Load;
use DDG::Meta::Information;
use List::MoreUtils qw(zip);

sub get_dukgo_user_pass {
	my ( $self ) = @_;
	my $config = $self->app->perl->get_dzil_config;
	unless (defined $config->{'%DUKGO'}) {
		shift->app->print_text(
			"[ERROR] No configuration found for your https://dukgo.com/ username and password, please use: 'dzil setup' first!",
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
		push @blocks, $block_class->new( plugins => $blocks_plugins{$_}, return_one => 0 );
	}
	load_class('DDG::Request');
	return \@blocks;
}

sub camel_to_underscore {
    $_ = shift;
    # Replace first capital by lowercase
    # if followed my lowercase.
    s/^([A-Z])([a-z])/lc($1).$2/e;
    # Substitute camelCase to camel_case
    s/([a-z])([A-Z])/$1.'_'.lc($2)/ge;
    return $_;
}


sub get_blocks_for_test_from_current_dir {
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
	print "\nUsing the following DDG plugins:\n\n";
	my @plugin_block = ();
	for (@args) {
	    my $plugin = $_;
	    my $plugin_info = {'name' => $plugin };
	    load $plugin;
	    #print Dumper($d);
	    #my $t = DDG::Meta::Information->apply_keywords($plugin);
	    my $d = $plugin->get_meta_information();
	    my @methods =   Class::Inspector->methods( $plugin, 'full', 'public' );
	    
	    if ($plugin =~ /Spice/)
	    {
		my @kickstart_arr = split('::',$plugin);
		my $kickstart = '/js/spice/'.$kickstart_arr[-1];
		$kickstart = camel_to_underscore($kickstart);
		$kickstart = lc $kickstart;
		$plugin_info->{'kickstart'} = $kickstart;
		my $plugin_share = lc camel_to_underscore($kickstart_arr[-1]);
		print $plugin_share;
		my $handlebar_path = 'share/spice/'. $plugin_share . '/'
		    . $plugin_share .'.handlebars';
		my $js_path = 'share/spice/'. $plugin_share . '/'
		    . $plugin_share .'.js';
		my $css_path = 'share/spice/'. $plugin_share . '/'
		    . $plugin_share .'.css';
		$plugin_info->{'handlebar_path'} = $handlebar_path;
		$plugin_info->{'js_path'} = $js_path;
		$plugin_info->{'css_path'} = $css_path;
	    }
	    else
	    {
		my $zci = $plugin->zci_new();
		if (exists $zci->{'answer_type'})
		{
		    $plugin_info->{'answer_type'} = $zci->{'answer_type'};
		}
	    }
	    my $a = $d->{primary_example_queries};
	    my $b = $d->{secondary_example_queries};
	    my @example = zip(@{$a}, @{$b});
	    @example = grep defined, @example;
	    $plugin_info->{'examples'} = \@example;
	    push(@plugin_block, $plugin_info);
	}
	return \@plugin_block;
}



1;

__END__

=pod

=head1 NAME

App::DuckPAN::DDG - DDG related functionality of duckpan

=head1 VERSION

version 0.116

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
