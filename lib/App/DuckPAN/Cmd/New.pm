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
use Data::Dumper;
with qw( App::DuckPAN::Cmd );
use Text::Xslate qw(mark_raw);
use IO::All;

sub run {
	my ( $self, @args ) = @_;

	# Instant Answer name as parameter
	my $entered_name = (@args) ? join(' ', @args) : $self->app->get_reply('Please enter a name for your Instant Answer');
	my $name = $self->app->phrase_to_camel($entered_name);
	my $lc_name = $self->app->camel_to_underscore($name);

	# %templates forms the spine data structure which is used
	# as a guide to discovering content which is moved around
	my %templates = (
		goodie => {
			lib_dir => "./lib/DDG/Goodie",
			files => {
				"./template/lib/DDG/Goodie/Example.pm" => "./lib/DDG/Goodie/$name.pm",
				"./template/t/Example.t" => "./t/$name.t",
			},
		},

		spice => {
			lib_dir => "./lib/DDG/Spice",
			share_dir => "./share/spice/$lc_name",
			files => {
				"./template/lib/DDG/Spice/Example.pm" => "./lib/DDG/Spice/$name.pm",
				"./template/t/Example.t" => "./t/$name.t",
				"./template/share/spice/example/example.handlebars" => "./share/spice/$lc_name/$lc_name.handlebars",
				"./template/share/spice/example/example.js" => "./share/spice/$lc_name/$lc_name.js"
			}
		}
	);

	# Check if we're in a Goodie repository
	if (-d $templates{'goodie'}{'lib_dir'}) {
		
		for my $filename (keys %{$templates{'goodie'}{'files'}}) {
			my $dest = $templates{'goodie'}{'files'}{$filename};
			if (-e $dest) {
				$self->app->print_text("[ERROR] File already exists: $name $dest");
				exit -1;
			}
			unless (-e $filename) {
				$self->app->print_text("[ERROR] Template does not exist: $filename");
				exit -1;
			}
		}

		while (my ($source, $dest) = each(%{$templates{'goodie'}{'files'}})) {
			my $tx = Text::Xslate->new();
			my %vars = (ia_name => $name,	lia_name => $lc_name);
			my $content = $tx->render($source, \%vars);
			io($dest)->append($content);
			$self->app->print_text("Created file: $dest");
		}
		$self->app->print_text("Successfully created Goodie: $name ");
	}

	# Check if we're in a Spice repository
	elsif (-d $templates{'spice'}{'lib_dir'}) {

		if (-d $templates{'spice'}{'share_dir'}) {
			$self->app->print_text("[ERROR] Instant answer already exists: $name");
			exit -1;
		}	else {
			for my $filename (keys %{$templates{'spice'}{'files'}}) {
				my $dest = $templates{'spice'}{'files'}{$filename};
				if (-e $dest) {
					$self->app->print_text("[ERROR] File already exists: $name $dest");
					exit -1;
				}
				unless (-e $filename) {
					$self->app->print_text("[ERROR] Template does not exist: $filename");
					exit -1;
				}
			}

			mkdir $templates{'spice'}{'share_dir'};
			while (my ($source, $dest) = each(%{$templates{'spice'}{'files'}})) {
				my $tx = Text::Xslate->new();
				my %vars = (ia_name => $name,
					lia_name => $lc_name);
				my $content = $tx->render($source, \%vars);

				io($dest)->append($content);

				$self->app->print_text("Created file: $dest");
			}
			$self->app->print_text("Successfully created Spice: $name");
		}
	}

	# [TODO] Implement Fathead and Longtail templates

	else {
		$self->app->print_text("[ERROR] No lib/DDG/Goodie, lib/DDG/Spice, lib/DDG/Fathead or lib/DDG/Longtail found");
	}
}

1;
