package configurationManager;
use strict;
use warnings;
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(pass_through);

$ModuleAutoloader::VERSION = "1.1";

my $debugList = '';
GetOptions (
	"ConfigManager-DebugList" => \$debugList,
);

my $currentFileDirectory = " ";
BEGIN
{
	foreach my $dir (@INC) {
		next if (!defined $dir);
		next if (ref($dir));
		if (-f $dir."/configurationManager.pm") {
			$currentFileDirectory = $dir."/";
			last;
		}
	}
	
	if ($currentFileDirectory eq " ") {
		die BaseException->new({
			message => "configurationManager can't resolve itself dependancy",
			code => "3a8ddc3b1",
			previous => undef,
		});
	}
	
	push(@INC, $currentFileDirectory."/configurationManagerLib/Container");
	push(@INC, $currentFileDirectory."/configurationManagerLib/Loader");
	push(@INC, $currentFileDirectory."/configurationManagerLib/YAML-1.15/lib");
	push(@INC, $currentFileDirectory."/configurationManagerLib/Exception");
	push(@INC, $currentFileDirectory."/configurationManagerLib/Explorer");
	push(@INC, $currentFileDirectory."/configurationManagerLib");
}

use ConfigurationContainer;
use ConfigurationLoader;
my @configRepositories;

sub new
{
	my $class = shift;
	my ($args) = @_;
	
	my $self = bless {}, $class;
	
	foreach my $argKey (keys(%{$args})) {
		$self->{$argKey} = $args->{$argKey};
	}
	
	my @selfRepositories;
	push(@selfRepositories, $_) foreach (@configRepositories);
	if ($self->{"repositories"}) {
		foreach my $repository (@{$self->{"repositories"}}) {
			push(@selfRepositories, $repository);
		}
	}
	
	$self->{container} = ConfigurationContainer->new({
		"repositories" => [@selfRepositories],
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
	my $pkg = shift(@_);
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
