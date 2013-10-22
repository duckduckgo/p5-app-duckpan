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
use POSIX ();

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
		'duckpan.js'                => { name => 'Duckpan.js'},
	);

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	my $hostname = $self->app->server_hostname;
	print "\n\nChecking for updates of the HTML from http://$hostname/\n\n";

	foreach my $file_name (keys %spice_files){
        my $cache_file_path = file($self->app->cfg->cache_path, $file_name);
		copy(file(dist_dir('App-DuckPAN'), $file_name), $cache_file_path) unless -f $cache_file_path;
		next unless defined $spice_files{$file_name}{'file_path'};

        my $mtime = POSIX::strftime("%a, %d %b %Y %H:%M:%S", gmtime((stat($cache_file_path))[9])) . ' GMT';
		my $path = $spice_files{$file_name}{'file_path'};
		my $url = 'http://'.$hostname.''.$path;
        my $req = HTTP::Request->new(GET => $url);
        $req->header('If-Modified-Since' => $mtime);
		my $res = $self->app->http->request($req);

		if ($res->code eq '200'){
				my $content = $res->decoded_content(charset => 'none');
				if ($file_name =~ m/\.js$/){
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_js($content));
				} elsif  ($file_name =~ m/\.css$/){
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_css($content));
				} else {
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_html($content));
				}
		} elsif ($res->code ne '304') {
			print "$spice_files{$file_name}{'name'} fetching failed, will just use cached version...";
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
