use strict;
use warnings;

package MyClass;
use Class::Tiny 'foo';

package MyClass::Chained;
use Class::Tiny::Chained 'abc', 'def';

package MyClass::Unchained;
@MyClass::Unchained::ISA = ('MyClass::Chained');
use Class::Tiny 'abc';

package MyClass::Rechained;
@MyClass::Rechained::ISA = ('MyClass');
use Class::Tiny::Chained 'abc';

package main;

use Test::More;
use Test::Identity;

my $obj;

$obj = MyClass->new;
is $obj->foo(2), 2, 'setter is not chained';
is $obj->foo, 2, 'getter is not chained';

$obj = MyClass::Chained->new;
identical $obj->abc(2), $obj, 'setter is chained';
is $obj->abc, 2, 'getter is not chained';
identical $obj->def(3), $obj, 'setter is chained';
is $obj->def, 3, 'getter is not chained';

$obj = MyClass::Unchained->new;
is $obj->abc(2), 2, 'setter is not chained';
is $obj->abc, 2, 'getter is not chained';
identical $obj->def(3), $obj, 'setter is chained';
is $obj->def, 3, 'getter is not chained';

$obj = MyClass::Rechained->new;
is $obj->foo(2), 2, 'setter is not chained';
is $obj->foo, 2, 'getter is not chained';
identical $obj->abc(3), $obj, 'setter is chained';
is $obj->abc, 3, 'getter is not chained';

done_testing;
