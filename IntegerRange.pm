
#  Copyright (c) 1996 Steffen Beyer. All rights reserved.
#  This package is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.

package Set::IntegerRange;

use Carp;

use Set::IntegerFast;

@ISA = qw();

@EXPORT = qw();

@EXPORT_OK = qw();

$VERSION = '1.0';

sub new
{
    croak("Usage: Set::IntegerRange::new(\$class,\$lower,\$upper)")
      if (@_ != 3);

    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $lower = shift;
    my $upper = shift;
    my $this;

    if ($lower <= $upper)
    {
        $this = [ new Set::IntegerFast($upper-$lower+1), $lower, $upper ];
        bless($this, $class);
        return($this);
    }
    else
    {
        croak "Set::IntegerRange::new(): lower > upper boundary";
    }
}

sub Empty
{
    croak("Usage: Set::IntegerRange::Empty(\$set)")
      if (@_ != 1);

    my($this) = @_;

    $this->[0]->Empty();
}

sub Fill
{
    croak("Usage: Set::IntegerRange::Fill(\$set)")
      if (@_ != 1);

    my($this) = @_;

    $this->[0]->Fill();
}

sub Insert
{
    croak("Usage: Set::IntegerRange::Insert(\$set,\$index)")
      if (@_ != 2);

    my($this,$index) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);

    if (($index >= $lower) && ($index <= $upper))
    {
        $this->[0]->Insert($index-$lower);
    }
    else
    {
        croak "Set::IntegerRange::Insert(): index out of range";
    }
}

sub Delete
{
    croak("Usage: Set::IntegerRange::Delete(\$set,\$index)")
      if (@_ != 2);

    my($this,$index) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);

    if (($index >= $lower) && ($index <= $upper))
    {
        $this->[0]->Delete($index-$lower);
    }
    else
    {
        croak "Set::IntegerRange::Delete(): index out of range";
    }
}

sub in
{
    croak("Usage: Set::IntegerRange::in(\$set,\$index)")
      if (@_ != 2);

    my($this,$index) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);

    if (($index >= $lower) && ($index <= $upper))
    {
        return($this->[0]->in($index-$lower));
    }
    else
    {
        croak "Set::IntegerRange::in(): index out of range";
    }
}

sub Norm
{
    croak("Usage: Set::IntegerRange::Norm(\$set)")
      if (@_ != 1);

    my($this) = @_;

    return($this->[0]->Norm());
}

sub Min
{
    croak("Usage: Set::IntegerRange::Min(\$set)")
      if (@_ != 1);

    my($this) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);
    my($temp);

    $temp = $this->[0]->Min();
    return( (($temp >= 0) && ($temp <= ($upper-$lower))) ? ($temp+$lower) : $temp );
}

sub Max
{
    croak("Usage: Set::IntegerRange::Max(\$set)")
      if (@_ != 1);

    my($this) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);
    my($temp);

    $temp = $this->[0]->Max();
    return( (($temp >= 0) && ($temp <= ($upper-$lower))) ? ($temp+$lower) : $temp );
}

sub Union
{
    croak("Usage: Set::IntegerRange::Union(\$set1,\$set2,\$set3)")
      if (@_ != 3);

    my($set1,$set2,$set3) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);
    my($lower3,$upper3) = ($set3->[1],$set3->[2]);

    if (($lower1 == $lower2) && ($lower1 == $lower3) &&
        ($upper1 == $upper2) && ($upper1 == $upper3))
    {
        $set1->[0]->Union($set2->[0],$set3->[0]);
    }
    else
    {
        croak "Set::IntegerRange::Union(): set size mismatch";
    }
}

sub Intersection
{
    croak("Usage: Set::IntegerRange::Intersection(\$set1,\$set2,\$set3)")
      if (@_ != 3);

    my($set1,$set2,$set3) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);
    my($lower3,$upper3) = ($set3->[1],$set3->[2]);

    if (($lower1 == $lower2) && ($lower1 == $lower3) &&
        ($upper1 == $upper2) && ($upper1 == $upper3))
    {
        $set1->[0]->Intersection($set2->[0],$set3->[0]);
    }
    else
    {
        croak "Set::IntegerRange::Intersection(): set size mismatch";
    }
}

sub Difference
{
    croak("Usage: Set::IntegerRange::Difference(\$set1,\$set2,\$set3)")
      if (@_ != 3);

    my($set1,$set2,$set3) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);
    my($lower3,$upper3) = ($set3->[1],$set3->[2]);

    if (($lower1 == $lower2) && ($lower1 == $lower3) &&
        ($upper1 == $upper2) && ($upper1 == $upper3))
    {
        $set1->[0]->Difference($set2->[0],$set3->[0]);
    }
    else
    {
        croak "Set::IntegerRange::Difference(): set size mismatch";
    }
}

sub ExclusiveOr
{
    croak("Usage: Set::IntegerRange::ExclusiveOr(\$set1,\$set2,\$set3)")
      if (@_ != 3);

    my($set1,$set2,$set3) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);
    my($lower3,$upper3) = ($set3->[1],$set3->[2]);

    if (($lower1 == $lower2) && ($lower1 == $lower3) &&
        ($upper1 == $upper2) && ($upper1 == $upper3))
    {
        $set1->[0]->ExclusiveOr($set2->[0],$set3->[0]);
    }
    else
    {
        croak "Set::IntegerRange::ExclusiveOr(): set size mismatch";
    }
}

sub Complement
{
    croak("Usage: Set::IntegerRange::Complement(\$set1,\$set2)")
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        $set1->[0]->Complement($set2->[0]);
    }
    else
    {
        croak "Set::IntegerRange::Complement(): set size mismatch";
    }
}

sub equal
{
    croak("Usage: Set::IntegerRange::equal(\$set1,\$set2)")
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        return($set1->[0]->equal($set2->[0]));
    }
    else
    {
        croak "Set::IntegerRange::equal(): set size mismatch";
    }
}

sub inclusion
{
    croak("Usage: Set::IntegerRange::inclusion(\$set1,\$set2)")
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        return($set1->[0]->inclusion($set2->[0]));
    }
    else
    {
        croak "Set::IntegerRange::inclusion(): set size mismatch";
    }
}

sub lexorder
{
    croak("Usage: Set::IntegerRange::lexorder(\$set1,\$set2)")
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        return($set1->[0]->lexorder($set2->[0]));
    }
    else
    {
        croak "Set::IntegerRange::lexorder(): set size mismatch";
    }
}

sub Compare
{
    croak("Usage: Set::IntegerRange::Compare(\$set1,\$set2)")
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        return($set1->[0]->Compare($set2->[0]));
    }
    else
    {
        croak "Set::IntegerRange::Compare(): set size mismatch";
    }
}

sub Copy
{
    croak("Usage: Set::IntegerRange::Copy(\$set1,\$set2)")
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        $set1->[0]->Copy($set2->[0]);
    }
    else
    {
        croak "Set::IntegerRange::Copy(): set size mismatch";
    }
}

1;

__END__

=head1 NAME

Set::IntegerRange - Sets of Integers

Easy manipulation of sets of integers (arbitrary intervals)

=head1 SYNOPSIS

=over 4

=item *

C<use Set::IntegerRange;>

=item *

C<$set = new Set::IntegerRange($lowerbound, $upperbound);>

the set object constructor method

=item *

C<$set = Set::IntegerRange-E<gt>new($lowerbound, $upperbound);>

alternate way of calling the set object constructor method

=item *

C<$set-E<gt>Empty();>

deletes all elements in the set

=item *

C<$set-E<gt>Fill();>

inserts all possible elements into the set

=item *

C<$set-E<gt>Insert($index);>

inserts a given element

=item *

C<$set-E<gt>Delete($index);>

deletes a given element

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

=back

=head1 DESCRIPTION

This class lets you dynamically create sets of arbitrary intervals of
integers and to perform all the basic operations for sets on them, like

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

Please refer to L<Set::IntegerFast(3)> for a detailed description of
each method!

Note that the method "Resize()" is not available in this class because
extending an existing set at the lower end would require a very
inefficient bitwise shift or copy of existing elements.

The method "Version()" is also unavailable in this module.

A method "DESTROY()" is not needed here since the destruction of objects
which aren't used anymore is taken care of implicitly and automatically
by Perl itself.

Note also that subclassing of this class is not impaired or disabled
in any way (in contrast to the "Set::IntegerFast" class).

=head1 SEE ALSO

Set::IntegerFast(3), perl(1), perlsub(1), perlmod(1), perlref(1),
perlobj(1), perlbot(1), perlxs(1), perlxstut(1), perlguts(1).

=head1 VERSION

This man page documents Set::IntegerRange version 1.0.

=head1 AUTHOR

Steffen Beyer <sb@sdm.de> (sd&m GmbH&Co.KG, Munich, Germany)

=head1 COPYRIGHT

Copyright (c) 1996 by Steffen Beyer. All rights reserved.

=head1 LICENSE AGREEMENT

This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

