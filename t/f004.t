#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set1->Union($set2,$set3);
#   $set1->Intersection($set2,$set3);
#   $set1->Difference($set2,$set3);
#   $set1->ExclusiveOr($set2,$set3);
#   $set1->Complement($set2);
#   $set1->equal($set2);
#   $set1->inclusion($set2);
#   $set1->Copy($set2);
# ======================================================================

print "1..47\n";

$set0 = Set::IntegerFast::Create(1000);
$set1 = Set::IntegerFast::Create(1000);
$set2 = Set::IntegerFast::Create(1000);
$set3 = Set::IntegerFast::Create(1000);
$set4 = Set::IntegerFast::Create(1000);
$set3->Fill;

for ( $i = 0; $i < 1000; $i+=2 )
{
    $set1->Insert($i);
    $set2->Insert($i+1);
}

$n = 1;
if (! $set0->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set0->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set0->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set1->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set1->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Union($set0,$set1);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Union($set0,$set2);
if ($set4->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Union($set1,$set2);
if ($set4->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Union($set1,$set3);
if ($set4->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Union($set2,$set3);
if ($set4->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->inclusion($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->inclusion($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->inclusion($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->inclusion($set4))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set1->inclusion($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set1->inclusion($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->inclusion($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->inclusion($set4))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->inclusion($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->inclusion($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->inclusion($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->inclusion($set4))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Intersection($set1,$set2);
if ($set4->equal($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Intersection($set1,$set3);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Intersection($set2,$set3);
if ($set4->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Difference($set1,$set2);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Difference($set2,$set1);
if ($set4->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Difference($set3,$set1);
if ($set4->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Difference($set3,$set2);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->ExclusiveOr($set0,$set1);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->ExclusiveOr($set1,$set1);
if ($set4->equal($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->ExclusiveOr($set1,$set2);
if ($set4->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->ExclusiveOr($set1,$set3);
if ($set4->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Complement($set0);
if ($set4->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Complement($set1);
if ($set4->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Complement($set2);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Complement($set3);
if ($set4->equal($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Complement($set4);
if ($set4->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Copy($set0);
if ($set4->equal($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Copy($set1);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Copy($set2);
if ($set4->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Copy($set3);
if ($set4->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Intersection($set4,$set1);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Union($set4,$set2);
if ($set4->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->Difference($set4,$set2);
if ($set4->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set4->ExclusiveOr($set4,$set3);
if ($set4->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}

$set0->Destroy;
$set1->Destroy;
$set2->Destroy;
$set3->Destroy;
$set4->Destroy;

__END__
