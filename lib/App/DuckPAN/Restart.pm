package App::DuckPAN::Restart;
# ABSTRACT: Automatic restarting of application on file change

use File::Find::Rule;
use Filesys::Notify::Simple;

use App::DuckPAN::TemplateDefinitions;
use Try::Tiny;

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

sub _get_directories_to_monitor {
    my $self = shift;
    my @output_dirs;

    try {
        my $template_defs = App::DuckPAN::TemplateDefinitions->new;
        my @templates = $template_defs->get_templates;

        for my $template (@templates) {
            push @output_dirs, $template->output_directory
                unless $template->name =~ /test/;
        }
    }
    catch {
        if (/template definitions/i) {
            # There was a problem loading the template definitions file. This
            # can happen if the instant answer repository is of an older
            # version and does not have the templates.yml file.
            #
            # In this case we use the older method of determining directories
            # to monitor. This support can be removed sometime in the future.
            # Note: Cheatsheet directories will not be monitored with this
            # method.

            $self->app->emit_debug("Instant Answers repository does not have a " .
                "template definitions file. Some directories may not be monitored " .
                "for changes.");

            while(my ($type, $io) = each %{$self->app->get_ia_type()->{templates}}){
                next if $type eq 'test'; # skip the test dir?
                push @output_dirs, $io->{out};
            }
        }
        else {
            die $_;
        }
    };

    my %distinct_dirs;

    # add all subdirectories
    for my $dir (@output_dirs) {
        ++$distinct_dirs{$_} for File::Find::Rule->directory()->in($dir);
    }

    ++$distinct_dirs{$self->app->get_ia_type()->{dir}};

    return [ keys %distinct_dirs ];
}

# Monitors development directories for file changes.  Tries to get the
# list of directories in a general way.  This subroutine 
# blocks, so when it returns we know there's been a change
sub _monitor_directories {
    my $self = shift;

    # Find all of the directories that neeed to monitored
    # Note: Could potentially be functionality added to App::DuckPAN
    # which would return the directories involved in an IA
    # (see https://github.com/duckduckgo/p5-app-duckpan/issues/200)
    my $dirs = $self->_get_directories_to_monitor;

    FSMON: while(1){
        # Find all subdirectories
        # Create our watcher with each directory
        my $watcher = Filesys::Notify::Simple->new($dirs);
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
