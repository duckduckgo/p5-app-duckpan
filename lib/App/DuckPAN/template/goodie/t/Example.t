#!/usr/bin/env perl

: include shared::perl_standard_imports_tests { repo => 'Goodie' };

zci answer_type => "<: $ia.id :>";
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    return "plain text response",
    : include shared::perl_structured_answer_text { indent => 8 };

}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( <: $ia.perl_module :> )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    '<: $ia.example_query :>' => build_test('query'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'bad example query' => undef,
);

done_testing;
