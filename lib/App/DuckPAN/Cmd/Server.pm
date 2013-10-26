package App::DuckPAN::Cmd::Server;
# ABSTRACT: Starting up the web server to test instant answers

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
use Data::Printer;
use Data::Dumper;

has page_js_filename => (
	is => 'rw',
);

has page_css_filename => (
	is => 'rw',
);

has spice_js_filename => (
	is => 'rw',
);

has hostname => (
	is => 'ro',
	builder => '_build_hostname',
	lazy => 1,
);

sub _build_hostname {
	my ( $self ) = @_;
	return $self->app->server_hostname;
}

sub run {
	my ( $self, @args ) = @_;

	# Check if newer version of App::Duckpan
	# or DDG exists
	exit 1 unless $self->app->check_app_duckpan;
	exit 1 unless $self->app->check_ddg;

	dir($self->app->cfg->cache_path)->mkpath unless -d $self->app->cfg->cache_path;

	# This hash contains files which DuckPAN requests
	# and stores locally in its own cache
	# The are all necessary for DuckPAN Server to function properly
	#
	# page_root.html  : DDG Homepage
	#                   - used for error page when no instant answers trigger
	#
	# page_spice.html : DDG SERP
	#	                  - this is the page we inject Spice and Goodie results into
	#
	# handlebars.js   : The FULL Handlebars lib
	#                   - needed to compile Spice templates in the browser
	#
	# duckpan.js      : Small script DuckPAN runs on SERP load
	#                   - used to compile Spice templates and inject Goodies into SERP
	#                   - stored locally, no need to make web request for this

	my %assets = (
		'page_root.html'            => { name => 'DuckDuckGo Landing Page', file_path => '/' },
		'page_spice.html'           => { name => 'DuckDuckGo SERP', file_path => '/?q=duckduckhack-template-for-spice2' },
		'handlebars.js'             => { name => 'Handlebars.js', file_path => '/js/handlebars-1.0.0-rc.3.js' },
		'duckpan.js'                => { } # no name/path required; always pulled from the cache
	);

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	print "\n\nTrying to fetch current versions of the HTML from http://".$self->hostname."/\n\n";

	# First we bootstrap the cache, copying all files from /share (dist_dir) into the
	# cache. Then we get each file from given hostname (usually DuckDuckGo.com) and
	# rewrite all links in the HTML to point to the same hostname. This also makes
	# sure requests for assets stored locally come from DuckPAN cache so they aren't
	# requested from DuckDuckGo again. Then we push this new copy of the file into
	# the DuckPAN cache.

	for my $file_name (keys %assets) {
		
		# copy all files in /share (dist_dir) into cache, unless they already exist
		copy(file(dist_dir('App-DuckPAN'),$file_name),file($self->app->cfg->cache_path,$file_name)) unless -f file($self->app->cfg->cache_path,$file_name);

		next unless defined $assets{$file_name}{'file_path'};

		my $path = $assets{$file_name}{'file_path'};
		my $url = 'http://'.$self->hostname.''.$path;
		my $res = $self->app->http->request(HTTP::Request->new(GET => $url));

		if ($res->is_success){
			my $content = $res->decoded_content(charset => 'none');

			# Make sure we cache DDG js/css and only
			# request new copies when they exist
			if ($file_name eq "page_spice.html") {
				$self->get_assets($content);
			}

			# The following block writes the requested files into the cache.
			# Each file, depending on the type (js/css/html) first has all
			# links within the file modified by the appropriate function
			# ie. change_js, change_css, change_html which are explained below.

			if ($file_name =~ m/\.js$/){
				io(file($self->app->cfg->cache_path,$file_name))->print($self->change_js($content));
			} elsif  ($file_name =~ m/\.css$/){
				io(file($self->app->cfg->cache_path,$file_name))->print($self->change_css($content));
			} else {
				io(file($self->app->cfg->cache_path,$file_name))->print($self->change_html($content));
			}

		} else {
			print "\n".$assets{$file_name}{'name'}." fetching failed, will just use cached version...";
		}
	}

	# Pull file out of cache to be served later by DuckPAN
	my $page_root = io(file($self->app->cfg->cache_path,'page_root.html'))->slurp;
	my $page_spice = io(file($self->app->cfg->cache_path,'page_spice.html'))->slurp;
	my $page_css = io(file($self->app->cfg->cache_path,$self->page_css_filename))->slurp;

	# Concatenate all JS files
	# Order matters because of JS dependencies 
	# DDG JS -> Handlebars -> jQuery & Spice.js -> Duckpan.js
	my $page_js = io(file($self->app->cfg->cache_path,$self->page_js_filename))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'handlebars.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,$self->spice_js_filename))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'duckpan.js'))->slurp;

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
		server_hostname => $self->hostname,
	);
	my $runner = Plack::Runner->new(
		#loader => 'Restarter',
		includes => ['lib'],
		app => sub { $web->run_psgi(@_) },
	);
	#$runner->loader->watch("./lib");
	exit $runner->run;
}

# Force DuckPAN to ignore requests for certain files
# that are not needed (ie. d.js, s.js, post.html)
sub change_js {
	my ( $self, $js ) = @_;
	$js =~ s!/([ds])\.js\?!/?duckduckhack_ignore=1&!g;
	$js =~ s!/post\.html!/?duckduckhack_ignore=1&!g;
	return $self->change_css($js);
}

# Rewrite all relative asset links in CSS
# E.g url("/assets/background.png") => url("http://duckduckgo.com/assets")
sub change_css {
	my ( $self, $css ) = @_;
	$css =~ s!url\(("?)!url\($1http://$self->hostname/!g;
	return $css;
}

sub change_html {
	my ( $self, $html ) = @_;

	my $root = HTML::TreeBuilder->new;
	$root->parse($html);

	my @a = $root->look_down(
		"_tag", "a"
	);

	my @link = $root->look_down(
		"_tag", "link"
	);

	# Make sure DuckPAN serves DDG CSS (already pulled down at startup)
	# ie <link href="/s123.css"> becomes <link href="/?duckduckhack_css=1">
	# Also rewrite relative links to hostname
	for (@a,@link) {
		if ($_->attr('type') && $_->attr('type') eq 'text/css') {
			$_->attr('href','/?duckduckhack_css=1');
		} elsif (substr($_->attr('href'),0,1) eq '/') {
			$_->attr('href','http://'.$self->hostname.''.$_->attr('href'));
		}
	}

	my @script = $root->look_down(
		"_tag", "script"
	);


	# Make sure DuckPAN serves DDG JS (already pulled down at startup)
	# ie <link href="/d123.js"> becomes <link href="/?duckduckhack_js=1">
	# Also rewrite relative links to hostname
	for (@script) {
		if (my $src = $_->attr('src')) {
			if ($src =~ m/^\/d\d+\.js/) {
				$_->attr('src','/?duckduckhack_js=1');
			} elsif (substr($src,0,1) eq '/') {
				$_->attr('src','http://'.$self->hostname.''.$_->attr('src'));
			}
		}
	}

	my @img = $root->look_down(
		"_tag", "img"
	);

	# Rewrite img links to be requested from hostname
	for (@img) {
		if ($_->attr('src')) {
			$_->attr('src','http://'.$self->hostname.''.$_->attr('src'));
		}
	}

	my $newhtml = $root->as_HTML;

	return $self->change_js($self->change_css($newhtml));
}

# This is where we cache and check for newer versions
# of DDG JS and CSS by paring the HTML requested from
# DuckDuckGo. If new files exits, we grab them, rewrite
# any links and store them in the cache. Otherwise we 
# serve the current versions from the cache.

sub get_assets {
	my ($self, $html ) = @_;
	
	my $root = HTML::TreeBuilder->new;
	$root->parse($html);

	my @script = $root->look_down(
		"_tag", "script"
	);

	my @link = $root->look_down(
		"_tag", "link"
	);

	# Find version no. for d.js and spice2.js
	for (@script) {
		if (my $src = $_->attr('src')) {
			if ($src =~ m/^\/(d\d+\.js)/) {
				$self->page_js_filename($1);
			} elsif ($src =~ m/^\/spice2\/(spice2_duckpan_(?:\d+|dev)\.js)/) {
				$self->spice_js_filename($1);
			}
		}
	}

	# Find version no. for s.css
	for (@link) {
		if ($_->attr('type') && $_->attr('type') eq 'text/css') {
			if (my $href = $_->attr('href')) {
				if ($href =~ m/^\/(s\d+\.css)/) {
					$self->page_css_filename($1);
				}
			}
		}
	}

	# Check if we need to request any new assets from hostname, otherwise use cached copies
	for my $curr_asset ($self->page_js_filename, $self->page_css_filename, $self->spice_js_filename) {
		my $curr_asset_path = $curr_asset =~ qr/spice2/ ? "/spice2/".$curr_asset : "/".$curr_asset;

		unless (-f file($self->app->cfg->cache_path,$curr_asset)) {
			my $path = $curr_asset_path;
			my $url = 'http://'.$self->hostname.''.$curr_asset_path;
			my $res = $self->app->http->request(HTTP::Request->new(GET => $url));

			if ($res->is_success) {
				my $content = $res->decoded_content(charset => 'none');

				if ($curr_asset =~ m/\.js$/){
					io(file($self->app->cfg->cache_path,$curr_asset))->print($self->change_js($content));
				} elsif  ($curr_asset =~ m/\.css$/){
					io(file($self->app->cfg->cache_path,$curr_asset))->print($self->change_css($content));
				} else {
					io(file($self->app->cfg->cache_path,$curr_asset))->print($self->change_html($content));
				}

			} else {
				print "\n".$curr_asset." fetching failed, will just use cached version...";
			}
		}
	}
}

1;
