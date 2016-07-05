package App::DuckPAN::Fathead;
# ABSTRACT: Searches a given output.txt file for a query match

use Moo;
with 'App::DuckPAN::HasApp';

use DBI;
use JSON;
use Path::Tiny;
use Data::Printer return_value => 'dump';

has output_txt => (
	is => 'rw',
	lazy => 1,
	required => 0,
	default => sub { undef },
);

sub search_output {

	my ($self, $query) = @_;

	# Open output.txt file for searching
	# Handles as a CSV with "\t" separator
	# Provide numbered column names
	my $dbh = DBI->connect ("dbi:CSV:", undef, undef, {
		f_dir                   => path($self->output_txt)->parent,
		f_ext                   => ".txt/r",
		csv_sep_char            => "\t",
		csv_quote_char          => undef,
		csv_escape_char         => undef,
		csv_allow_whitespace    => 1,
		csv_allow_quotes        => 1,
		RaiseError              => 1,
		PrintError              => 0,
		csv_tables => {
			output => {
				file => 'output.txt',
				col_names => [
					"title",
					"type",
					"redirect",
					"col4",
					"categories",
					"col6",
					"related_topics",
					"external_links",
					"disambiguation",
					"col10",
					"images",
					"abstract",
					"source_url",
				],
			},
		},
	}) or die $DBI::errstr;

	my $result;
	$@ = "";

	eval {
		my $sth = $dbh->prepare("SELECT * FROM output WHERE title = ?");
		$sth->execute($query);
		while (my $row = $sth->fetchrow_hashref) {
			$result = $row;
		}
		$sth->finish();
	};
	$self->app->emit_error("SQL database error: $@") if $@;

	return $result;
}

# Build a Structed Answer hash
# Properties depend on Fathead result type
sub structured_answer {
	my ($self, $data) = @_;

	my $out = {
		id => "main_answer",
		# meta => $meta,
		data => $data,
		from => 'main_answer',
		signal => "high",
	};

	## TODO Get IA Metadata
	$out->{data}->{Heading} = $data->{title};
	$out->{data}->{Abstract} = $data->{abstract};
	$out->{data}->{AbstractURL} = $data->{source_url};
	$out->{data}->{FirstURL} = $data->{source_url};
	$out->{data}->{meta} = {
		src_name => "Website",
		repo => "fathead"
	};
	$out->{data}->{Image} = $data->{images}; ##TODO Process `images` into HTML
	# $out->{data}->{Results} = [ { FirstResult => "htpps://duckduckgo.com"} ]; ##TODO Builds Results array

	if ($data->{type} eq 'A') {
		$out->{topic} = 'About';
		$out->{model} = 'FatheadArticle';
		$out->{templates} = {
			'detail' => 'info_detail'
		};
	}

	if ($data->{type} eq 'D') {
		$out->{topic} = 'Meanings';
		$out->{model} = 'FatheadListItem';
		$out->{templates} = {
			'item' => 'meanings_item'
		};
	}

	if ($data->{type} eq 'C') {
		$out->{topic} = 'List';
		$out->{model} = 'FatheadListItem';
		$out->{templates} = {
			'item' => 'categories_item'
		};
	}
	return $out;
}

1;
