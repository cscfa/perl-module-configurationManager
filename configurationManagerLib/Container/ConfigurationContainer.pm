package ConfigurationContainer;
use strict;
use warnings;

use ParameterException;
use ConfigurationExplorer;

sub new
{
	my $class = shift;
	my ($args) = @_;
	
	my $self = bless {}, $class;
	
	foreach my $argKey (keys(%{$args})) {
		$self->{$argKey} = $args->{$argKey};
	}
	
	if (!$self->{"repositories"}) {
		my $exception = ParameterException->new({
			message => "Repositories must be given to the ConfigurationContainer::new",
			code => "69deb47d1",
			previous => ''
		});
		die $exception;
	}
	
	ConfigurationContainer::makeList($self);
	
	return $self;
}

sub makeList
{
	my $self = shift(@_);
	
	my $explorer = ConfigurationExplorer->new();
	my %configs;
	
	foreach my $repository (@{$self->{"repositories"}}) {
		my $result = $explorer->searchFiles({
			directories => [$repository],
			pattern => ".(yaml|yml)\$",
			recursive => 1,
		});
		
		foreach my $configFile (@{$result}) {
			my ($configKey, $configExtension) = ($configFile =~ /(.+).(yaml|yml)/i);
			$configs{$configKey} = {
				fileName => $configFile,
				repository => ($repository =~ /\/\$/) ? $repository : $repository.'/',
				extension => $configExtension,
				loaded => 0,
				content => undef,
				location => ($repository =~ /\/\$/) ? $repository.$configFile : $repository.'/'.$configFile,
			};
		}
	}

	$self->{"configs"} = \%configs;

	return $self;
}

sub debug
{
	my $self = shift(@_);
	
	my %configs = %{$self->{"configs"}};
	
	foreach my $configKey (keys(%configs)) {
		print "Config file : ";
		print $configKey ." => ".$configs{$configKey}->{location}."\n";
	}
}

sub has
{
	my $self = shift(@_);
	my $key = shift(@_);
	
	if (exists $self->{"configs"}->{$key}) {
		return 1;
	} else {
		return 0;
	}
}

1;
__END__
