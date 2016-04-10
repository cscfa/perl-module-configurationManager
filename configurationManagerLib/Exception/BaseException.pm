package BaseException;
use strict;
use warnings;

$BaseException::VERSION = "1.0";

sub new
{
	my $class = shift(@_);
	my ($arguments) = @_;
	my $self = bless({}, $class);
	
	foreach my $attribute ("message", "code", "previous"){
		$self->{$attribute} = (!defined $arguments->{$attribute}) ? "" : $arguments->{$attribute};
	}
	
	return $self;
}

sub getPrevious
{
	my $self = shift(@_);
	return $self->{"previous"};
}

sub setPrevious
{
	my ($self, $value) = @_;
	$self->{"previous"} = $value;
	
	return $self;
}

sub getCode
{
	my $self = shift(@_);
	return $self->{"code"};
}

sub setCode
{
	my ($self, $value) = @_;
	$self->{"code"} = $value;
	
	return $self;
}

sub getMessage
{
	my $self = shift(@_);
	return $self->{"message"};
}

sub setMessage
{
	my ($self, $value) = @_;
	$self->{"message"} = $value;
	
	return $self;
}

1;
__END__

=begin markdown

# BaseException
The BaseException package introduce the base exception
object that store a message, a code and a previous exception.

Use [strict](http://perldoc.perl.org/strict.html)
Use [warnings](http://perldoc.perl.org/warnings.html)

[ParameterException](./ParameterException.md) is a child
[DirectoryException](./DirectoryException.md) is a child
[YamlException](./YamlException.md) is a child

Version: 1.0
Date: 2016/04/09
Author: Matthieu vallance <matthieu.vallance@cscfa.fr>
Module: [configurationManager](../../configurationManager.md)
License: MIT

## Attributes

name | scope | type
---- | ----- | ----
message | public | text
code | public | integer
previous | public | Exception

## Methods

#### New

Base exception default constructor

**param:** Give arguments into a Hash object
	* text      'message'  the message of the exception
	* integer   'code'	   the exception code
	* exception 'previous' the previous exception
	
**return:** Exception


#### Get previous

This method return the object previous exception

**return:** Exception


#### Set previous

This method allow to update the object previous exception

**param:** Exception previous The previous exception of the current object

**return:** Exception


#### Get code

This method return the object code status

**return:** text


#### Set code

This method allow to update the object code status

**param:** integer code The object code status to set

**return:** Exception


#### Get message

This method return the object message value

**return:** text


#### Set message

This method allow to update the object message value

**param:** text message The message text to set

**return:** Exception

=end markdown