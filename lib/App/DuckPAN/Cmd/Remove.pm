package App::DuckPAN::Cmd::Remove;
# ABSTRACT: Command for removing Instant Answers and Instant
# Answer files.

use Moo;
use App::DuckPAN::InstantAnswer::Config;
use MooX::Options;

with qw( App::DuckPAN::Cmd App::DuckPAN::InstantAnswer::Cmd );

option interactive => (
	is      => 'ro',
	short   => 'i',
	doc     => 'prompt before every removal',
	default => 0,
);

sub run {
	my $self = shift;
	my $ia = $self->_ask_ia_check();
	my $ia_cfg = App::DuckPAN::InstantAnswer::Config->new(ia => $ia);
	my %files = %{$ia_cfg->files()};
	my @files = @{$files{all}};
	$self->app->emit_and_exit(0, 'Nothing to do') unless @files;
	$self->app->emit_info(
		"This will remove the following files:\n" .
		join "\n", @files
	);
	if ($self->app->ask_yn('Continue?')) {
		foreach my $file (@files) {
			if ($self->interactive) {
				$file->remove()
					if $self->app->ask_yn("Remove file: '$file'?");
			}
			else {
				$file->remove();
			}
		}
	}
}

1;

__END__
