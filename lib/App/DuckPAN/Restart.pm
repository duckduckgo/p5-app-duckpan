package App::DuckPAN::Restart;
# ABSTRACT: Automatic restarting of application on file change

use File::Find::Rule;
use Filesys::Notify::Simple;

use strict;

use Moo::Role;

requires '_run_app';

sub run_restarter {
    my ($self, $args) = @_;

    # will keep (re)starting the server until user ctrl-c
    while(1){
        defined(my $app = fork) or die 'Failed to fork application';
        unless($app){ # app kid
            $self->_run_app($args);
            exit 0;
        }

        my $fmon = fork;
        unless($fmon){ # file monitor kid
            unless(defined $fmon){
                kill SIGTERM => $app;
                die 'Failed to fork file monitor';
            }
            $self->_monitor_directories;
            exit 0;
        }

        # wait for one them to exit
        my $pid = waitpid -1, 0;

        # reload the application
        if($pid == $fmon){
            # if we can't kill the app, let's not start another
            unless(kill SIGTERM => $app){
                die "Failed to kill the application (pid: $app). Check manually";
            }
            # wait for it, otherwise the next whie loop will get it
            waitpid($app, 0);
        }
        elsif($pid == $app){ # or exit
            kill SIGTERM => $fmon;
            exit;
        }
        else{ die "Unknown kid $pid reaped!\n"; } # shouldn't happen
    }
}

# Monitors development directories for file changes.  Tries to get the
# list of directories in a general way.  This subroutine 
# blocks, so when it returns we know there's been a change
sub _monitor_directories {
    my $self  = shift;

    # Find all of the directories that neeed to monitored
    my %distinct_dirs;
    while(my ($type, $io) = each %{$self->app->get_ia_type()->{templates}}){
        next if $type eq 'test'; # skip the test dir?
        # Get any subdirectories
        my @d = File::Find::Rule->directory()->in($io->{out});
        ++$distinct_dirs{$_} for @d;
    }
    ++$distinct_dirs{$self->app->get_ia_type()->{dir}};
    # No dupes
    my @dirs = keys %distinct_dirs;
    FSMON: while(1){
        # Find all subdirectories
        # Create our watcher with each directory
        my $watcher = Filesys::Notify::Simple->new(\@dirs);
        # Wait for something to happen.  This blocks, which is why
        # it's in a wheel.  On detection of update it will fall
        # through; thus the while(1)
        my $reload;
        $watcher->wait(sub {
            for my $event (@_) {
                my $file = $event->{path};
                # if it's just a newly created directory or a dot file,
                # there shouldn't be a need to reload.  This will catch
                # directories with files in them properly, as each file
                # will be its own event
                if( (-d $file) || ($file =~ m{^(?:.+/)?\.[^/]+$}o)){
                    next;
                }
                # All other changes trigger a reload
                ++$reload;
            }
        });
        # time to reload or keep waiting
        last FSMON if $reload;
    }
}

1;
