package App::DuckPAN;

use Moo;
use MooX::Cmd;
use App::DuckPAN::Config;
use App::DuckPAN::Help;
use File::Which;
use Class::Load ':all';

our $VERSION ||= '0.000';

has config => (
	is => 'ro',
	builder => '_build_config',
	lazy => 1,
	handles => [qw(
		config_path
	)]
);

sub _build_config { App::DuckPAN::Config->new }

has help => (
	is => 'ro',
	builder => '_build_help',
	lazy => 1,
);

sub _build_help { App::DuckPAN::Help->new( version => $VERSION ) }

has perl => (
	is => 'ro',
	builder => '_build_perl',
	lazy => 1,
);

sub _build_perl { 
	load_class('App::DuckPAN::Perl');
	App::DuckPAN::Perl->new( app => shift );
}

sub execute {
	my ( $self, $args, $chain ) = @_;
	print $self->help->help;
}

sub check_requirements {
	my ( $self ) = @_;
	my $fail = 0;
	print "Checking your environment for the DuckPAN requirements\n";
	#$fail = 1 unless $self->check_locallib;
	$fail = 1 unless $self->check_git;
	$fail = 1 unless $self->check_wget;
}

sub check_git {
	my ( $self ) = @_;
	my $ok = 1;
	print "Checking for git... ";
	if (my $git = which('git')) {
		my $version_string = `$git --version`;
		if ($version_string =~ m/git version (\d+)\.(\d+)\.(\d+)\.(\d+)/) {
			if ($1 <= 1 && $2 < 7) {
				print "require minimum 1.7"; $ok = 0;
			} else {
				print $git;
			}
		} else {
			print "Unknown version!"; $ok = 0;
		}
	} else {
		print "No!"; $ok = 0;
	}
	print "\n";
	return $ok;
}

sub check_wget {
	my ( $self ) = @_;
	my $ok = 1;
	print "Checking for wget... ";
	if (my $wget = which('wget')) {
		print $wget;
	} else {
		print "No!"; $ok = 0;
	}
	print "\n";
	return $ok;
}

# sub check_locallib {
	# my ( $self ) = @_;
	# my $ok = 1;
	# print "Checking for local::lib installation... ";
	# if (my $perl5lib = $ENV{PERL5LIB}) {
		# my @paths = split(/:/,$perl5lib);
		# print "Yes";
	# } else {
		# print "No!"; $ok = 1;
	# }
	# print "\n";
	# return $ok;
# }

1;
