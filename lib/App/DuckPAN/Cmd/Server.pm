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

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_ddg;

	dir($self->app->cfg->cache_path)->mkpath unless -d $self->app->cfg->cache_path;

	my %spice_files = (
		'page_root.html'         => { name => 'DuckDuckGo HTML', file_path => '/' },
		'page_spice.html'        => { name => 'DuckDuckGo Spice-Template', file_path => '/?q=duckduckhack-template-for-spice2' },
		'page.css'               => { name => 'DuckDuckGo CSS', file_path => '/style.css' },
		'duckduck.js'            => { name => 'DuckDuckGo Javascript', file_path => '/duckduck.js' },
		'jquery.js'              => { name => 'jQuery', file_path => '/js/jquery/jquery-1.8.2.min.js' },
		'handlebars.min.js'      => { name => 'Handlebars.js', file_path => '/js/handlebars.min.js' },
		'default.handlebars.js'  => { name => 'Default Spice2 Template', file_path => '/spice2/default.handlebars.js' },
		'spice2.js'              => { name => 'Spice2.js', file_path => '/spice2/spice2.js' },
		'carousel.handlebars.js' => { name => 'Default Spice2 Carousel Template', file_path => '/spice2/carousel.handlebars.js' },
		'carousel-in.js'         => { name => 'Default Carousel Javascript', file_path => '/spice2/carousel-in.js' },
		'spice2_duckpan.js'      => { name => 'Spice2 DuckPAN javascript', file_path => '/spice2/spice2_duckpan.js' }
	);

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	print "\n\nTrying to fetch current versions of the HTML from http://duckduckgo.com/\n\n";

	my $hostname = $self->app->server_hostname;
	my $temp;

	foreach (keys %spice_files){
		copy(file(dist_dir('App-DuckPAN'),$_),file($self->app->cfg->cache_path,$_)) unless -f file($self->app->cfg->cache_path,$_);

		if ($temp = get('http://'.$hostname.$spice_files{$_}{"file_path"})) {
			
			if ($_ =~ m/js/){
				io(file($self->app->cfg->cache_path,$_))->print($self->change_js($temp));
			} elsif  ($_ =~ m/css/){
				io(file($self->app->cfg->cache_path,$_))->print($self->change_css($temp));
			} else {
				io(file($self->app->cfg->cache_path,$_))->print($self->change_html($temp));
			}
		} else {
			print "\n". $spice_files{$_}{"name"} . " fetching failed, will just use cached version...";
		}
	}

	my $page_root = io(file($self->app->cfg->cache_path,'page_root.html'))->slurp;
	my $page_spice = io(file($self->app->cfg->cache_path,'page_spice.html'))->slurp;
	my $page_css = io(file($self->app->cfg->cache_path,'page.css'))->slurp;
	
	# Concatenate all JS files
	# Order matters because of dependencies
	my $page_js = io(file($self->app->cfg->cache_path,'duckduck.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'jquery.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'handlebars.min.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'default.handlebars.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'spice2.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'carousel.handlebars.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'carousel-in.js'))->slurp;
	$page_js .= io(file($self->app->cfg->cache_path,'spice2_duckpan.js'))->slurp;

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
			if ($src =~ m/^\/d\d{3}\.js/) {
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
