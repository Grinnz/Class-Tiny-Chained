package Class::Tiny::Chained;

use strict;
use warnings;
use parent 'Class::Tiny';

use Class::Method::Modifiers 'install_modifier';

our $VERSION = '0.001';

my %CHAINED;

sub import {
  my $class = shift;
  my $pkg   = caller;
  $class->prepare_class($pkg);
  if (@_) {
    $class->create_attributes($pkg, @_);
    $class->chain_attributes($pkg);
  }
}

sub chain_attributes {
  my ($class, $pkg) = @_;
  my @attrs = grep { !$CHAINED{$pkg}{$_} } $class->get_all_attributes_for($pkg);
  $CHAINED{$pkg}{$_} = 1 for @attrs;
  install_modifier $pkg, around => \@attrs, sub {
    my ($orig, $self) = (shift, shift);
    return $self->$orig() unless @_;
    $self->$orig(@_);
    return $self;
  };
}

1;

=head1 NAME

Class::Tiny::Chained - Minimalist class construction, with chained attributes

=head1 SYNOPSIS

In I<Person.pm>:

 package Person;
 
 use Class::Tiny::Chained qw( name );
 
 1;

In I<Employee.pm>:

 package Employee;
 use parent 'Person';
 
 use Class::Tiny::Chained qw( ssn ), {
   timestamp => sub { time }    # attribute with default
 };
 
 1;

In I<example.pl>:

 use Employee;
 
 my $obj = Employee->new( name => "Larry", ssn => "111-22-3333" );
 
 # attribute setters are chainable
 my $obj = Employee->new->name("Fred")->ssn("444-55-6666");
 my $ts = $obj->name("Bob")->timestamp;

=head1 DESCRIPTION

L<Class::Tiny::Chained> is a wrapper around L<Class::Tiny> which makes the
generated attribute accessors chainable; that is, when setting an attribute
value, the object is returned so that further methods can be called.

=head1 INTERNALS

In addition to the methods discussed in L<Class::Tiny/"Introspection and internals">,
L<Class::Tiny::Chained> implements the following internal method.

=head2 chain_attributes

 Class::Tiny::Chained->chain_attributes("Employee");

Modifies the attribute setters of all attributes of the given L<Class::Tiny>
class to be chainable (return the object). Called automatically on any classes
created via L<Class::Tiny::Chained>.

=head1 BUGS

Report any issues on the public bugtracker.

=head1 AUTHOR

Dan Book <dbook@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2015 by Dan Book.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=head1 SEE ALSO

L<Object::Tap>, L<MooX::ChainedAttributes>
