package App::DuckPAN::WebPublisher;
# ABSTRACT: Webserver for duckpan publisher

use Moo;
with qw( App::DuckPAN::HasApp );

use HTTP::Request;
use Plack::Request;
use Plack::Response;

has sites => ( is => 'ro', required => 1 );

has ports => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		my %ports;
		for my $key (keys %{$self->sites}) {
			my $port = $self->sites->{$key}->{port};
			my $url = $self->sites->{$key}->{url};
			my $site = $self->publisher->sites->{$key};
			$ports{$port} = {
				site => $site,
				url => $url,
			};
		}
		return \%ports;
	},
);

has publisher => (
	is => 'ro',
	lazy => 1,
	default => sub {
		require lib;
		lib->import('lib');
		require DDG::Publisher;
		DDG::Publisher->new;
	},
);

sub run_psgi {
	my ( $self, $env ) = @_;
	my $request = Plack::Request->new($env);
	my $response = $self->request($request);
	return $response->finalize;
}

has current_language => (
	is => 'rw',
	default => 'en_US',
);

sub request {
	my ( $self, $request ) = @_;

	my $response = Plack::Response->new(200);
	my $body;

	my $locale = defined $ENV{DDG_LOCALE} ? $ENV{DDG_LOCALE} : 'en_US';

	my $site = $self->ports->{$request->port}->{site};
	my $url = $self->ports->{$request->port}->{url};

	$self->current_language($request->param('kad')) if $request->param('kad');

	my $uri = $request->path_info eq '/' ? '/index' : $request->path_info;
	$uri =~ s/\/$//;

	my $file = $uri.'/'.$self->current_language.'.html';

	if (defined $site->fullpath_files->{$file}) {
		$self->app->show_msg('Request '.$request->path_info.' uses '.$file.' from DDG::Publisher...');
		$body = $site->fullpath_files->{$file}->uncached_content;
		$response->code("200");
		$response->content_type('text/html');
	} else {
		my $res = $self->app->http->request(HTTP::Request->new(GET => $url.$request->request_uri));
		if ($res->is_success) {
			$body = $res->decoded_content;
			$response->code($res->code);
			$response->content_type($res->content_type);
		} else {
			$body = "GET ".$url.$request->request_uri.": ".$res->status_line;
			warn $body, "\n";
		}
	}

	# This could cause issues with incorrectly encoded data as Plack expects a
	# raw bytestream. We should find the root of this issue and reencode
	# offending strings.
	Encode::_utf8_off($body);
	$response->body($body);
	return $response;
}

1;
