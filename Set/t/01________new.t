#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

@ISA = qw(Set::IntegerFast);

# ======================================================================
#   $set = Set::IntegerFast::new('Set::IntegerFast',$elements);
# ======================================================================

print "1..83\n";

$n = 1;

# test if the constructor works at all:

$set = Set::IntegerFast::new('Set::IntegerFast',1);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test if the constructor handles NULL pointers as expected:

$ref = Set::IntegerFast::new('Set::IntegerFast',0);
if (!defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test if the copy of an object reference works as expected:

$ref = $set;
if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$ref} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (${$ref} == ${$set})
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test the constructor with a large set (13,983,816 elements):

$set = Set::IntegerFast::new('Set::IntegerFast',&binomial(49,6));
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# are the two sets really distinct and set objects behaving as expected?

if (${$ref} != ${$set})
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# are set objects behaving as expected, i.e. are they write-protected?

eval { ${$set} = 0x00088850; };
if ($@ =~ /Modification of a read-only value attempted/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set = 0x00088850;
if ($set == 559184)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ${$ref} = 0x000E9CE0; };
if ($@ =~ /Modification of a read-only value attempted/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$ref = 0x000E9CE0;
if ($ref == 957664)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test various ways of calling the constructor:

# 1: $set = Set::IntegerFast::new('Set::IntegerFast',1);
# 2: $class = 'Set::IntegerFast'; $set = Set::IntegerFast::new($class,2);
# 3: $set = new Set::IntegerFast(3);
# 4: $set = Set::IntegerFast->new(4);
# 5: $ref = $set->new(5);
# 6: $set = $set->new(6);

# (test case #1 has been handled above)

# test case #2:

$class = 'Set::IntegerFast';
$set = Set::IntegerFast::new($class,2);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test case #3:

$ref = new Set::IntegerFast(3);
if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$ref} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# coherence test:

if (${$ref} != ${$set})
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test case #4:

$set = Set::IntegerFast->new(4);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# coherence test:

if (${$ref} != ${$set})
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# prepare possibility for id check:

$old = ${$set};
if (${$set} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test case #5:

$ref = $set->new(5);
if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$ref} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# coherence tests:

if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (${$set} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (${$ref} != ${$set})
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# prepare exact copy of object reference:

$ref = $set;
if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$ref} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (${$ref} == ${$set})
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (${$ref} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test case #6 (pseudo auto-destruction test):

$set = $set->new(6);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# coherence tests:

if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$ref} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (${$ref} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (${$ref} != ${$set})
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# auto-destruction test:

$set = $set->new(7);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# coherence test:

if (${$ref} != ${$set})
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test weird ways of calling the constructor:

eval { $set = Set::IntegerFast::new("",8); };
if ($@ =~ /Set::IntegerFast::new\(\): error in first parameter \(class name or reference\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new('',9); };
if ($@ =~ /Set::IntegerFast::new\(\): error in first parameter \(class name or reference\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new(undef,10); };
if ($@ =~ /Set::IntegerFast::new\(\): error in first parameter \(class name or reference\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new(6502,11); };
if ($@ =~ /Set::IntegerFast::new\(\): error in first parameter \(class name or reference\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new('main',12); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ( (ref($set) eq 'main') || (ref($set) eq 'Set::IntegerFast') )
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new('nonsense',13); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ( (ref($set) eq 'nonsense') || (ref($set) eq 'Set::IntegerFast') )
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = new main(14); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ( (ref($set) eq 'main') || (ref($set) eq 'Set::IntegerFast') )
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

@parameters = ( 'main', 15 );
eval { $set = Set::IntegerFast::new(@parameters); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ( (ref($set) eq 'main') || (ref($set) eq 'Set::IntegerFast') )
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test syntactically incorrect constructor calls:

eval { $set = Set::IntegerFast::new(16); };
if ($@ =~ /Usage: Set::IntegerFast::new\(class,elements\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new('main'); };
if ($@ =~ /Usage: Set::IntegerFast::new\(class,elements\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new($set); };
if ($@ =~ /Usage: Set::IntegerFast::new\(class,elements\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new('main',17,1); };
if ($@ =~ /Usage: Set::IntegerFast::new\(class,elements\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new($set,'main',18); };
if ($@ =~ /Usage: Set::IntegerFast::new\(class,elements\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerFast::new($set,19,'main'); };
if ($@ =~ /Usage: Set::IntegerFast::new\(class,elements\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

exit;

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

__END__

