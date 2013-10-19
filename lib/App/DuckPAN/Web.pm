package App::DuckPAN::Web;
# ABSTRACT: Webserver for duckpan server

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
use JSON;
use Data::Dumper;

has blocks => ( is => 'ro', required => 1 );
has page_root => ( is => 'ro', required => 1 );
has page_spice => ( is => 'ro', required => 1 );
has page_css => ( is => 'ro', required => 1 );
has page_js => ( is => 'ro', required => 1 );
has server_hostname => ( is => 'ro', required => 0 );

has _share_dir_hash => ( is => 'rw' );
has _path_hash => ( is => 'rw' );
has _rewrite_hash => ( is => 'rw' );
has _spice_js_hash => ( is => 'rw' );

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
	my %spice_js_hash;
	for (@{$self->blocks}) {
		for (@{$_->only_plugin_objs}) {
			if ($_->does('DDG::IsSpice')) {
				$rewrite_hash{ref $_} = $_->rewrite if $_->has_rewrite;
				$spice_js_hash{ref $_} = $_->spice_js;
			}
			$share_dir_hash{$_->module_share_dir} = ref $_ if $_->can('module_share_dir');
			$path_hash{$_->path} = ref $_ if $_->can('path');
		}
	}
	$self->_share_dir_hash(\%share_dir_hash);
	$self->_path_hash(\%path_hash);
	$self->_rewrite_hash(\%rewrite_hash);
	$self->_spice_js_hash(\%spice_js_hash);
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

	if (@path_parts && $path_parts[0] eq 'share') {
		my $filename = pop @path_parts;
		my $share_dir = join('/',@path_parts);

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
		$body .= -f $filename_path ? io($filename_path)->slurp : "";

	} elsif (@path_parts && $path_parts[0] eq 'js' && $path_parts[1] eq 'spice') {
		for (keys %{$self->_path_hash}) {
			if ($request->request_uri =~ m/^$_/g) {
				my $path_remainder = $request->request_uri;
				$path_remainder =~ s/^$_//;
				$path_remainder =~ s/\/+/\//g;
				$path_remainder =~ s/^\///;
				my $spice_class = $self->_path_hash->{$_};
				my $spice_js = $self->_spice_js_hash->{$spice_class};
				my $rewrite = $self->_rewrite_hash->{$spice_class};
				if ($rewrite) {
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
								$body = $rewrite->callback.'('.$body.');';
							}
							elsif ($rewrite->wrap_string_callback && $rewrite->callback) {
								$body =~ s/"/\\"/g;
								$body =~ s/\n/\\n/g;
								$body =~ s/\R//g;
								$body = $rewrite->callback.'("'.$body.'");';
							} else {
								$response->code($res->code);
								$response->content_type($res->content_type);
							}
						} else {
							warn $res->status_line, "\n";
							$body = "";
						}
					}
				} else {
					$response->content_type('text/javascript');
					$response->body($spice_js);
					return $response;
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
		my @calls_template = ();

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
			$page = $root->as_HTML;
			$page =~ s/<\/body>/<script type="text\/javascript">seterr('Sorry, no hit for your plugins')<\/script><\/body>/;
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
				my $filename = $path[-1];

				if (scalar(@path) > 3 and
					$share_dir =~ /(share\/spice\/([^\/]+)\/?)(.*)/){

					my $parent_dir = $1;
					my $parent_name = $2;
					my $common_js = $parent_dir."$parent_name.js";

					unless ($has_common_js) {
						$has_common_js = 1 if (-f $common_js);
					}

				 	@files = map { $_ } grep {
					       $_->name =~ /^.+handlebars$/
					   } io($parent_dir)->all_files;
				}

				$filename =~ s/share\/spice\///g;
				$filename =~ s/\//\_/g;

				$io = io($result->caller->module_share_dir);
				push(@files, @$io);

				foreach (@files){

					if ($_->filename =~ /$filename\.js$/){
						push (@calls_script, $_);

					} elsif ($_->filename =~ /$filename\.css$/){
						push (@calls_nrc, $_);

					} elsif ($_->filename =~ /^.+handlebars$/){
						push (@calls_template, $_);
					}
				}
				push (@calls_nrj, $result->call_path);

			# Check if we have a Goodie result
			} elsif ( ref $result eq 'DDG::ZeroClickInfo' ){
				push (@calls_template, $result);

			# If not Spice or Goodie,
			# inject raw Dumper() output from into page
			} else {

				my $content = $root->look_down(
					"id", "bottom_spacing2"
					);
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
		#   calls_templates : spice handlebars templates or goodie result
		
		my $calls_nrj = (scalar @calls_nrj)	?	join(";",map { "nrj('".$_."')" } @calls_nrj) . ';' : '';
		my $calls_nrc = (scalar @calls_nrc) ? join(";",map { "nrc('".$_."')" } @calls_nrc) . ';' : '';
		my $calls_script = (scalar @calls_script)
			? join("",map { "<script type='text/JavaScript' src='".$_."'></script>" } @calls_script)
			: '';

		if (@calls_template) {
			my ($template_name, $template_content);
				$calls_script .= join("",map {

				my $result = $_;

				# Check if our array is full of template files
				if (ref $result eq 'IO::All::File') {

					# Give the script tag a name based on the template name
					# e.g. filename: hacker_news.handlebars
					# creates <script ... name=hacker_news>...</script>
					$template_name = $result->filename;
					$template_name =~ s/.handlebars//g;
					$template_content = $result->all;
					"<script class='duckduckhack_spice_template' name='$template_name' type='text/plain'>$template_content</script>"

				# Check if array contains a goodie result
				} elsif (ref $result eq 'DDG::ZeroClickInfo') {

					my $goodie = $result;

					# Loop over all possible getter for DDG::ZeroClickInfo
					# If exists, push into hash,
					# JSON encode and inject into script tag
					my @getters = qw(abstract abstract_text abstract_source abstract_url image heading answer answer_type definition definition_source definition_url html related_topics_sections results type redirect);

					my %result_data = map {
						my $has_func = 'has_'.$_;
						my $func = $_;
						$goodie->$has_func ? ( $_ => $goodie->$func ) : ();
					} @getters;

					$template_name = $_->has_answer_type ? $_->answer_type : "unnamed-goodie";
					$template_content =  encode_json \%result_data;
					"<script class='duckduckhack_goodie' name='$template_name' type='application/json'>$template_content</script>";
				}

			} @calls_template);
		}

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
