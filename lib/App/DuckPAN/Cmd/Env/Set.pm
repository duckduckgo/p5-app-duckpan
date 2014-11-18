package App::DuckPAN::Cmd::Env::Set;
# ABSTRACT: Sets the specified env variable value

sub execute {
    my ($class, $self, $name, @params) = @_;
    $self->help('set', "<name> <value>") if !@params || !$name;
    my $data = $self->load_env_ini;
    $data->{uc $name} = join(" ", @params);
    $self->save_env_ini($data);
}

1;
