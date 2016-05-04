package App::DuckPAN::InstantAnswer::Util;
# ABSTRACT: Utilities for working with Instant Answer Metadata.

BEGIN {
	require Exporter;

	our @ISA = qw(Exporter);

	our %EXPORT_TAGS = (
		predicate => [qw(is_cheat_sheet is_spice is_goodie)],
	);
	our @EXPORT_OK = (qw(find_ia_files), map { @$_ } values %EXPORT_TAGS);
}

use Path::Tiny;
use File::Find::Rule;

# Repo, but make sure there is no 's' on the end.
sub _share_repo {
	my $repo = shift;
	return lc ($repo =~ s/s$//ir);
}

sub _lib_repo { ucfirst _share_repo(shift) }

# Currently hard-coded as we know where they all are.
my $cheat_dir = path('share/goodie/cheat_sheets/json');

# Repository-specific paths that can be derived from metadata.
sub repo_paths {
	my $ia = shift;
	# Goodie/Spice etc.
	my $lib_repo = _lib_repo($ia->{repo});
	# goodie/spice etc.
	my $share_name = _share_repo($ia->{repo});
	my $back_end_dir = path("lib/DDG/$lib_repo");
	my $share_dir = path("share/$share_name");
	my $local_share = path($share_dir, $ia->{id});
	if (is_cheat_sheet($ia) eq 'cheat_sheet') {
		$local_share = $share_dir->child('cheat_sheets');
	}
	return (
		share           => $share_dir,
		local_share     => $local_share,
		# Location of Instant Answer back-end packages
		back_end_dir    => $back_end_dir,
	);
}

sub is_cheat_sheet {
	my $ia = shift;
	return $ia->{id} =~ /_cheat_sheet$/;
}

sub is_goodie {
	my $ia = shift;
	return $ia->{repo} eq 'goodies';
}

sub is_spice {
	my $ia = shift;
	return $ia->{repo} eq 'spice';
}

# Find the file for a cheat sheet given the metadata.
sub find_cheat_sheet {
	my $ia = shift;
	my $fname = $ia->{id} =~ s/_cheat_sheet$//r;
	$fname =~ s/_/-/g;
	$fname .= '.json';
	return File::Find::Rule->name($fname)->in($cheat_dir);
}

sub _path_from_package {
	my $package = shift;
	return $package =~ s{::}{/}gr;
}

# Find all *existing* files for an Instant Answer.
sub find_ia_files {
	my $ia = shift;
	# All files found.
	my @all;
	# Files found that aren't 'special' (named).
	my @other;
	# 'Special' files.
	my %named;
	my %meta_paths = repo_paths($ia);
	if (is_cheat_sheet($ia)) {
		my ($cheat_file, @other_cheats) = find_cheat_sheet($ia);
		$named{cheat_sheet} = $cheat_file;
		push @other, @other_cheats;
	} else {
		# Back-end files
		my $ddg_path = _path_from_package($ia->{perl_module});
		my $back_end_module = path('lib', "${ddg_path}.pm");
		$back_end_module = undef unless $back_end_module->exists;
		my $back_end_dir = path('lib', $ddg_path);
		my @other_back_end = File::Find::Rule->name('*')->in($back_end_dir);
		$named{back_end_module} = $back_end_module;
		push @other, @other_back_end;
		# Share files
		push @other, File::Find::Rule->name('*')
			->in($meta_paths{local_share});
	}
	%named = map { $_ => path($named{$_}) } grep { $named{$_} } (keys %named);
	@other = map { path($_) } grep { $_ } @other;
	my %n = map { $_ => 1 } grep { $_ } (@other, values %named);
	@all = map { path($_) } keys %n;
	return (
		named => \%named,
		all   => \@all,
		other => \@other,
	);
}

1;

__END__
