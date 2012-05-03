package App::DuckPAN::Web;

use Moo;
use DDG::Request;
use Plack::Request;
use Plack::Response;
use HTML::Entities;
use HTML::TreeBuilder;
use Data::Printer;
use URL::Encode qw( url_decode_utf8 );

has blocks => ( is => 'ro', required => 1 );
has page_root => ( is => 'ro', required => 1 );
has page_spice => ( is => 'ro', required => 1 );
has page_css => ( is => 'ro', required => 1 );
has page_js => ( is => 'ro', required => 1 );

sub run_psgi {
	my ( $self, $env ) = @_;
	my $request = Plack::Request->new($env);
	my $response = $self->request($request);
	return $response->finalize;
}

sub request {
	my ( $self, $request ) = @_;
	my $response = Plack::Response->new(200);
	my $body;
	if ($request->param('duckduckhack_ignore')) {
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
		$page =~ s/duckduckhack-template-for-spice/$query/g;
		if ($result) {
			p($result);
		} else {
			my $root = HTML::TreeBuilder->new;
			$root->parse($self->page_root);
			my $error_field = $root->look_down(
				"id", "error_homepage"
			);
			$error_field->push_content("Sorry, no hit on your plugins");
			$error_field->attr( id => "error_duckduckhack" );
			my $text_field = $root->look_down(
				"name", "q"
			);
			$text_field->attr( value => $query );
			$page = $root->as_HTML;
		}
		$response->content_type('text/html');
		$body = $page;
	} else {
		$response->content_type('text/html');
		$body = $self->page_root;
	}
	$response->body($body);
	return $response;
}

1;