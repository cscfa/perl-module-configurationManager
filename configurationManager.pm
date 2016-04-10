package configurationManager;
use strict;
use warnings;
use FindBin;
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(pass_through);

$ModuleAutoloader::VERSION = "1.1";

my $debugList = '';
GetOptions (
	"ConfigManager-DebugList" => \$debugList,
);

BEGIN
{
	push(@INC, "$FindBin::Bin/configurationManagerLib/Container");
	push(@INC, "$FindBin::Bin/configurationManagerLib/Loader");
	push(@INC, "$FindBin::Bin/configurationManagerLib/YAML-1.15/lib");
}

use ConfigurationContainer;
use ConfigurationLoader;
my @configRepositories;

sub new
{
	my $class = shift;
	my ($args) = @_;
	
	my $self = bless {}, $class;
	
	foreach my $argKey (keys($args)) {
		$self->{$argKey} = $args->{$argKey};
	}
	if ($self->{"repositories"}) {
		foreach my $repository (@{$self->{"repositories"}}) {
			push(@configRepositories, $repository);
		}
	}
	
	$self->{container} = ConfigurationContainer->new({
		"repositories" => [@configRepositories],
	});
	$self->{container}->debug() if $debugList;
	
	$self->{loader} = ConfigurationLoader->new({
		"container" => $self->{container},
	});
	
	return $self;
}

sub get
{
	my $self = shift(@_);
	my $key = shift(@_);
	
	$self->{loader}->load($key);
}

sub import
{
    my $pkg = shift;
    my ($messages) = @_;

    if ( defined $messages ) {
    	if (ref($messages) eq "ARRAY"){
    		foreach my $message (@{$messages}) {
    			$pkg->applyMessage($message);
    		}
    	} else {
    		$pkg->applyMessage($messages);
    	}
    }
    return;
}

sub applyMessage
{
	my $message = shift(@_);
	
	if ($message =~ /^repo=/) {
		my ($repository) = ($message =~ /repo=(.+)/);
		push(@configRepositories, $repository);
	} elsif ($message =~ /^DebugList=/) {
		my ($state) = ($message =~ /DebugList=([01])/);
		$debugList = ($state eq "0") ? 0 : 1;
	}
}

1;
__END__
