# perl-module-configurationManager
The configuration manager perl module is used to dynamicaly load YAML configuration files with leazy load

## Define the configuration repository:

To define a repository, several ways exists:

#### With use statement :

The repositories defined by the use statement are shared between each configuration manager.

```perl
use FindBin;
use configurationManager ["repo=".$FindBin::Bin."/conf", "repo=/an/other/config"];
```

#### With the 'new' subroutine

By instanciate a new configurationManager with repositories, you assign to this manager a self repository that is not shared with the others.

```perl
use configurationManager;

my $altConfig = configurationManager->new({
	repositories => [$FindBin::Bin."/altConf"],
});
```

## Get configuration

The configurationManager offer access to the configuration behind the 'get' subroutine. The parameter to give as argument is the configuration filename without extension. If the file is into a recursive repository, give the relative path to it.

### Example:
```
/path/to/the/repository:
	-> myConfig.yaml
	-> mySecondConfig.yaml
	-> aDirectory:
		-> anotherConfig.yaml
```
##### content of /path/to/the/repository/myConfig.yaml :
```yaml
hello: "world"
my: "name"
```

##### content of /path/to/the/repository/aDirectory/anotherConfig.yaml :
```yaml
hello: "state"
my: "purpose"
```

##### code :
```perl
use configurationManager;
use Data::Dumper;

my $manager = configurationManager->new({
	repositories => ["/path/to/the/repository"],
});

print Dumper $manager->get("myConfig");
# $VAR1 = {
# 		'hello' => 'world',
#		'my' => 'name'
# };

print Dumper $manager->get("aDirectory/anotherConfig");
# $VAR2 = {
# 		'hello' => 'state',
#		'my' => 'purpose'
# };
```

## Reserved keys :

name | purpose | content
---- | ------- | -------
import | Import another configuration | scalar OR array

### Import

The import key is used to automatically load another configuration into the current one. Note, the importation is done by first level key, and the imported configuration never override the current.

##### example:
```
/path/to/the/repository:
	-> myConfig.yaml
	-> mySecondConfig.yaml
```
##### content of /path/to/the/repository/myConfig.yaml :
```yaml
hello: "world"
my: "name"
import: "mySecondConfig"
```
##### content of /path/to/the/repository/mySecondConfig.yaml :
```yaml
is: "bergamote"
and: 'I'
eat: "strudle"
```

##### code :
```perl
use configurationManager;
use Data::Dumper;

my $manager = configurationManager->new({
	repositories => ["/path/to/the/repository"],
});

print Dumper $manager->get("myConfig");
# $VAR1 = {
# 		'hello' => 'world',
#		'my' => 'name',
#		'is' => 'bergamote',
#		'and' => 'I',
#		'eat' => 'strudle'
# };
```
