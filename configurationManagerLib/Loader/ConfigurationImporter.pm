package ConfigurationImporter;
use strict;
use warnings;
require Exporter;

sub import
{
	no strict 'refs';
	no warnings 'once';
	
	my ($args) = @_;
	return if(!exists $args->{"content"});
	return if(!defined $args->{"content"});
	
	my $content = ${$args->{"content"}};
	my $loader = $args->{"loader"};

	foreach my $contentKey (keys($content)) {
		next if ($contentKey ne "import");
		
		my @importedFiles;;
		if (ref(\$content->{$contentKey}) eq "SCALAR") {
			push(@importedFiles, $content->{$contentKey});
		} elsif (ref($content->{$contentKey}) eq "ARRAY") {
			push(@importedFiles, $_) foreach (@{$content->{$contentKey}});
		}
		
		delete $content->{$contentKey};
		foreach my $importedFile (@importedFiles) {
			my $importedContent = $loader->load($importedFile);
			
			foreach my $importedContentKey (keys($importedContent)) {
				if (!exists $content->{$importedContentKey}) {
					$content->{$importedContentKey} = $importedContent->{$importedContentKey};
				}
			}
		}
	}
}

1;
__END__
