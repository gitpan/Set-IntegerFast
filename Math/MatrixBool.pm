
#  Copyright (c) 1996, 1997 by Steffen Beyer. All rights reserved.
#  This package is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.

package Math::MatrixBool;

use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw();

@EXPORT_OK = qw();

$VERSION = '2.0';

bootstrap Math::MatrixBool $VERSION;

use Carp;

use Set::IntegerFast;

use overload
     'neg' => '_complement',
       '~' => '_complement',
    'bool' => '_boolean',
       '!' => '_not_boolean',
      '""' => '_stringify',
     'abs' => '_number_of_elements',
       '+' => '_addition',
       '*' => '_multiplication',
       '|' => '_union',
       '-' => '_difference',
       '&' => '_intersection',
       '^' => '_exclusive_or',
      '+=' => '_assign_addition',
      '*=' => '_assign_multiplication',
      '|=' => '_assign_union',
      '-=' => '_assign_difference',
      '&=' => '_assign_intersection',
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
    croak "Usage: \$new_matrix = Math::MatrixBool::new(\$class,\$rows,\$columns)"
      if (@_ != 3);

    my $proto = shift;
    my $class = ref($proto) || $proto || '';
    my $rows = shift;
    my $cols = shift;
    my $this;
    my $matrix;

    croak "Math::MatrixBool::new(): error in first parameter (class name or reference)"
      if ($class eq '');

    croak "Math::MatrixBool::new(): number of rows must be > 0"
      if ($rows <= 0);

    croak "Math::MatrixBool::new(): number of columns must be > 0"
      if ($cols <= 0);

    $matrix = new Set::IntegerFast($rows * $cols);
    if ((defined $matrix) && ref($matrix) && (${$matrix} != 0))
    {
        $this = [ $matrix, $rows, $cols ];
        bless($this, $class);
        return($this);
    }
    else { return(undef); }
}

sub new_from_string
{
    croak "Usage: \$new_matrix = Math::MatrixBool->new_from_string(\$string);"
      if (@_ != 2);

    my $proto  = shift;
    my $class  = ref($proto) || $proto || '';
    my $string = shift;
    my($line,$values);
    my($rows,$cols);
    my($row,$col);
    my($warn);
    my($this);

    croak "Math::MatrixBool::new_from_string(): error in first parameter (class name or reference)"
      if ($class eq '');

    $warn = 0;
    $rows = 0;
    $cols = 0;
    $values = [ ];
    while ($string =~ m!^\s* \[ \s+ ( (?: (?: 0|1 ) \s+ )+ ) \] \s*? \n !x)
    {
        $line = $1;
        $string = $';
        $values->[$rows] = [ ];
        @{$values->[$rows]} = split(' ', $line);
        $col = @{$values->[$rows]};
        if ($col != $cols)
        {
            unless ($cols == 0) { $warn = 1; }
            if ($col > $cols) { $cols = $col; }
        }
        $rows++;
    }
    if ($string !~ m!^\s*$!)
    {
        croak "Math::MatrixBool::new_from_string(): syntax error in input string";
    }
    if ($rows == 0)
    {
        croak "Math::MatrixBool::new_from_string(): empty input string";
    }
    if ($warn)
    {
        warn "Math::MatrixBool::new_from_string(): missing elements will be set to zero!\n";
    }
    $this = Math::MatrixBool::new($class,$rows,$cols);
    for ( $row = 0; $row < $rows; $row++ )
    {
        for ( $col = 0; $col < @{$values->[$row]}; $col++ )
        {
            if ($values->[$row][$col] != 0)
            {
                $this->[0]->Insert( $row * $cols + $col );
            }
        }
    }
    return($this);
}

sub Dim  #  Returns dimensions of a matrix
{
    croak "Usage: (\$rows,\$columns) = Math::MatrixBool::Dim(\$matrix);"
      if (@_ != 1);
 
    my($matrix) = @_;
 
    return( $matrix->[1], $matrix->[2] );
}

sub Zero
{
    croak "Usage: Math::MatrixBool::Zero(\$matrix)"
      if (@_ != 1);

    my($this) = @_;

    $this->[0]->Empty();
}

sub Fill
{
    croak "Usage: Math::MatrixBool::Fill(\$matrix)"
      if (@_ != 1);

    my($this) = @_;

    $this->[0]->Fill();
}

sub One  #  Fills main diagonal
{
    croak "Usage: Math::MatrixBool::One(\$matrix)"
      if (@_ != 1);

    my($this) = @_;
    my($rows,$cols) = ($this->[1],$this->[2]);
    my($i,$k);

    $this->[0]->Empty();
    $k = ($rows <= $cols) ? $rows : $cols;
    for ( $i = 0; $i < $k; $i++ )
    {
        $this->[0]->Insert( $i * $cols + $i );
    }
}

sub Insert
{
    croak "Usage: Math::MatrixBool::Insert(\$matrix,\$row,\$column)"
      if (@_ != 3);

    my($this,$row,$col) = @_;
    my($rows,$cols) = ($this->[1],$this->[2]);

    croak "Math::MatrixBool::Insert(): row index out of range"
      if (($row < 1) || ($row > $rows));
    croak "Math::MatrixBool::Insert(): column index out of range"
      if (($col < 1) || ($col > $cols));

    $this->[0]->Insert( --$row * $cols + --$col );
}

sub Delete
{
    croak "Usage: Math::MatrixBool::Delete(\$matrix,\$row,\$column)"
      if (@_ != 3);

    my($this,$row,$col) = @_;
    my($rows,$cols) = ($this->[1],$this->[2]);

    croak "Math::MatrixBool::Delete(): row index out of range"
      if (($row < 1) || ($row > $rows));
    croak "Math::MatrixBool::Delete(): column index out of range"
      if (($col < 1) || ($col > $cols));

    $this->[0]->Delete( --$row * $cols + --$col );
}

sub flip
{
    croak "Usage: \$boolean = Math::MatrixBool::flip(\$matrix,\$row,\$column)"
      if (@_ != 3);

    my($this,$row,$col) = @_;
    my($rows,$cols) = ($this->[1],$this->[2]);

    croak "Math::MatrixBool::flip(): row index out of range"
      if (($row < 1) || ($row > $rows));
    croak "Math::MatrixBool::flip(): column index out of range"
      if (($col < 1) || ($col > $cols));

    return( $this->[0]->flip( --$row * $cols + --$col ) );
}

sub in
{
    croak "Usage: \$boolean = Math::MatrixBool::in(\$matrix,\$row,\$column)"
      if (@_ != 3);

    my($this,$row,$col) = @_;
    my($rows,$cols) = ($this->[1],$this->[2]);

    croak "Math::MatrixBool::in(): row index out of range"
      if (($row < 1) || ($row > $rows));
    croak "Math::MatrixBool::in(): column index out of range"
      if (($col < 1) || ($col > $cols));

    return( $this->[0]->in( --$row * $cols + --$col ) );
}

sub Min
{
    croak "Usage: \$minimum = Math::MatrixBool::Min(\$matrix)"
      if (@_ != 1);

    my($this) = @_;

    return( $this->[0]->Min() );
}

sub Number_of_elements  #  returns the number of elements which are set
{
    croak "Usage: \$elements = Math::MatrixBool::Number_of_elements(\$matrix)"
      if (@_ != 1);

    my($this) = @_;

    return( $this->[0]->Norm() );
}

sub Norm_max  #  Maximum of sums of each row
{
    croak "Usage: \$norm_max = Math::MatrixBool::Norm_max(\$matrix)"
      if (@_ != 1);

    my($this) = @_;
    my($rows,$cols) = ($this->[1],$this->[2]);
    my($max,$sum,$i,$j);

    $max = 0;
    for ( $i = 0; $i < $rows; $i++ )
    {
        $sum = 0;
        for ( $j = 0; $j < $cols; $j++ )
        {
            $sum ^= $this->[0]->in( $i * $cols + $j );
            # in general, this is $sum += abs( $matrix[$i][$j] );
        }
        if ($sum > $max) { $max = $sum; }
    }
    return($max);
}

sub Norm_one  #  Maximum of sums of each column
{
    croak "Usage: \$norm_one = Math::MatrixBool::Norm_one(\$matrix)"
      if (@_ != 1);

    my($this) = @_;
    my($rows,$cols) = ($this->[1],$this->[2]);
    my($max,$sum,$i,$j);

    $max = 0;
    for ( $j = 0; $j < $cols; $j++ )
    {
        $sum = 0;
        for ( $i = 0; $i < $rows; $i++ )
        {
            $sum ^= $this->[0]->in( $i * $cols + $j );
            # in general, this is $sum += abs( $matrix[$i][$j] );
        }
        if ($sum > $max) { $max = $sum; }
    }
    return($max);
}

sub Addition
{
    croak "Usage: Math::MatrixBool::Addition(\$matrix1,\$matrix2,\$matrix3)"
      if (@_ != 3);

    my($matrix1,$matrix2,$matrix3) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);
    my($rows3,$cols3) = ($matrix3->[1],$matrix3->[2]);

    if (($rows1 == $rows2) && ($rows1 == $rows3) &&
        ($cols1 == $cols2) && ($cols1 == $cols3))
    {
        $matrix1->[0]->ExclusiveOr($matrix2->[0],$matrix3->[0]);
    }
    else
    {
        croak "Math::MatrixBool::Addition(): matrix size mismatch";
    }
}

sub Multiplication
{
    croak "Usage: \$product_matrix = Math::MatrixBool::Multiplication(\$matrix1,\$matrix2)"
      if (@_ != 2);

    my($matrix1,$matrix2) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);
    my($temp);

    if ($cols1 == $rows2)
    {
        $temp = $matrix1->new($rows1,$cols2);
        Multiply($temp->[0],$rows1,$cols2,
              $matrix1->[0],$rows1,$cols1,
              $matrix2->[0],$rows2,$cols2);
    }
    else
    {
        croak "Math::MatrixBool::Multiplication(): matrix size mismatch";
    }
    return($temp);
}

sub Kleene
{
    croak "Usage: Math::MatrixBool::Kleene(\$matrix1,\$matrix2)"
      if (@_ != 2);

    my($matrix1,$matrix2) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);

    croak "Math::MatrixBool::Kleene(): matrix is not quadratic"
      if ($rows2 != $cols2);

    if (($rows1 == $rows2) && ($cols1 == $cols2))
    {
        $matrix1->Copy($matrix2);
        Closure($matrix1->[0],$rows1,$cols1);
    }
    else
    {
        croak "Math::MatrixBool::Kleene(): matrix size mismatch";
    }
}

sub Union
{
    croak "Usage: Math::MatrixBool::Union(\$matrix1,\$matrix2,\$matrix3)"
      if (@_ != 3);

    my($matrix1,$matrix2,$matrix3) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);
    my($rows3,$cols3) = ($matrix3->[1],$matrix3->[2]);

    if (($rows1 == $rows2) && ($rows1 == $rows3) &&
        ($cols1 == $cols2) && ($cols1 == $cols3))
    {
        $matrix1->[0]->Union($matrix2->[0],$matrix3->[0]);
    }
    else
    {
        croak "Math::MatrixBool::Union(): matrix size mismatch";
    }
}

sub Intersection
{
    croak "Usage: Math::MatrixBool::Intersection(\$matrix1,\$matrix2,\$matrix3)"
      if (@_ != 3);

    my($matrix1,$matrix2,$matrix3) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);
    my($rows3,$cols3) = ($matrix3->[1],$matrix3->[2]);

    if (($rows1 == $rows2) && ($rows1 == $rows3) &&
        ($cols1 == $cols2) && ($cols1 == $cols3))
    {
        $matrix1->[0]->Intersection($matrix2->[0],$matrix3->[0]);
    }
    else
    {
        croak "Math::MatrixBool::Intersection(): matrix size mismatch";
    }
}

sub Difference
{
    croak "Usage: Math::MatrixBool::Difference(\$matrix1,\$matrix2,\$matrix3)"
      if (@_ != 3);

    my($matrix1,$matrix2,$matrix3) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);
    my($rows3,$cols3) = ($matrix3->[1],$matrix3->[2]);

    if (($rows1 == $rows2) && ($rows1 == $rows3) &&
        ($cols1 == $cols2) && ($cols1 == $cols3))
    {
        $matrix1->[0]->Difference($matrix2->[0],$matrix3->[0]);
    }
    else
    {
        croak "Math::MatrixBool::Difference(): matrix size mismatch";
    }
}

sub ExclusiveOr
{
    croak "Usage: Math::MatrixBool::ExclusiveOr(\$matrix1,\$matrix2,\$matrix3)"
      if (@_ != 3);

    my($matrix1,$matrix2,$matrix3) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);
    my($rows3,$cols3) = ($matrix3->[1],$matrix3->[2]);

    if (($rows1 == $rows2) && ($rows1 == $rows3) &&
        ($cols1 == $cols2) && ($cols1 == $cols3))
    {
        $matrix1->[0]->ExclusiveOr($matrix2->[0],$matrix3->[0]);
    }
    else
    {
        croak "Math::MatrixBool::ExclusiveOr(): matrix size mismatch";
    }
}

sub Complement
{
    croak "Usage: Math::MatrixBool::Complement(\$matrix1,\$matrix2)"
      if (@_ != 2);

    my($matrix1,$matrix2) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);

    if (($rows1 == $rows2) && ($cols1 == $cols2))
    {
        $matrix1->[0]->Complement($matrix2->[0]);
    }
    else
    {
        croak "Math::MatrixBool::Complement(): matrix size mismatch";
    }
}

sub equal
{
    croak "Usage: \$boolean = Math::MatrixBool::equal(\$matrix1,\$matrix2)"
      if (@_ != 2);

    my($matrix1,$matrix2) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);

    if (($rows1 == $rows2) && ($cols1 == $cols2))
    {
        return( $matrix1->[0]->equal($matrix2->[0]) );
    }
    else
    {
        croak "Math::MatrixBool::equal(): matrix size mismatch";
    }
}

sub inclusion
{
    croak "Usage: \$boolean = Math::MatrixBool::inclusion(\$matrix1,\$matrix2)"
      if (@_ != 2);

    my($matrix1,$matrix2) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);

    if (($rows1 == $rows2) && ($cols1 == $cols2))
    {
        return( $matrix1->[0]->inclusion($matrix2->[0]) );
    }
    else
    {
        croak "Math::MatrixBool::inclusion(): matrix size mismatch";
    }
}

sub lexorder
{
    croak "Usage: \$boolean = Math::MatrixBool::lexorder(\$matrix1,\$matrix2)"
      if (@_ != 2);

    my($matrix1,$matrix2) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);

    if (($rows1 == $rows2) && ($cols1 == $cols2))
    {
        return( $matrix1->[0]->lexorder($matrix2->[0]) );
    }
    else
    {
        croak "Math::MatrixBool::lexorder(): matrix size mismatch";
    }
}

sub Compare
{
    croak "Usage: \$result = Math::MatrixBool::Compare(\$matrix1,\$matrix2)"
      if (@_ != 2);

    my($matrix1,$matrix2) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);

    if (($rows1 == $rows2) && ($cols1 == $cols2))
    {
        return( $matrix1->[0]->Compare($matrix2->[0]) );
    }
    else
    {
        croak "Math::MatrixBool::Compare(): matrix size mismatch";
    }
}

sub Copy
{
    croak "Usage: Math::MatrixBool::Copy(\$matrix1,\$matrix2)"
      if (@_ != 2);

    my($matrix1,$matrix2) = @_;
    my($rows1,$cols1) = ($matrix1->[1],$matrix1->[2]);
    my($rows2,$cols2) = ($matrix2->[1],$matrix2->[2]);

    if (($rows1 == $rows2) && ($cols1 == $cols2))
    {
        $matrix1->[0]->Copy($matrix2->[0]);
    }
    else
    {
        croak "Math::MatrixBool::Copy(): matrix size mismatch";
    }
}

sub Shadow
{
    croak "Usage: \$new_matrix = Math::MatrixBool::Shadow(\$some_matrix)"
      if (@_ != 1);

    my($matrix) = @_;
    my($temp);

    $temp = $matrix->new($matrix->[1],$matrix->[2]);
    return($temp);
}

sub Clone
{
    croak "Usage: \$twin_matrix = Math::MatrixBool::Clone(\$some_matrix)"
      if (@_ != 1);

    my($matrix) = @_;
    my($temp);

    $temp = $matrix->new($matrix->[1],$matrix->[2]);
    $temp->Copy($matrix);
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

    return( $object->Min() < $object->[1] * $object->[2] );
}

sub _not_boolean
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'!'"; #&_trace($name,$object,$argument,$flag);

    return( !($object->Min() < $object->[1] * $object->[2]) );
}

sub _stringify
{
    my($object,$argument,$flag) = @_;
#   my($name) = '""'; #&_trace($name,$object,$argument,$flag);
    my($rows,$cols) = ($object->[1],$object->[2]);
    my($i,$j,$s);

    $s = '';
    for ( $i = 1; $i <= $rows; $i++ )
    {
        $s .= "[ ";
        for ( $j = 1; $j <= $cols; $j++ )
        {
            if ($object->in($i,$j)) { $s .= "1 "; } else { $s .= "0 "; }
        }
        $s .= "]\n";
    }
    return($s);
}

sub _number_of_elements
{
    my($object,$argument,$flag) = @_;
#   my($name) = "abs"; #&_trace($name,$object,$argument,$flag);

    return( $object->Number_of_elements() );
}

sub _addition
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
            $temp->ExclusiveOr($object,$argument);
            return($temp);
        }
        else
        {
            $object->ExclusiveOr($object,$argument);
            return($object);
        }
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _multiplication
{
    my($object,$argument,$flag) = @_;
    my($name) = "'*'"; #&_trace($name,$object,$argument,$flag);
    my($temp);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if ((defined $flag) && $flag)
        {
            return( Multiplication($argument,$object) );
        }
        else
        {
            return( Multiplication($object,$argument) );
        }
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _union
{
    my($object,$argument,$flag) = @_;
    my($name) = "'|'"; #&_trace($name,$object,$argument,$flag);
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
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
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
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _intersection
{
    my($object,$argument,$flag) = @_;
    my($name) = "'&'"; #&_trace($name,$object,$argument,$flag);
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
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
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
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _assign_addition
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'+='"; #&_trace($name,$object,$argument,$flag);

    return( &_addition($object,$argument,undef) );
}

sub _assign_multiplication
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'*='"; #&_trace($name,$object,$argument,$flag);

    return( &_multiplication($object,$argument,undef) );
}

sub _assign_union
{
    my($object,$argument,$flag) = @_;
#   my($name) = "'|='"; #&_trace($name,$object,$argument,$flag);

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
#   my($name) = "'&='"; #&_trace($name,$object,$argument,$flag);

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

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        return( $object->equal($argument) );
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _not_equal
{
    my($object,$argument,$flag) = @_;
    my($name) = "'!='"; #&_trace($name,$object,$argument,$flag);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        return( !($object->equal($argument)) );
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _true_sub_set
{
    my($object,$argument,$flag) = @_;
    my($name) = "'<'"; #&_trace($name,$object,$argument,$flag);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if ((defined $flag) && $flag)
        {
            return( !($argument->equal($object)) &&
                     ($argument->inclusion($object)) );
        }
        else
        {
            return( !($object->equal($argument)) &&
                     ($object->inclusion($argument)) );
        }
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _sub_set
{
    my($object,$argument,$flag) = @_;
    my($name) = "'<='"; #&_trace($name,$object,$argument,$flag);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if ((defined $flag) && $flag)
        {
            return( $argument->inclusion($object) );
        }
        else
        {
            return( $object->inclusion($argument) );
        }
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _true_super_set
{
    my($object,$argument,$flag) = @_;
    my($name) = "'>'"; #&_trace($name,$object,$argument,$flag);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if ((defined $flag) && $flag)
        {
            return( !($object->equal($argument)) &&
                     ($object->inclusion($argument)) );
        }
        else
        {
            return( !($argument->equal($object)) &&
                     ($argument->inclusion($object)) );
        }
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _super_set
{
    my($object,$argument,$flag) = @_;
    my($name) = "'>='"; #&_trace($name,$object,$argument,$flag);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if ((defined $flag) && $flag)
        {
            return( $object->inclusion($argument) );
        }
        else
        {
            return( $argument->inclusion($object) );
        }
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
    }
}

sub _compare
{
    my($object,$argument,$flag) = @_;
    my($name) = "cmp"; #&_trace($name,$object,$argument,$flag);

    if ((defined $argument) && ref($argument) &&
        (ref($argument) !~ /^SCALAR$|^ARRAY$|^HASH$|^CODE$|^REF$/))
    {
        if ((defined $flag) && $flag)
        {
            return( $argument->Compare($object) );
        }
        else
        {
            return( $object->Compare($argument) );
        }
    }
    else
    {
        croak "Math::MatrixBool $name: wrong argument type";
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

Math::MatrixBool - Matrix of Booleans

Easy manipulation of matrices of booleans (Boolean Algebra)

=head1 SYNOPSIS

=over 4

=item *

C<use Math::MatrixBool;>

=item *

C<$new_matrix = new Math::MatrixBool($rows,$columns);>

the matrix object constructor method

Note that this method returns B<undef> if the necessary memory
cannot be allocated.

=item *

C<$new_matrix = Math::MatrixBool-E<gt>new($rows,$columns);>

alternate way of calling the matrix object constructor method

=item *

C<$new_matrix = $some_matrix-E<gt>>C<new($rows,$columns);>

still another way of calling the matrix object constructor method
($some_matrix is not affected by this)

=item *

C<$new_matrix = Math::MatrixBool-E<gt>>C<new_from_string($string);>

This method allows you to read in a matrix from a string (for
instance, from the keyboard, from a file or from your code).

The syntax is simple: each row must start with "[" and end with "]"
and a "\n" and contain one or more numbers, all separated by spaces
or tabs. Additional spaces or tabs can be added at will, but no
comments. Numbers are either "0" or "1".

Examples:

    $string = "[ 1 0 0 ]\n[ 1 1 0 ]\n[ 1 1 1 ]\n";
    $matrix = Math::MatrixBool->new_from_string($string);
    print "$matrix";

By the way, this prints

    [ 1 0 0 ]
    [ 1 1 0 ]
    [ 1 1 1 ]

But you can also do this in a much more comfortable way using the
shell-like "here-document" syntax:

    $matrix = Math::MatrixBool->new_from_string(<<'MATRIX');
    [  1  0  0  0  0  0  1  ]
    [  0  1  0  0  0  0  0  ]
    [  0  0  1  0  0  0  0  ]
    [  0  0  0  1  0  0  0  ]
    [  0  0  0  0  1  0  0  ]
    [  0  0  0  0  0  1  0  ]
    [  1  0  0  0  0  0  1  ]
    MATRIX

You can even use variables in the matrix:

    $c1  =  $A1 * $x1 - $b1 >= 0  ?"1":"0";
    $c1  =  $A2 * $x2 - $b2 >= 0  ?"1":"0";
    $c1  =  $A3 * $x3 - $b3 >= 0  ?"1":"0";

    $matrix = Math::MatrixBool->new_from_string(<<"MATRIX");

        [   1    0    0   ]
        [   0    1    0   ]
        [  $c1  $c2  $c3  ]

    MATRIX

(Remember that you may use spaces and tabs to format the matrix to
your taste)

Note that this method uses exactly the same representation for a
matrix as the "stringify" operator "": this means that you can convert
any matrix into a string with C<$string = "$matrix";> and read it back
in later (for instance from a file!).

If the string you supply (or someone else supplies) does not obey
the syntax mentioned above, an exception is raised, which can be
caught by "eval" as follows:

    print "Please enter your matrix: ";
    $string = <STDIN>;
    eval { $matrix = Math::MatrixBool->new_from_string($string); };
    if ($@)
    {
        print "$@";
        # ...
        # (error handling)
    }
    else
    {
        # continue...
    }

or as follows:

    eval { $matrix = Math::MatrixBool->new_from_string(<<"MATRIX"); };
    [   1    0    0   ]
    [   0    1    0   ]
    [  $c1  $c2  $c3  ]
    MATRIX
    if ($@)
    # ...

Possible error messages are:

    Math::MatrixBool::new_from_string(): syntax error in input string
    Math::MatrixBool::new_from_string(): empty input string

If the input string has rows with varying numbers of columns,
the following warning will be printed to STDERR:

    Math::MatrixBool::new_from_string(): missing elements will be set to zero!

If everything is okay, the method returns an object reference to the
(newly allocated) matrix containing the elements you specified.

=item *

C<($rows,$columns) = $matrix-E<gt>Dim();>

returns the dimensions (= number of rows and columns) of the given matrix

=item *

C<$matrix-E<gt>Zero();>

deletes all elements in the matrix

=item *

C<$matrix-E<gt>Fill();>

inserts all possible elements into the matrix

=item *

C<$matrix-E<gt>One();>

fills the matrix with one's in the main diagonal and zero's elsewhere

Note that multiplying this matrix with itself yields the same matrix again
(provided it is quadratic)!

=item *

C<$matrix-E<gt>Insert($row,$column);>

inserts a given element

=item *

C<$matrix-E<gt>Delete($row,$column);>

deletes a given element

=item *

C<$boolean = $matrix-E<gt>>C<flip($row,$column);>

flips a given element and returns its new value

=item *

C<$boolean = $matrix-E<gt>>C<in($row,$column);>

tests wether a given element is set

=item *

C<$elements = $matrix-E<gt>Number_of_elements();>

calculates the number of elements contained in the given matrix

=item *

C<$norm_max = $matrix-E<gt>Norm_max();>

calculates the "maximum"-norm of the given matrix

=item *

C<$norm_one = $matrix-E<gt>Norm_one();>

calculates the "1"-norm of the given matrix

=item *

C<$matrix1-E<gt>Addition($matrix2,$matrix3);>

calculates the sum of matrix2 and matrix3 and stores the result in matrix1
(in-place is also possible)

=item *

C<$product_matrix = $matrix1-E<gt>Multiplication($matrix2);>

calculates the product of matrix1 and matrix2 and returns an object reference
to a new matrix where the result is stored

=item *

C<$matrix1-E<gt>Kleene($matrix2);>

computes the reflexive transitive closure of the given matrix (matrix2)
and stores the result in matrix1 (in-place is also possible)

Uses a variant of Kleene's algorithm. See L<Kleene(3)> for more details
about this algorithm!

This algorithm is mainly used in graph theory: Each position in the matrix
corresponds to a (directed!) possible connection ("edge") between two points
("vortices") of a graph. Each position in the matrix contains a "1" if the
corresponding edge is part of the graph and a "0" if not.

Computing the closure of this matrix means to find out if there is a path
from any vortice of the graph to any other (a path consisting of one or more
edges).

Note that there are more applications of Kleene's algorithm in other fields
as well (see also Math::MatrixReal(3), DFA::Kleene(3), Kleene(3)).

=item *

C<$matrix1-E<gt>Union($matrix2,$matrix3);>

calculates the union of matrix2 and matrix3 and stores the result in matrix1
(in-place is also possible)

=item *

C<$matrix1-E<gt>Intersection($matrix2,$matrix3);>

calculates the intersection of matrix2 and matrix3 and stores the result in matrix1
(in-place is also possible)

=item *

C<$matrix1-E<gt>Difference($matrix2,$matrix3);>

calculates matrix2 "minus" matrix3 ( = matrix2 \ matrix3 ) and stores the result in matrix1
(in-place is also possible)

Note that this is set difference, not matrix difference! Matrix difference
degenerates to (= is the same as) matrix addition in a Boolean Algebra!!

=item *

C<$matrix1-E<gt>ExclusiveOr($matrix2,$matrix3);>

calculates the exclusive-or (which in the case of a Boolean Algebra happens
to be the same as the addition) of matrix2 and matrix3 and stores the
result in matrix1 (in-place is also possible)

=item *

C<$matrix1-E<gt>Complement($matrix2);>

calculates the complement of matrix2 and stores the result in matrix1
(in-place is also possible)

=item *

C<$boolean = $matrix1-E<gt>equal($matrix2);>

tests if matrix1 is the same as matrix2

=item *

C<$boolean = $matrix1-E<gt>inclusion($matrix2);>

tests if matrix1 is contained in matrix2

=item *

C<$boolean = $matrix1-E<gt>lexorder($matrix2);>

tests if matrix1 comes lexically before matrix2, i.e., if (matrix1 <= matrix2)
holds, as though the two bit vectors used to represent the two matrices were
two large numbers in binary representation

(Note that this is an B<arbitrary> order relationship!)

=item *

C<$result = $matrix1-E<gt>Compare($matrix2);>

lexically compares matrix1 and matrix2 and returns -1, 0 or 1 if
(matrix1 < matrix2), (matrix1 == matrix2) or (matrix1 > matrix2) holds,
respectively

(Again, the two bit vectors representing the two matrices are compared as
though they were two large numbers in binary representation)

=item *

C<$matrix1-E<gt>Copy($matrix2);>

copies the contents of matrix2 to an B<ALREADY EXISTING> matrix1

=item *

C<$new_matrix = $some_matrix-E<gt>Shadow();>

returns an object reference to a B<NEW> but B<EMPTY> matrix of
the B<SAME SIZE> as some_matrix

=item *

C<$twin_matrix = $some_matrix-E<gt>Clone();>

returns an object reference to a B<NEW> matrix of the B<SAME SIZE> as
some_matrix; the contents of some_matrix have B<ALREADY BEEN COPIED>
to the new matrix

=item *

B<Hint: method names all in lower case indicate a boolean return value!>

(Except for "C<new()>" and "C<new_from_string()>", of course!)

=back

Please refer to L<"OVERLOADED OPERATORS"> below for ways of using
overloaded operators instead of explicit method calls in order to
facilitate calculations with matrices!

=head1 DESCRIPTION

This class lets you dynamically create boolean matrices of arbitrary
size and perform all the basic operations for matrices on them, like

=over 4

=item -

setting or deleting elements,

=item -

testing wether a certain element is set,

=item -

computing the sum, difference, product, closure and complement of matrices,

(you can also compute the union, intersection, difference and exclusive-or
of the underlying bit vector)

=item -

copying matrices,

=item -

testing two matrices for equality or inclusion, and

=item -

computing the number of elements and the norm of a matrix.

=back

Please refer to L<"OVERLOADED OPERATORS"> below for ways of using
overloaded operators instead of explicit method calls in order to
facilitate calculations with matrices!

Note that the method "Resize()" is not available in this class because
extending an existing matrix would require a very inefficient bitwise
shift and/or copy of existing elements.

The method "Version()" is also unavailable in this module.

A method "DESTROY()" is not needed here since the destruction of objects
which aren't used anymore is taken care of implicitly and automatically
by Perl itself.

Note also that subclassing of this class is not impaired or disabled
in any way (in contrast to the "Set::IntegerFast" class).

=head1 OVERLOADED OPERATORS

Calculations with matrices can not only be performed with explicit method
calls using this module, but also through "magical" overloaded arithmetic
and relational operators.

For instance, instead of writing

    $matrix1 = Math::MatrixBool->new($rows,$columns);
    $matrix2 = Math::MatrixBool->new($rows,$columns);
    $matrix3 = Math::MatrixBool->new($rows,$columns);

    [...]

    $matrix3->Multiplication($matrix1,$matrix2);

you can just say

    $matrix1 = Math::MatrixBool->new($rows,$columns);
    $matrix2 = Math::MatrixBool->new($rows,$columns);

    [...]

    $matrix3 = $matrix1 * $matrix2;

That's all!

Here is the list of all "magical" overloaded operators and their
semantics (meaning):

Unary operators: '-', '~', 'abs', testing, '!', '""'

Binary (arithmetic) operators: '+', '*', '|', '-', '&', '^'

Binary (relational) operators: '==', '!=', '<', '<=', '>', '>='

Binary (relational) operators: 'cmp', 'eq', 'ne', 'lt', 'le', 'gt', 'ge'

Note that both arguments to a binary operator from the list above must
be matrices; numbers or other types of data are not permitted as arguments
and will produce an error message.

=over 5

=item '-'

Unary Minus ( C<$matrix2 = -$matrix1;> )

Same as "Complement". See "Complement" below.

=item '~'

Complement ( C<$matrix2 = ~$matrix1;> )

The operator '~' (or unary '-') computes the complement of the given matrix.

=item abs

Absolute Value ( C<$no_of_elem = abs($matrix);> )

Here, the absolute value of a matrix has been defined as the number
of elements the given matrix contains. This is B<NOT> the same as the
"norm" of a matrix!

=item test

Boolean Test ( C<if ($matrix) { ... }> )

You can actually test a matrix as though it were a boolean value.

No special operator is needed for this; Perl automatically calls the
appropriate method in this package if "$matrix" is a blessed reference
to an object of the "Math::MatrixBool" class or one of its derived
classes.

This method returns "true" (1) if the given matrix is not empty and "false"
('') otherwise.

=item '!'

Negated Boolean Test ( C<if (! $matrix) { ... }> )

You can also perform a negated test on a matrix as though it were a boolean
value. For example:

    if (! $matrix) { ... }

    unless ($matrix) { ... }     #  internally, same as above!

This operator returns "true" (1) if the given matrix is empty and "false"
('') otherwise.

=item '""""'

"Stringification" ( C<print "$matrix";> )

It is possible to get a string representation of a given matrix by just
putting the matrix object reference between double quotes.

Note that in general the string representation of a matrix will span over
multiple lines (i.e., the string which is generated contains "\n" characters,
one at the end of each row of the matrix).

Example:

    $matrix = new Math::MatrixBool(5,6);
    $matrix->One();
    print "$matrix";

This will print:

    [ 1 0 0 0 0 0 ]
    [ 0 1 0 0 0 0 ]
    [ 0 0 1 0 0 0 ]
    [ 0 0 0 1 0 0 ]
    [ 0 0 0 0 1 0 ]

=item '+'

Addition ( C<$matrix3 = $matrix1 + $matrix2;> )

The '+' operator calculates the sum of two matrices.

Examples:

    $all   =  $odd + $even;

    $all  +=  $odd;
    $all  +=  $even;

Note that the '++' operator will produce an error message if applied
to an object of this class because adding a number to a matrix makes
no sense.

=item '*'

Multiplication ( C<$matrix3 = $matrix1 * $matrix2;> )

The '*' operator calculates the matrix product of two matrices.

Examples:

    $test   =  $one * $one;

    $test  *=  $one;
    $test  *=  $test;

Note that you can use matrices of any size as long as their numbers of
rows and columns correspond in the following way (example):

        $matrix_3 = $matrix_1 * $matrix_2;

                          [ 2 2 ]
                          [ 2 2 ]
                          [ 2 2 ]

              [ 1 1 1 ]   [ 3 3 ]
              [ 1 1 1 ]   [ 3 3 ]
              [ 1 1 1 ]   [ 3 3 ]
              [ 1 1 1 ]   [ 3 3 ]

I.e., the number of columns of matrix #1 is the same as the number of
rows of matrix #2, and the number of rows and columns of the resulting
matrix #3 is determined by the number of rows of matrix #1 and the
number of columns of matrix #2, respectively.

This way you can also perform the multiplication of a matrix with a
vector, since a vector is just a degenerated matrix with several rows
but only one column, or just one row and several columns.

=item '|'

Union ( C<$matrix3 = $matrix1 | $matrix2;> )

The '|' operator is used to calculate the union of two matrices
(of corresponding elements).

Examples:

    $all   =  $odd | $even;

    $all  |=  $odd;
    $all  |=  $even;

=item '-'

Difference ( C<$matrix3 = $matrix1 - $matrix2;> )

The operator '-' calculates the (dotted) difference of two matrices, i.e.,

    0 - 0 == 0
    0 - 1 == 0
    1 - 0 == 1
    1 - 1 == 0

for each corresponding element.

Examples:

    $odd   =  $all  - $even;

    $all  -=  $even;

Note that the '--' operator will produce an error message if applied
to an object of this class because subtracting a number from a matrix
makes no sense.

=item '&'

Intersection ( C<$matrix3 = $matrix1 & $matrix2;> )

The '&' operator is used to calculate the intersection of two matrices
(of the corresponding elements).

Examples:

    $rest  =  $all & $even;

    $all  &=  $even;

=item '^'

ExclusiveOr ( C<$matrix3 = $matrix1 ^ $matrix2;> )

The '^' operator is used to calculate the exclusive-or of two matrices
(of their corresponding elements).

In fact this operation is identical with the addition of two matrices
in this case of a Boolean Algebra.

Examples:

    $odd   =  $all  ^ $even;

    $all  ^=  $even;

=item '=='

Test For Equality ( C<if ($matrix1 == $matrix2) { ... }> )

This operator tests two matrices for equality.

Note that B<without> operator overloading, C<( $matrix1 == $matrix2 )> would
test wether the two references B<pointed to> the B<same object>! (!)

B<With> operator overloading in effect, C<( $matrix1 == $matrix2 )> tests
wether the two matrix objects B<contain> exactly the B<same elements>!

=item '!='

Test For Non-Equality ( C<if ($matrix1 != $matrix2) { ... }> )

This operator tests wether two matrices are different.

Note again that this tests wether the B<contents> of the two matrices are
not the same, and B<not> wether the two B<references> are different!

=item 'E<lt>'

Test For True Subset ( C<if ($matrix1 E<lt> $matrix2) { ... }> )

This operator tests wether $matrix1 is a true subset of $matrix2, i.e.
wether the elements contained in $matrix1 are also contained in $matrix2,
but not all elements contained in $matrix2 are contained in $matrix1.

Example:

        [ 1 0 0 0 0 ]                       [ 1 0 0 0 1 ]
        [ 0 1 0 0 0 ]                       [ 0 1 0 0 0 ]
        [ 0 0 1 0 0 ]  is a true subset of  [ 0 0 1 0 0 ]
        [ 0 0 0 1 0 ]                       [ 0 0 0 1 0 ]
        [ 1 0 0 0 1 ]                       [ 1 0 0 0 1 ]

        [ 1 0 0 0 0 ]                       [ 1 0 0 0 1 ]
        [ 0 1 0 0 0 ]                       [ 0 1 0 0 0 ]
   but  [ 0 0 1 0 0 ]   is not a subset of  [ 0 0 1 0 0 ]
        [ 0 0 0 1 0 ]                       [ 0 0 0 1 0 ]
        [ 1 0 0 0 1 ]                       [ 0 0 0 0 1 ]

(nor vice-versa!)

        [ 1 0 0 0 1 ]                       [ 1 0 0 0 1 ]
        [ 0 1 0 0 0 ]                       [ 0 1 0 0 0 ]
   and  [ 0 0 1 0 0 ]     is a subset of    [ 0 0 1 0 0 ]
        [ 0 0 0 1 0 ]                       [ 0 0 0 1 0 ]
        [ 1 0 0 0 1 ]                       [ 1 0 0 0 1 ]

but not a true subset because the two matrices are identical.

=item 'E<lt>='

Test For Subset ( C<if ($matrix1 E<lt>= $matrix2) { ... }> )

This operator tests wether $matrix1 is a subset of $matrix2, i.e.
wether all elements contained in $matrix1 are also contained in $matrix2.

This also evaluates to "true" when the two matrices are the same.

=item 'E<gt>'

Test For True Superset ( C<if ($matrix1 E<gt> $matrix2) { ... }> )

This operator tests wether $matrix1 is a true superset of $matrix2, i.e.
wether all elements contained in $matrix2 are also contained in $matrix1,
but not all elements contained in $matrix1 are contained in $matrix2.

Note that C<($matrix1 E<gt> $matrix2)> is exactly the same as
C<($matrix2 E<lt> $matrix1)>.

=item 'E<gt>='

Test For Superset ( C<if ($matrix1 E<gt>= $matrix2) { ... }> )

This operator tests wether $matrix1 is a superset of $matrix2, i.e.
wether all elements contained in $matrix2 are also contained in $matrix1.

This also evaluates to "true" when the two matrices are equal.

Note that C<($matrix1 E<gt>= $matrix2)> is exactly the same as
C<($matrix2 E<lt>= $matrix1)>.

=item cmp

Compare ( C<$result = $matrix1 cmp $matrix2;> )

This operator compares the two matrices lexically, i.e. it regards the
two bit vectors representing the two matrices as two large (unsigned)
numbers in binary representation and returns "-1" if the number for
$matrix1 is smaller than that for $matrix2, "0" if the two numbers are
the same (i.e., when the two matrices are equal!) or "1" if the number
representing $matrix1 is larger than the number representing $matrix2.

Note that this comparison has nothing to do whatsoever with algebra,
it is just an B<arbitrary> order relationship!

It is only intended to provide an (arbitrary) order by which (for example)
an array of matrices can be sorted, for instance to find out quickly (using
binary search) if a specific matrix has already been produced before in some
matrix-producing process or not.

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

For instance, C<($matrix1 le $matrix2)> is much more readable and clearer
than C<(($matrix1 cmp $matrix2) E<lt>= 0)>!

=back

=head1 SEE ALSO

Math::MatrixReal(3), DFA::Kleene(3), Kleene(3),
Set::IntegerRange(3), Set::IntegerFast(3).

=head1 VERSION

This man page documents Math::MatrixBool version 2.0.

=head1 AUTHOR

Steffen Beyer <sb@sdm.de> (sd&m GmbH&Co.KG, Munich, Germany)

=head1 COPYRIGHT

Copyright (c) 1996, 1997 by Steffen Beyer. All rights reserved.

=head1 LICENSE AGREEMENT

This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

