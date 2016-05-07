package App::DuckPAN::Cmd::New;
# ABSTRACT: Take a name as input and generates a new, named Goodie or Spice instant answer skeleton

# See the template/templates.yml file in the Goodie or Spice repository for the
# list of template-sets and files generated for them

use Moo;
with qw(
	App::DuckPAN::Cmd
	App::DuckPAN::InstantAnswer::Cmd
	App::DuckPAN::Option::Tell
);

use App::DuckPAN::InstantAnswer::Util qw(find_ia_files is_cheat_sheet);
use App::DuckPAN::InstantAnswer::Config;

use MooX::Options protect_argv => 0;

use App::DuckPAN::Template::Definitions;
use App::DuckPAN::Template::Set;

no warnings 'uninitialized';
##########################
# Command line arguments #
##########################

# A 'template' for the user is equivalent to a 'template-set' for the program
option template => (
	is      => 'rwp',
	format  => 's',
	short   => 't',
	doc     => 'template used to generate the instant answer skeleton (default: default)',
);

###########
# Methods #
###########

has ia => (
	is => 'rwp',
);

my $set_defs = App::DuckPAN::Template::Set->new();

sub run {
	my ($self, @args) = @_;

	my $ia = $self->_ask_ia_check();
	$self->_set_ia(
		App::DuckPAN::InstantAnswer::Config->new(ia => $ia)
	);
	my @sets = $self->ia->get_available_template_sets();
	my $set;
	if (my $template = $self->template) {
		($set) = $set_defs->lookup(id => $template) or
			$self->app->emit_and_exit(
				-1, "Unknown template '$template'\n"
			);
	}
	else {
		my %set_map = map { $_->description => $_ } @sets;
		$set = $set_map{$self->app->get_reply(
			"Which template set would you like to use?",
			choices => [sort keys %set_map],
		)};
	}
	$set->generate( app => $self->app, ia => $ia );
}

1;
