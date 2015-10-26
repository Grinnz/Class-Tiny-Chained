use strict;
use warnings;

package MyClass;
use Class::Tiny 'foo';
sub bar { 1 }

package MyClass::Chained;
use Class::Tiny::Chained 'foo';
sub bar { 1 }

package MyClass::ToChain;
use Class::Tiny 'foo';
sub bar { 1 }

package main;

use Test::More;
use Test::Identity;

my $obj;

$obj = MyClass->new;
is $obj->foo(2), 2, 'setter is not chained';
is $obj->foo, 2, 'getter is not chained';
is $obj->bar, 1, 'sub is not chained';

Class::Tiny::Chained->chain_attributes('MyClass');
identical $obj->foo(2), $obj, 'setter is chained';
is $obj->foo, 2, 'getter is not chained';
is $obj->bar, 1, 'sub is not chained';

$obj = MyClass::Chained->new;
identical $obj->foo(2), $obj, 'setter is chained';
is $obj->foo, 2, 'getter is not chained';
is $obj->bar, 1, 'sub is not chained';

Class::Tiny::Chained->chain_attributes('MyClass::ToChain');
$obj = MyClass::ToChain->new;
identical $obj->foo(2), $obj, 'setter is chained';
is $obj->foo, 2, 'getter is not chained';
is $obj->bar, 1, 'sub is not chained';

# don't rechain methods
my $method = MyClass::Chained->can('foo');
Class::Tiny::Chained->chain_attributes('MyClass::Chained');
identical $method, MyClass::Chained->can('foo'), 'method was not modified';

done_testing;
