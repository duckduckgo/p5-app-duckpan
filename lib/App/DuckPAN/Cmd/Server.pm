package App::DuckPAN::Cmd::Server;
# ABSTRACT: Starting up the webserver to test plugins

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Plack::Runner;
use File::ShareDir::ProjectDistDir;
use File::Copy;
use Path::Class;
use IO::All -utf8;
use LWP::Simple;
use HTML::TreeBuilder;
use Config::INI;
use Data::Dumper;

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_app_duckpan;
	exit 1 unless $self->app->check_ddg;

	dir($self->app->cfg->cache_path)->mkpath unless -d $self->app->cfg->cache_path;

	my %spice_files = (
		'page_root.html'            => { name => 'DuckDuckGo HTML', file_path => '/' },
		'page_spice.html'           => { name => 'DuckDuckGo Spice-Template', file_path => '/?q=duckduckhack-template-for-spice2' },
		'page.css'                  => { name => 'DuckDuckGo CSS', file_path => '/style.css' },
		'duckduck.js'               => { name => 'DuckDuckGo Javascript', file_path => '/duckduck.js' },
		'handlebars.js'             => { name => 'Handlebars.js', file_path => '/js/handlebars-1.0.0-rc.3.js' },
		'spice2_duckpan.js'         => { name => 'Spice2.js', file_path => '/spice2/spice2_duckpan.js' },
		'spice2_duckpan_compile.js' => { name => 'Spice2 DuckPAN compile script', file_path => '/spice2/spice2_duckpan_compile.js' }
	);

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};
	my @shared_assets = @{$self->app->ddg->get_plugin_info_from_current_dir(@args)};
	# In case of spice plugin verify if assets are available 
	# Warn developer of asset status
	foreach (@shared_assets)
	{
	    my $pd = $_;
	    my $name = $pd->{'name'};
	    if ($name =~ /Spice/)
	    {
		my $handlebar_path = $pd->{'handlebar_path'};
		my $js_path = $pd->{'js_path'};
		my $css_path = $pd->{'css_path'};
		print "WARNING: $handlebar_path does not exist\n" if ! -e $handlebar_path;
		print "WARNING: $js_path does not exist\n" if ! -e $js_path;
		print "INFO: $css_path does not exist \n" if ! -e $css_path;
	    }
	}
	my $hostname = $self->app->server_hostname;
	print "\n\nTrying to fetch current versions of the HTML from http://$hostname/\n\n";
	
	foreach my $file_name (keys %spice_files){
		copy(file(dist_dir('App-DuckPAN'),$file_name),file($self->app->cfg->cache_path,$file_name)) unless -f file($self->app->cfg->cache_path,$file_name);
		
		my $path = $spice_files{$file_name}{'file_path'};
		my $url = 'http://'.$hostname.''.$path;
		my $res = $self->app->http->request(HTTP::Request->new(GET => $url));
		
		if ($res->is_success){

				my $content = $res->decoded_content(charset => 'none');

				if ($file_name =~ m/\.js$/){
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_js($content));
				} elsif  ($file_name =~ m/\.css$/){
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_css($content));
				} else {
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_html($content));
				}
		} else {
			#print $res->status_line, "\n";
			print "\n".$spice_files{$file_name}{'name'}." fetching failed, will just use cached version...";
		}
	}

	my $page_root = io(file($self->app->cfg->cache_path,'page_root.html'))->slurp;

	my $page_spice = io(file($self->app->cfg->cache_path,'page_spice.html'))->slurp;
	my $page_css = io(file($self->app->cfg->cache_path,'page.css'))->slurp;

	# Concatenate all JS files
	# Order matters because of dependencies
	my $page_js = io(file($self->app->cfg->cache_path,'duckduck.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'handlebars.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'spice2_duckpan.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'spice2_duckpan_compile.js'))->slurp;

	print "\n\nStarting up webserver...";
	print "\n\nYou can stop the webserver with Ctrl-C";
	print "\n\n";

	require App::DuckPAN::Web;

	my $web = App::DuckPAN::Web->new(
		blocks => \@blocks,
		page_root => $page_root,
		page_spice => $page_spice,
		page_css => $page_css,
		page_js => $page_js,
		server_hostname => $hostname,
	);
	my $runner = Plack::Runner->new(
		#loader => 'Restarter',
		includes => ['lib'],
		app => sub { $web->run_psgi(@_) },
	);
	#$runner->loader->watch("./lib");
	exit $runner->run;
}

sub change_js {
	my ( $self, $js ) = @_;
	$js =~ s!/([ds])\.js\?!/?duckduckhack_ignore=1&!g;
	$js =~ s!/post\.html!/?duckduckhack_ignore=1&!g;
	return $self->change_css($js);
}

sub change_css {
	my ( $self, $css ) = @_;
	$css =~ s!url\(("?)!url\($1http://duckduckgo.com/!g;
	return $css;
}

sub change_html {
	my ( $self, $html ) = @_;

	my $root = HTML::TreeBuilder->new;
	$root->parse($html);

	my $hostname = $self->app->server_hostname;

	my @a = $root->look_down(
		"_tag", "a"
	);

	my @link = $root->look_down(
		"_tag", "link"
	);

	for (@a,@link) {
		if ($_->attr('type') && $_->attr('type') eq 'text/css') {
			$_->attr('href','/?duckduckhack_css=1');
		} elsif (substr($_->attr('href'),0,1) eq '/') {
			$_->attr('href','http://'.$hostname.''.$_->attr('href'));
		}
	}

	my @script = $root->look_down(
		"_tag", "script"
	);

	for (@script) {
		if (my $src = $_->attr('src')) {
			if ($src =~ m/^\/d\d{3,4}\.js/) {
				$_->attr('src','/?duckduckhack_js=1');
			} elsif (substr($src,0,1) eq '/') {
				$_->attr('src','http://'.$hostname.''.$_->attr('src'));
			}
		}
	}

	my @img = $root->look_down(
		"_tag", "img"
	);

	for (@img) {
		if ($_->attr('src')) {
			$_->attr('src','http://'.$hostname.''.$_->attr('src'));
		}
	}

	my $newhtml = $root->as_HTML;

	return $self->change_js($self->change_css($newhtml));
}

1;
