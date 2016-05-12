package App::DuckPAN::Restart;
# ABSTRACT: Automatic restarting of application on file change

use Carp;
use Filesys::Notify::Simple;
use List::MoreUtils qw(uniq);

use strict;

use namespace::clean;

use Moo::Role;

requires qw(_run_app ias);

sub run_restarter {
	my ($self, $args) = @_;

	# ensure working directory is always valid.
	$self->app->initialize_working_directory();

	# will keep (re)starting the server until the app exits
	while(1){
	    defined(my $app = fork) or croak('Failed to fork application');
	    unless($app){ # app kid
	        $self->_run_app($args);
	        return;
	    }

	    # Slightly different format here since we need to take care of
	    # the newly spawned app on failure.
	    my $fmon = fork;
	    unless($fmon){ # file monitor kid
	        unless(defined $fmon){
	            kill SIGTERM => $app;
	            croak('Failed to fork file monitor');
	        }
	        $self->_monitor_files;
	        return;
	    }

	    # wait for one them to exit. -1 waits for all children
	    my $pid = waitpid -1, 0;

	    # reload the application
	    if($pid == $fmon){
	        # if we can't kill the app, let's not start another
	        unless(kill SIGTERM => $app){
	            croak("Failed to kill the application (pid: $app). Check manually");
	        }
	        # wait for it, otherwise the next whie loop will get it
	        waitpid($app, 0);
	    }
	    elsif($pid == $app){ # or exit
	        kill SIGTERM => $fmon;
	        return;
	    }
	    else{ croak("Unknown kid $pid reaped!\n"); } # shouldn't happen
	}
}

# All files associated with any of the configured Instant Answers.
sub _get_files_to_monitor {
	my $self = shift;
	my @monitor_files;
	my @ias = @{$self->ias};
	foreach my $ia (@ias) {
		my @files = @{$ia->files->{all}};
		push @monitor_files, @files;
	}
	return uniq @monitor_files;
}

sub _monitor_files {
	my $self = shift;
	my @files = $self->_get_files_to_monitor();
	FSMON: while(1){
	    # Find all subdirectories
	    # Create our watcher with each directory
	    my $watcher = Filesys::Notify::Simple->new(\@files);
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
