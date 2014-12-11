package App::DuckPAN::Cmd::Query;
# ABSTRACT: Command line tool for testing queries and see triggered instant answers

use MooX;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
    my ($self, @args) = @_;

    while(1){
        my $reload = 'ONCE_ONLY';

        my $pid;
        # open pipe for child to parent communication of reloading
		# will exit if it fails
        pipe(my $rdr, my $wrt);
    
        if($pid = fork()) { # parent proces
            close $wrt;
            $reload = <$rdr>; # wait for any output
            close $rdr;
            waitpid($pid, 0);
        } 
        else { # run the app in a separate process
            die "cannot fork: $!" unless defined $pid;
            close $rdr;
            # no buffering on our child write handle
            my $old = select $wrt;$|++; select($old);
    
            $self->app->check_requirements;    # Will exit if missing

			# These are the instant answers to be tested
            my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};
    
            require App::DuckPAN::Query;
            App::DuckPAN::Query->run($self->app, \@blocks, $wrt);
            close $wrt;
            exit;
        }
        # The child will have set $reload if the exit was triggered by an updated file
        exit unless defined $reload and $reload =~ /_RELOAD_/o; 
    }
}

1;
