package ParameterException;
use strict;
use warnings;

$ParameterException::VERSION = "1.0";

use BaseException;
use parent qw(BaseException);

1;
__END__

=begin markdown

# ParameterException
The ParameterException package define base parameter
error exception. It's used to inform that a method parameter
not corresponding as the normal assertion on itself.

Child of [BaseException](./BaseException.md)

Use [strict](http://perldoc.perl.org/strict.html)
Use [warnings](http://perldoc.perl.org/warnings.html)

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
