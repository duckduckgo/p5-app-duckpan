package App::DuckPAN::Web;

use Moo;
use Plack::Request;
use Plack::Response;

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
	if ($request->param('duckduckhack_css')) {
		$response->content_type('text/css');
		$response->body($self->page_css);
	} elsif ($request->param('duckduckhack_js')) {
		$response->content_type('text/javascript');
		$response->body($self->page_js);
	} else {
		$response->content_type('text/html');
		$response->body($self->page_root);
	}
	return $response;
}

1;