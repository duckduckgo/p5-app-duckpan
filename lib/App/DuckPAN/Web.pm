package App::DuckPAN::Web;
# ABSTRACT: Webserver for duckpan server

use Moo;
use DDG::Request;
use DDG::Test::Location;
use DDG::Test::Language;
use Plack::Request;
use Plack::Response;
use Plack::MIME;
use HTML::Entities;
use HTML::TreeBuilder;
use HTML::Element;
use Data::Printer;
use IO::All;
use HTTP::Request;
use LWP::UserAgent;
use URI::Escape;
use JSON;
use Data::Dumper;

has blocks => ( is => 'ro', required => 1 );
has page_root => ( is => 'ro', required => 1 );
has page_spice => ( is => 'ro', required => 1 );
has page_css => ( is => 'ro', required => 1 );
has page_js => ( is => 'ro', required => 1 );
has page_templates => ( is => 'ro', required => 1 );
has server_hostname => ( is => 'ro', required => 0 );

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
			env_proxy => 1,
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
			}
			$share_dir_hash{$_->module_share_dir} = ref $_ if $_->can('module_share_dir');
			$path_hash{$_->path} = ref $_ if $_->can('path');
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

my $has_common_js = 0;

sub request {
	my ( $self, $request ) = @_;
	my $hostname = $self->server_hostname;
	my @path_parts = split(/\/+/,$request->request_uri);
	shift @path_parts;
	my $response = Plack::Response->new(200);
	my $body;

	if ($request->request_uri eq "/"){
		$response->content_type("text/html");
		$body = $self->page_root;
	} elsif (@path_parts && $path_parts[0] eq 'share') {
		my $filename = pop @path_parts;
		my $share_dir = join('/',@path_parts);

		# remove spice version from path when present
		# eg. get_asset_path returns `/share/spice/recipe/###/yummly.ico`
		$share_dir =~ s!/\d+!!;

		if ($filename =~ /\.js$/ and
			$has_common_js and
			$share_dir =~ /(share\/spice\/([^\/]+)\/?)(.*)/){

			my $parent_dir = $1;
			my $parent_name = $2;
			my $common_js = $parent_dir."$parent_name.js";

			$body = io($common_js)->slurp;
			warn "\nAppended $common_js to $filename\n\n";
		}

		my $filename_path = $self->_share_dir_hash->{$share_dir}->can('share')->($filename);
		my $content_type = Plack::MIME->mime_type($filename);
		$response->content_type($content_type);
		$body .= -f $filename_path ? io($filename_path)->slurp : "";

	} elsif (@path_parts && $path_parts[0] eq 'js' && $path_parts[1] eq 'spice') {
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
					# Make sure we replace "${dollar}" with "$".
					$to =~ s/\$\{dollar\}/\$/g;

					# Check if environment variables (most likely the API key) is missing.
					# If it is missing, switch to the DDG endpoint.
					if(defined $rewrite->missing_envs) {
						 $to = 'https://ddh1.duckduckgo.com' . $request->request_uri;
						 # Display the URL that we used.
						 print "\nAPI key not found. Using DuckDuckGo's endpoint:\n";
					}
					p($to);

					my $res = $self->ua->request(HTTP::Request->new(
						GET => $to,
						[ $rewrite->accept_header ? ("Accept", $rewrite->accept_header) : () ]
						));
					if ($res->is_success) {
						$body = $res->decoded_content;
						# Encode utf8 api_responses to bytestream for Plack.
						utf8::encode $body if utf8::is_utf8 $body;
						warn "Cannot use wrap_jsonp_callback and wrap_string callback at the same time!" if $rewrite->wrap_jsonp_callback && $rewrite->wrap_string_callback;
						if ($rewrite->wrap_jsonp_callback && $rewrite->callback) {
							$body = $rewrite->callback.'('.$body.');' unless defined $rewrite->missing_envs;
						}
						elsif ($rewrite->wrap_string_callback && $rewrite->callback) {
							$body =~ s/"/\\"/g;
							$body =~ s/\n/\\n/g;
							$body =~ s/\R//g;
							$body = $rewrite->callback.'("'.$body.'");' unless defined $rewrite->missing_envs;
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
		$response->status(204);
		$body = "";
	} elsif ($request->param('duckduckhack_css')) {
		$response->content_type('text/css');
		$body = $self->page_css;
	} elsif ($request->param('duckduckhack_js')) {
		$response->content_type('text/javascript');
		$body = $self->page_js;
	} elsif ($request->param('duckduckhack_templates')) {
		$response->content_type('text/javascript');
		$body = $self->page_templates;
	} elsif ($request->param('q') && $request->path_info eq '/') {
		my $query = $request->param('q');
		Encode::_utf8_on($query);
		my $ddg_request = DDG::Request->new(
			query_raw => $query,
			location => test_location_by_env(),
			language => test_language_by_env(),
		);

		my @results = ();
		my @calls_nrj = ();
		my @calls_nrc = ();
		my @calls_script = ();
		my %calls_template = ();

		for (@{$self->blocks}) {
			push(@results,$_->request($ddg_request));
		}

		my $page = $self->page_spice;
		my $uri_encoded_query = uri_escape_utf8($query, "^A-Za-z");
		my $html_encoded_query = encode_entities($query);
		my $uri_encoded_ddh = quotemeta(uri_escape('duckduckhack-template-for-spice2', "^A-Za-z0-9"));
		$page =~ s/duckduckhack-template-for-spice2/$html_encoded_query/g;
		$page =~ s/$uri_encoded_ddh/$uri_encoded_query/g;

		# For debugging query replacement.
		#p($uri_encoded_ddh);
		#p($page);

		my $root = HTML::TreeBuilder->new;
		$root->parse($page);

		# Check for no results
		if (!scalar(@results)) {

			print "NO RESULTS\n";

			$root = HTML::TreeBuilder->new;
			$root->parse($self->page_root);
			my $text_field = $root->look_down(
				"name", "q"
			);
			$text_field->attr( value => $query );
			$root->find_by_tag_name('body')->push_content(
				HTML::TreeBuilder->new_from_content(
					q(<script type="text/javascript">seterr('Sorry, no hit for your plugins')</script>)
				)->guts
			);
			$page = $root->as_HTML;
		}

		# Iterate over results,
		# checking if result is a Spice or Goodie
		# and sets up the page content accordingly
		foreach my $result (@results) {

			# Info for terminal.
			p($result) if $result;

			# NOTE -- this isn't designed to have both goodies and spice at once.

			# Check if we have a Spice result
			# if so grab the associated JS, Handlebars and CSS
			# and add them to correct arrays for injection into page
			if (ref $result eq 'DDG::ZeroClickInfo::Spice') {

				my $io;
				my @files;
				my $share_dir = $result->caller->module_share_dir;
				my @path = split(/\/+/, $share_dir);
				my $spice_name = join("_", @path[2..$#path]);

				$io = io($result->caller->module_share_dir);
				push(@files, @$io);

				foreach (@files){

					if ($_->filename =~ /$spice_name\.js$/){
						push (@calls_script, $_);

					} elsif ($_->filename =~ /$spice_name\.css$/){
						push (@calls_nrc, $_);

					} elsif ($_->filename =~ /^.+handlebars$/){
						my $template_name = $_->filename;
						$template_name =~ s/\.handlebars//;
						$calls_template{$spice_name}{$template_name}{"content"} = $_;
						$calls_template{$spice_name}{$template_name}{"is_ct_self"} = $result->call_type eq 'self';
					}
				}
				push (@calls_nrj, $result->call_path);

			# Check if we have a Goodie result
			# if so modify HTML and return content
			} elsif ( ref $result eq 'DDG::ZeroClickInfo' ){

				# Grab ZCI div, push in required HTML
				my $zci_container = HTML::Element->new('div', id => "zci-answer", class => "zci zci--answer is-active");
				$zci_container->push_content(
					HTML::TreeBuilder->new_from_content(
						q(<div class="cw">
							<div class="zci__main  zci__main--detail">
								<div class="zci__body"></div>
							</div>
						</div>)
					)->guts
				);
				my $zci_body = $zci_container->look_down(class => 'zci__body');

				# Stick the answer inside $zci_body
				my $answer = $result->answer;
				if ($result->has_html) {
					my $tb = HTML::TreeBuilder->new();
					# Specifically allow unknown tags to support <svg> and <canvas>
					$tb->ignore_unknown(0);
					$answer = $tb->parse_content($result->html)->guts;
				}
				$zci_body->push_content($answer);

				my $zci_wrapper = $root->look_down(id => "zero_click_wrapper");
				$zci_wrapper->insert_element($zci_container);

				my $duckbar_home = $root->look_down(id => "duckbar_home");
				$duckbar_home->delete_content();
				$duckbar_home->attr(class => "zcm__menu");
				$duckbar_home->push_content(
					HTML::TreeBuilder->new_from_content(
						q(<li class="zcm__item">
							<a data-zci-link="answer" class="zcm__link  zcm__link--answer is-active" href="javascript:;">Answer</a>
						</li>)
					)->guts
				);

				my $duckbar_static_sep = $root->look_down(id => "duckbar_static_sep");
				$duckbar_static_sep->attr(class => "zcm__sep--h");

				my $html = $root->look_down(_tag => "html");
				$html->attr(class => "set-header--fixed  has-zcm js no-touch csstransforms3d csstransitions svg use-opts has-active-zci")

			# If not Spice or Goodie,
			# inject raw Dumper() output from into page
			} else {

				my $content = $root->look_down(id => "bottom_spacing2");
				my $dump = HTML::Element->new('pre');
				$dump->push_content(Dumper $result);
				$content->insert_element($dump);
				$page = $root->as_HTML;
			}
		}

		# Setup various script tags:
		#   calls_script : spice js files
		#   calls_nrj : proxied spice api calls
		#   calls_nrc : spice css calls
		#   calls_template : spice handlebars templates

		my $calls_nrj = (scalar @calls_nrj) ? join(";",map { "nrj('".$_."')" } @calls_nrj) . ';' : '';
		my $calls_nrc = (scalar @calls_nrc) ? join(";",map { "nrc('".$_."')" } @calls_nrc) . ';' : '';
		my $calls_script = (scalar @calls_script)
			? join("",map { "<script type='text/JavaScript' src='".$_."'></script>" } @calls_script)
			: '';

		if (%calls_template) {
			foreach my $spice_name ( keys %calls_template ){
				$calls_script .= join("",map {
					my $template_name = $_;
					my $is_ct_self = $calls_template{$spice_name}{$template_name}{"is_ct_self"};
					my $template_content = $calls_template{$spice_name}{$template_name}{"content"}->slurp;
					"<script class='duckduckhack_spice_template' spice-name='$spice_name' template-name='$template_name' is-ct-self='$is_ct_self' type='text/plain'>$template_content</script>"

				} keys $calls_template{$spice_name});
			}
		}

		$page = $root->as_HTML;

		$page =~ s/####DUCKDUCKHACK-CALL-NRJ####/$calls_nrj/g;
		$page =~ s/####DUCKDUCKHACK-CALL-NRC####/$calls_nrc/g;
		$page =~ s/####DUCKDUCKHACK-CALL-SCRIPT####/$calls_script/g;

		$response->content_type('text/html');
		$body = $page;

	} else {
		my $res = $self->ua->request(HTTP::Request->new(GET => "http://".$hostname.$request->request_uri));
		if ($res->is_success) {
			$body = $res->decoded_content;
			$response->code($res->code);
			$response->content_type($res->content_type);
		} else {
			warn $res->status_line, "\n";
			$body = "";
		}
	}

	$response->body($body);
	return $response;
}

1;
