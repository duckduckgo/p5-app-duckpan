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
use Data::Printer;
use Data::Dumper;

my ($page_js_filename, $page_css_filename, $spice_js_filename, $hostname);

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_app_duckpan;
	exit 1 unless $self->app->check_ddg;

	dir($self->app->cfg->cache_path)->mkpath unless -d $self->app->cfg->cache_path;

	my %assets = (
		'page_root.html'            => { name => 'DuckDuckGo Landing Page', file_path => '/' },
		'page_spice.html'           => { name => 'DuckDuckGo SERP', file_path => '/?q=duckduckhack-template-for-spice2' },
		'handlebars.js'             => { name => 'Handlebars.js', file_path => '/js/handlebars-1.0.0-rc.3.js' },
		'duckpan.js'                => { }
	);

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	$hostname = $self->app->server_hostname;
	print "\n\nTrying to fetch current versions of the HTML from http://$hostname/\n\n";

	for my $file_name (keys %assets) {

		copy(file(dist_dir('App-DuckPAN'),$file_name),file($self->app->cfg->cache_path,$file_name)) unless -f file($self->app->cfg->cache_path,$file_name);

		next unless defined $assets{$file_name}{'file_path'};

		my $path = $assets{$file_name}{'file_path'};
		my $url = 'http://'.$hostname.''.$path;
		my $res = $self->app->http->request(HTTP::Request->new(GET => $url));

		if ($res->is_success){

				my $content = $res->decoded_content(charset => 'none');

				if ($file_name eq "page_spice.html") {
					$self->get_assets($content);
				};

				if ($file_name =~ m/\.js$/){
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_js($content));
				} elsif  ($file_name =~ m/\.css$/){
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_css($content));
				} else {
					io(file($self->app->cfg->cache_path,$file_name))->print($self->change_html($content));
				}

		} else {
			#print $res->status_line, "\n";
			print "\n".$assets{$file_name}{'name'}." fetching failed, will just use cached version...";
		}
	}

	my $page_root = io(file($self->app->cfg->cache_path,'page_root.html'))->slurp;
	my $page_spice = io(file($self->app->cfg->cache_path,'page_spice.html'))->slurp;
	my $page_css = io(file($self->app->cfg->cache_path,$page_css_filename))->slurp;

	# Concatenate all JS files
	# Order matters because of dependencies
	my $page_js = io(file($self->app->cfg->cache_path,$page_js_filename))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'handlebars.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,$spice_js_filename))->slurp;
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
	$css =~ s!url\(("?)!url\($1http://$hostname/!g;
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
			if ($src =~ m/^\/d\d+\.js/) {
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

	for (@script) {
		if (my $src = $_->attr('src')) {
			if ($src =~ m/^\/(d\d+\.js)/) {
				$page_js_filename = $1;
			} elsif ($src =~ m/^\/spice2\/(spice2_duckpan_\d{3,4}\.js)/) {
				$spice_js_filename = $1;
			}
		}
	}

	for (@link) {
		if ($_->attr('type') && $_->attr('type') eq 'text/css') {
			if (my $href = $_->attr('href')) {
				if ($href =~ m/^\/(s\d+\.css)/) {
					$page_css_filename = $1;
				}
			}
		}
	}

	for my $curr_asset ($page_js_filename, $page_css_filename, $spice_js_filename) {
		my $curr_asset_path = $curr_asset =~ qr/spice2/ ? "/spice2/".$curr_asset : "/".$curr_asset;

		unless (-f file($self->app->cfg->cache_path,$curr_asset)) {
			my $path = $curr_asset_path;
			my $url = 'http://'.$hostname.''.$curr_asset_path;
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
