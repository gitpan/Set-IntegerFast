#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set1->lexorder($set2);
#   $set1->Compare($set2);
# ======================================================================

print "1..64\n";

$set0 = Set::IntegerFast::Create(1000);
$set1 = Set::IntegerFast::Create(1000);
$set2 = Set::IntegerFast::Create(1000);
$set3 = Set::IntegerFast::Create(1000);

$set1->Insert(1);
$set2->Insert(2);
$set3->Insert(1);
$set3->Insert(2);

$n = 1;
if ($set0->lexorder($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->lexorder($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set1->lexorder($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->lexorder($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->lexorder($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->lexorder($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set3->lexorder($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set3->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set3->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->lexorder($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($set0->Compare($set0) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set1) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set2) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set1) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set2) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set1) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set2) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set1) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set2) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set3) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set0->Empty;
$set1->Empty;
$set2->Empty;
$set3->Empty;

$set1->Insert(512);
$set2->Insert(256);
$set3->Insert(256);
$set3->Insert(512);

if ($set0->lexorder($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->lexorder($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set1->lexorder($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->lexorder($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->lexorder($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->lexorder($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set3->lexorder($set0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set3->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set3->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->lexorder($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($set0->Compare($set0) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set1) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set2) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set1) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set2) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set1) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set2) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set1) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set2) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set3) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}

$set0->Destroy;
$set1->Destroy;
$set2->Destroy;
$set3->Destroy;

__END__
