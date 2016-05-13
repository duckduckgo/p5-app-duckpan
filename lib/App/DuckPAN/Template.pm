package App::DuckPAN::Template;
# ABSTRACT: Template to generate one file of an Instant Answer

# An Instant Answer has multiple templates, each of which can be used
# to generate one output file.

use Moo;

use Try::Tiny;
use Text::Xslate;
use Path::Tiny qw(path);
use List::Util qw(pairs);
use Carp;

use namespace::clean;

has id => (
	is       => 'ro',
	required => 1,
	doc      => 'Unique ID of the template',
);

has label => (
	is       => 'ro',
	required => 1,
	doc      => 'Label of the template',
);

has input_file => (
	is       => 'ro',
	required => 1,
	doc      => 'Path of the input file for the template',
);

has output_file => (
	is       => 'ro',
	required => 1,
	doc      => 'Path of the output file for the template. ' .
	            'This string is rendered through Text::Xslate to get the final path. ' .
	            'If a CODE reference is provided, then it is used to generate the template ' .
	            'string for use with XSlate; it is passed the same arguments as XSlate would receive.',
);

has _template_dir_top => (
	is	     => 'ro',
	required => 1,
	doc      => 'Top-level directory containing all templates.',
	init_arg => 'template_directory',
);

has allow => (
	is => 'rwp',
	required => 1,
	doc => 'CODE reference that indicates whether a particular ' .
					'Instant Answer is supported by the template.',
	trigger => \&_normalize_allow_to_sub,
);

sub _normalize_allow_to_sub {
	my ($self, $allow) = @_;
	if (ref $allow eq 'CODE') {
		return $allow;
	}
	elsif (ref $allow eq 'ARRAY') {
		$self->_set_allow(sub {
			my $vars = shift;
			return 1 if grep { $_->($vars) } @$allow;
			return 0;
		});
	}
	else {
		croak("Cannot use @{[ref $allow]} as a predicate");
	}
}

sub supports {
	my ($self, $what) = @_;
	return $self->allow->($what);
}

has _configure => (
	is => 'ro',
	default => sub { [] },
	init_arg => 'configure',
);

sub configure {
	my ($self, %options) = @_;
	my $separated = $options{ia}->{perl_module} =~ s{::}{/}gr;
	my $base_separated = $separated =~ s{^DDG/[^/]+/}{}r;
	my %vars = (
		ia                     => $options{ia},
		repo                   => $options{app}->repository,
		package_separated      => $separated,
		package_base_separated => $base_separated,
	);
	my $app = $options{app};
	my @configs = @{$self->_configure};
	# Build the configured variables from the definitions.
	foreach (pairs @configs) {
		my ($output_var, $config) = @$_;
		my $cfg  = $config->{configure};
		my $val;
		if (ref $cfg eq 'CODE') {
			$val = $cfg->(%vars);
		}
		else {
			my $type = $config->{type} // 'no_config';
			if ($type eq 'reply') {
				$val = $app->get_reply($cfg->{prompt}, %$cfg);
			}
		}
		$vars{$output_var} = $val;
	}
	$self->generate($app, \%vars);
}

sub indent {
	my $prefix = shift;
	$prefix = ' ' x $prefix if $prefix =~ /^\d+$/;
	return sub {
		my $text = shift;
		join "\n", map { "$prefix$_" } split "\n", $text;
	};
}

# Create the output file from the input file
sub generate {
	my ($self, $app, $vars) = @_;

	# Increased verbosity to help while writing templates
	my $tx = Text::Xslate->new(
		path    => $self->_template_dir_top,
		type    => 'text',
		verbose => 2,
		function => {
			indent => \&indent,
		},
	);

	my $input_file = ref $self->input_file eq 'CODE'
		? path($tx->render_string($self->input_file->($vars), $vars))
		: path($tx->render_string($self->input_file, $vars));

	my $output_file = ref $self->output_file eq 'CODE'
		? path($tx->render_string($self->output_file->($vars), $vars))
		: path($tx->render_string($self->output_file, $vars));

	carp("Template output file $output_file already exists") and return if $output_file->exists;

	my $content = $tx->render($input_file, $vars);

	try {
	    path($output_file)->touchpath->spew_utf8($content);
	} catch {
	    croak "Error creating output file '$output_file' from template: $_";
	};

	return $output_file;
}

1;

