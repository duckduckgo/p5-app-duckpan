package App::DuckPAN::Cmd::Install;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

sub run {
	my ( $self, @args ) = @_;

	if (-f 'dist.ini') {
		$self->app->print_text(
			"Found a dist.ini, suggesting a Dist::Zilla distribution",
		);

		$self->app->perl->cpanminus_install_error
			if (system("dzil install --install-command 'cpanm .'"));
		$self->app->print_text(
			"Everything fine!",
		);
	}

}

1;
