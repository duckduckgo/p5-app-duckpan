package App::DuckPAN::TemplateDefinitions;
# ABSTRACT: Parse the template definitions file to create templates and template sets

use Moo;

use Try::Tiny;
use Path::Tiny;
use YAML::XS qw(LoadFile);

use App::DuckPAN::Template;
use App::DuckPAN::TemplateSet;

use namespace::clean;

has templates_yml => (
    is       => 'ro',
    required => 1,
    default  => sub { path('template', 'templates.yml') },
    doc      => 'Path to the YAML file with template definitions',
);

has _templates_data => (
    is       => 'rwp',
    init_arg => undef,
    doc      => 'Raw template definitions read from the template definitions file',
);

has _template_map => (
    is       => 'ro',
    lazy     => 1,
    builder  => 1,
    init_arg => undef,
    doc      => 'Hashref of tempate name => App::DuckPAN::Template instances ' .
                'built from the templates_yml file',
);

sub _build__template_map {
    my $self = shift;
    my $template_root = path($self->templates_yml)->parent;
    my $data = $self->_templates_data->{templates};
    my %template_map;

    for my $name (keys %$data) {
        my $template_data = $data->{$name};

        my $template = App::DuckPAN::Template->new(
            name          => $name,
            description   => $template_data->{description},
            input_file    => path($template_root, $template_data->{input}),
            output_file   => path($template_data->{output}),
            needs_restart => $template_data->{needs_restart},
        );

        $template_map{$name} = $template;
    }

    return \%template_map;
}

has _template_sets => (
    is      => 'ro',
    builder => 1,
    lazy    => 1,
    doc     => 'hashref of template set name to App::DuckPAN::TemplateSet instances ' .
               'built from the templates_yml file',
);

sub _build__template_sets {
    my $self = shift;
    my $sets_data = $self->_templates_data->{template_sets};
    my %template_sets;

    for my $name (keys %$sets_data) {
        my $data     = $sets_data->{$name};
        my @required = @{$data->{required} // []};
        my @optional = @{$data->{optional} // []};

        # check if all templates in this set are defined
        for my $template_name (@required, @optional) {
            die "Template '$template_name' not defined in " . $self->templates_yml
                unless $self->_template_map->{$template_name};
        }

        my $template_set = App::DuckPAN::TemplateSet->new(
            name               => $name,
            description        => $data->{description},
            required_templates => [ @{$self->_template_map}{@required} ],
            optional_templates => [ @{$self->_template_map}{@optional} ],
        );

        $template_sets{$name} = $template_set;
    }

    return \%template_sets;
}

# Get a template set by name
sub get_template_set {
    my ($self, $name) = @_;

    return $self->_template_sets->{$name};
}

# Get all available template set names
sub get_template_sets {
    my ($self) = @_;

    return values %{$self->_template_sets};
}

# Get a list of all templates
sub get_templates {
    my ($self) = @_;

    return values %{$self->_template_map};
}

sub BUILD {
    my $self = shift;

    try {
        $self->_set__templates_data(LoadFile($self->templates_yml));
    } catch {
        die "Error loading template definitions file " . $self->templates_yml . ": $_";
    };
}

1;

