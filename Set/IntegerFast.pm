
#  Copyright (c) 1995, 1996, 1997 by Steffen Beyer. All rights reserved.
#  This package is free software; you can redistribute it and/or modify
#  it under the same terms as Perl itself.

package Set::IntegerFast;

use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw();

@EXPORT_OK = qw();

$VERSION = '3.0';

bootstrap Set::IntegerFast $VERSION;

1;

__END__

=head1 NAME

Set::IntegerFast - Sets of Integers

Easy and efficient manipulation of sets of integers
(intervals from zero to some positive integer)

=head1 SYNOPSIS

=over 4

=item *

C<use Set::IntegerFast;>

=item *

C<$ver = Set::IntegerFast::Version();>

returns the version number

=item *

C<$set = Set::IntegerFast::new('Set::IntegerFast',$elements);>

the set object constructor method

(this way of calling the set object constructor method is deprecated,
though, because it is error-prone and specifying the name of the class
twice is unnecessary!)

=item *

C<$class = 'Set::IntegerFast'; $set = Set::IntegerFast::new($class,$elements);>

(alternate way of calling the set object constructor)

(also deprecated)

=item *

C<$set = new Set::IntegerFast($elements);>

(alternate way of calling the set object constructor)

=item *

C<$set = new Set::IntegerFast $elements;>

(same as before, but without the parentheses)

(recommended)

=item *

C<$set = Set::IntegerFast-E<gt>new($elements);>

(alternate way of calling the set object constructor)

(recommended)

=item *

C<$set2 = $set1-E<gt>new($elements);>

(alternate way of calling the set object constructor)

(leaves the set "C<$set1>" untouched)

=item *

C<$set = $set-E<gt>new($elements);>

(alternate way of calling the set object constructor)

(destroys the set previously stored in "C<$set>", however)

=item *

C<$set-E<gt>DESTROY();>

destroys the set and releases the memory occupied by it

(Note that you don't need to call this method explicitly - Perl will
do it automatically for you when the last reference to your set is
deleted, for instance through assigning a different value to the Perl
variable containing the reference to your set, like in "C<$set = 0;>")

=item *

C<$size = $set-E<gt>Size();>

returns the size (= maximum number of elements it can contain) the given
set was created with (or "C<Resize()>"d to)

=item *

C<$set-E<gt>Resize($elements);>

changes the size of the given set

=item *

C<$set-E<gt>Empty();>

deletes all elements in the set

=item *

C<$set-E<gt>Fill();>

inserts all possible elements into the set

=item *

C<$set-E<gt>Empty_Interval($lower,$upper);>

removes all elements in the interval C<[$lower..$upper]> (B<including>
both limits) from the set

=item *

C<$set-E<gt>Fill_Interval($lower,$upper);>

inserts all elements in the interval C<[$lower..$upper]> (B<including>
both limits) into the set

=item *

C<$set-E<gt>Flip_Interval($lower,$upper);>

flips all elements in the interval C<[$lower..$upper]> (B<including>
both limits) in the set

=item *

C<$set-E<gt>Insert($index);>

inserts a given element

=item *

C<$set-E<gt>Delete($index);>

deletes a given element

=item *

C<$set-E<gt>flip($index);>

flips a given element and returns its new value

=item *

C<$set-E<gt>in($index);>

tests the presence of a given element

=item *

C<$set-E<gt>Norm();>

calculates the norm (number of elements) of the set

=item *

C<$set-E<gt>Min();>

returns the minimum of the set ( min({}) := +infinity )

=item *

C<$set-E<gt>Max();>

returns the maximum of the set ( max({}) := -infinity )

=item *

C<$set1-E<gt>Union($set2,$set3);>

calculates the union of set2 and set3 and stores the result in set1
(in-place is also possible)

=item *

C<$set1-E<gt>Intersection($set2,$set3);>

calculates the intersection of set2 and set3 and stores the result in set1
(in-place is also possible)

=item *

C<$set1-E<gt>Difference($set2,$set3);>

calculates set2 "minus" set3 ( = set2 \ set3 ) and stores the result in set1
(in-place is also possible)

=item *

C<$set1-E<gt>ExclusiveOr($set2,$set3);>

calculates the symmetric difference of set2 and set3 and stores the result
in set1 (in-place is also possible)

=item *

C<$set1-E<gt>Complement($set2);>

calculates the complement of set2 and stores the result in set1
(in-place is also possible)

=item *

C<$set1-E<gt>equal($set2);>

tests if set1 is the same as set2

=item *

C<$set1-E<gt>inclusion($set2);>

tests if set1 is contained in set2

=item *

C<$set1-E<gt>lexorder($set2);>

tests if set1 comes lexically before set2, i.e., if (set1 <= set2) holds,
as though the two bit vectors used to represent the two sets were two
large numbers in binary representation

(Note that this is an B<arbitrary> order relationship!)

=item *

C<$set1-E<gt>Compare($set2);>

lexically compares set1 and set2 and returns -1, 0 or 1 if
(set1 < set2), (set1 == set2) or (set1 > set2) holds, respectively

(Again, the two bit vectors representing the two sets are compared as
though they were two large numbers in binary representation)

=item *

C<$set1-E<gt>Copy($set2);>

copies set2 to set1

=item *

B<Hint: method names all in lower case indicate a boolean return value!>

(Except for "C<new()>", of course!)

=back

=head1 DESCRIPTION

This module allows you to create sets of arbitrary size (only limited
by the size of a machine word and available memory on your system) of an
interval of positive integers starting with zero, to dynamically change
the size of such sets and to perform all the basic operations for sets
on them, like

=over 4

=item -

adding or removing elements,

=item -

testing for the presence of a certain element,

=item -

computing the union, intersection, difference, symmetric difference or
complement of sets,

=item -

copying sets,

=item -

testing two sets for equality or inclusion, and

=item -

computing the minimum, the maximum and the norm (number of elements) of a set.

=back

Note that it is extremely easy to implement sets of arbitrary intervals
of integers using this module (negative indices are no obstacle),
despite the fact that only intervals of positive integers (from
zero to some positive integer) are supported directly.

Please refer to L<"ARBITRARY SETS"> below to see how this can be done!

The module is mainly intended for mathematical or algorithmical computations.
There are also a number of efficient algorithms that rely on sets.

An example of such an efficient algorithm (which uses a different
representation for sets than this module, however) is Kruskal's
algorithm for minimal spanning trees in graphs. (That algorithm is
included in this distribution as a Perl module for those interested.
Please refer to L<Graph::Kruskal(3)> for more details!)

Another famous algorithm using sets is the "Seave of Erathostenes" for
calculating prime numbers, which is included here as a demo program
(see "primes.pl").

An important field of application is the computation of "first", "follow"
and "look-ahead" character sets for the construction of LL, SLR, LR and LALR
parsers for compilers (or a compiler-compiler, like "yacc", for instance).

(That's what the C library in this package was initially written for)

(See Aho, Hopcroft, Ullman, "The Design and Analysis of Computer Algorithms"
for an excellent book on efficient algorithms and the famous "Dragon Book" on
how to build compilers by Aho, Sethi, Ullman)

Therefore, this module is primarily designed for efficiency and not for a
comfortable user interface (the latter can be added by additional modules,
as shown by the "Set::IntegerRange" and "Math::MatrixBool" modules).

It only offers a basic functionality and leaves it up to your application
to add whatever special handling it needs (for example, negative indices
can be realized by biasing the whole range with an offset).

(Please refer to L<"ARBITRARY SETS"> below and the "Set::IntegerRange"
module in this package to see how!)

Sets in this package are implemented as bit vectors, and elements are positive
integers from zero to the maximum number of elements (which you specify when
creating the set) minus one.

Each element (i.e., number or "index") thus corresponds to one bit in the
bit array. Bit number 0 of word number 0 corresponds to element number 0,
element number 1 corresponds to bit number 1 of word number 0, and so on.

The module doesn't use bytes as basic storage unit, it rather uses machine
words, assuming that a machine word is the most efficiently handled size of
all scalar types on any machine (that's what the C standard proposes and
assumes anyway).

In order to achieve this, it automatically determines the number of bits
in a machine word on your system and then adjusts its internal constants
accordingly.

The greater the size of this basic storage unit, the better the complexity
of the methods in this module (but also the greater the average waste of
unused bits in the last word).

See L<"COMPLEXITY"> in this man page for an overview of the complexity of
each method!

Note that the C library in this package (F<lib_set.c>) is designed in such
a way that it may be used independently from Perl and this Perl extension
module. (!)

For this, you can use the file F<lib_set.o> exactly as it is produced when
building this module! It contains no references to Perl, and it doesn't need
any Perl header files in order to compile. (It only needs F<lib_defs.h> and
some system header files)

Note however that this C library does not perform any bounds checking
whatsoever! (This is left to your application!)

(See the corresponding explanation in the file F<lib_set.c> for more details
and the file F<IntegerFast.xs> for an example of how this can be done!)

In this module, all bounds and type checking (which should be absolutely
fool-proof, by the way!) is done in the XS subroutines.

=head2 ARBITRARY SETS

Note that it is extremely easy to implement sets of arbitrary intervals
of integers using this module (negative indices are no obstacle),
despite the fact that only intervals of positive integers (from
zero to some positive integer) are supported directly.

All that is required - given that "$lowerbound" and "$upperbound" contain
the lower and upper limits, respectively, of the range of integers you want
to cover with your set - is that you use

=over 2

=item

C<$set = new Set::IntegerFast($upperbound - $lowerbound + 1);>

=item

C<$set-E<gt>Empty_Interval($lowerindex-$lowerbound, $upperindex-$lowerbound);>

=item

C<$set-E<gt>Fill_Interval($lowerindex-$lowerbound, $upperindex-$lowerbound);>

=item

C<$set-E<gt>Flip_Interval($lowerindex-$lowerbound, $upperindex-$lowerbound);>

=item

C<$set-E<gt>Insert($index - $lowerbound);>

=item

C<$set-E<gt>Delete($index - $lowerbound);>

=item

C<$set-E<gt>flip($index - $lowerbound);>

=item

C<$set-E<gt>in($index - $lowerbound);>

=item

C<$temp = $set-E<gt>Min();>
C<(($temp> >= C<0) && ($temp> <= C<($upperbound - $lowerbound))) ? ($temp + $lowerbound) : $temp;>

=item

C<$temp = $set-E<gt>Max();>
C<(($temp> >= C<0) && ($temp> <= C<($upperbound - $lowerbound))) ? ($temp + $lowerbound) : $temp;>

=back

(where "$index" is an integer in the range [$lowerbound..$upperbound])

instead of

=over 2

=item

C<$set = new Set::IntegerFast($elements);>

=item

C<$set-E<gt>Empty_Interval($lowerindex, $upperindex);>

=item

C<$set-E<gt>Fill_Interval($lowerindex, $upperindex);>

=item

C<$set-E<gt>Flip_Interval($lowerindex, $upperindex);>

=item

C<$set-E<gt>Insert($index);>

=item

C<$set-E<gt>Delete($index);>

=item

C<$set-E<gt>flip($index);>

=item

C<$set-E<gt>in($index);>

=item

C<$set-E<gt>Min();>

=item

C<$set-E<gt>Max();>

=back

(where "$index" is an integer in the range [0..$elements-1])

It's as simple as that!

Note that if you don't want to go through the hassle ;-) of handling this
yourself, you can use the "Set::IntegerRange" module in this package which
provides exactly the same methods as the "Set::IntegerFast" module (except
for "Resize()"), which stores the lower and upper limits along with any
given set and provides the necessary translation as shown above.

Please refer to L<Set::IntegerRange(3)> for more details!

Please refer to L<Math::MatrixBool(3)> for yet another example on how
to incorporate this module in your own applications!

=head1 DETAILS

=over 4

=item *

C<$ver = Set::IntegerFast::Version();>

This function returns a string with the (numeric) version
number of the "Set::IntegerFast" extension package.

Since this function is not exported, you always have to
qualify it explicitly (i.e., "C<Set::IntegerFast::Version()>").

This is to avoid possible conflicts with version functions
from other packages.

=item *

C<$set = Set::IntegerFast-E<gt>new($elements);>

This is the set object constructor method.

Call this method to create a new set object able to contain
"$elements" elements (all integers in the range [0..$elements-1]).

The method returns a reference to the newly created set object.

This set object is always initialized to an empty set.

Beware that every time you pass a reference to one of the other
methods in this package it is checked if it's "blessed" (see the
perlref(1), perlobj(1) and perlbot(1) man pages for more details
on blessed references) into the right class (i.e., this package).

An error message occurs if the reference is not one that has been
returned by this "Set::IntegerFast" object constructor method.

(See also L<"SUBCLASSING (INHERITANCE)"> in this man page for
more details on this subject!)

Note that this method returns the value "undef" if you try to create
a set object with zero elements. This also occurs when the method is
unable to allocate the necessary memory using "malloc()".

Any attempt to use such a "reference" either results in a warning
about the use of an uninitialized value (if the C<-w> switch is set)
or an error message with program abortion if you try to invoke a
method with it.

Note also that if you specify a negative number for "$elements" it
will be interpreted as a large positive number due to its internal
2's complement binary representation and the set object constructor
method will attempt to create a set of that size, probably resulting
in an "out of memory" error message and program abortion.

=item *

C<$set-E<gt>DESTROY();>

This is the set object destructor method. It destroys the given set
and releases the memory occupied by it.

Note that you don't need to call this method explicitly - Perl will
do it automatically for you when the last reference to your set is
deleted, for instance through assigning a different value to the Perl
variable containing the reference to your set, like in "C<$set = 0;>")

Note also that once you have called the destructor method B<explicitly>,
your Perl variable ("$set" in this example) no longer contains a valid
set object reference. Any attempt to invoke a method with that variable
after the set has been DESTROYed will result in an
"Set::IntegerFast::<method>(): not a 'Set::IntegerFast' object reference
in ..." error and program abortion.

(This will also happen if you inadvertently invoke "DESTROY" twice for
the same object!)

Therefore, it is recommended to NEVER call this method explicitly!

Use "C<$set = 0;>" or "C<undef $set;>" (or the like) instead!

Note however that keeping copies of the reference prevents the
destruction of the set object to take place until the last copy
of the reference has also been deleted:

    $set = new Set::IntegerFast(1000);
    ...
    $ref = $set;
    ...
    $set = 0;    # set object is NOT destroyed yet!
    ...
    $ref = 0;    # NOW the set object gets killed!

=item *

C<$size = $set-E<gt>Size();>

This method returns the size (= maximum number of elements it can contain)
the given set was created with (or "C<Resize()>"d to).

=item *

C<$set-E<gt>Resize($elements);>

This method allows you to change the size of an existing set,
keeping as many of the elements contained in it as
will fit into the new set (i.e., all elements which are smaller
than the minimum of the old maximum number of elements and the
new maximum number of elements).

If the number of machine words needed to store the given maximum
number of elements of the new set is smaller than or equal
to the number of words needed to store the old set, the memory
already allocated for the old set is kept and simply adjusted to
hold the new set.

This means that even if the maximum number of elements increases,
this does not necessarily mean that new memory needs to be allocated
(if the old and the new maximum number of elements fit into the same
number of machine words)!

If the number of machine words needed to store the given maximum number
of elements of the new set is greater than the number of words needed to
store the old set, new memory is allocated for the new set, the old set
is copied to the new one and the old set is deleted, i.e., the memory
allocated for it is freed.

This also means that if you decrease the size of a given set
so that it will use fewer machine words, and increase it again
later so that it will use more words than the downsized set but
still less than the original set, new memory will be allocated
anyway because the information about the size of the original
set is lost when you downsize it.

When the maximum number of elements is increased (regardless of
wether the number of machine words used to store the new set
increases or stays the same), the new elements are all initialized
to zero, i.e., they are not contained in the new set.

This does not affect those elements that have been copied from the
old to the new set, of course.

Beware that when you invert the meaning of contained/not contained
in your calculations (which you are free to do, of course), i.e.,
when you are calculating the complement of the set you're
actually interested in, increasing the size of your set might not
yield the result you'd expect!

I.e., doing this will not work as intended:

    $set = Set::IntegerFast::Create(1000);
    $set->Insert(0);
    $set->Insert(1);
    for ( $j = 4; $j <= $limit; $j += 2 ) { $set->Insert($j); }
    for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
    {
        for ( ; $j <= $limit; $j += $i ) { $set->Insert($j); }
    }
    $set->Resize(100000);

This calculates the prime numbers up to 1000 and then increases
the size of the set to 100000. However, since the original set
contains all the NON-prime numbers, increasing the size of the
set ends up with a mess: if an element below 1000 is not contained
in the set, it's a prime number, whereas all the numbers between
1000 and 100000 (which are not contained in the set due to the
initialization of the new elements) may or may not be prime numbers.

If you calculate the set of primes instead and then increase the
size of the set, there is no interpretation conflict:

    $set = Set::IntegerFast::Create(1000);
    $set->Fill();
    $set->Delete(0);
    $set->Delete(1);
    for ( $j = 4; $j <= $limit; $j += 2 ) { $set->Delete($j); }
    for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
    {
        for ( ; $j <= $limit; $j += $i ) { $set->Delete($j); }
    }
    $set->Resize(100000);

In this case, all the elements which are contained in the new set
definitely are prime numbers!

Finally, note that "$set->Resize(0);" is (internally) exactly the
same as "$set->DESTROY();".

(Remember Larry Wall: "There is more than one way to do it!")

Beware that this leaves you with an invalid reference in the variable
"$set"!

(See also the documentation of the "DESTROY()" method above for more
details)

=item *

C<$set-E<gt>Empty();>

This method removes all elements the set contains from the set,
leaving an empty set ("{}").

The method "$set->in($i)" returns false (0) for every element
after invoking this method for the given set.

=item *

C<$set-E<gt>Fill();>

This method adds all elements the set can potentially contain
to the set, yielding a "full" set ("~{}", or the complement of
the empty set).

The method "$set->in($i)" returns true (1) for every element
after invoking this method for the given set.

=item *

C<$set-E<gt>Empty_Interval($lower,$upper);>

This method removes all elements in the interval C<[$lower..$upper]>
(B<including> both limits) from the set.

"C<$lower>" and "C<$upper>" may have the same value; this is the same
as deleting a single element with "C<Delete()>".

Note that C<$set-E<gt>Empty_Interval(0,$set-E<gt>Size()-1);> is the same
as C<$set-E<gt>Empty();>.

=item *

C<$set-E<gt>Fill_Interval($lower,$upper);>

This method inserts all elements in the interval C<[$lower..$upper]>
(B<including> both limits) into the set.

"C<$lower>" and "C<$upper>" may have the same value; this is the same
as inserting a single element with "C<Insert()>".

Note that C<$set-E<gt>Fill_Interval(0,$set-E<gt>Size()-1);> is the same
as C<$set-E<gt>Fill();>.

=item *

C<$set-E<gt>Flip_Interval($lower,$upper);>

This method flips all elements in the interval C<[$lower..$upper]>
(B<including> both limits) in the set.

"C<$lower>" and "C<$upper>" may have the same value; this is the same
as flipping a single element with "C<flip()>".

Note that C<$set-E<gt>Flip_Interval(0,$set-E<gt>Size()-1);> is the same
as C<$set-E<gt>Complement($set);>.

=item *

C<$set-E<gt>Insert($i);>

This method adds the element "$i" to the given set, i.e.,
performs $set = $set + {$i} (where "+" stands for the "union"
operator for sets, and where "{$i}" denotes a set that only
contains the element "$i").

If "$i" is outside of the range of [0..$elements-1] (where "$elements"
is the maximum number of elements the given set was created with),
an error message occurs.

Note that negative indices "$i" will be interpreted as large
positive numbers due to their internal 2's complement binary
representation and most likely lie outside the permitted range
(and cause an error message).

=item *

C<$set-E<gt>Delete($i);>

This method deletes the element "$i" from the given set, i.e.,
performs $set = $set \ {$i} (where "\" stands for the "difference"
operator for sets, and where "{$i}" denotes a set that only
contains the element "$i").

If "$i" is outside of the range of [0..$elements-1] (where "$elements"
is the maximum number of elements the given set was created with),
an error message occurs.

Note that negative indices "$i" will be interpreted as large
positive numbers due to their internal 2's complement binary
representation and most likely lie outside the permitted range
(and cause an error message).

=item *

C<$set-E<gt>flip($i);>

This method flips the element "$i" in the given set, i.e. B<adds> this
element to the given set if it is B<not> contained in the set, or B<removes>
this element from the given set if it B<is> contained in the set.

In set theory terminology, this method performs the operation

    $set = ( $set + {$i} ) \ ( $set * {$i} )

(where "+", "*" and "\" stand for the "union", "intersection" and
"difference" operators for sets, respectively, and where "{$i}"
denotes a set that only contains the element "$i").

After doing this, the method returns the B<new> state of the given
element, i.e. it returns true (1) if the element "$i" is now contained
in the given set, or false (0) otherwise.

If "$i" is outside of the range of [0..$elements-1] (where "$elements"
is the maximum number of elements the given set was created with),
an error message occurs.

Note that negative indices "$i" will be interpreted as large
positive numbers due to their internal 2's complement binary
representation and most likely lie outside the permitted range
(and cause an error message).

=item *

C<$set-E<gt>in($i);>

This method tests if the element "$i" is contained in the given
set.

It returns true (1) if the given set contains element "$i" and
false (0) otherwise.

If "$i" is outside of the range of [0..$elements-1] (where "$elements"
is the maximum number of elements the given set was created with),
an error message occurs.

Note that negative indices "$i" will be interpreted as large
positive numbers due to their internal 2's complement binary
representation and most likely lie outside the permitted range
(and cause an error message).

=item *

C<$set-E<gt>Norm();>

This method computes the "norm" of the given set, i.e., the number
of elements the given set contains.

When applied to the empty set (see also the method "Empty()" above),
this method returns zero.

When applied to the "all" set (see also the method "Fill()" above),
this method returns the maximum number "$elements" of elements the
set can hold (which the set was initially created with).

=item *

C<$set-E<gt>Min();>

This method computes the minimum of (i.e., the smallest element
contained in) the given set.

Note that the minimum of an empty set (see also the method "Empty()"
above) doesn't exist. Therefore, plus infinity (represented by the
numeric constant "LONG_MAX" on your system) is returned as the minimum
of an empty set.

The reason for this is that plus infinity is always greater than
any minimum of any non-empty set, so that the minimum of the minima
of several sets always yields a meaningful value.

If you need to know the value of the constant "LONG_MAX" (for instance
for comparison), simply create a small, empty dummy set and determine
its minimum, i.e., do something like this:

    $dummy = Set::IntegerFast->new(1);
    $LONG_MAX = $dummy->Min();

=item *

C<$set-E<gt>Max();>

This method computes the maximum of (i.e., the greatest element
contained in) the given set.

Note that the maximum of an empty set (see also the method "Empty()"
above) doesn't exist. Therefore, minus infinity (represented by the
numeric constant "LONG_MIN" on your system) is returned as the maximum
of an empty set.

The reason for this is that minus infinity is always less than
any maximum of any non-empty set, so that the maximum of the maxima
of several sets always yields a meaningful value.

If you need to know the value of the constant "LONG_MIN" (for instance
for comparison), simply create a small, empty dummy set and determine
its maximum, i.e., do something like this:

    $dummy = Set::IntegerFast->new(1);
    $LONG_MIN = $dummy->Max();

=item *

C<$set1-E<gt>Union($set2,$set3);>

This method computes the union of the two argument sets (i.e.,
"$set2 + $set3") and stores the result in set "$set1".

The information that initially was stored in the resulting set
"$set1" gets overwritten, i.e., lost.

In-place substitution is possible, i.e., the resulting set may
also be identical with one (or both) of the two arguments.

Note that the two argument sets and the resulting set must all
have the same size (i.e., they must have been created with the
same maximum number "$elements" of elements) or you will get
an error message.

=item *

C<$set1-E<gt>Intersection($set2,$set3);>

This method computes the intersection of the two argument sets
(i.e., "$set2 * $set3") and stores the result in set "$set1".

The information that initially was stored in the resulting set
"$set1" gets overwritten, i.e., lost.

In-place substitution is possible, i.e., the resulting set may
also be identical with one (or both) of the two arguments.

Note that the two argument sets and the resulting set must all
have the same size (i.e., they must have been created with the
same maximum number "$elements" of elements) or you will get
an error message.

=item *

C<$set1-E<gt>Difference($set2,$set3);>

This method computes the difference of the two argument sets
(i.e., "$set2 \ $set3") and stores the result in set "$set1".

The information that initially was stored in the resulting set
"$set1" gets overwritten, i.e., lost.

In-place substitution is possible, i.e., the resulting set may
also be identical with one (or both) of the two arguments.

Note that the two argument sets and the resulting set must all
have the same size (i.e., they must have been created with the
same maximum number "$elements" of elements) or you will get
an error message.

=item *

C<$set1-E<gt>ExclusiveOr($set2,$set3);>

This method computes the symmetric difference of the two argument
sets, i.e., "( $set2 + $set3 ) \ ( $set2 * $set3 )", and stores
the result in set "$set1".

Note that the above formula is equivalent to calculating the
exclusive-or of the corresponding elements in the two argument
sets, hence the name of this method.

Calculating the exclusive-or is much faster than evaluating the
above formula because it uses a built-in machine language instruction.

The information that initially was stored in the resulting set
"$set1" gets overwritten, i.e., lost.

In-place substitution is possible, i.e., the resulting set may
also be identical with one (or both) of the two arguments.

Note that the two argument sets and the resulting set must all
have the same size (i.e., they must have been created with the
same maximum number "$elements" of elements) or you will get
an error message.

=item *

C<$set1-E<gt>Complement($set2);>

This method computes the complement of the argument set
(i.e., "~ $set2") and stores the result in set "$set1".

The information that initially was stored in the resulting set
"$set1" gets overwritten, i.e., lost.

In-place substitution is possible, i.e., the resulting set
and the argument set may be identical.

Note that the argument set and the resulting set must have
the same size (i.e., they must have been created with the
same maximum number "$elements" of elements) or you will
get an error message.

=item *

C<$set1-E<gt>equal($set2);>

This method tests if the two sets "$set1" and "$set2" are the
same.

It returns true (1) if the given sets are the same and false (0)
otherwise.

Note that the two sets must have the same size (i.e., they must
have been created with the same maximum number "$elements" of
elements) or you will get an error message.

=item *

C<$set1-E<gt>inclusion($set2);>

This method tests if the set "$set1" is included in the set
"$set2", i.e., if "$set1" is a subset of "$set2" (or in
other terms, if "$set2" is a superset of "$set1").

It returns true (1) if this condition is met and false (0)
otherwise.

Note that the two sets must have the same size (i.e., they must
have been created with the same maximum number "$elements" of
elements) or you will get an error message.

=item *

C<$set1-E<gt>lexorder($set2);>

This method compares two sets as though they were two large numbers,
stored in binary representation (unsigned), and returns true (1) if
"$set1" is less than or equal to "$set2", and false (0) otherwise.

The element with index 0 thereby constitutes the least significant bit
(LSB) and the element with index ($elements-1) (where "$elements" is
the maximum number of elements the two sets were created with) the most
significant bit (MSB).

In some algorithms, it may be necessary to have many sets at the same
time, and it may be important to define some order relationship on them
to process them all in a well-defined order.

This lexical order is completely arbitrary and has no meaning whatsoever
in terms of set theory. (!)

Note that the two sets must have the same size (i.e., they must
have been created with the same maximum number "$elements" of
elements) or you will get an error message.

=item *

C<$set1-E<gt>Compare($set2);>

This method compares two sets as though they were two large numbers,
stored in binary representation (unsigned), and returns the value "-1"
if "$set1" is less than "$set2", "0" if "$set1" and "$set2" are the same
and "1" if "$set1" is greater than "$set2".

The element with index 0 thereby constitutes the least significant bit
(LSB) and the element with index ($elements-1) (where "$elements" is
the maximum number of elements the two sets were created with) the most
significant bit (MSB).

In some algorithms, it may be necessary to have many sets at the same
time, and it may be important to define some order relationship on them
to process them all in a well-defined order.

This lexical order is completely arbitrary and has no meaning whatsoever
in terms of set theory. (!)

Note that the two sets must have the same size (i.e., they must
have been created with the same maximum number "$elements" of
elements) or you will get an error message.

=item *

C<$set1-E<gt>Copy($set2);>

This method allows you to make a copy of a given set, for instance
to make the comparison possible between the initial and the final
set after some computation.

Note that the "carbon copy" set "$set1" is NOT created by the
"Copy()" method, it rather must have been created beforehand,
and the two sets must have the same size (i.e., they must
have been created with the same maximum number "$elements" of
elements), or you will get an error message.

The information that initially was stored in the set "$set1"
gets overwritten, i.e., lost.

Note also that one could substitute this method by the following
two method invocations (there are other possibilities as well):

    $set0->Empty();
    $set1->Union($set2,$set0);

provided that "$set0", "$set1" and "$set2" are all of the same size.

But of course this is extremely inefficient.

=back

=head1 SUBCLASSING (INHERITANCE)

Currently, subclassing of the "Set::IntegerFast" class is disabled.

This is because you must know B<exactly> what you are doing if you want
to do this.

As a matter of fact, Perl doesn't know anything about the internals of
a "Set::IntegerFast" object.

This is what is called "information hiding", "module opacity" or
"module secret" in object oriented programming.

Perl only knows an (anonymous) scalar variable which holds a number.
This number is a pointer that the C part of the "Set::IntegerFast" module
uses to access a given set. The anonymous scalar is considered to be an
object (of class "Set::IntegerFast") by Perl.

What the object constructor method "new()" actually does is to call the
C part of the module (function "Set_Create()") to create a new set object.
It then creates the anonymous scalar Perl variable and stores the pointer
returned by "Set_Create()" in it. This scalar is then blessed into an object
of class "Set::IntegerFast". Finally "new()" returns a reference to that
scalar.

Beware that the C part of this module uses a B<fake pointer> which points
to a convenient location B<inside> the set object (B<not> to the beginning
of the allocated block of memory!). This pointer is B<not> the pointer
returned by "malloc()" or passed to "free()"!

Therefore, it is dangerous (at the risk of segmentation faults and core
dumps and possibly lost or overwritten data) to mingle with these things
unless you completely understand all the mechanisms involved.

It is also very dangerous to mess around with the number stored in the
anonymous scalar variable. Changing this number and then calling one of
the methods of this class is a sure way to catastrophy.

To prevent this, the anonymous scalar is always write-protected.

If you still want to use subclasses of the "Set::IntegerFast" class,
you must do the following:

=over 4

=item -

Change directory to the "F<Set-IntegerFast-3.2/>" distribution directory

=item -

Edit the file F<Set/Makefile.PL> and change the line

    'DEFINE'		=> '',     # e.g., '-DHAVE_SOMETHING' 

to

    'DEFINE'		=> '-DENABLE_SUBCLASSING',

=item -

Then rebuild the entire module:

Issue "make realclean", "perl Makefile.PL", "make test" and
(if all goes well) "make install" at the shell prompt.

=back

In most cases you won't need this, though. See the "Set::IntegerRange"
and "Math::MatrixBool" modules for how to expand the functionality of
this class without need for formal subclassing or inheritance!

(Without need for any kludge, either!)

=head1 COMPLEXITY

In the following, "n" is the maximum number of elements your set
can hold, and "b" is the number of bits in a machine word on your
system.

(If the maximum number of elements you specified when creating the
set is not a multiple of "b", set "n" to the next greater multiple
of "b" here)

                         worst       best       average
                         case        case        case

    new                  n/b         n/b         n/b          1)
    DESTROY              1           1           1
    Size                 1           1           1
    Resize               n/b         1           n+b/2b       2)
    Empty                n/b         n/b         n/b
    Fill                 n/b         n/b         n/b
    Empty_Interval       n/b         1           <<P0>>
    Fill_Interval        n/b         1           <<P0>>
    Flip_Interval        n/b         1           <<P0>>
    Insert               1           1           1
    Delete               1           1           1
    flip                 1           1           1
    in                   1           1           1
    Norm                 n/b+n       n/b         <<P1>>       3)
    Min                  n/b+b       2           <<P2>>       4)
    Max                  n/b+b       2           <<P2>>       4)
    Union                n/b         n/b         n/b
    Intersection         n/b         n/b         n/b
    Difference           n/b         n/b         n/b
    ExclusiveOr          n/b         n/b         n/b
    Complement           n/b         n/b         n/b
    equal                n/b         1           <<P3>>       5)
    inclusion            n/b         1           <<P4>>       5)
    lexorder             n/b         1           <<P3>>       6)
    Compare              n/b         1           <<P3>>       6)
    Copy                 n/b         n/b         n/b

=over 4

=item 1)

complexity is n/b here because a set is always initialized to
an empty set (padded with zeros).

=item 2)

"n" is the maximum number of elements in the NEW set here.
"best case" is when the new set is smaller than the old set.
"worst case" is when the new set is larger than the old one,
in which case the new set has to be initialized and the old
set has to be copied to the new one. "average case" assumes
that half of the time the new set is larger, half of the time
it is smaller than the old set.

=item 3)

"worst case" is when the set is full, i.e., all elements are
present. "best case" is when the set is empty.

=item 4)

"best case" is when the first (Min) or the last (Max) element
is set. "worst case" is when ONLY the last (Min) or the first
(Max) element is set. (The algorithm has complexity n/b for
a completely empty set)

=item 5)

"best case" is when the condition is false at the first word.

=item 6)

"best case" is when the two sets differ at the first word.

=back

For values of "n" not too large, the average case complexity of the
methods Norm, Min, Max, equal, lexorder, Compare and inclusion can
be calculated with the following Perl subroutines (note the terms
"2**$n" and even "2**(2*$n)" below which limit the computable
complexities!) according to the formula:

    E[X]  =  SUM{ i=1..n } i * p(i)

(where 1..n are the possible values the stochastic variable X can have,
p(i) is the probability of value i and E[X] the average outcome of X)

(The result is more or less close to n for Norm, vaguely in the range
n/2b to n/b for Min and Max, close to 1 for equal, lexorder, Compare
and inclusion, and almost constant n/3b for Empty_Interval,
Fill_Interval and Flip_Interval.)

    <<P0>> :

    sub average_case     # methods "Empty_Interval", "Fill_Interval",
    {                    # "Flip_Interval"
        my($n,$b) = @_;
        my($s,$t);

        $s = $n * ( $n * ($n + 3 * $b) + $b * (3 - $b) ) / (6 * $b);
        $t = $n * ($n + 1) / 2;
        return($s / $t);
    }

    <<P1>> :

    sub average_case     # method "Norm"
    {
        my($n,$b) = @_;
        my($i,@j,$c,$k,$l,$p,$s,$sum);

        $k = int($n / $b);
        if (($k * $b) < $n) { $n = ++$k * $b; }
        $sum = 0;
        for ( $i = $k; $i >= 1; --$i )
        {
            $j[$i] = 0;
        }
        $c = 0;
        while (! $c)
        {
            $p = 1;
            $s = $k;
            for ( $i = $k; $i >= 1; --$i )
            {
                $l = $j[$i];
                $s += $l;
                if ($l >= 1) { --$l; }
                $p *= 2**$l;
            }
            $sum += $s * $p;
            $c = 1;
            for ( $i = $k; ($i >= 1) && $c; --$i )
            {
                if ($c = (++$j[$i] > $b)) { $j[$i] = 0; }
            }
        }
        return($sum / 2**$n);
    }

    <<P2>> :

    sub average_case     # methods "Min" and "Max"
    {
        my($n,$b) = @_;
        my($i,$j,$k,$l,$o,$p,$sum);

        $k = int($n / $b);
        if (($k * $b) < $n) { $n = ++$k * $b; }
        $sum = $k;
        for ( $l = 2; $l <= ($k+$b); ++$l )
        {
            $o = $l - 2;
            if ($o > $k - 1) { $o = $k - 1; }
            $p = 0;
            for ( $i = 0; $i <= $o; ++$i )
            {
                $j = $l - $i - 1;
                if ($j <= $b)
                {
                    $p += 2**($n-$i*$b-$j);
                }
            }
            $sum += $l * $p;
        }
        return($sum / 2**$n);
    }

    <<P3>> :

    sub average_case     # methods "equal", "lexorder", "Compare"
    {
        my($n,$b) = @_;
        my($i,$k,$t1,$t2,$sum);

        $k = int($n / $b);
        if (($k * $b) < $n) { $n = ++$k * $b; }
        $t1 = 0;
        $t2 = 0;
        $sum = 0;
        for ( $i = $k; $i >= 1; --$i )
        {
            $t1 = 2**(($k-$i+1)*$b);
            $sum += ($t1 - $t2) * $i;
            $t2 = $t1;
        }
        return($sum / 2**$n);
    }

    <<P4>> :

    sub average_case     # method "inclusion"
    {
        my($n,$b) = @_;
        my($i,$j,$k,$l,$s,$t1,$t2,$sum);

        $k = int($n / $b);
        if (($k * $b) < $n) { $n = ++$k * $b; }
        $t1 = 0;
        $t2 = 0;
        $sum = 0;
        for ( $i = $k; $i >= 1; --$i )
        {
            $s = 0;
            $l = ($i - 1) * $b;
            for ( $j = 0; $j <= $l; ++$j )
            {
                $s += 2**$j * &binomial($l,$j);
            }
            $t1 = $s * 2**(2*($n-$l));
            $sum += ($t1 - $t2) * $i;
            $t2 = $t1;
        }
        return($sum / 2**(2*$n));
    }

    sub binomial
    {
        my($n,$k) = @_;
        my($prod) = 1;
        my($j) = 0;

        if (($n <= 0) || ($k <= 0) || ($n <= $k)) { return(1); }
        if ($k > $n - $k) { $k = $n - $k; }
        while ($j < $k)
        {
            $prod *= $n--;
            $prod /= ++$j;
        }
        return(int($prod + 0.5));
    }

=head1 EXAMPLE

	#!perl -w

	use strict;
	no strict "vars";

	use Set::IntegerFast;

	print "\n***** Calculating Prime Numbers - The Seave Of Erathostenes *****\n";

	$limit = 0;

	if (-t STDIN)
	{
	    while ($limit < 16)
	    {
	        print "\nPlease enter an upper limit (>15): ";
	        $limit = <STDIN>;
	        chop($limit) while ($limit =~ /\n$/);
	        $limit = 0 if (($limit eq "") || ($limit =~ /\D/));
	    }
	    print "\n";
	}
	else
	{
	    $limit = 100;
	    print "\nRunning in batch mode - using $limit as upper limit.\n\n";
	}

	$set = new Set::IntegerFast($limit+1);

	$set->Fill();

	$set->Delete(0);
	$set->Delete(1);

	print "Calculating the prime numbers in the range [2..$limit]...\n\n";

	$start = time;

	for ( $j = 4; $j <= $limit; $j += 2 )
	{
	    $set->Delete($j);
	}

	for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
	{
	    for ( ; $j <= $limit; $j += $i )
	    {
	        $set->Delete($j);
	    }
	}

	$stop = time;

	&print_elapsed_time;

	$min = $set->Min();
	$max = $set->Max();
	$norm = $set->Norm();

	print "Found $norm prime numbers in the range [2..$limit]:\n\n";

	for ( $i = $min, $j = 0; $i <= $max; $i++ )
	{
	    if ($set->in($i))
	    {
	        print "prime number #", ++$j, " = $i\n";
	    }
	}

	print "\n";

	exit;

	sub print_elapsed_time
	{
	    ($sec,$min,$hour,$year,$yday) = (gmtime($stop - $start))[0,1,2,5,7];
	    $year -= 70;
	    $flag = 0;
	    print "Elapsed time: ";
	    if ($year > 0)
	    {
	        printf("%d year%s ", $year, ($year!=1)?"s":"");
	        $flag = 1;
	    }
	    if (($yday > 0) || $flag)
	    {
	        printf("%d day%s ", $yday, ($yday!=1)?"s":"");
	        $flag = 1;
	    }
	    if (($hour > 0) || $flag)
	    {
	        printf("%d hour%s ", $hour, ($hour!=1)?"s":"");
	        $flag = 1;
	    }
	    if (($min > 0) || $flag)
	    {
	        printf("%d minute%s ", $min, ($min!=1)?"s":"");
	    }
	    printf("%d second%s.\n\n", $sec, ($sec!=1)?"s":"");
	}

	__END__

=head1 SEE ALSO

Set::IntegerRange(3), Math::MatrixBool(3), Math::MatrixReal(3),
DFA::Kleene(3), Kleene(3), Graph::Kruskal(3), perl(1), perlsub(1),
perlmod(1), perlref(1), perlobj(1), perlbot(1), perlxs(1),
perlxstut(1), perlguts(1).

=head1 VERSION

This man page documents Set::IntegerFast version 3.0.

=head1 AUTHOR

Steffen Beyer <sb@sdm.de> (sd&m GmbH&Co.KG, Munich, Germany)

=head1 COPYRIGHT

Copyright (c) 1995, 1996, 1997 by Steffen Beyer. All rights reserved.

=head1 LICENSE AGREEMENT

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

