package App::DuckPAN::DDG;
# ABSTRACT: DDG related functionality of duckpan

use Moo;
with 'App::DuckPAN::HasApp';

use Module::Pluggable::Object;
use Class::Load ':all';
use Data::Printer;
use List::Util qw (first);

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

# This function tells the user which modules / instant answers failed to load.
sub print_failed_modules {
    my %failed_to_load = %{shift @_};

    # Print out the missing modules in color.
    if(%failed_to_load) {
        print "\nThese instant answers were not loaded:\n";
        p(%failed_to_load);
        print "To learn more about installing Perl dependencies, please read https://duck.co/duckduckhack/faq#how-do-i-install-a-missing-perl-dependency.\nNote: You can ignore these errors if you're not working on these instant answers.\n" if first { /dependencies/ } values %failed_to_load;
    }
}

sub get_blocks_from_current_dir {
    my ( $self, @args ) = @_;
    unless ($self->app->get_local_ddg_version) {
        print "\n[ERROR] You need to have the DDG distribution installed\n";
        print "\nTo get the installation command, please run: duckpan check\n\n";
        exit 1;
    }
    my $type = $self->app->get_ia_type();
    my $finder = Module::Pluggable::Object->new(
        search_path => [$type->{dir}],
    );
    if (scalar @args == 0) {
        my @plugins = $finder->plugins;
        push @args, sort { $a cmp $b } @plugins;
        @args = map {
                $_ =~ s!/!::!g;
                my @parts = split('::',$_);
                shift @parts;
                join('::',@parts);
        } @args;
    } else {
        @args = map { $_ = "DDG::". $type->{name} ."::$_" unless m,^lib(::|/)DDG,; $_; } @args;
    }
    unless (@args) {
        print "\n[ERROR] No DDG::Goodie::*, DDG::Spice::* packages found\n";
        print "\nHint: You must be in the root of your repository so that this works.\n\n";
        exit 1;
    }
    require lib;
    lib->import('lib');
    print "\nUsing the following DDG instant answers:\n\n";
    
    
    # This list contains all of the classes that loaded successfully.
    my @successfully_loaded = ();
    
    # This hash contains all of the modules that failed.
    # The key contains the module name and the value contains the dependency that wasn't met.
    my %failed_to_load = ();
    
    # This loop goes through each Goodie / Spice, and it tries to load it.
    foreach my $class (@args) {
        # Let's try to load each Goodie / Spice module
        # and see if they load successfully.
        my ($load_success, $load_error_message) = try_load_class($class);

        # If they load successfully, $load_success would be a 1.
        # Otherwise, it would be a 0.
        if($load_success) {
            # Since we only want the successful classes to trigger, we 
            # collect all of the ones that triggered successfully in a temporary list.
            push @successfully_loaded, $class;

            # Display to the user when a class has been successfully loaded.
            print " - $class (" . $class->triggers_block_type . ")\n";
        } else {
            # Get the module name that needs to be installed by the user.
            if($load_error_message =~ /Can't locate ([^\.]+).pm in \@INC/) {
                $load_error_message = $1;
                $load_error_message =~ s/\//::/g;
                
                $failed_to_load{$class} = "Please install $load_error_message and any other required dependencies to use this instant answer.";
            } else {
                # We just set the value to whatever the error message was if it failed for some other reason.
                $failed_to_load{$class} = $load_error_message;
            }
        }
    }

    # Since @args can contain modules that we don't want to trigger (since they didn't load in the first place),
    # and @successfully_loaded does, we just use what's in @successfully_loaded.
    @args = @successfully_loaded;

    # Now let's tell the user why some of the modules failed.
    print_failed_modules(\%failed_to_load);
    
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
