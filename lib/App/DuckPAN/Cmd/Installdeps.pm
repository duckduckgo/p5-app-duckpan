package App::DuckPAN::Cmd::Installdeps;

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
			if (system("dzil authordeps --missing 2>/dev/null | grep -vP '[^\\w:]' | cpanm"));
		$self->app->perl->cpanminus_install_error
			if (system("dzil listdeps --missing 2>/dev/null | grep -vP '[^\\w:]' | cpanm"));
		$self->app->print_text(
			"Everything fine!",
		);
	}

}

1;
