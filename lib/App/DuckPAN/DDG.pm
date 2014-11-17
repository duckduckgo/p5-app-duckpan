package App::DuckPAN::DDG;
# ABSTRACT: DDG related functionality of duckpan

use Moo;
with 'App::DuckPAN::HasApp';
use feature 'state';

use again;
use Module::Pluggable::Object;
use Class::Unload;
use Data::Printer;
use List::Util qw (first);
use Try::Tiny;

sub get_dukgo_user_pass {
    my ($self) = @_;
    my $config = $self->app->perl->get_dzil_config;
    $self->app->emit_and_exit(1, "No configuration found for your https://duck.co/ username and password", "Please use 'dzil setup' first!")
      unless (defined $config->{'%DUKGO'});

    return $config->{'%DUKGO'}->{username}, $config->{'%DUKGO'}->{password};
}

# This function tells the user which modules / instant answers failed to load.
sub show_failed_modules {
    my ($self, $failed_to_load) = @_;

    if (%$failed_to_load) {
        $self->app->emit_notice("These instant answers were not loaded:");
        $self->app->emit_notice(p($failed_to_load, colored => $self->app->colors));
        $self->app->emit_notice(
            "To learn more about installing Perl dependencies, please read https://duck.co/duckduckhack/faq#how-do-i-install-a-missing-perl-dependency.",
            "Note: You can ignore these errors if you're not working on these instant answers."
        ) if first { /dependencies/ } values %$failed_to_load;
    }
}

has all_modules => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
    clearer => 1,
);

sub _build_all_modules {
    my $self = shift;

    my $type   = $self->app->ia_type;
    my $finder = Module::Pluggable::Object->new(
        search_path => [$type->{dir}],
    );
    $self->app->emit_debug('Scanning ' . $type->{dir} . ' for available modules...');
    my @plugins = map {
        $_ =~ s!/!::!g;
        my @parts = split('::', $_);
        shift @parts;
        join('::', @parts);
      } sort {
        $a cmp $b
      } ($finder->plugins);

    return \@plugins;
}

sub blocks_loader {
    my ($self, @args) = @_;

    return sub {
        my $type = $self->app->ia_type;
        my @mods;
        if (@args == 0) {
            state $dir_checked = $type->{dir}->stat->mtime;
            if ((my $latest = $type->{dir}->stat->mtime) > $dir_checked) {
                $self->clear_all_modules;
                $dir_checked = $latest;
            }
            @mods = @{$self->all_modules};
        } else {
            @mods = map { $_ = "DDG::" . $type->{name} . "::$_" unless m,^lib(::|/)DDG,; $_; } @args;
        }

        require lib;
        lib->import('lib');
        Class::Unload->unload('Moo'); # Otherwise it will not reapply constructors.
        $self->app->emit_info("Loading Instant Answers...");

        # This list contains all of the classes that loaded successfully.
        my @successfully_loaded = ();

        # This hash contains all of the modules that failed.
        # The key contains the module name and the value contains the dependency that wasn't met.
        my %failed_to_load = ();

        # This loop goes through each Goodie / Spice, and it tries to load it.
        foreach my $class (@mods) {
            # Let's try to load each Goodie / Spice module
            # and see if they load successfully.
            try {
                if (require_again($class)) {
                    # We actually (re-)loaded the class.
                    $self->app->emit_debug(" + $class (" . $class->triggers_block_type . ")");
                }
                # Regardless, it's loaded.
                push @successfully_loaded, $class;
            }
            catch {
                # Get the module name that needs to be installed by the user.
                if ($_ =~ /Can't locate ([^\.]+).pm in \@INC/) {
                    my $dep_error = $1;
                    $dep_error =~ s/\//::/g;

                    $failed_to_load{$class} = "Please install $dep_error and any other required dependencies to use this instant answer.";
                } else {
                    # We just set the value to whatever the error message was if it failed for some other reason.
                    $failed_to_load{$class} = $_;
                }
            };
        }

        # Now let's tell the user why some of the modules failed.
        $self->show_failed_modules(\%failed_to_load);

        my %blocks_plugins;
        for (@successfully_loaded) {
            $blocks_plugins{$_->triggers_block_type} //= [];
            push @{$blocks_plugins{$_->triggers_block_type}}, $_;
        }

        my @blocks;
        for (keys %blocks_plugins) {
            my $block_class = 'DDG::Block::' . $_;
            require_again($block_class);
            push @blocks,
              $block_class->new(
                plugins    => $blocks_plugins{$_},
                return_one => 0
              );
        }
        require_again('DDG::Request');
        return \@blocks;
    };
}

1;
