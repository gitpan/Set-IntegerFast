#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set->Empty;
#   $set->Fill;
#   $set1->Complement($set2);
#   $set1->equal($set2);
# ======================================================================

print "1..5\n";

$set1 = Set::IntegerFast::Create(1000);
$set2 = Set::IntegerFast::Create(1000);

$n = 1;
if ($set1->equal($set2)) {print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set1->Insert(999);
if (! $set1->equal($set2)) {print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set1->Fill;
$set2->Complement($set2);
if ($set1->equal($set2)) {print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set2->Empty;
$set1->Complement($set1);
if ($set1->equal($set2)) {print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set1->Complement($set1);
$set1->Complement($set1);
if ($set1->equal($set2)) {print "ok $n\n";} else {print "not ok $n\n";}

$set1->Destroy;
$set2->Destroy;

__END__
