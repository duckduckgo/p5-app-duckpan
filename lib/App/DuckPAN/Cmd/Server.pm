package App::DuckPAN::Cmd::Server;
# ABSTRACT: Starting up the web server to test instant answers

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;
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

option no_cache => (
    is => 'ro',
    lazy => 1,
    default => sub { 0 }
);

option verbose => (
    is => 'ro',
    lazy => 1,
    short => 'v',
    default => sub { 0 }
);

option port => (
    is => 'ro',
    format => 'i',
    lazy => 1,
    short => 'p',
    default => sub { 5000 }
);

has page_js_filename => (
    is => 'rw',
);

has page_templates_filename => (
    is => 'rw',
);

has page_locales_filename => (
    is => 'rw',
);

# We set this into an array because there can be multiple
# CSS files in the page.
has page_css_filenames => (
    is => 'rw',
    default => sub { [] },
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

    # Check if newer version of App::Duckpan or DDG exists
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
    #                     - this is the page we inject Spice and Goodie results into
    #
    # duckpan.js      : Small script DuckPAN runs on SERP load
    #                   - used to compile Spice templates
    #                   - stored locally, no need to make web request for this

    my %assets = (
        'page_root.html'            => { name => 'DuckDuckGo Landing Page', file_path => '/' },
        'page_spice.html'           => { name => 'DuckDuckGo SERP', file_path => '/?q=duckduckhack-template-for-spice2' },
        'duckpan.js'                => { } # no name/path required; always pulled from the cache
    );

    my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

    print "\n\nHostname is: http://".$self->hostname if $self->verbose;
    print "\n\nChecking for newest assets from: http://".$self->hostname."\n";
    print "\n[CACHE DISABLED]. Forcing request for all assets...\n\n" if $self->verbose && $self->no_cache;

    # First we bootstrap the cache, copying all files from /share (dist_dir) into the
    # cache. Then we get each file from given hostname (usually DuckDuckGo.com) and
    # rewrite all links in the HTML to point to the same hostname. This also makes
    # sure requests for assets stored locally come from DuckPAN cache so they aren't
    # requested from DuckDuckGo again. Then we push this new copy of the file into
    # the DuckPAN cache.

    for my $file_name (keys %assets) {

        # copy all files in /share (dist_dir) into cache, unless they already exist
        unless (-f file($self->app->cfg->cache_path,$file_name)) {
            copy(file(dist_dir('App-DuckPAN'),$file_name),file($self->app->cfg->cache_path,$file_name));
        }

        next unless defined $assets{$file_name}{'file_path'};

        my $path = $assets{$file_name}{'file_path'};
        my $url = 'http://'.$self->hostname.''.$path;
        $self->retrieve_and_cache($url, $file_name, 1);
    }

    # Pull files out of cache to be served later by DuckPAN server
    my $page_root = io(file($self->app->cfg->cache_path,'page_root.html'))->slurp;
    my $page_spice = io(file($self->app->cfg->cache_path,'page_spice.html'))->slurp;
    
    # Since there are multiple CSS files to slurp in,
    # we iterate through each one.
    my $page_css = join('', map { 
        io(file($self->app->cfg->cache_path, $_))->slurp;
    } @{$self->page_css_filenames});
    my $page_js = io(file($self->app->cfg->cache_path,$self->page_js_filename))->slurp;
    my $page_locales = io(file($self->app->cfg->cache_path,$self->page_locales_filename))->slurp;
    # Concatenate duckpan.js to g.js
    # This way duckpan.js runs after all dependencies are loaded
    my $page_templates = io(file($self->app->cfg->cache_path,$self->page_templates_filename))->slurp;
    $page_templates .= "\n//duckpan.js\n";
    $page_templates .= io(file($self->app->cfg->cache_path,'duckpan.js'))->slurp;

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
        page_locales => $page_locales,
        page_templates => $page_templates,
        server_hostname => $self->hostname,
    );
    my $runner = Plack::Runner->new(
        #loader => 'Restarter',
        includes => ['lib'],
        app => sub { $web->run_psgi(@_) },
    );
    #$runner->loader->watch("./lib");
    $runner->parse_options("--port", $self->port);
    exit $runner->run;
}

# Force DuckPAN to ignore requests for certain files
# that are not needed (ie. d.js, s.js, g.js, post2.html)
sub change_js {
    my ( $self, $js ) = @_;
    $js =~ s!/([dsg]\d+?|duckduck|duckgo_dev)\.js\?!/?duckduckhack_ignore=1&!g;
    $js =~ s!/post2\.html!/?duckduckhack_ignore=1&!g;
    return $self->change_css($js);
}

# Rewrite all relative asset links in CSS
# E.g url("/assets/background.png") => url("http://duckduckgo.com/assets")
sub change_css {
    my ( $self, $css ) = @_;
    my $hostname = $self->hostname;
    $css =~ s!:\s*url\(("?)/?!:url\($1http://$hostname/!g;
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
    my $has_css = 0;
    for (@a, @link) {
        if ($_->attr('type') && $_->attr('type') eq 'text/css') {
            # We only want to load the CSS file once.
            # We only load it once because /?duckduckhack_css=1 already has all of the CSS
            # in a single page.
            unless($has_css) {
                $_->attr('href','/?duckduckhack_css=1');
                $has_css = 1;
            } else {
                $_->attr('href','/?duckduckhack_ignore=1');
            }
        } elsif (defined $_->attr('href') && substr($_->attr('href'),0,1) eq '/') {
            $_->attr('href','http://'.$self->hostname.''.$_->attr('href'));
        }
    }

    my @script = $root->look_down(
        "_tag", "script"
    );

    # Make sure DuckPAN serves DDG JS (already pulled down at startup)
    # ie <link href="/d123.js"> becomes <link href="/?duckduckhack_js=1">
    # Also rewrite relative links to hostname

    # Temp Fix: Force ignore of d.js & duckduck.
    # This logic needs to be improved!

    my $has_dpanjs = 0;
    for (@script) {
        if (my $src = $_->attr('src')) {

            if ($src =~ m/^\/(dpan\d+|duckpan_dev)\.js/) {
                $_->attr('src','/?duckduckhack_js=1');
                $has_dpanjs = 1;
            } elsif ($src =~ m/^\/(g\d+|duckgo_dev)\.js/) {
                $_->attr('src','/?duckduckhack_templates=1');
            } elsif ($src =~ m/^\/(d\d+|duckduck)\.js/) {

                # If dpan.js is not present (ie. homepage)
                # make sure we serve the js rather than blocking
                # the call to d.js
                if ($has_dpanjs){
                    $_->attr('src','/?duckduckhack_ignore=1');
                } else {
                    $_->attr('src','/?duckduckhack_js=1');
                }
            } elsif (substr($src,0,8) eq '/locales') {
                $_->attr('src','/?duckduckhack_locales=1');
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
# of DDG JS and CSS by parsing the HTML requested from
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

    # Find version no. for d.js and g.js
    for (@script) {
        if (my $src = $_->attr('src')) {
            if ($src =~ m/^\/((?:dpan\d+|duckpan_dev)\.js)/) {
                $self->page_js_filename($1);
            } elsif ($src =~ m/^\/((?:g\d+|duckgo_dev)\.js)/) {
                $self->page_templates_filename($1);
            } elsif ($src =~ m/^\/(locales(?:.*)\.js)/) {
                my $long_name = $1;
                $long_name =~ s#/#_#g;  # Turn long path into crazy-long filename
                $self->page_locales_filename($long_name);
            }
        }
    }

    # Find version no. for s.css
    for (@link) {
        if ($_->attr('type') && $_->attr('type') eq 'text/css') {
            if (my $href = $_->attr('href')) {
                # We're looking for txxx.css and sxxx.css.
                # style.css and static.css are for development mode.
                if ($href =~ m/^\/((?:[st]\d+|style|static)\.css)/) {
                    push(@{$self->page_css_filenames}, $1);
                }
            }
        }
    }

    if ($self->no_cache) {
        print "\nCaching turned off; assets will not be loaded.\n";
    } else {
        # Check if we need to request any new assets from hostname, otherwise use cached copies
        for my $curr_asset ($self->page_js_filename, $self->page_templates_filename, @{$self->page_css_filenames}, $self->page_locales_filename) {
            if (-f file($self->app->cfg->cache_path, $curr_asset)) {
                print "\n$curr_asset already exists in cache -- no request made.\n" if $self->verbose;
            } else {
                my $url = 'http://' . $self->hostname . '/' . $curr_asset;
                $self->retrieve_and_cache($url, $curr_asset, 0);
            }
        }
    }
}

sub retrieve_and_cache {
    my ($self, $url, $file_name, $recurse) = @_;
    # I don't think the recurse parameter is actually needed, but it maintains parity
    # with the previous code this way

    my $cache_path = $self->app->cfg->cache_path;
    if ($self->verbose) {
        print "\nCache path: " . $cache_path;
        print "\nRequesting: $url...";
    }
    my $res = $self->app->http->request(HTTP::Request->new(GET => $url));

    if ($res->is_success) {
        print "success!\n" if $self->verbose;
        my $content = $res->decoded_content(charset => 'none');

        # We need to load the assets on the SERPs for reuse.
        $self->get_assets($content) if ($recurse && $file_name eq "page_spice.html");

        # Choose a method for rewriting internal connections.
        my $change_method = ($file_name =~ m/\.js$/) ? 'change_js' : ($file_name =~ m/\.css$/) ? 'change_css' : 'change_html';
        # Put rewriten file into our cache.
        my $where = file($cache_path, $file_name);
        io($where)->print($self->$change_method($content));
        print "Wrote cache: \"$where\".\n\n" if $self->verbose;
    } else {
        print "failed!\n" if $self->verbose;
        die qq~[FATAL ERROR] Request for "$file_name" failed with response: ~ . $res->status_line . "\n";
    }

    return;
}

1;
