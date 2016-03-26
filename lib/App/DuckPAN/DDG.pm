package App::DuckPAN::DDG;
# ABSTRACT: DDG related functionality of duckpan

use Moo;
with 'App::DuckPAN::HasApp';

use Module::Pluggable::Object;
use Class::Load ':all';
use Data::Printer return_value => 'dump';
use List::Util qw (first);

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
	        "To learn more about installing Perl dependencies, please read http://docs.duckduckhack.com/resources/other-dev-environments.html#dealing-with-installation-issues.",
	        "Note: You can ignore these errors if you're not working on these instant answers."
	    ) if first { /dependencies/ } values %$failed_to_load;
	}
}

sub get_blocks_from_current_dir {
	my ($self, @args) = @_;

	$self->emit_and_exit(1, 'You need to have the DDG distribution installed', 'To get the installation command, please run: duckpan check')
	  unless ($self->app->get_local_ddg_version);

	my $type   = $self->app->get_ia_type();
	my $finder = Module::Pluggable::Object->new(
	    search_path => [$type->{dir}],
	);
	if (scalar @args == 0) {
	    my @plugins = $finder->plugins;
	    push @args, sort { $a cmp $b } @plugins;
	    @args = map {
	        $_ =~ s!/!::!g;
	        my @parts = split('::', $_);
	        shift @parts;
	        join('::', @parts);
	    } @args;
	}
	else {
	    @args = map {
				my $camel_name = $self->app->normalize_ia_name($_) || $_;
				$camel_name =~ m,^lib(::|/)DDG, ? $camel_name
					: 'DDG::' . $type->{name} . "::$camel_name";
			} @args;
	}
	require lib;
	lib->import('lib');
	$self->app->emit_info("Loading Instant Answers...");

	# This list contains all of the classes that loaded successfully.
	my @successfully_loaded;

	# This hash contains all of the modules that failed.
	# The key contains the module name and the value contains the dependency that wasn't met.
	my %failed_to_load;

	my (%blocks_plugins, @UC_TRIGGERS);
	# This loop goes through each Goodie / Spice, and it tries to load it.
	foreach my $class (@args) {
	    # Let's try to load each Goodie / Spice module
	    # and see if they load successfully.
	    my ($load_success, $load_error_message) = try_load_class($class);

	    # If they load successfully, $load_success would be a 1.
	    # Otherwise, it would be a 0.
	    if ($load_success) {
	        # Since we only want the successful classes to trigger, we
	        # collect all of the ones that triggered successfully in a temporary list.
	        push @successfully_loaded, $class;

	        # Display to the user when a class has been successfully loaded.
	        $self->app->emit_debug(" - $class (" . $class->triggers_block_type . ")");

			unless ($blocks_plugins{$class->triggers_block_type}) {
				$blocks_plugins{$class->triggers_block_type} = [];
			}

			my $triggers_block_type = $class->triggers_block_type;
			push @{$blocks_plugins{$triggers_block_type}}, $class;

			# We could potentially do other IA-specific checks here
			# Check for useless uppercase Words triggers so we can warn
			if($triggers_block_type eq 'Words'){
				my $trigger_types = $class->get_triggers;

				UC_TRIGGER: for my $triggers (values %$trigger_types){
					for my $t (@$triggers){
						if($t =~ /\p{Uppercase}/){
							push @UC_TRIGGERS, $class;
							#warn "is $t uppercase?\n";
							# the first one found should be sufficient.
							last UC_TRIGGER;
						}
					}
				}
			}
	    }
	    else {
	        # Get the module name that needs to be installed by the user.
	        if ($load_error_message =~ /Can't locate ([^\.]+).pm in \@INC/) {
	            $load_error_message = $1;
	            $load_error_message =~ s/\//::/g;

	            $failed_to_load{$class} = "Please install $load_error_message and any other required dependencies to use this instant answer.";
	        }
	        else {
	            # We just set the value to whatever the error message was if it failed for some other reason.
	            $failed_to_load{$class} = $load_error_message;
	        }
	    }
	}

	# Since @args can contain modules that we don't want to trigger (since they didn't load in the first place),
	# and @successfully_loaded does, we just use what's in @successfully_loaded.
	@args = @successfully_loaded;

	# Now let's tell the user why some of the modules failed.
	$self->show_failed_modules(\%failed_to_load);

	if(@UC_TRIGGERS){
		$self->app->emit_notice('Detected potential UPPERCASE triggers in the following instant answers. If yours is listed, check it out! Only lowercase will work.' . "\n"
			. p(@UC_TRIGGERS, colored => $self->app->colors));
	}

	my @blocks;
	for (keys %blocks_plugins) {
	    my $block_class = 'DDG::Block::' . $_;
	    load_class($block_class);
	    push @blocks,
	      $block_class->new(
	        plugins    => $blocks_plugins{$_},
	        return_one => 0
	      );
	}
	load_class('DDG::Request');
	return \@blocks;
}

1;
