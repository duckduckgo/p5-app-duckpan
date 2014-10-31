package App::DuckPAN::Cmd::Server;
# ABSTRACT: Starting up the web server to test instant answers

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;
use Plack::Runner;
use File::ShareDir::ProjectDistDir;
use File::Copy;
use Path::Tiny;
use LWP::Simple;
use HTML::TreeBuilder;
use Config::INI;
use Data::Printer;
use Data::Dumper;

option force => (
    is => 'ro',
    lazy => 1,
    short => 'f',
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

has page_js => (
    is      => 'ro',
    default => sub { [] },
);

has page_locales => (
    is      => 'ro',
    default => sub { [] },
);

has page_css => (
    is      => 'ro',
    default => sub { [] },
);

has page_templates => (
    is      => 'ro',
    default => sub {
        [{
                name     => 'DuckPAN JS',
                internal => 'duckpan.js',
                external => undef,
            },
        ];
    });

# page_root.html  : DDG Homepage
#                   - used for error page when no instant answers trigger
has page_root => (
    is      => 'ro',
    default => sub {
        [{
                name     => 'DuckDuckGo Landing Page',
                internal => 'page_root.html',
                external => '/'
            },
        ];
    },
);

# page_spice.html : DDG SERP
#                   - this is the page we inject Spice and Goodie results into
has page_spice => (
    is      => 'ro',
    default => sub {
        [{
                name            => 'DuckDuckGo SERP',
                internal        => 'page_spice.html',
                external        => '/?q=duckduckhack-template-for-spice2',
                load_sub_assets => 1,
            },
        ];
    },
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

    # Ensure eveything is up do date, or exit.
    $self->app->verify_versions;
    my $cache_path = $self->app->cfg->cache_path;


    my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

    print "\n\nHostname is: http://".$self->hostname if $self->verbose;
    print "\n\nChecking for newest assets from: http://".$self->hostname."\n";
    print "\n[CACHE DISABLED]. Forcing request for all assets...\n\n" if $self->verbose && $self->force;

    # First we bootstrap the cache, copying all files from /share (dist_dir) into the
    # cache. Then we get each file from given hostname (usually DuckDuckGo.com) and
    # rewrite all links in the HTML to point to the same hostname. This also makes
    # sure requests for assets stored locally come from DuckPAN cache so they aren't
    # requested from DuckDuckGo again. Then we push this new copy of the file into
    # the DuckPAN cache.

    foreach my $asset (@{$self->page_root}, @{$self->page_spice}) {
        my $file_name = $asset->{internal};
        my $from_file = path(dist_dir('App-DuckPAN'), $file_name);
        my $to_file   = $cache_path->child($file_name);
        # copy all files in /share (dist_dir) into cache, unless they already exist
        if ($from_file->exists){
            $from_file->copy($to_file) unless ($to_file->exists);
        }

        $self->retrieve_and_cache($asset);
    }

    # Pull files out of cache to be served later by DuckPAN server
    my %web_args = (
        blocks          => \@blocks,
        server_hostname => $self->hostname,
    );
    foreach my $key_name (map { 'page_' . $_ } (qw(css js locales templates root spice))) {
        $web_args{$key_name} = $self->slurp_or_empty($self->$key_name);
    }

    print "\n\nStarting up webserver...";
    print "\n\nYou can stop the webserver with Ctrl-C";
    print "\n\n";

    require App::DuckPAN::Web;

    my $web = App::DuckPAN::Web->new(%web_args);
    my $runner = Plack::Runner->new(
        #loader => 'Restarter',
        includes => ['lib'],
        app => sub { $web->run_psgi(@_) },
    );
    #$runner->loader->watch("./lib");
    $runner->parse_options("--port", $self->port);
    exit $runner->run;
}

sub slurp_or_empty {
    my ($self, $which) = @_;
    my $cache_path = path($self->app->cfg->cache_path);

    my $contents = '';
    foreach my $which_file (grep { $_->{internal} } (@$which)) {
        my $where = $cache_path->child($which_file->{internal});
        $contents .= $self->make_source_comment($which_file) . $where->slurp if ($where->exists);
    }

    return $contents;
}

sub make_source_comment {
    my ($self, $file_info) = @_;

    my $comment  = '';
    my $internal = $file_info->{internal};
    my $title    = $file_info->{name} || $internal;
    if ($internal =~ /js$/) {
        $comment = '// ' . $title;
    } elsif ($internal =~ /css$/) {
        $comment = '/* ' . $title . '*/';
    } elsif ($internal =~ /html$/) {
        $comment = '<!-- ' . $title . ' -->';
    }

    return "\n$comment\n";    # Just two blank lines if we don't know how to comment for the file type.
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
            next if ($src =~ m/^\/\?duckduckhack_/); # Already updated, no need to do again
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
            } elsif ($src =~ /locales/) {
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

sub get_sub_assets {
    my ($self, $from, $html) = @_;

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
                unshift @{$self->page_js}, {name => 'Main JS', internal => $1, external=> $1};
            } elsif ($src =~ m/^\/((?:g\d+|duckgo_dev)\.js)/) {
                unshift @{$self->page_templates}, { name => 'Templating JS', internal => $1, external => $1 };
            } elsif ($src =~ m/^\/(locales(?:.*)\.js)/) {
                my $long_path = $1;
                my $cache_name = $long_path;
                $cache_name =~ s#^.+(\.\d+\.\d+\.js)#locales$1#g;  # Turn long path into cacheable name
                unshift @{$self->page_locales}, {name => 'Locales JS', internal => $cache_name, external => $long_path};
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
                    my $name = $1;
                    unshift @{$self->page_css}, {name => $name.' CSS',internal =>  $name, external => $name};
                }
            }
        }
    }

    if ($self->force) {
        print "\nCache disabled; Forcing request for every asset.\n";
    }
    # Check if we need to request any new assets from hostname, otherwise use cached copies
    foreach my $curr_asset (grep { defined $_ && $_->{internal} } (@{$self->page_js}, @{$self->page_templates}, @{$self->page_css}, @{$self->page_locales})) {
        my $file_name = $curr_asset->{internal};
        if (path($self->app->cfg->cache_path, $file_name)->exists) {
            print "\n$file_name already exists in cache -- no request made.\n" if $self->verbose;
        } else {
            $self->retrieve_and_cache($curr_asset, $from);
        }
    }
}

sub retrieve_and_cache {
    my ($self, $asset, $sub_of) = @_;

    return unless ($asset->{internal} && $asset->{external});

    my $file_name  = $asset->{internal};
    my $path_start = (substr($asset->{external}, 0, 1) eq '/') ? '' : '/';
    my $url        = 'http://' . $self->hostname . $path_start . $asset->{external};
    my $prefix     = ($sub_of) ? '  [via ' . $sub_of->{name} . '] ' : '';
    $prefix .= '[' . $asset->{name} . '] ';

    print "\n" . $prefix . "requesting from: $url..." if ($self->verbose);

    my $res = $self->app->http->request(HTTP::Request->new(GET => $url));

    if ($res->is_success) {
        print "success!\n" if $self->verbose;
        my $content = $res->decoded_content(charset => 'none');

        # We need to load the assets on the SERPs for reuse.
        if ($asset->{load_sub_assets}) {
            print $prefix. "parsing for additional assets\n" if $self->verbose;
            $self->get_sub_assets($asset, $content) if ($asset->{load_sub_assets});
            print $prefix. "assets loaded\n" if $self->verbose;
        }

        # Choose a method for rewriting internal connections.
        my $change_method = ($file_name =~ m/\.js$/) ? 'change_js' : ($file_name =~ m/\.css$/) ? 'change_css' : 'change_html';
        # Put rewriten file into our cache.
        my $where = path($self->app->cfg->cache_path, $file_name);
        $where->spew($self->$change_method($content));
        print $prefix. "written to cache: $where\n" if $self->verbose;
    } else {
        print "failed!\n" if $self->verbose;
        die qq~$prefix [FATAL ERROR] request failed with response: ~ . $res->status_line . "\n";
    }

    return;
}

1;
