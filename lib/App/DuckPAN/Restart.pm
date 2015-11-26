package App::DuckPAN::Restart;
# ABSTRACT: Automatic restarting of application on file change

use File::Find::Rule;
use Filesys::Notify::Simple;

use App::DuckPAN::TemplateDefinitions;

use strict;

use Moo::Role;

requires '_run_app';

sub run_restarter {
    my ($self, $args) = @_;

    # exit immediately if not in an IA directory
    $self->app->get_ia_type;

    # will keep (re)starting the server until the app exits
    while(1){
        defined(my $app = fork) or die 'Failed to fork application';
        unless($app){ # app kid
            $self->_run_app($args);
            exit 0;
        }

        # Slightly different format here since we need to take care of
        # the newly spawned app on failure.
        my $fmon = fork;
        unless($fmon){ # file monitor kid
            unless(defined $fmon){
                kill SIGTERM => $app;
                die 'Failed to fork file monitor';
            }
            $self->_monitor_directories;
            exit 0;
        }

        # wait for one them to exit. -1 waits for all children
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
    # Note: Could potentially be functionality added to App::DuckPAN
    # which would return the directories involved in an IA
    # (see https://github.com/duckduckgo/p5-app-duckpan/issues/200)
    my $template_defs = App::DuckPAN::TemplateDefinitions->new;
    my @templates = $template_defs->get_templates;
    my %distinct_dirs;

    for my $template (@templates) {
	next unless $template->needs_restart;

        # Get any subdirectories
        my @d = File::Find::Rule->directory()->in($template->output_directory);
        # We don't know what templates will contain, e.g. subdiretories
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
                # if it's a newly created directory, dot file, or pulled 
                # in dynamically there shouldn't be a need to reload.
                # This will catch directories with files in them properly,
                # as each file will be its own event
                if( (-d $file) || ($file =~ m{^(?:.+/)?\.[^/]+$}o) || ($file =~ /\.(?:handlebars|css|js)$/oi) ){
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
