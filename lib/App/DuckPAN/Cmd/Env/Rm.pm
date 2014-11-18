package App::DuckPAN::Cmd::Env::Rm;
# ABSTRACT: Removes the specified env variable

sub execute {
    my ( $class, $self, $name ) = @_;
    $self->help('rm', "<name>") if !$name;
    my $data = $self->load_env_ini;
    $name = uc $name;
    defined $data->{$name} ? delete $data->{$name} : $self->app->emit_error("'". $name ."' not found!");
    $self->save_env_ini($data);
}

1;
