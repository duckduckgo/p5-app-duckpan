: include shared::perl_package_header {ia => $ia};

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

: include shared::perl_standard_imports {repo => 'Goodie'};

zci answer_type => '<: $ia.id :>';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers <: $ia_trigger :>;

# Handle statement
handle <: $ia_handler :> => sub {

    my <: $ia_handler_var :><: $ia_handler :> = <: $ia_handler_var :>_;

    # Optional - Guard against no remainder
    # I.E. the query is only 'triggerWord' or 'trigger phrase'
    #
    # return unless $remainder;

    # Optional - Regular expression guard
    # Use this approach to ensure the remainder matches a pattern
    # I.E. it only contains letters, or numbers, or contains certain words
    #
    # return unless qr/^\w+|\d{5}$/;

    return "plain text response",
: include shared::perl_structured_answer_text { indent => 8 };

};

1;
