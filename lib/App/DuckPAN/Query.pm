package App::DuckPAN::Query;
# ABSTRACT: Main application/loop for duckpan query

use Moo;
use DDG;
use DDG::Request;
use DDG::Test::Location;
use DDG::Test::Language;
use Data::Printer;
use POE qw( Wheel::ReadLine Wheel::Run Filter::Reference );
use Try::Tiny;
use File::Find::Rule;
use Filesys::Notify::Simple;
use Data::Dumper;

# Entry into the module.
sub run {
    my ( $self, $app, $blocks, $pfh ) = @_;

    # Main session. All events declared have equivalent subs.
    POE::Session->create(
        package_states => [
            $self => [qw(_start _get_user_input _got_user_input _run_query _spawn_fsmon _close _fsmon_out _fsmon_err _fsmon_signaled)]
        ],
        args => [$app, $blocks, $pfh] # passed to _start
    );
    POE::Kernel->run();

    return 0;
}

# Initialize the main session. Called once by default.
sub _start {
    my ($k, $h, $app, $blocks, $pfh) = @_[KERNEL, HEAP, ARG0, ARG1, ARG2];

    my $history_path = $app->cfg->cache_path->child('query_history');

    # Session that handles user input
    my $powh_readline = POE::Wheel::ReadLine->new(
        InputEvent => '_got_user_input'
    );
    $powh_readline->bind_key("C-\\", "interrupt");
    $powh_readline->read_history($history_path);
    $powh_readline->put('(Empty query for ending test)');

    # Store in the heap for use in other events
    @$h{qw(app blocks parent_fh console history_path)} = ($app, $blocks, $pfh, $powh_readline, $history_path);

    # Queue user input event
    $k->yield('_spawn_fsmon');
    $k->yield('_get_user_input');
}

# Event to handle user input, triggered by ReadLine
sub _got_user_input {
    my ($k, $h, $input) = @_[KERNEL, HEAP, ARG0];

    # If we have input, send it off to be processed
    if($input){
        my ($console, $history_path) = @$h{qw(console history_path)};

        $console->put("  You entered: $input");
        $console->addhistory($input);
        $console->write_history($history_path);
        $k->yield(_run_query => $input); # this yield keeps the loop going
    }
    else{
        $h->{console}->put('\\_o< Thanks for testing!');
        exists $h->{FileMonitor} && $h->{FileMonitor}->kill;
        exit;
    }
    # falling through here without queuing an event ends the app.
}

# Event that prints the prompt and waits for input.
sub _get_user_input {
    $_[HEAP]{console}->get('Query: ');
}

# Event that processes the query
sub _run_query {
    my ($k, $h, $query) = @_[KERNEL, HEAP, ARG0];    
    
    my ($app, $blocks) = @$h{qw{app blocks}};

    try {
        my $request = DDG::Request->new(
            query_raw => $query,
            location => test_location_by_env(),
            language => test_language_by_env(),
        );
        my $hit;
        # Iterate through the IAs passing each the query request
        for my $b (@$blocks) {
            for ($b->request($request)) {
                $hit = 1;
                $app->emit_info('---', p($_, colored => $app->colors), '---');
            }
        }
        unless ($hit) {
            $app->emit_info('Sorry, no hit on your instant answer')
        }
    }
    catch {
        my $error = $_;
        if ($error =~ m/Malformed UTF-8 character/) {
            $app->emit_info('You got a malformed utf8 error message. Normally' . 
                ' it means that you tried to enter a special character at the query' . 
                ' prompt but your interface is not properly configured for utf8.' . 
                ' Please check the documentation for your terminal, ssh client' .
                ' or other client used to execute duckpan.'
            );
        }
        $app->emit_info("Caught error: $error");
    };

    # Enqueue input event
    $k->yield('_get_user_input');
}

# Forks off file monitor 
sub _spawn_fsmon {
    my ($k, $h) = @_[KERNEL, HEAP, ARG0];

    return "Wheel already exists" if exists $h->{FileMonitor};
    
    # Spawn off a new wheel. Usually you would want to use StdioFilter
    # for both in/out communication.  However, some of the DDG code prints
    # warnings to STDOUT which cannot be properly filtered by POE to be
    # passed back to the parent.  So we just print from within the child
    # and pass all output back to the parent via Filter::Line
    my $wheel = POE::Wheel::Run->new(
            Program => \&_fs_monitor,
            ProgramArgs => [$h->{app}->get_ia_type()->{dir}], 
            CloseOnCall => 1, 
            NoSetSid    => 1,
            StdoutEvent => '_fsmon_out',
            StderrEvent => '_fsmon_err',
            CloseEvent => '_close',            
            StdioFilter => POE::Filter::Reference->new,
            StderrFilter => POE::Filter::Line->new 
    );
    
    # register child signal handler
    $k->sig_child($wheel->PID, '_child_signaled');
    # store the wheel in the HEAP
    $h->{FileMonitor} = $wheel;
    return 0; 
}

# Child signal handler. Prevent further propagation
sub _fsmon_signaled { $_[KERNEL]->sig_handled }

# Output event of FileMonitor child.
sub _fsmon_out {
    my ($h, $msg) = @_[HEAP, ARG0];
    
    # Tell the QueryRunner to shutdown so it can be restarted
    if($msg->[0] eq '_RELOAD_'){
        print {$h->{parent_fh}} "_RELOAD_";
        exists $h->{FileMonitor} && $h->{FileMonitor}->kill;
        exit 0;
    }
}

# Child close event, automatically called when a child exits
sub _close {
    my ($h, $id) = @_[HEAP, ARG0];

    # Remove the wheel from the heap 
    delete $h->{FileMonitor};
}

# STDERR from the file system monitor child
sub _fsmon_err { $_[HEAP]->{console}->put($_[ARG0]) }

# Monitor the IA directory for changes
sub _fs_monitor {
    my $base_dir = shift;

    select(STDOUT);$|=1;

    FSMON: while(1){
        # Find all subdirectories
        my @dirs = File::Find::Rule->directory()->in($base_dir);
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
                # there shouldn't be a need to reload
                if( (-d $file) || ($file =~ m{^(?:.+/)?\.[^/]+$}o)){
                    next;
                }
                # All other changes trigger a reload
                ++$reload;
            }
        });
        if($reload){
            # Send message to parent to reload
            my $filter = POE::Filter::Reference->new;
            print STDOUT @{$filter->put([['_RELOAD_']])}; 
            last FSMON;
        }
    }
}
 
1;
