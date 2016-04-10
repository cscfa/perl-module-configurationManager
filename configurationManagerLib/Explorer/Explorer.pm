package Explorer;
use strict;
use warnings;

use ParameterException;
use DirectoryException;

$Explorer::VERSION = "1.0";

sub new
{
	my $class = shift(@_);
	my ($arguments) = @_;
	my $self = bless({}, $class);
	return $self;
}

sub searchDirectoriesContaining
{
	my ($self) = shift;
	my ($args) = @_;
	
	if (!defined $args->{"directories"}) {
		die ParameterException->new({
			message => "directories parameter must be given for Explorer::search.",
			code => "075055f31",
		});
	}
	my $pattern = (defined $args->{"pattern"}) ? $args->{"pattern"} : ".+";
	
	my @directories;
	
	if (defined $args->{"recursive"} and $args->{"recursive"}) {
		foreach my $directory (@{$args->{"directories"}}) {
			my @directory = @{Explorer::recursiveSearchDirectoriesContaining($self, {
				directory => $directory,
				pattern => $pattern
			})};
			foreach my $recursiveDir (@directory) {
				push(@directories, $recursiveDir);
			}
		}
	} else {
		foreach my $directory (@{$args->{"directories"}}) {
			my $tmpResult = Explorer::getDirectoryContent($self, {
				directory => $directory,
				withoutDirectory => 1,
				pattern => $pattern
			});

			if (@{$tmpResult->{file}}) {
				push(@directories, $directory);
			}
		}
	}
	
	return \@directories;
}

sub recursiveSearchDirectoriesContaining
{
	my ($self) = shift;
	my ($args) = @_;
	
	if (!defined $args->{"directory"}) {
		die ParameterException->new({
			message => "directory parameter must be given for Explorer::recursiveSearch.",
			code => "36829afc1",
		});
	}
	my $pattern = (defined $args->{"pattern"}) ? $args->{"pattern"} : ".+";

	my @directories;
	my $tmpResult = Explorer::getDirectoryContent($self, {
		directory => $args->{"directory"},
		pattern => $pattern
	});
	
	if (@{$tmpResult->{file}}) {
		push(@directories, $args->{"directory"});
	}

	if (@{$tmpResult->{directory}}) {
		foreach my $recursion (@{$tmpResult->{directory}}){
			my @recursive = @{Explorer::recursiveSearchDirectoriesContaining($self, {
				directory => $args->{"directory"}."/".$recursion,
				pattern => $pattern
			})};
			foreach my $recursionDir (@recursive) {
				push(@directories, $recursionDir);
			}
		}
	}
	
	return \@directories;
}

sub searchFiles
{
	my ($self) = shift;
	my ($args) = @_;
	
	if (!defined $args->{"directories"}) {
		die ParameterException->new({
			message => "directories parameter must be given for Explorer::searchFiles.",
			code => "174e02371",
		});
	}
	my $pattern = (defined $args->{"pattern"}) ? $args->{"pattern"} : ".+";
	
	my @files;
	
	if (defined $args->{"recursive"} and $args->{"recursive"}) {
		foreach my $directory (@{$args->{"directories"}}) {
			my @resultFiles = @{Explorer::recursiveSearchFiles($self, {
				directory => $directory,
				pattern => $pattern
			})};
			foreach my $recursiveFile (@resultFiles) {
				push(@files, $recursiveFile);
			}
		}
	} else {
		foreach my $directory (@{$args->{"directories"}}) {
			my $tmpResult = Explorer::getDirectoryContent($self, {
				directory => $directory,
				pattern => $pattern
			});

			if (@{$tmpResult->{file}}) {
				foreach my $recursiveFile (@{$tmpResult->{file}}) {
					push(@files, $recursiveFile);
				}
			}
		}
	}
	
	return \@files;
}

sub recursiveSearchFiles
{
	my ($self) = shift;
	my ($args) = @_;
	
	if (!defined $args->{"directory"}) {
		die ParameterException->new({
			message => "directory parameter must be given for Explorer::recursiveSearchFiles.",
			code => "f3608d5a1",
		});
	}
	my $pattern = (defined $args->{"pattern"}) ? $args->{"pattern"} : ".+";

	my @files;
	my $tmpResult = Explorer::getDirectoryContent($self, {
		directory => $args->{"directory"},
		pattern => $pattern
	});
	
	if (@{$tmpResult->{file}}) {
		foreach my $recursionFile (@{$tmpResult->{file}}) {
			push(@files, $recursionFile);
		}
	}

	if (@{$tmpResult->{directory}}) {
		foreach my $recursion (@{$tmpResult->{directory}}){
			my @recursive = @{Explorer::recursiveSearchFiles($self, {
				directory => $args->{"directory"}."/".$recursion,
				pattern => $pattern
			})};
			foreach my $recursionFile (@recursive) {
				push(@files, $recursionFile);
			}
		}
	}
	
	return \@files;
}

sub getDirectoryContent
{
	my ($self) = shift;
	my ($args) = @_;
	
	if (!defined $args->{"directory"}) {
		die ParameterException->new({
			message => "directory parameter must be given for Explorer::getDirectoryContent.",
			code => "1d1572fb1",
		});
	}
	my $filePattern = (defined $args->{"pattern"}) ? $args->{"pattern"} : ".+";
	my $dirPattern = (defined $args->{"directoryPattern"}) ? $args->{"directoryPattern"} : ".+";
	my $allowDirectory = !(defined $args->{"withoutDirectory"});
	my $allowFile = !(defined $args->{"withoutFile"});
	
	opendir(my $dh, $args->{"directory"}) || die DirectoryException->new({
		message => "directory parameter must be readable for Explorer::getDirectoryContent. Given : ".$args->{"directory"},
		code => "1d1572fb2",
	});
	
	my $result;
	$result->{file} = [];
	$result->{directory} = [];
	while(readdir $dh) {
		my $f = $_;
		if (!($f =~ /^\./)) {
			if (-f $args->{"directory"} . "/" . $f) {
				if ($f =~ /$filePattern/) {
					if ($allowFile) {
						push($result->{file}, $f);
					}
				}
			}
		}
		
		if (!($f =~ /^\./)) {
			if (-d $args->{"directory"} . "/" . $f) {
				if ($f =~ /$dirPattern/) {
					if ($allowDirectory) {
						push($result->{directory}, $f);
					}
				}
			}
		}
	}
	
	closedir $dh || die DirectoryException->new({
		message => "directory parameter must be closeable for Explorer::getDirectoryContent.",
		code => "1d1572fb3",
	});
	
	return $result;
}

1;
__END__

=begin markdown

# Explorer
The Explorer package introduce directory exploring.

Use [strict](http://perldoc.perl.org/strict.html)
Use [warnings](http://perldoc.perl.org/warnings.html)

Version: 1.0
Date: 2016/04/09
Author: Matthieu vallance <matthieu.vallance@cscfa.fr>
Module: [configurationManager](../../configurationManager.md)
License: MIT

## Attributes

No one now

## Methods

#### New

Base Explorer default constructor

**return:** Explorer


#### searchDirectoriesContaining
	
This search method allow to search a specified file pattern
into a directory recursively or not. Give params as hash.

**param:** text       pattern     the file pattern to search for
**param:** array:text directories a set of directory where search the file
**param:** boolean    recursive   the recursion search state

**return:** a reference to an array containing each of the directories that contain a file matching the given pattern

#### recursiveSearchDirectoriesContaining

_note: internal use only, perform searchDirectoriesContaining with 'recursive'.

This search method perform the same things as searchDirectoriesContaining but
force recursive.

**param:** text       pattern     the file pattern to search for
**param:** array:text directories a set of directory where search the file

**return:** a reference to an array containing each of the directories that contain a file matching the given pattern

#### getDirectoryContent

This method return a set of file and directory that exists into
the given directory. It allowed to perform a patern matching.

**param:** give parameters into an object
	* text    directory        The directory where searh
	* text    pattern          The file pattern to match [optional][default: ".+"]
	* text 	  directoryPattern The directory pattern to match [optional][default: ".+"]
	* boolean withoutDirectory Exclude directory from search results [optional][default: false]
	* boolean withoutFile      Exclude files from search results [optional][default: false]
	
**throw:** DirectoryException if opendir or closedir failed
**throw:** ParameterException if directory parameter is omited

**return:** a pseudo object that contain:
	* file: an array of finded files
	* directory: an array of finded directories
=end markdown