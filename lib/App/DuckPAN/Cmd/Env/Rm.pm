package App::DuckPAN::Cmd::Env::Rm;
# ABSTRACT: Removes the specified env variable

sub execute {
    my ( $class, $self, $name ) = @_;
    $self->help('rm', "<name>") if !$name;
    my $data = $self->load_env_ini;
    defined $data->{uc $name} ? delete $data->{uc $name} : $self->app->emit_error("'". uc $name ."' not found!");
    $self->save_env_ini($data);
}

1;
