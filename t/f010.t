#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set->Resize($elements);
# ======================================================================

$limit = 500;

$set = Set::IntegerFast::Create($limit+1);
$set->Fill;
$set->Delete(0);
$set->Delete(1);

for ( $j = 4; $j <= $limit; $j += 2 ) { $set->Delete($j); }

for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
{
    for ( ; $j <= $limit; $j += $i ) { $set->Delete($j); }
}

for ( $i = 3, $j = 8, $p = 0; $i <= $limit; ++$i )
{
    if ($set->in($i)) { $prime[$p++] = $i; }
    else { if ($i == $j) { $prime[$p++] = $i; $j <<= 1; } }
}

print "1..", (3 * $p + 4), "\n";

$n = 1;

$set->Resize(0);

eval { $set->Destroy; };
if ($@ =~ /Can't call method "Destroy" without a package or object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { Set::IntegerFast::Destroy($set); };
if ($@ =~ /Not a 'Set::IntegerFast' object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

for ( $i = 0; $i < $p - 1; $i += 2 )
{
    $j           = $prime[$i];
    $prime[$i]   = $prime[$i+1];
    $prime[$i+1] = $j;
}

$new = $prime[0] * $prime[$p-1];
$set = Set::IntegerFast::Create($new);
$old = $new;
$set->Fill;

&test;

for ( $i = 1; $i < $p; ++$i )
{
    $new = $prime[$i] * $prime[$p-1];
    $set->Resize($new);
    &test;
    $old = $new;
}

$set->Resize(0);

eval { Set::IntegerFast::Destroy($set); };
if ($@ =~ /Not a 'Set::IntegerFast' object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->Destroy; };
if ($@ =~ /Can't call method "Destroy" without a package or object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}

exit;

sub test
{
    if ($new >= $old)
    {
        if ($set->Norm == $old)
        {print "ok $n\n";} else {print "not ok $n\n";}
        $n++;
        $set->Complement($set);
        if ($set->Norm == ($new - $old))
        {print "ok $n\n";} else {print "not ok $n\n";}
        $n++;
        $set->Fill;
        if ($set->Norm == $new)
        {print "ok $n\n";} else {print "not ok $n\n";}
        $n++;
    }
    else
    {
        if ($set->Norm == $new)
        {print "ok $n\n";} else {print "not ok $n\n";}
        $n++;
        $set->Complement($set);
        if ($set->Norm == 0)
        {print "ok $n\n";} else {print "not ok $n\n";}
        $n++;
        $set->Complement($set);
        if ($set->Norm == $new)
        {print "ok $n\n";} else {print "not ok $n\n";}
        $n++;
    }
}

__END__
