package App::DuckPAN::Cmd::Server;
# ABSTRACT: Starting up the web server to test instant answers

use Moo;
with qw( App::DuckPAN::Cmd App::DuckPAN::Restart );

use MooX::Options protect_argv => 0;
use Plack::Runner;
use File::ShareDir::ProjectDistDir;
use File::Copy;
use Path::Tiny;
use LWP::Simple;
use HTML::TreeBuilder;
use Config::INI;
use Term::ProgressBar;

option port => (
    is => 'ro',
    format => 'i',
    lazy => 1,
    short => 'p',
    default => sub { 5000 },
    doc  => 'set port on which server should listen. defaults to 5000',
);


has page_info => (
    is      => 'ro',
    builder => '_build_page_info',
    lazy=> 1,
);

sub _build_page_info {
    my $self       = shift;
    my $cache_path = $self->asset_cache_path;

    return +{
        js        => [],
        locales   => [],
        css       => [],
        templates => [{
                name     => 'Template Compiling JS',
                internal => $cache_path->child('template_compiler.js'),
                # stored locally, no need to make web request for this
                external => undef,
                desc     => 'Small script DuckPAN runs on SERP load; compiles Spice IA templates',
            },
        ],
        root => [{
                name     => 'DDG Homepage',
                internal => $cache_path->child('page_root.html'),
                external => '/',
                desc     => 'used for error page when no instant answers trigger',
            },
        ],
        spice => [{
                name            => 'DDG SERP',
                internal        => $cache_path->child('page_spice.html'),
                external        => '/?q=duckduckhack-template-for-spice2',
                load_sub_assets => 1,
                desc            => 'this is the page we inject Spice and Goodie results into',
            },
        ],
    };
}

has hostname => (
    is => 'ro',
    builder => '_build_hostname',
    lazy => 1,
);

sub _build_hostname {
    my ( $self ) = @_;
    return $self->app->server_hostname;
}

has asset_cache_path => (
    is      => 'ro',
    builder => 1,
    lazy    => 1,
);

sub _build_asset_cache_path {
    my $self       = shift;

    my $asset_path = $self->app->cfg->cache_path->child($self->hostname);
    $asset_path->mkpath unless $asset_path->exists;

    return $asset_path;
}

# Entry point into app
sub run {
    my ($self, @args) = @_;

    $self->run_restarter(\@args);
}

# Starts the Plack server on the designated port.  Will be launched in a child
# process since it blocks. Will be killed by user ctrl-c or parent explicitly
# kill'ing it.
sub _run_app {
    my ($self, $args) = @_;

    my $cache_path = $self->app->cfg->cache_path;

    $self->app->check_requirements; # Ensure eveything is up do date, or exit.

    my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@$args)};

    $self->app->emit_debug("Hostname is: https://" . $self->hostname);
    $self->app->emit_info("Checking asset cache...");

    foreach my $asset (map { @{$self->page_info->{$_}} } (qw(root spice templates))) {
        if (defined $asset->{external}) {
            $self->retrieve_and_cache($asset);
        } else {
            # Files without external sources should be copied from the distribution.
            my $to_file = $asset->{internal};
            my $from_file = path(dist_dir('App-DuckPAN'), $to_file->basename);
            $from_file->copy($to_file) if ($from_file->exists && !$to_file->exists);
        }
    }

    # Pull files out of cache to be served later by DuckPAN server
    my %web_args = (
        blocks          => \@blocks,
        server_hostname => $self->hostname,
    );
    foreach my $page (keys %{$self->page_info}) {
        $web_args{'page_' . $page} = $self->slurp_or_empty($self->page_info->{$page});
    }

    $self->app->emit_info("Starting up webserver...", "You can stop the webserver with Ctrl-C");

    require App::DuckPAN::Web;

    my $web    = App::DuckPAN::Web->new(%web_args);
    my $runner = Plack::Runner->new(
        #loader => 'Restarter',
        includes => ['lib'],
        app      => sub { $web->run_psgi(@_) },
    );
    #$runner->loader->watch("./lib");
    $runner->parse_options("--port", $self->port);
    exit $runner->run;
}

sub slurp_or_empty {
    my ($self, $which) = @_;
    my $cache_path = $self->asset_cache_path;
    my $contents = '';
    foreach my $which_file (grep { $_->{internal} } (@$which)) {
        my $where = $which_file->{internal};
        my $change_method = ($where =~ m/\.js$/) ? 'change_js' : ($where =~ m/\.css$/) ? 'change_css' : 'change_html';

        $contents .= $self->make_source_comment($which_file) . $self->$change_method($where->slurp) if ($where->exists);
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

    my $has_ddh = 0;
    for (@script) {
        if (my $src = $_->attr('src')) {
            next if ($src =~ m/^\/\?duckduckhack_/); # Already updated, no need to do again
            if ($src =~ m/^\/(dpan\d+|duckpan)\.js/) {
                if ($has_ddh){
                    $_->attr('src','/?duckduckhack_ignore=1');
                } else {
                    $_->attr('src','/?duckduckhack_js=1');
                    $has_ddh = 1;
                }
            } elsif ($src =~ m/^\/(g\d+|serp)\.js/) {
                $_->attr('src','/?duckduckhack_templates=1');
            } elsif ($src =~ m/^\/(d\d+|base)\.js/) {

                # If dpan.js is not present (ie. homepage)
                # make sure we serve the js rather than blocking
                # the call to d.js
                if ($has_ddh){
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
    my ($self, $from) = @_;

    my $html = $from->{internal}->slurp;
    my $root = HTML::TreeBuilder->new;
    $root->parse($html);

    my @script = $root->look_down(
        "_tag", "script"
    );

    my @link = $root->look_down(
        "_tag", "link"
    );

    my $cache_path = $self->asset_cache_path;

    # Find version no. for d.js and g.js
    for (@script) {
        if (my $src = $_->attr('src')) {
            if ($src =~ m/^\/((?:dpan\d+|duckpan)\.js)/) {
                unshift @{$self->page_info->{js}},
                  {
                    name     => 'Main JS',
                    internal => $cache_path->child($1),
                    external => $1
                  };
            } elsif ($src =~ m/^\/((?:g\d+|serp)\.js)/) {
                unshift @{$self->page_info->{templates}},
                  {
                    name     => 'Templating JS',
                    internal => $cache_path->child($1),
                    external => $1
                  };
            } elsif ($src =~ m/^\/(locales(?:.*)\.js)/) {
                my $long_path  = $1;
                my $cache_name = $long_path;
                $cache_name =~ s#^.+(\.\d+\.\d+\.js)#locales$1#g;    # Turn long path into cacheable name
                unshift @{$self->page_info->{locales}},
                  {
                    name     => 'Locales JS',
                    internal => $cache_path->child($cache_name),
                    external => $long_path
                  };
            }
        }
    }

    for (grep { $_->attr('type') && $_->attr('type') eq 'text/css' } @link) {
        if (my $href = $_->attr('href')) {
            # We're looking for txxx.css and sxxx.css.
            # style.css and static.css are for development mode.
            if ($href =~ m/^\/((?:[st]\d+|style|static)\.css)/) {
                my $name = $1;
                unshift @{$self->page_info->{css}},
                  {
                    name     => $name . ' CSS',
                    internal => $cache_path->child($name),
                    external => $name
                  };
            }
        }
    }

    # Check if we need to request any new assets from hostname, otherwise use cached copies
    foreach my $curr_asset (grep { defined $_ && $_->{internal} } map { @{$self->page_info->{$_}} } (qw(js templates css locales))) {
        $self->retrieve_and_cache($curr_asset, $from);
    }
}

sub retrieve_and_cache {
    my ($self, $asset, $sub_of) = @_;

    return unless ($asset->{internal} && $asset->{external});

    my $to_file    = $asset->{internal};
    my $path_start = (substr($asset->{external}, 0, 1) eq '/') ? '' : '/';
    my $url        = 'https://' . $self->hostname . $path_start . $asset->{external};
    my $prefix     = ($sub_of) ? '[via ' . $sub_of->{name} . '] ' : '';
    $prefix .= '[' . $asset->{name} . '] ';
    if ($to_file->exists && (time - $to_file->stat->ctime) < $self->app->cachesec) {
        $self->app->emit_debug($prefix . $to_file->basename . " recently cached -- no request made.");
    } else {
        $self->app->emit_debug($prefix . 'requesting from: ' . $url . '...');
        $to_file->remove;
        $to_file->touchpath;
        my ($expected_length, $bytes_received, $progress);
        my $next_update = 0;
        my $res         = $self->app->http->request(
            HTTP::Request->new(GET => $url),
            sub {
                my ($chunk, $res) = @_;
                $bytes_received += length($chunk);
                $to_file->append($chunk);
                $expected_length //= $res->content_length || 0;
                return unless $self->app->verbose;    # Progress bar is just for verbose mode;
                if ($expected_length && !defined($progress)) {
                    $progress = Term::ProgressBar->new({
                        name   => $prefix,
                        count  => $expected_length,
                        remove => 1,
                        ETA    => 'linear',
                        fh     => \*STDOUT,
                    });
                    $progress->minor(0);
                } elsif ($progress && $bytes_received > $next_update) {
                    $next_update = $progress->update($bytes_received);
                }
            });
        if (!$res->is_success) {
            $self->app->emit_and_exit(-1, qq~$prefix request failed with response: ~ . $res->status_line . "\n");
        } elsif ($expected_length && $bytes_received < $expected_length) {
            $to_file->remove;
            $self->app->emit_and_exit(-1, qq~$prefix only $bytes_received of $expected_length bytes received~);
        } else {
            $progress->update($expected_length) if ($progress && $expected_length);
            $self->app->emit_debug($prefix . 'written to cache: ' . $to_file);
        }
    }
    # We need to load the assets on the SERPs for reuse.
    if ($asset->{load_sub_assets}) {
        $self->app->emit_debug($prefix . 'parsing for additional assets');
        $self->get_sub_assets($asset);
        $self->app->emit_debug($prefix . 'assets loaded');
    }

    return;
}

1;
