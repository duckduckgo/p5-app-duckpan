package App::DuckPAN::Cmd::Env::Get;
# ABSTRACT: Gets the specified env variable

sub execute {
    my ($class, $self, $name) = @_;
    $self->help('get', "<name>") if !$name;
    my $data = $self->load_env_ini;
    $name = uc $name;
    $data->{$name} ? $self->app->emit_info("export ". $name ."=". $data->{$name}) : $self->app->emit_error("'". $name ."' is not set!");
}

1;
