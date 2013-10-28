package App::DuckPAN::Cmd::New;
# ABSTRACT: Take a name as input and generates a new, named Goodie or Spice instant answer skeleton

# For Goodies:
# 	- <name>.pm file is created in lib/DDG/Goodie
#
# For Spice:
# 	- <name>.pm file is created in lib/DDG/Spice
# 	- directory /share/spice/<name> is created
# 	- <name.js> is created in /share/spice/<name>
# 	- <name.handlebars> is created in /share/spice/<name>

use Moo;
use Data::Dumper;
with qw( App::DuckPAN::Cmd );
use Text::Xslate qw(mark_raw);
use IO::All;

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
		    
		while (my ($source, $dest) = each($plugins{'goodie'}{'files'})) {
		    
		    
		    my $tx = Text::Xslate->new();
		    my %vars = (ia_name => $plugin_name,
			lia_name => $lc_plugin);
		    my $content = $tx->render($source, \%vars);
		    
		    #$cooked_data > io($dest);
		    io($dest)->append($content);
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
		    while (my ($source, $dest) = each($plugins{'spice'}{'files'})) {
			
			my $tx = Text::Xslate->new();
			my %vars = (ia_name => $plugin_name,
			    lia_name => $lc_plugin);
			my $content = $tx->render($source, \%vars);
		    
			#$cooked_data > io($dest);
			io($dest)->append($content);
		    
			$self->app->print_text("Plugin $plugin_name $dest file copied\n");
			
		    }   
		    $self->app->print_text("Plugin $plugin_name definitions created\n");
		    
		}
	    }

	}
}
	    

1;
