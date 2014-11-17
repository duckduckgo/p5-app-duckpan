package App::DuckPAN::Cmd::New;
# ABSTRACT: Take a name as input and generates a new, named Goodie or Spice instant answer skeleton

# For Goodies:
# 	- <name>.pm file is created in lib/DDG/Goodie
#
# For Spice:
# 	- <name>.pm file is created in lib/DDG/Spice
# 	- directory /share/spice/<name> is created
# 	- <name.js> is created in /share/spice/<name>
# 	- <name.handlebars> is created in /share/spice/<name>

use Moo;
with qw( App::DuckPAN::Cmd );
use Text::Xslate qw(mark_raw);
use Path::Tiny;


sub run {
	my ($self, @args) = @_;

	# Check which IA repo we're in...
	my $type = $self->app->ia_type;

	# Instant Answer name as parameter
	my $entered_name = (@args) ? join(' ', @args) : $self->app->get_reply('Please enter a name for your Instant Answer');
	$self->app->emit_and_exit(-1, "Must supply a name for your Instant Answer.") unless $entered_name;
	$entered_name =~ s/\//::/g;    #change "/" to "::" for easier handling
	my $name = $self->app->phrase_to_camel($entered_name);
	my ($package_name, $separated_name, $path, $lc_path) = ($name, $name, "", "");
	$separated_name =~ s/::/ /g;

	if ($entered_name =~ m/::/) {
		my @path_parts = split(/::/, $entered_name);
		if (scalar @path_parts > 1) {
			$name    = pop @path_parts;
			$path    = join("/", @path_parts);
			$lc_path = join("/", map { $self->app->camel_to_underscore($_) } @path_parts);
		} else {
			$self->app->emit_and_exit(-1, "Malformed input. Please provide a properly formatted package name for your Instant Answer.");
		}
	}

	my $lc_name     = $self->app->camel_to_underscore($name);
	my $filepath    = ($path eq "") ? $name : "$path/$name";
	my $lc_filepath = ($lc_path eq "") ? $lc_name : "$lc_path/$lc_name";
	if (scalar $lc_path) {
		$lc_path =~ s/\//_/g;    #safe to modify, we already used this in $lc_filepath
		$lc_name = $lc_path . "_" . $lc_name;
	}

	$self->app->emit_and_exit(-1, "No templates exist for this IA Type: " . $type->{name}) if (!defined $type->{templates});

	my %template_info = %{$type->{templates}};
	my $tx            = Text::Xslate->new();
	my %files         = (
		test       => ["$filepath.t"],
		code       => ["$filepath.pm"],
		handlebars => [$lc_filepath, "$lc_name.handlebars"],
		js         => [$lc_filepath, "$lc_name.js"]);
	my %vars = (
		ia_name           => $name,
		ia_package_name   => $package_name,
		ia_name_separated => $separated_name,
		lia_name          => $lc_name,
		ia_path           => $filepath
	);
	foreach my $template_type (sort keys %template_info) {
		my ($source, $dest) = ($template_info{$template_type}{in}, $template_info{$template_type}{out});
		$self->app->emit_and_exit(-1, 'Template does not exist: ' . $source) unless ($source->exists);
		# Update dest based on type:
		$dest = $dest->child(@{$files{$template_type}});
		$self->app->emit_and_exit(-1, 'File already exists: "' . $dest->basename . '" in ' . $dest->parent) if ($dest->exists);
		my $content = $tx->render("$source", \%vars);
		$dest->touchpath->append_utf8($content);    #create file path and append to file
		$self->app->emit_info("Created file: $dest");
	}
	$self->app->emit_info("Successfully created " . $type->{name} . ": $package_name");
}

1;
