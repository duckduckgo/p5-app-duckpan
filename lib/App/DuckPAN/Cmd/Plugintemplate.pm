package App::DuckPAN::Cmd::Plugintemplate;
# ABSTRACT: Plugintemplate creates basic files for zeroclickinfo plugin.
# It is capable of creating Goodie and Spice plugin.
# In case of Goodie it creates a .pm file
# For Spice it creates a populated .pm and empty handlebars and js file


use Moo;
use Data::Dumper;
with qw( App::DuckPAN::Cmd );

use MooX::Options;


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
	    
	    if (-e 'lib/DDG/Goodie')
	    {
		$self->app->print_text('Creating Goodie Plugin Template '. $plugin_name);
		my $uncooked_plugin_file = <<"__EOF__";
package DDG::Goodie::%s;
#ABSTRACT: A plugin created by DuckPAN plugintemplate. Please modify the file to suit your plugin design.
use DDG::Goodie;
use utf8;

triggers any => '';

zci is_cached => 1;
zci answer_type => "";

attribution
    github => ['https://github.com/', ''];

primary_example_queries '';
secondary_example_queries '';
description '';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/%s.pm';
category '';
topics '';
handle query_raw => sub {
};

1;
		
__EOF__
		
	        my $cooked_plugin_file = sprintf($uncooked_plugin_file,
						  $plugin_name,
						  $plugin_name);
		my $file_name = 'lib/DDG/Goodie/'. $plugin_name .'.pm';
		if (-f $file_name)
		{
		    $self->app->print_text('Plugin '. $plugin_name. ' already exists');
		}
		else
		{
		    open (OUTFILE, '>>'. $file_name);
		    print OUTFILE $cooked_plugin_file;
		    close(OUTFILE);
		}

	    }
	    
	    if (-e 'lib/DDG/Spice')
	    {
		$self->app->print_text('Creating Spice Plugin Template '. $plugin_name);
		my $uncooked_plugin_file = <<"__EOF__";
package DDG::Spice::%s;
#ABSTRACT: A plugin created by DuckPAN plugintemplate. Please modify the file to suit your plugin design.

use DDG::Spice;
use URI::Escape;

primary_example_queries "";
secondary_example_queries "";
description "Plugin Description";
name "%s";
icon_url "";
source "";
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/%s.pm";
category "";
topics "";
attribution github => ["https://github.com/", ""];
triggers query_lc => qr//;		

handle query_lc = sub {};

1;
__EOF__
               my $cooked_plugin_file = sprintf($uncooked_plugin_file,
						  $plugin_name,
						  $plugin_name,
						  $plugin_name);
	       my $file_name = 'lib/DDG/Spice/'. $plugin_name .'.pm';
		
		if (-f $file_name)
		{
		    $self->app->print_text('Plugin '. $plugin_name. ' already exists');
		}
		else
		{
		    open (OUTFILE, '>>'. $file_name);
		    print OUTFILE $cooked_plugin_file;
		    close(OUTFILE);
		}
		
		my $lc_plugin_name = camel_to_underscore($plugin_name);
		my $share_dir = 'share/spice/'.$lc_plugin_name;
		my $handlebar = 'share/spice/'. $lc_plugin_name . '/'. $lc_plugin_name . '.handlebars';
		my $js = 'share/spice/'. $lc_plugin_name . '/'. $lc_plugin_name . '.js'; 
		mkdir $share_dir;
		touch $handlebar;
		touch $js;
	    }
	}


}

1;
