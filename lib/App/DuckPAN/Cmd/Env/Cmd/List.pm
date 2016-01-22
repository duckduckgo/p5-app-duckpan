package App::DuckPAN::Cmd::Env::Cmd::List;
# ABSTRACT: List all env variables

use Moo;
with qw( App::DuckPAN::Cmd::Env::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ( $self )  = @_;
	my $data = $self->env->load_env_ini;
	if (keys %{$data}) {
		$self->root->emit_info("export ". $_ ."=". $data->{$_} ) for (sort keys %{$data});
	} else {
		$self->root->emit_notice("There are no env variables set currently.");
	}
}

1;
