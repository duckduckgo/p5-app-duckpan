package App::DuckPAN::Cmd::Env::List;
# ABSTRACT: List all env variables

sub execute {
    my ($class, $self)  = @_;
    my $data = $self->load_env_ini;
    if (keys %{$data}) {
        $self->app->emit_info("export ". $_ ."=". $data->{$_} ) for (sort keys %{$data});
    } else {
        $self->app->emit_notice("There are no env variables set currently.");
    }
}

1;
