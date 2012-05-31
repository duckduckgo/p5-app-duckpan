package App::DuckPAN::Web;

use Moo;
use DDG::Request;
use Plack::Request;
use Plack::Response;
use HTML::Entities;
use HTML::TreeBuilder;
use Data::Printer;
use IO::All -utf8;
use HTTP::Request;
use LWP::UserAgent;
use URI::Escape;

has blocks => ( is => 'ro', required => 1 );
has page_root => ( is => 'ro', required => 1 );
has page_spice => ( is => 'ro', required => 1 );
has page_css => ( is => 'ro', required => 1 );
has page_js => ( is => 'ro', required => 1 );

has _share_dir_hash => ( is => 'rw' );
has _path_hash => ( is => 'rw' );

has ua => (
	is => 'ro',
	default => sub {
		LWP::UserAgent->new(
			timeout => 5,
			ssl_opts => { verify_hostname => 0 },
		);
	},
);

sub BUILD {
	my ( $self ) = @_;
	my %share_dir_hash;
	my %path_hash;
	for (@{$self->blocks}) {
		for (@{$_->only_plugin_objs}) {
			$share_dir_hash{$_->module_share_dir} = ref $_ if $_->can('module_share_dir');
			$path_hash{$_->path} = ref $_ if $_->can('path');
		}
	}
	$self->_share_dir_hash(\%share_dir_hash);
	$self->_path_hash(\%path_hash);
}

sub run_psgi {
	my ( $self, $env ) = @_;
	my $request = Plack::Request->new($env);
	my $response = $self->request($request);
	return $response->finalize;
}

sub request {
	my ( $self, $request ) = @_;
	my @path_parts = split('/',$request->request_uri);
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
				my $spice_class = $self->_path_hash->{$_};
				die "Spice tested here must have a rewrite..." unless $spice_class->has_rewrite;
				my $rewrite = $spice_class->rewrite;
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
						if ($rewrite->wrap_jsonp_callback && $rewrite->callback) {
							$body = $rewrite->callback.'('.$body.');';
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
		my $ddg_request = DDG::Request->new( query_raw => $query );
		my $result;
		for (@{$self->blocks}) {
			($result) = $_->request($ddg_request);
			last if $result;
		}
		my $page = $self->page_spice;
		my $uri_encoded_query = uri_escape($query, "^A-Za-z");
		my $uri_encoded_ddh = quotemeta(uri_escape('duckduckhack-template-for-spice', "^A-Za-z"));
		$page =~ s/duckduckhack-template-for-spice/$query/g;
		$page =~ s/$uri_encoded_ddh/$uri_encoded_query/g;

		if ($result) {
			p($result);
            my $call_extf = $result->caller->module_share_dir.'/spice.js';
            my $call_extc = $result->caller->module_share_dir.'/spice.css';
            my $call_ext = $result->call_path;
            $page =~ s/####DUCKDUCKHACK-CALL-EXT####/$call_ext/g;
            $page =~ s/####DUCKDUCKHACK-CALL-EXTC####/$call_extc/g;
			$page =~ s/####DUCKDUCKHACK-CALL-EXTF####/$call_extf/g;
		} else {
			my $root = HTML::TreeBuilder->new;
			$root->parse($self->page_root);
			# my $error_field = $root->look_down(
			# 	"id", "error_homepage"
			# );
			# $error_field->push_content("Sorry, no hit on your plugins");
			# $error_field->attr( id => "error_duckduckhack" );
			my $text_field = $root->look_down(
				"name", "q"
			);
			$text_field->attr( value => $query );
			$page = $root->as_HTML;
			$page =~ s/<\/body>/<script type="text\/javascript">seterr('Sorry, no hit for your plugins')<\/script><\/body>/;
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