package ConfigurationLoader;
use strict;
use warnings;
use ConfigException;
use YAML qw/LoadFile/;

sub new
{
	my $class = shift;
	my ($args) = @_;
	
	my $self = bless {}, $class;
	
	foreach my $argKey (keys($args)) {
		$self->{$argKey} = $args->{$argKey};
	}
	
	if (!$self->{"container"}) {
		my $exception = ParameterException->new({
			message => "ConfigurationContainer must be given to ConfigurationLoader::new",
			code => "96ef36f01",
			previous => '',
		});
		die $exception;
	}
	
	return $self;
}

sub load
{
	my $self = shift(@_);
	my $key = shift(@_);
	
	if ($self->{"container"}->has($key)) {
		my $config = $self->{"container"}->{"configs"}->{$key};
		
		if ($config->{"loaded"}) {
			return $config->{"content"};
		} else {
			$config->{"content"} = LoadFile($config->{"location"});
			$config->{"loaded"} = 1;
			
			return $config->{"content"};
		}
	} else {
		my $exception = ConfigException->new({
			message => "you've requested an unexistant configuration ($key). \n",
			code => "9ef0af6c1",
			previous => '',
		});
		die $exception;
	}
}


1;
__END__
