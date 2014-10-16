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
use IO::All;
use File::Path qw(make_path);

sub run {
	my ( $self, @args ) = @_;

	# Instant Answer name as parameter
	my $entered_name = (@args) ? join(' ', @args) : $self->app->get_reply('Please enter a name for your Instant Answer');
	my $name = $self->app->phrase_to_camel($entered_name);
	my ($path, $lc_path) = ("", "");
	my $package_name = $name;

	if ($entered_name =~ m/::|\//) {
		my @path_parts = split(/::|\//, $entered_name);
		$name = pop @path_parts;
		$path = join("/", @path_parts);
		$path .= "/";
		$lc_path = $self->app->camel_to_underscore($path);
		$package_name =~ s/\//::/;
	}

	my $lc_name = $self->app->camel_to_underscore($name);

	# %templates forms the spine data structure which is used
	# as a guide to discovering content which is moved around
	my %templates = (
		Goodie => {
			lib_dir => "./lib/DDG/Goodie",
			dirs => [
				"./lib/DDG/Goodie/$path",
				"./t/$path",
			],
			files => {
				"./template/lib/DDG/Goodie/Example.pm" => "./lib/DDG/Goodie/$path"."$name.pm",
				"./template/t/Example.t" => "./t/$path"."$name.t",
			},
		},

		Spice => {
			lib_dir => "./lib/DDG/Spice",
			share_dir => "./share/spice/$lc_path"."$lc_name",
			dirs => [
				"./lib/DDG/Spice/$path",
				"./t/$path",
				"./share/spice/$lc_path",
				"./share/spice/$lc_path",
			],
			files => {
				"./template/lib/DDG/Spice/Example.pm" => "./lib/DDG/Spice/$path"."$name.pm",
				"./template/t/Example.t" => "./t/$path"."$name.t",
				"./template/share/spice/example/example.handlebars" => "./share/spice/$lc_path"."$lc_name/$lc_name.handlebars",
				"./template/share/spice/example/example.js" => "./share/spice/$lc_path"."$lc_name/$lc_name.js"
			}
		},
		Fathead => {
			lib_dir => "./lib/DDG/Fathead",
			# [TODO] Implement Fathead templates
		},
		Longtail => {
			lib_dir => "./lib/DDG/Longtail",
			# [TODO] Implement Fathead templates
		}
	);

	# Check which IA repo we're in...
	my $type = "";
	if (-d $templates{'Goodie'}{'lib_dir'}) {
		$type = "Goodie";
	} elsif (-d $templates{'Spice'}{'lib_dir'}) {
		$type = "Spice";
	} elsif (-d $templates{'Fathead'}{'lib_dir'}) {
		$type = "Fathead";
		$self->app->print_text("[ERROR] Sorry, DuckPAN does not support Fatheads yet!");
		exit -1;
	} elsif (-d $templates{'Longtail'}{'lib_dir'}) {
		$type = "Longtail";
		$self->app->print_text("[ERROR] Sorry, DuckPAN does not support Longtails yet!");
		exit -1;
	} else {
		$self->app->print_text("[ERROR] No lib/DDG/Goodie, lib/DDG/Spice, lib/DDG/Fathead or lib/DDG/Longtail found");
	}

	while (my ($source, $dest) = each(%{$templates{$type}{'files'}})) {
		my $io = io($dest);
		if ($io->exists) {
			my $filename = $io->filename;
			my $filepath= $io->filepath;
			$self->app->print_text("[ERROR] File already exists: \"$filename\" in $filepath");
			exit -1;
		}
		unless (-e $source) {
			$self->app->print_text("[ERROR] Template does not exist: $source");
			exit -1;
		}

		my $tx = Text::Xslate->new();
		my %vars = (ia_name => $name, lia_name => $lc_name);
		my $content = $tx->render($source, \%vars);
		$io->file->assert->append($content); #create file path and append to file
		$self->app->print_text("Created file: $dest");
	}
	$self->app->print_text("Successfully created $type: $name");
}

1;
