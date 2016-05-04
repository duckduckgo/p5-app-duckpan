package App::DuckPAN::Template::Definitions;
# ABSTRACT: Defines available templates.

use Moo;

use Try::Tiny;
use Path::Tiny;
use YAML::XS qw(LoadFile);

use App::DuckPAN::Template;
use App::DuckPAN::TemplateSet;
use App::DuckPAN::InstantAnswer::Util qw(:predicate);

use namespace::clean;

has _template_dir => (
    is       => 'ro',
    required => 1,
    init_arg => 'template_directory',
    default => sub {
			path($INC{'App/DuckPAN.pm'} =~ s/\.pm$//r, 'template')
    },
    doc => 'Path to directory containing all template files.',
);

my %templates = (
	cheat_sheet => {
		label => 'Cheat Sheet',
		input_file => 'goodie/cheat_sheet.tx',
		allow => \&is_cheat_sheet,
		output_file => sub {
			my $vars = shift;
			my $fname = $vars->{ia}{id} =~ s/_cheat_sheet$//r;
			$fname =~ s/_/-/g;
			$fname .= '.json';
			return 'share/goodie/cheat_sheets/json/' .
				$vars->{template_type} eq 'language' ? 'language/' : ''
				. $fname;
		}
	},
	js => {
		label => 'JavaScript',
		input_file => '<:$repo.template_dir:>/js.tx',
		allow => [\&is_spice, \&is_goodie],
		output_file => 'share/<:$repo.share_name:>/<:$ia.id:>/js.tx',
	},
	pm => {
		label => 'Perl Module',
		input_file => '<:$repo.template_dir:>/perl_main.tx',
		output_file => '<:$paths.back_end_module:>',
	},
);

has _template_definitions => (
	is => 'ro',
	doc => 'HASH of template definitions to build.',
	isa => sub { carp('Not a HASH ref') unless ref $_[0] eq 'HASH' },
	default => sub { \%templates },
);

has _templates => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__templates {
    my $self = shift;
    my %templ;
    while (my ($template, $config) = each %{$self->_template_definitions}) {
			$templ{$template} = App::DuckPAN::Template->new(
				name => $template,
				template_directory => $self->_template_dir,
				%$config,
			);
		}
		return \%templ;
}

sub get_templates {
	my ($self, $by, $lookup) = @_;
	my @templates = values %{$self->_templates};
	if ($by eq 'allow') {
		return grep { $_->supports($lookup) } @templates;
	}
	return grep { $_->$by eq $lookup } @templates;
}

1;
