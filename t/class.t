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

my $obj;

$obj = MyClass->new;
is $obj->foo(2), 2, 'setter is not chained';
is $obj->foo, 2, 'getter is not chained';
is $obj->bar, 1, 'sub is not chained';

Class::Tiny::Chained->chain_attributes('MyClass');
is $obj->foo(2), $obj, 'setter is chained';
is $obj->foo, 2, 'getter is not chained';
is $obj->bar, 1, 'sub is not chained';

$obj = MyClass::Chained->new;
is $obj->foo(2), $obj, 'setter is chained';
is $obj->foo, 2, 'getter is not chained';
is $obj->bar, 1, 'sub is not chained';

Class::Tiny::Chained->chain_attributes('MyClass::ToChain');
$obj = MyClass::ToChain->new;
is $obj->foo(2), $obj, 'setter is chained';
is $obj->foo, 2, 'getter is not chained';
is $obj->bar, 1, 'sub is not chained';

done_testing;
