
#  Copyright (c) 1996, 1997 by Steffen Beyer. All rights reserved.
#  This package is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.

package Set::IntegerRange;

use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw();

@EXPORT_OK = qw();

$VERSION = '3.0';

use Carp;

use Set::IntegerFast;

use overload
     'neg' => '_complement',
       '~' => '_complement',
    'bool' => '_boolean',
       '!' => '_not_boolean',
     'abs' => '_norm',
       '+' => '_union',
       '|' => '_union',                # alternative for '+'
       '-' => '_difference',
       '*' => '_intersection',
       '&' => '_intersection',         # alternative for '*'
       '^' => '_exclusive_or',
      '+=' => '_assign_union',
      '|=' => '_assign_union',         # alternative for '+='
      '-=' => '_assign_difference',
      '*=' => '_assign_intersection',
      '&=' => '_assign_intersection',  # alternative for '*='
      '^=' => '_assign_exclusive_or',
      '==' => '_equal',
      '!=' => '_not_equal',
       '<' => '_true_sub_set',
      '<=' => '_sub_set',
       '>' => '_true_super_set',
      '>=' => '_super_set',
     'cmp' => '_compare',
       '=' => '_clone',
'fallback' =>   undef;

sub new
{
    croak "Usage: Set::IntegerRange::new(\$class,\$lower,\$upper)"
      if (@_ != 3);

    my $proto = shift;
    my $class = ref($proto) || $proto || '';
    my $lower = shift;
    my $upper = shift;
    my $this;
    my $set;

    croak "Set::IntegerRange::new(): error in first parameter (class name or reference)"
      if ($class eq '');

    if ($lower <= $upper)
    {
        $set = new Set::IntegerFast($upper-$lower+1);
        if ((defined $set) && ref($set) && (${$set} != 0))
        {
            $this = [ $set, $lower, $upper ];
            bless($this, $class);
            return($this);
        }
        else { return(undef); }
    }
    else
    {
        croak "Set::IntegerRange::new(): lower > upper boundary";
    }
}

sub Size
{
    croak "Usage: Set::IntegerRange::Size(\$set)"
      if (@_ != 1);

    my($this) = @_;

    return( $this->[1], $this->[2] );
}

sub Empty
{
    croak "Usage: Set::IntegerRange::Empty(\$set)"
      if (@_ != 1);

    my($this) = @_;

    $this->[0]->Empty();
}

sub Fill
{
    croak "Usage: Set::IntegerRange::Fill(\$set)"
      if (@_ != 1);

    my($this) = @_;

    $this->[0]->Fill();
}

sub Empty_Interval
{
    croak "Usage: Set::IntegerRange::Empty_Interval(\$set,\$lower,\$upper)"
      if (@_ != 3);

    my($this,$lower,$upper) = @_;
    my($min,$max) = ($this->[1],$this->[2]);

    croak "Set::IntegerRange::Empty_Interval(): lower index out of range"
      if (($lower < $min) || ($lower > $max));

    croak "Set::IntegerRange::Empty_Interval(): upper index out of range"
      if (($upper < $min) || ($upper > $max));

    croak "Set::IntegerRange::Empty_Interval(): lower > upper index"
      if ($lower > $upper);

    $this->[0]->Empty_Interval($lower-$min,$upper-$min);
}

sub Fill_Interval
{
    croak "Usage: Set::IntegerRange::Fill_Interval(\$set,\$lower,\$upper)"
      if (@_ != 3);

    my($this,$lower,$upper) = @_;
    my($min,$max) = ($this->[1],$this->[2]);

    croak "Set::IntegerRange::Fill_Interval(): lower index out of range"
      if (($lower < $min) || ($lower > $max));

    croak "Set::IntegerRange::Fill_Interval(): upper index out of range"
      if (($upper < $min) || ($upper > $max));

    croak "Set::IntegerRange::Fill_Interval(): lower > upper index"
      if ($lower > $upper);

    $this->[0]->Fill_Interval($lower-$min,$upper-$min);
}

sub Flip_Interval
{
    croak "Usage: Set::IntegerRange::Flip_Interval(\$set,\$lower,\$upper)"
      if (@_ != 3);

    my($this,$lower,$upper) = @_;
    my($min,$max) = ($this->[1],$this->[2]);

    croak "Set::IntegerRange::Flip_Interval(): lower index out of range"
      if (($lower < $min) || ($lower > $max));

    croak "Set::IntegerRange::Flip_Interval(): upper index out of range"
      if (($upper < $min) || ($upper > $max));

    croak "Set::IntegerRange::Flip_Interval(): lower > upper index"
      if ($lower > $upper);

    $this->[0]->Flip_Interval($lower-$min,$upper-$min);
}

sub Insert
{
    croak "Usage: Set::IntegerRange::Insert(\$set,\$index)"
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
    croak "Usage: Set::IntegerRange::Delete(\$set,\$index)"
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

sub flip
{
    croak "Usage: Set::IntegerRange::flip(\$set,\$index)"
      if (@_ != 2);

    my($this,$index) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);

    if (($index >= $lower) && ($index <= $upper))
    {
        return( $this->[0]->flip($index-$lower) );
    }
    else
    {
        croak "Set::IntegerRange::flip(): index out of range";
    }
}

sub in
{
    croak "Usage: Set::IntegerRange::in(\$set,\$index)"
      if (@_ != 2);

    my($this,$index) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);

    if (($index >= $lower) && ($index <= $upper))
    {
        return( $this->[0]->in($index-$lower) );
    }
    else
    {
        croak "Set::IntegerRange::in(): index out of range";
    }
}

sub Norm
{
    croak "Usage: Set::IntegerRange::Norm(\$set)"
      if (@_ != 1);

    my($this) = @_;

    return( $this->[0]->Norm() );
}

sub Min
{
    croak "Usage: Set::IntegerRange::Min(\$set)"
      if (@_ != 1);

    my($this) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);
    my($temp);

    $temp = $this->[0]->Min();
    return( (($temp >= 0) && ($temp <= ($upper-$lower))) ? ($temp+$lower) : $temp );
}

sub Max
{
    croak "Usage: Set::IntegerRange::Max(\$set)"
      if (@_ != 1);

    my($this) = @_;
    my($lower,$upper) = ($this->[1],$this->[2]);
    my($temp);

    $temp = $this->[0]->Max();
    return( (($temp >= 0) && ($temp <= ($upper-$lower))) ? ($temp+$lower) : $temp );
}

sub Union
{
    croak "Usage: Set::IntegerRange::Union(\$set1,\$set2,\$set3)"
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
    croak "Usage: Set::IntegerRange::Intersection(\$set1,\$set2,\$set3)"
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
    croak "Usage: Set::IntegerRange::Difference(\$set1,\$set2,\$set3)"
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
    croak "Usage: Set::IntegerRange::ExclusiveOr(\$set1,\$set2,\$set3)"
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
    croak "Usage: Set::IntegerRange::Complement(\$set1,\$set2)"
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
    croak "Usage: Set::IntegerRange::equal(\$set1,\$set2)"
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        return( $set1->[0]->equal($set2->[0]) );
    }
    else
    {
        croak "Set::IntegerRange::equal(): set size mismatch";
    }
}

sub inclusion
{
    croak "Usage: Set::IntegerRange::inclusion(\$set1,\$set2)"
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        return( $set1->[0]->inclusion($set2->[0]) );
    }
    else
    {
        croak "Set::IntegerRange::inclusion(): set size mismatch";
    }
}

sub lexorder
{
    croak "Usage: Set::IntegerRange::lexorder(\$set1,\$set2)"
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        return( $set1->[0]->lexorder($set2->[0]) );
    }
    else
    {
        croak "Set::IntegerRange::lexorder(): set size mismatch";
    }
}

sub Compare
{
    croak "Usage: Set::IntegerRange::Compare(\$set1,\$set2)"
      if (@_ != 2);

    my($set1,$set2) = @_;
    my($lower1,$upper1) = ($set1->[1],$set1->[2]);
    my($lower2,$upper2) = ($set2->[1],$set2->[2]);

    if (($lower1 == $lower2) && ($upper1 == $upper2))
    {
        return( $set1->[0]->Compare($set2->[0]) );
    }
    else
    {
        croak "Set::IntegerRange::Compare(): set size mismatch";
    }
}

sub Copy
{
    croak "Usage: Set::IntegerRange::Copy(\$set1,\$set2)"
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

sub Shadow
{
    croak "Usage: Set::IntegerRange::Shadow(\$set)"
      if (@_ != 1);

    my($set) = @_;
    my($temp);

    $temp = $set->new($set->[1],$set->[2]);
    return($temp);
}

sub Clone
{
    croak "Usage: Set::IntegerRange::Clone(\$set)"
      if (@_ != 1);

    my($set) = @_;
    my($temp);

    $temp = $set->new($set->[1],$set->[2]);
    $temp->Copy($set);
    return($temp);
}

                ########################################
                #                                      #
                # define overloaded operators section: #
                #                                      #
                ########################################

sub _complement
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'~'"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    $temp = $object->new($object->[1],$object->[2]);
    $temp->Complement($object);
    return($temp);
}

sub _boolean
{
    my($object,$argument,$flag) = @_;
#   my($name) = "bool"; #&_trace($name,$object,$argument,$flag);

    return( $object->Min() <= $object->[2] );
}

sub _not_boolean
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'!'"; #&_trace($name,$object,$argument,$flag);

    return( !($object->Min() <= $object->[2]) );
}

sub _norm
{
    my($object,$argument,$flag) = @_;
#   my($name) = "abs"; #&_trace($name,$object,$argument,$flag);

    return( $object->Norm() );
}

sub _union
{
    my($object,$argument,$flag) = @_;
    my($name) = "'+'"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if (defined $flag)
        {
            $temp = $object->new($object->[1],$object->[2]);
            $temp->Union($object,$argument);
            return($temp);
        }
        else
        {
            $object->Union($object,$argument);
            return($object);
        }
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        if (defined $flag)
        {
            $temp = $object->new($object->[1],$object->[2]);
            $temp->Copy($object);
            $temp->Insert($argument);
            return($temp);
        }
        else
        {
            $object->Insert($argument);
            return($object);
        }
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
}

sub _difference
{
    my($object,$argument,$flag) = @_;
    my($name) = "'-'"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if (defined $flag)
        {
            $temp = $object->new($object->[1],$object->[2]);
            if ($flag) { $temp->Difference($argument,$object); }
            else       { $temp->Difference($object,$argument); }
            return($temp);
        }
        else
        {
            $object->Difference($object,$argument);
            return($object);
        }
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        if (defined $flag)
        {
            $temp = $object->new($object->[1],$object->[2]);
            if ($flag)
            {
                unless ($object->in($argument)) { $temp->Insert($argument); }
            }
            else
            {
                $temp->Copy($object);
                $temp->Delete($argument);
            }
            return($temp);
        }
        else
        {
            $object->Delete($argument);
            return($object);
        }
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
}

sub _intersection
{
    my($object,$argument,$flag) = @_;
    my($name) = "'*'"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if (defined $flag)
        {
            $temp = $object->new($object->[1],$object->[2]);
            $temp->Intersection($object,$argument);
            return($temp);
        }
        else
        {
            $object->Intersection($object,$argument);
            return($object);
        }
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        if (defined $flag)
        {
            $temp = $object->new($object->[1],$object->[2]);
            if ($object->in($argument)) { $temp->Insert($argument); }
            return($temp);
        }
        else
        {
            $flag = $object->in($argument);
            $object->Empty();
            if ($flag) { $object->Insert($argument); }
            return($object);
        }
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
}

sub _exclusive_or
{
    my($object,$argument,$flag) = @_;
    my($name) = "'^'"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if (defined $flag)
        {
            $temp = $object->new($object->[1],$object->[2]);
            $temp->ExclusiveOr($object,$argument);
            return($temp);
        }
        else
        {
            $object->ExclusiveOr($object,$argument);
            return($object);
        }
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        if (defined $flag)
        {
            $temp = $object->new($object->[1],$object->[2]);
            $temp->Copy($object);
            $temp->flip($argument);
            return($temp);
        }
        else
        {
            $object->flip($argument);
            return($object);
        }
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
}

sub _assign_union
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'+='"; #&_trace($name,$object,$argument,$flag);

    return( &_union($object,$argument,undef) );
}

sub _assign_difference
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'-='"; #&_trace($name,$object,$argument,$flag);

    return( &_difference($object,$argument,undef) );
}

sub _assign_intersection
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'*='"; #&_trace($name,$object,$argument,$flag);

    return( &_intersection($object,$argument,undef) );
}

sub _assign_exclusive_or
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'^='"; #&_trace($name,$object,$argument,$flag);

    return( &_exclusive_or($object,$argument,undef) );
}

sub _equal
{
    my($object,$argument,$flag) = @_;
    my($name) = "'=='"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        $temp = $argument;
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        $temp = $object->new($object->[1],$object->[2]);
        $temp->Insert($argument);
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
    return( $object->equal($temp) );
}

sub _not_equal
{
    my($object,$argument,$flag) = @_;
    my($name) = "'!='"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        $temp = $argument;
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        $temp = $object->new($object->[1],$object->[2]);
        $temp->Insert($argument);
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
    return( !($object->equal($temp)) );
}

sub _true_sub_set
{
    my($object,$argument,$flag) = @_;
    my($name) = "'<'"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        $temp = $argument;
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        $temp = $object->new($object->[1],$object->[2]);
        $temp->Insert($argument);
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
    if ((defined $flag) && $flag)
    {
        return( !($temp->equal($object)) &&
                 ($temp->inclusion($object)) );
    }
    else
    {
        return( !($object->equal($temp)) &&
                 ($object->inclusion($temp)) );
    }
}

sub _sub_set
{
    my($object,$argument,$flag) = @_;
    my($name) = "'<='"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        $temp = $argument;
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        $temp = $object->new($object->[1],$object->[2]);
        $temp->Insert($argument);
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
    if ((defined $flag) && $flag)
    {
        return( $temp->inclusion($object) );
    }
    else
    {
        return( $object->inclusion($temp) );
    }
}

sub _true_super_set
{
    my($object,$argument,$flag) = @_;
    my($name) = "'>'"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        $temp = $argument;
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        $temp = $object->new($object->[1],$object->[2]);
        $temp->Insert($argument);
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
    if ((defined $flag) && $flag)
    {
        return( !($object->equal($temp)) &&
                 ($object->inclusion($temp)) );
    }
    else
    {
        return( !($temp->equal($object)) &&
                 ($temp->inclusion($object)) );
    }
}

sub _super_set
{
    my($object,$argument,$flag) = @_;
    my($name) = "'>='"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        $temp = $argument;
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        $temp = $object->new($object->[1],$object->[2]);
        $temp->Insert($argument);
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
    if ((defined $flag) && $flag)
    {
        return( $object->inclusion($temp) );
    }
    else
    {
        return( $temp->inclusion($object) );
    }
}

sub _compare
{
    my($object,$argument,$flag) = @_;
    my($name) = "cmp"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        $temp = $argument;
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        $temp = $object->new($object->[1],$object->[2]);
        $temp->Insert($argument);
    }
    else
    {
        croak "Set::IntegerRange $name: wrong argument type";
    }
    if ((defined $flag) && $flag)
    {
        return( $temp->Compare($object) );
    }
    else
    {
        return( $object->Compare($temp) );
    }
}

sub _clone
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'='"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    $temp = $object->new($object->[1],$object->[2]);
    $temp->Copy($object);
    return($temp);
}

sub _trace
{
    my($text,$object,$argument,$flag) = @_;

    unless (defined $object)   { $object   = 'undef'; };
    unless (defined $argument) { $argument = 'undef'; };
    unless (defined $flag)     { $flag     = 'undef'; };
    if (ref($object))   { $object   = ref($object);   }
    if (ref($argument)) { $argument = ref($argument); }
    print "$text: \$obj='$object' \$arg='$argument' \$flag='$flag'\n";
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

C<$set = new Set::IntegerRange($lowerbound,$upperbound);>

the set object constructor method

Note that this method returns B<undef> if the necessary memory
cannot be allocated.

=item *

C<$set = Set::IntegerRange-E<gt>new($lowerbound,$upperbound);>

alternate way of calling the set object constructor method

=item *

C<$set2 = $set1-E<gt>>C<new($lowerbound,$upperbound);>

still another way of calling the set object constructor method ($set1
is not affected by this)

=item *

C<($lower,$upper) = $set-E<gt>Size();>

returns the lower and upper boundaries that the given set was created with

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

copies the contents of set2 to an B<ALREADY EXISTING> set1

=item *

C<$set1 = $set2-E<gt>Shadow();>

returns an object reference to a B<NEW> but B<EMPTY> set of
the B<SAME SIZE> as set2

=item *

C<$set1 = $set2-E<gt>Clone();>

returns an object reference to a B<NEW> set of the B<SAME SIZE> as
set2; the contents of set2 have B<ALREADY BEEN COPIED> to the new
set

=item *

B<Hint: method names all in lower case indicate a boolean return value!>

(Except for "C<new()>", of course!)

=back

Please refer to L<"OVERLOADED OPERATORS"> below for ways of using
overloaded operators instead of explicit method calls in order to
facilitate calculations with sets!

=head1 DESCRIPTION

This class lets you dynamically create sets of arbitrary intervals of
integers and perform all the basic operations for sets on them, like

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
each of the methods mentioned above under B<SYNOPSIS>!

Please refer to L<"OVERLOADED OPERATORS"> below for ways of using
overloaded operators instead of explicit method calls in order to
facilitate calculations with sets!

Note that the method "Resize()" is not available in this class because
extending an existing set at the lower end would require a very
inefficient bitwise shift or copy of existing elements.

The method "Version()" is also unavailable in this module.

A method "DESTROY()" is not needed here since the destruction of objects
which aren't used anymore is taken care of implicitly and automatically
by Perl itself.

Note also that subclassing of this class is not impaired or disabled
in any way (in contrast to the "Set::IntegerFast" class).

=head1 OVERLOADED OPERATORS

Calculations with sets can not only be performed with explicit method
calls using this module, but also through "magical" overloaded arithmetic
and relational operators.

For instance, instead of writing

    $set1 = Set::IntegerRange->new($lower,$upper);
    $set2 = Set::IntegerRange->new($lower,$upper);
    $set3 = Set::IntegerRange->new($lower,$upper);

    [...]

    $set3->Union($set1,$set2);

you can just say

    $set1 = Set::IntegerRange->new($lower,$upper);
    $set2 = Set::IntegerRange->new($lower,$upper);

    [...]

    $set3 = $set1 + $set2;

That's all!

Here is the list of all "magical" overloaded operators and their
semantics (meaning):

Unary operators: '-', '~', 'abs', testing, '!'

Binary (arithmetic) operators: '+' ('|'), '-', '*' ('&'), '^'

Binary (relational) operators: '==', '!=', '<', '<=', '>', '>='

(semantics are the same as common from set theory)

Binary (relational) operators: 'cmp', 'eq', 'ne', 'lt', 'le', 'gt', 'ge'

(special meaning)

=over 5

=item '-'

Unary Minus ( C<$set2 = -$set1;> )

Same as "Complement". See "Complement" below.

=item '~'

Complement ( C<$set2 = ~$set1;> )

The operator '~' (or unary '-') computes the complement of the given set.

Example:

    print( ( $odd == ~$even ) ? "true!\n" : "NOT true!\n" );

=item abs

Absolute Value ( C<$norm = abs($set);> )

In set theory, the absolute value of a set is defined as the number
of elements the given set contains. This is also called the "norm" of
the set.

Example:

    $set = new Set::IntegerRange(-42,42);
    print abs($set), "\n";
    $set->Fill();
    print abs($set), "\n";

This prints "0" and "85".

=item test

Boolean Test ( C<if ($set) { ... }> )

You can actually test a set as though it were a boolean value.

No special operator is needed for this; Perl automatically calls the
appropriate method in this package if "$set" is a blessed reference
to an object of the "Set::IntegerRange" class or one of its derived
classes.

This method returns "true" (1) if the given set is not empty and "false"
('') otherwise.

=item '!'

Negated Boolean Test ( C<if (! $set) { ... }> )

You can also perform a negated test on a set as though it were a boolean
value. For example:

    if (! $set) { ... }

    unless ($set) { ... }     #  internally, same as above!

This operator returns "true" (1) if the given set is empty and "false"
('') otherwise.

=item '+'

Union ( C<$set3 = $set1 + $set2;> )

The '+' operator is used to denote the union of two sets, as in

    $all   =  $odd + $even;

Note that you can also use the assignment form of the '+' operator, i.e.

    $all  +=  $odd;
    $all  +=  $even;

Even the use of the '++' operator is possible, although it doesn't
make much sense:

    $set++;

and

    ++$set;

This inserts element "1" into the set.

If one of the two arguments of the '+' operator is a number, this
number is inserted into the set. As the union of two sets is a
commutative operation, it doesn't matter wether the left or the
right argument is numeric:

    $set2  =  $set1 +   5;
    $set2  =  $set1 +  -1;
    $set2  =    0   + $set1;
    $set2  =   -2   + $set1;

or (as before)

    $set  +=   5;
    $set  +=  -1;
    $set  +=   0; # remember that this is element "0", not addition!
    $set  +=  -2;

=head2 Important Note:

In fact, when you are using a number as one of the two arguments to any
of the (binary) overloaded operators in this package, this number denotes
the set containing just that single element, i.e. {5}, {-1}, {0}, {-2}. (!)

Except for the '+', '-', '*' and '^' operator, this set (containing just
a single element) is B<explicitly constructed> before the requested operation
is carried out. (!)

In the case of the '+', '-', '*' and '^' operator, however, this has
been optimized so that the "Insert", "Delete" and "flip" method is
called directly (complexity of 1) as appropriate, instead of a costly
set operation (complexity of n/b).

=item '-'

Difference ( C<$set3 = $set1 - $set2;> )

In set theory, the difference of two sets is usually denoted by the
operator '\', i.e.  C<$primes \ $odd == {2}>.

Unfortunately, '\' is not an operator that Perl would recognize as such
and allow overloading of, so '-' is used instead.

Again, you have several possible ways of using this operator:

    $odd   =  $all  - $even;

    $all  -=  $even;

    $set2  =  $set1 -   5;
    $set2  =  $set1 -  -1;
    $set2  =    0   - $set1;
    $set2  =   -2   - $set1;

    $set  -=   5;
    $set  -=  -1;
    $set  -=   0;
    $set  -=  -2;

    $set--;
    --$set;

Note that C<$set2 = -2 - $set1;> for instance will yield either {} or {-2}
for $set2, depending on wether "-2" is contained in $set1 or not, because
this statement is equivalent to C<$set2 = {-2} \ $set1;>!

Note also that C<$set--;> and C<--$set;> just removes element "1" from the
set.

=item '*'

Intersection ( C<$set3 = $set1 * $set2;> )

The '*' operator is used to denote the intersection of two sets.

Again, you have several possibilities of using this operator:

    $two     =  $primes * $even;

    $primes *=  $even;

    $set2    =  $set1 *   5;
    $set2    =  $set1 *  -1;
    $set2    =    0   * $set1;
    $set2    =   -2   * $set1;

    $set    *=   5;
    $set    *=  -1;
    $set    *=   0;
    $set    *=  -2;

=item '^'

ExclusiveOr ( C<$set3 = $set1 ^ $set2;> )

(= "Symmetric Difference")

The '^' operator is used to denote the "exclusive-or" or symmetric difference
of two sets.

In fact this operation can be expressed in terms of the union, intersection
and difference of two sets as follows:

    $xor = ( $set1 + $set2 ) - ( $set1 * $set2 );

(Verify it!)

    print( ( $set1 ^ $set2 ) == ( ( $set1 + $set2 ) - ( $set1 * $set2 ) ) ?
        "true!\n" : "NOT true!\n" );

Providing an explicit operator for this operation is advantageous, though,
because it uses a built-in machine language instruction internally, which
is much faster than evaluating the above expression.

You have the following alternatives for using this operator:

    $odd   =  $all  ^ $even;

    $all  ^=  $even;

    $set2  =  $set1 ^   5;
    $set2  =  $set1 ^  -1;
    $set2  =    0   ^ $set1;
    $set2  =   -2   ^ $set1;

    $set  ^=   5;
    $set  ^=  -1;
    $set  ^=   0;
    $set  ^=  -2;

=item '=='

Test For Equality ( C<if ($set1 == $set2) { ... }> )

This operator tests two sets for equality.

Note that B<without> operator overloading, C<( $set1 == $set2 )> would
test wether the two references B<pointed to> the B<same object>! (!)

B<With> operator overloading in effect, C<( $set1 == $set2 )> tests wether
the two set objects B<contain> exactly the B<same elements>!

Example:

    $set1 = new Set::IntegerRange(-42,42);
    $set2 = new Set::IntegerRange(-42,42);

    &test( $set1, $set2 );

    $set2 = $set1;

    &test( $set1, $set2 );

    exit;

    sub test
    {
        my($set1,$set2) = @_;

        $set1->Empty();
        $set2->Empty();

        for ( $i = -42; $i <= 42; $i += 5 )
        {
            $set1 += $i;
            $set2 += $i;
        }

        print( ( $set1 == $set2 ) ?
            "sets are the same\n" : "references are NOT the same\n" );

        $set1 ^= -42;

        print( ( $set1 == $set2 ) ?
            "objects are the same\n" : "objects are NOT the same\n" );
    }

At the first call of "&test(...);" above, this will either print
"sets are the same" or "references are NOT the same", depending
on wether the '==' operator is overloaded or not, respectively.

It will also print "objects are NOT the same" in either case
because (at that time) the two references as well as the contents
of the two sets differ.

At the second call of "&test(...);" above, "sets are the same"
will be printed in either case because the two references point
to the same object (therefore, '==' evaluates to "true" if operator
overloading is B<not> in effect) or the two objects pointed to
by the two references have the same contents, and so '==' also
evaluates to "true" if operator overloading B<is> in effect.

(There a actually two distinct objects involved here if operator
overloading is in effect, for reasons explained further below!)

Depending on wether operator overloading is in effect or not, this
will then print "objects are NOT the same" or "objects are the same",
respectively.

This is easy to understand when operator overloading is B<not> in effect
because then the two references point to the same object, so changing one
of the two objects also changes the other. So the two references as well
as the contents of the two sets (which really are only one!) are the same.

If operator overloading is in effect, though, matters are a bit more
complicated: When there are two or more references pointing to the same
object, and an attempt is made to change that object via the assignment
variant of one of the overloaded operators using one of the references
pointing to that object, a clone copy of the object in question is created
first and the reference pointing to this clone copy is assigned to the
variable which held the reference to the original object, before the
requested operation is finally carried out B<on the clone copy> of the
original object!

Example:

    $b = new Set::IntegerRange($lower,$upper);
    $c = new Set::IntegerRange($lower,$upper);

    [...]

    $a = $b;

    [...]

    $a += $c;

Before the statement C<$a += $c;> actually gets executed, the following code
is executed internally:

    $temp = $a->new($lower,$upper); # creates an empty new set of same size
    $temp->Copy($a);                # copies the contents to the new set
    $a = $temp;                     # assigns the new reference to $a
    undef $temp;

This means that after the statement C<$a += $c;>, $a effectively points
to a different set than $b!

And probably (depending on $c) the contents of the two sets $a and $b
also differ! (Because the set pointed to by $b remains unaffected by
the operation performed on $a!)

This mechanism is intended to avoid (almost certainly) unwanted side
effects.

You can also regard this as a delayed ("lazy") form of execution of the
object copy operation you probably intended when writing C<$a = $b;>!
 
This means that when the first C<$set1 += $i;> is executed in the body
of the loop in the "test" subroutine above, $set1 gets assigned a clone
copy of $set2. This means that from that point on, $set1 and $set2
contain different references to different objects!

(With the same contents, however, at first!)

Only when the statement C<$set1 ^= -42;> (above) gets executed this becomes
apparent, however.

=item '!='

Test For Non-Equality ( C<if ($set1 != $set2) { ... }> )

This operator tests wether two sets are different.

Note again that this tests wether the B<contents> of the two sets are
not the same, and B<not> wether the two B<references> are different!

=item 'E<lt>'

Test For True Subset ( C<if ($set1 E<lt> $set2) { ... }> )

This operator tests wether $set1 is a true subset of $set2, i.e.
wether all elements contained in $set1 are also contained in $set2,
but not all elements contained in $set2 are contained in $set1.

=item 'E<lt>='

Test For Subset ( C<if ($set1 E<lt>= $set2) { ... }> )

This operator tests wether $set1 is a subset of $set2, i.e.
wether all elements contained in $set1 are also contained in $set2.

This also evaluates to "true" when the two sets contain exactly the
same elements, i.e. when the two sets are equal.

=item 'E<gt>'

Test For True Superset ( C<if ($set1 E<gt> $set2) { ... }> )

This operator tests wether $set1 is a true superset of $set2, i.e.
wether all elements contained in $set2 are also contained in $set1,
but not all elements contained in $set1 are contained in $set2.

Note that C<($set1 E<gt> $set2)> is exactly the same as
C<($set2 E<lt> $set1)>.

=item 'E<gt>='

Test For Superset ( C<if ($set1 E<gt>= $set2) { ... }> )

This operator tests wether $set1 is a superset of $set2, i.e.
wether all elements contained in $set2 are also contained in $set1.

This also evaluates to "true" when the two sets contain exactly the
same elements, i.e. when the two sets are equal.

Note that C<($set1 E<gt>= $set2)> is exactly the same as
C<($set2 E<lt>= $set1)>.

=item cmp

Compare ( C<$result = $set1 cmp $set2;> )

This operator compares the two sets lexically, i.e. it regards the
two bit vectors representing the two sets as two large (unsigned)
numbers in binary representation and returns "-1" if the number for
$set1 is smaller than that for $set2, "0" if the two numbers are
the same (i.e., when the two sets are equal!) or "1" if the number
representing $set1 is larger than the number representing $set2.

Note that this comparison has nothing to do whatsoever with set theory,
it is just an B<arbitrary> order relationship!

It is only intended to provide an (arbitrary) order by which (for example)
an array of sets can be sorted, for instance to find out quickly (using
binary search) if a specific set has already been produced before in some
set-producing process or not.

=item eq

"equal"

=item ne

"not equal"

=item lt

"less than"

=item le

"less than or equal"

=item gt

"greater than"

=item ge

"greater than or equal"

These are all operators derived from the "cmp" operator (see above).

They can be used instead of the "cmp" operator to make the intended
type of comparison more obvious in your code.

For instance, C<($set1 le $set2)> is much more readable and clearer than
C<(($set1 cmp $set2) E<lt>= 0)>!

=back

=head1 SEE ALSO

Set::IntegerFast(3), Math::MatrixBool(3), Math::MatrixReal(3),
DFA::Kleene(3), Kleene(3), Graph::Kruskal(3).

=head1 VERSION

This man page documents Set::IntegerRange version 3.0.

=head1 AUTHOR

Steffen Beyer <sb@sdm.de> (sd&m GmbH&Co.KG, Munich, Germany)

=head1 COPYRIGHT

Copyright (c) 1996, 1997 by Steffen Beyer. All rights reserved.

=head1 LICENSE AGREEMENT

This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

