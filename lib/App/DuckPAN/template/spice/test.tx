#!/usr/bin/env perl

: include shared::perl_standard_imports_tests { repo => 'Spice' }

spice is_cached => 1;

ddg_spice_test(
    [qw( <: $ia.perl_module :> )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    '<: $ia.example_query :>' => test_spice(
        '/js/spice/<: $ia.id :>/query',
        call_type => 'include',
        caller => '<: $ia.perl_module :>'
    ),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'bad example query' => undef,
);

done_testing;

