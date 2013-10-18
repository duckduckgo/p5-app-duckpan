package App::DuckPAN::Cmd::New;
# ABSTRACT: New is plugin template creates basic files for 
# zeroclickinfo plugin.
# It is capable of creating Goodie and Spice plugin.
# In case of Goodie it creates a .pm file
# For Spice it creates a populated .pm and empty handlebars and js file


use Moo;
use Data::Dumper;
with qw( App::DuckPAN::Cmd );
use Text::Sprintf::Named qw(named_sprintf);
use IO::All;

sub camel_to_underscore {
    $_ = shift;
    # Replace first capital by lowercase
    # if followed my lowercase.
    s/^([A-Z])([a-z])/lc($1).$2/e;
    # Substitute camelCase to camel_case
    s/([a-z])([A-Z])/$1.'_'.lc($2)/ge;
    return lc $_;
}

sub touch {
    my $file = shift @_;
    my $now = time;
    local (*TMP);

                utime ($now, $now, $file)
                || open (TMP, ">>$file")
                || warn ("Couldn't touch file: $!\n");
} 


sub run {
	my ( $self, @args ) = @_;
	if (@args < 1)
	{
	    $self->app->print_text('Plugin name is required');
	    
	}
	else
	{
	    # Plugin name as parameter
	    my $plugin_name = $args[0];
	    my $lc_plugin = camel_to_underscore($plugin_name);


	    # %plugin forms the spine data structure which is used
	    # as a guide to discovering content which is moved around

	    my %plugins = ( 
		goodie => {
		    dir => './lib/DDG/Goodie',
		    files => {
			'./plugin_template/lib/DDG/Goodie/Example.pm' => "./lib/DDG/Goodie/$plugin_name.pm",
			'./plugin_template/t/Example.t' => "./t/$plugin_name.t",
		    },  
		},
		spice => {
		    dir => './lib/DDG/Spice', 
		    dir_ui => "./share/spice/$lc_plugin",
		    files => {
			'./plugin_template/lib/DDG/Spice/Example.pm' => "./lib/DDG/Spice/$plugin_name.pm",
			'./plugin_template/t/Example.t' => "./t/$plugin_name.t",
			'./plugin_template/share/spice/example/example.handlebars' => "./share/spice/$lc_plugin/$lc_plugin.handlebars",
			'./plugin_template/share/spice/example/example.js' => "./share/spice/$lc_plugin/$lc_plugin.js"
			  },
		}  
		
		);
	    if (-d $plugins{'goodie'}{'dir'}) {
		for (keys $plugins{'goodie'}{'files'}) {
		    my $filename = $_;
		    my $dest = $plugins{'goodie'}{'files'}{$filename};
		    
		    if (-e $dest) {
			$self->app->print_text("Plugin $plugin_name $dest file already exists\n");
			exit -1;
		    }
		    
		    if (! -e $filename) {
			$self->app->print_text("Plugin template $filename does not exist\n");
			exit -1;
		    }
			
		}
		    
		my $content = '';
		while (my ($source, $dest) = each($plugins{'goodie'}{'files'})) {
		    
		    $content = io($source)->all;
		    my $cooked_data = named_sprintf($content, plugin_name => $plugin_name);
		    #$cooked_data > io($dest);
		    io($dest)->append($cooked_data);
		    $self->app->print_text("Plugin $plugin_name $dest file copied\n");
		    
		}   
		$self->app->print_text("Plugin $plugin_name definitions created\n");
		    
		
	    }

	    if (-d $plugins{'spice'}{'dir'}) {
		if (-d $plugins{'spice'}{'dir_ui'}) {
		    $self->app->print_text("Plugin $plugin_name already exists");
		    exit -1;
		}
		else {

		    for (keys $plugins{'spice'}{'files'}) {
			my $filename = $_;
			my $dest = $plugins{'spice'}{'files'}{$filename};
			
			if (-e $dest) {
			    $self->app->print_text("Plugin $plugin_name $dest file already exists\n");
			    exit -1;
			}
				
			if (! -e $filename) {
			    $self->app->print_text("Plugin template $filename does not exist\n");
			    exit -1;
			}
			
		    }
		    
		    mkdir $plugins{'spice'}{'dir_ui'};
		    my $content = '';
		    while (my ($source, $dest) = each($plugins{'spice'}{'files'})) {
			
			$content = io($source)->all;
			my $cooked_data = named_sprintf($content, plugin_name => $plugin_name);
			#$cooked_data > io($dest);
			io($dest)->append($cooked_data);
			$self->app->print_text("Plugin $plugin_name $dest file copied\n");
			
		    }   
		    $self->app->print_text("Plugin $plugin_name definitions created\n");
		    
		}
	    }

	}
}
	    

1;
