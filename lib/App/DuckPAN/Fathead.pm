package App::DuckPAN::Fathead;
# ABSTRACT: Searches a given output.txt file for a query match

use Moo;
with 'App::DuckPAN::HasApp';

use DBI;
use JSON;
use Path::Tiny;
use Data::Printer return_value => 'dump';

has selected => (
	is => 'rw',
	lazy => 1,
	required => 0,
	predicate => 1,
	trigger => 1
);

sub _trigger_selected {
	my ( $self, $id ) = @_;
	my $dir = path("lib/fathead/$id");
	unless ($dir->is_dir) {
		my $full_path = $dir->realpath;
		$self->app->emit_and_exit(1, "Directory not found: $full_path") ;
	}
	return $dir;
}

has output_txt => (
	is => 'rw',
	lazy => 1,
	required => 0,
	builder => 1
);

sub _build_output_txt {
	my ( $self ) = @_;
	my $file = undef;
	if ($self->has_selected) {
		$file = path("lib/fathead/", $self->selected, "/output.txt");
		unless ($file->exists){
			my $full_path = $file->realpath;
			$self->app->emit_and_exit(1, "No output.txt was not found in $full_path");
		}
	}
	return $file;
}

has dbh => (
	is => 'rw',
	lazy => 1,
	required => 0,
	builder => 1
);

sub _build_dbh {
	my ( $self ) = @_;

	# Open output.txt file for searching
	# Handles as a CSV with "\t" separator
	# Provide numbered column names
	my $dbh = DBI->connect ("dbi:CSV:", undef, undef, {
		f_dir                   => $self->output_txt->parent,
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
					"abstract_url",
				],
			},
		},
	}) or die $DBI::errstr;

	return $dbh;
}

# Get a Fathead result from the DB
# Requery when we get a Redirect
sub search_output {

	my ($self, $query) = @_;

	my $result = $self->db_lookup($query);

	if ($result->{type} eq "R") {
		my $redirect = $result->{redirect};
		$result = $self->db_lookup($redirect);
		$self->app->emit_notice("Following Redirect: '$query' -> '$redirect'");
	}

	return $result;

}

# Attempt to get a result from DB (output.txt)
# Capture & display any raised errors
sub db_lookup {
	my ($self, $query) = @_;

	my $result;
	$@ = "";

	eval {
		# TODO lowercase all titles first
		my $sth = $self->dbh->prepare("SELECT * FROM output WHERE lower(title) = ?");
		$sth->execute(lc $query);
		while (my $row = $sth->fetchrow_hashref) {
			$result = $row;
		}
		$sth->finish();
	};
	$self->app->emit_error("SQL database error: $@") if $@;

	return $result;
}

# Build a Structured Answer hash
# Properties depend on Fathead result type
sub structured_answer {
	my ($self, $data) = @_;

	# Get IA Metadata via ID lookup
	# Assume selected is an ID
	my $metadata = DDG::Meta::Data->get_ia(id => $self->selected) // {};

	# DBD::Csv ignores col_names letter casing
	# So, manually map columns to template properties
	# TODO update info_detail template to use lowercase variable names
	my %extra_data = (
		Heading 	=> $data->{title},
		Abstract 	=> $data->{abstract},
		AbstractURL => $data->{abstract_url},
		FirstURL 	=> $metadata->{src_url},
		# TODO Process `images` into HTML links
		Image 		=> $data->{images},
		# TODO Builds Results array for disambiguations
		# Results 	=> [ { FirstResult => "htpps://duckduckgo.com"} ];
	);

	my $out = {
		id => $self->selected,
		# from => $self->selected,
		# signal => "high",
		meta => $metadata,
		data => { %$data, %extra_data }
	};

	# Define template, topic and model based on result type
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
