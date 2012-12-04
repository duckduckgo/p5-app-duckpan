package App::DuckPAN::Web;

use Moo;
use DDG::Request;
use DDG::Test::Location;
use DDG::Test::Language;
use Plack::Request;
use Plack::Response;
use HTML::Entities;
use HTML::TreeBuilder;
use HTML::Element;
use Data::Printer;
use IO::All -utf8;
use HTTP::Request;
use LWP::UserAgent;
use URI::Escape;
use Data::Dumper;

has blocks => ( is => 'ro', required => 1 );
has page_root => ( is => 'ro', required => 1 );
has page_spice => ( is => 'ro', required => 1 );
has page_css => ( is => 'ro', required => 1 );
has page_js => ( is => 'ro', required => 1 );

has _share_dir_hash => ( is => 'rw' );
has _path_hash => ( is => 'rw' );
has _rewrite_hash => ( is => 'rw' );

has ua => (
	is => 'ro',
	default => sub {
		LWP::UserAgent->new(
			agent => "Mozilla/5.0", #User Agent required for some API's (eg. Vimeo, IsItUp)
			timeout => 5,
			ssl_opts => { verify_hostname => 0 },
		);
	},
);

sub BUILD {
	my ( $self ) = @_;
	my %share_dir_hash;
	my %path_hash;
	my %rewrite_hash;
	for (@{$self->blocks}) {
		for (@{$_->only_plugin_objs}) {
			if ($_->does('DDG::IsSpice')) {
				$rewrite_hash{ref $_} = $_->rewrite if $_->has_rewrite;
				$share_dir_hash{$_->module_share_dir} = ref $_ if $_->can('module_share_dir');
				$path_hash{$_->path} = ref $_ if $_->can('path');
			}
		}
	}
	$self->_share_dir_hash(\%share_dir_hash);
	$self->_path_hash(\%path_hash);
	$self->_rewrite_hash(\%rewrite_hash);
}

sub run_psgi {
	my ( $self, $env ) = @_;
	my $request = Plack::Request->new($env);
	my $response = $self->request($request);
	return $response->finalize;
}

sub request {
	my ( $self, $request ) = @_;
	my @path_parts = split(/\/+/,$request->request_uri);
	shift @path_parts;
	my $response = Plack::Response->new(200);
	my $body;
	if (@path_parts && $path_parts[0] eq 'share') {
		my $filename = pop @path_parts;
		my $share_dir = join('/',@path_parts);
		my $filename_path = $self->_share_dir_hash->{$share_dir}->can('share')->($filename);
		$body = -f $filename_path ? io($filename_path)->slurp : "";
	} elsif (@path_parts && $path_parts[0] eq 'js') {
		for (keys %{$self->_path_hash}) {
			if ($request->request_uri =~ m/^$_/g) {
				my $path_remainder = $request->request_uri;
				$path_remainder =~ s/^$_//;
				$path_remainder =~ s/\/+/\//g;
				$path_remainder =~ s/^\///;
				my $spice_class = $self->_path_hash->{$_};
				my $rewrite = $self->_rewrite_hash->{$spice_class};
				die "Spice tested here must have a rewrite..." unless $rewrite;
				my $from = $rewrite->from;
				my $re = $rewrite->has_from ? qr{$from} : qr{(.*)};
				if (my @captures = $path_remainder =~ m/$re/) {
					my $to = $rewrite->parsed_to;
					for (1..@captures) {
						my $index = $_-1;
						my $cap_from = '\$'.$_;
						my $cap_to = $captures[$index];
						if (defined $cap_to) {
							$to =~ s/$cap_from/$cap_to/g;
						} else {
							$to =~ s/$cap_from//g;
						}
					}
					p($to);
					my $res = $self->ua->request(HTTP::Request->new(GET => $to));
					if ($res->is_success) {
						$body = $res->decoded_content;
                        warn "Cannot use wrap_jsonp_callback and wrap_string callback at the same time!" if $rewrite->wrap_jsonp_callback && $rewrite->wrap_string_callback;
						if ($rewrite->wrap_jsonp_callback && $rewrite->callback) {
							$body = $rewrite->callback.'('.$body.');';
						}
						elsif ($rewrite->wrap_string_callback && $rewrite->callback) {
                            $body =~ s/"/\\"/g;
                            $body =~ s/\n/\\n/g;
							$body = $rewrite->callback.'("'.$body.'");';
						}
						$response->code($res->code);
						$response->content_type($res->content_type);
					} else {
					    warn $res->status_line, "\n";
					    $body = "";
					}
				}
			}
		}
	} elsif ($request->param('duckduckhack_ignore')) {
		$body = "";
	} elsif ($request->param('duckduckhack_css')) {
		$response->content_type('text/css');
		$body = $self->page_css;
	} elsif ($request->param('duckduckhack_js')) {
		$response->content_type('text/javascript');
		$body = $self->page_js;
	} elsif ($request->param('q')) {
		my $query = $request->param('q');
		Encode::_utf8_on($query);
		my $ddg_request = DDG::Request->new(
			query_raw => $query,
			location => test_location_by_env(),
			language => test_language_by_env(),
		);
		my $result;
		for (@{$self->blocks}) {
			($result) = $_->request($ddg_request);
			last if $result;
		}
		my $page = $self->page_spice;
		my $uri_encoded_query = uri_escape_utf8($query, "^A-Za-z");
		my $html_encoded_query = encode_entities($query);
		my $uri_encoded_ddh = quotemeta(uri_escape('duckduckhack-template-for-spice', "^A-Za-z"));
		$page =~ s/duckduckhack-template-for-spice/$html_encoded_query/g;
		$page =~ s/$uri_encoded_ddh/$uri_encoded_query/g;

		p($result) if $result;

		if (ref $result eq 'DDG::ZeroClickInfo::Spice') {
            my $call_extf = $result->caller->module_share_dir.'/spice.js';
            my $call_extc = $result->caller->module_share_dir.'/spice.css';
            my $call_ext = $result->call_path;
            $page =~ s/####DUCKDUCKHACK-CALL-EXT####/$call_ext/g;
            $page =~ s/####DUCKDUCKHACK-CALL-EXTC####/$call_extc/g;
			$page =~ s/####DUCKDUCKHACK-CALL-EXTF####/$call_extf/g;
		} else {
			my $root = HTML::TreeBuilder->new;
			if ($result) {
				$root->parse($page);
				my $content = $root->look_down(
					"id", "bottom_spacing2"
				);
				my $dump = HTML::Element->new('pre');
				$dump->push_content(Dumper $result);
				$content->insert_element($dump);
				$page = $root->as_HTML;
			} else {
				$root->parse($self->page_root);
				my $text_field = $root->look_down(
					"name", "q"
				);
				$text_field->attr( value => $query );
				$page = $root->as_HTML;
				$page =~ s/<\/body>/<script type="text\/javascript">seterr('Sorry, no hit for your plugins')<\/script><\/body>/;
			}
		}
		$response->content_type('text/html');
		$body = $page;
    } elsif ($request->param('u') && $path_parts[0] eq 'iu') {
        my $res = $self->ua->request(HTTP::Request->new(GET => "http://duckduckgo.com".$request->request_uri));
        if ($res->is_success) {
            $body = $res->decoded_content;
            $response->code($res->code);
            $response->content_type($res->content_type);
        } else {
            warn $res->status_line, "\n";
            $body = "";
        }
	} else {
		$response->content_type('text/html');
		$body = $self->page_root;
	}
	Encode::_utf8_off($body);
	$response->body($body);
	return $response;
}

1;
