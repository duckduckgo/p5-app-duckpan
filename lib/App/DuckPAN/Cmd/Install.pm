package App::DuckPAN::Cmd::Install;
# ABSTRACT: Install the distribution in current directory

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ( $self, @args ) = @_;

	if (-f 'dist.ini') {
		$self->app->emit_info("Found a dist.ini, suggesting a Dist::Zilla distribution");

		$self->app->perl->cpanminus_install_error
			if (system("dzil install --install-command 'cpanm .'"));
		$self->app->emit_info("Everything fine!");
	}

}

1;
