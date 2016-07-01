package App::DuckPAN::Fathead;
# ABSTRACT: Searches a given output.txt file for a query match

use Moo;
with 'App::DuckPAN::HasApp';

use DBI;
use JSON;
use Path::Tiny;
use Data::Printer return_value => 'dump';

sub search_output {

    my ($self, $query, $output_txt) = @_;

    # Open output.txt file for searching
    # Handles as a CSV with "\t" separator
    # Provide numbered column names
    my $dbh = DBI->connect ("dbi:CSV:", undef, undef, {
        f_dir                   => $output_txt->parent,
        f_ext                   => ".txt/r",
        csv_sep_char            => "\t",
        csv_quote_char          => undef,
        csv_escape_char         => undef,
        csv_allow_whitespace    => 1,
        csv_allow_quotes        => 1,
        RaiseError              => 1,
        PrintError              => 1,
        csv_tables => {
            output => {
                file => 'output.txt',
                col_names => [ map { "col$_" } (1..13)  ],
            },
        },
    }) or die $DBI::errstr;

    my $result;
    $@ = "";

    eval {
        my $sth = $dbh->prepare("SELECT * FROM output WHERE col1 = ?");
        $sth->execute($query);
        while (my $row = $sth->fetchrow_arrayref) {
            $result = $row;
        }
        $sth->finish();
    };
    $@ and die "SQL database error: $@";
    return $result;
}

sub output_as_json {
    my ($self, $output_txt) = @_;
    return "done";
}

1;
