package App::DuckPAN::Cmd::QueryServer;
# ABSTRACT: Command line tool for testing queries and see triggered plugins

use utf8::all;
use MooX qw( Options );
with qw( App::DuckPAN::Cmd );
use Data::Dumper;
use LWP::UserAgent;
use URI::Escape;
use JSON;


my $ua = LWP::UserAgent->new;

sub test_query {
    my $test_subject = shift @_;
    my $verbose = shift @_;
    my $plugin_name = $test_subject->{'name'};
    print "\n".$plugin_name."\n";
    my $examples_ref = $test_subject->{'examples'};
    my @examples = @{$examples_ref};
    	
    if (exists $test_subject->{'answer_type'})
    {
	my $answer_type = $test_subject->{'answer_type'};
	foreach my $ex (@examples)
	{
	    my $cooked_ex = uri_escape_utf8($ex);
	    my $url = 'https://api.duckduckgo.com?q='.$cooked_ex.'&o=json&no_html=1&d=0';
	    my $req = HTTP::Request->new(GET => $url);
	    my $res = $ua->request($req);
	    if ($res-> is_success){
		my $test_res =  from_json($res->content);
		if ($test_res->{"AnswerType"} =~ $answer_type)
		{
		    print '  '. $ex . " Test OK\n";
		}
		else
		{
		    print '  '. $ex . " Test FAIL\n";
		}
	       }
	    else
	    {
		print "  ". $ex . "Network Error\n";
	    }
	}
	
    }
    else
    {
	if ($plugin_name =~ /Goodie/)
	{
	    return;
	}
	if (exists $test_subject->{'kickstart'})
	{
	    my $kickstart = $test_subject->{'kickstart'};
	    foreach my $ex (@examples)
	    {
		my $cooked_ex = uri_escape_utf8($ex);
		my $url = 'https://duckduckgo.com?q='.$cooked_ex;
		my $req = HTTP::Request->new(GET => $url);
		my $res = $ua->request($req);
		if ($res-> is_success){
		    
		    if ($res->content =~ /\Q$kickstart\E/)
		    {
			print '  '. $ex . " Test OK\n";
		    }
		    else
		    {
			print '  '. $ex . " Test FAIL\n";
		    }
		}
		else
		{
		    print "  ". $ex . "Network Error\n";
		}
	    }
	}
	    
    }
}   



sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_app_duckpan;
	exit 1 unless $self->app->check_ddg;

	my @blocks = @{$self->app->ddg->get_blocks_for_test_from_current_dir(@args)};
	require App::DuckPAN::Query;
	foreach $b (@blocks)
	{
	    test_query($b);
	}

}

1;
