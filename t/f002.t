#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set->Insert($i);
#   $set->Delete($i);
#   $set->in($i);
#   $set1->Union($set2,$set3);
#   $set1->Intersection($set2,$set3);
#   $set1->Difference($set2,$set3);
#   $set1->Complement($set2);
#   $set1->equal($set2);
#   $set1->inclusion($set2);
#   $set1->lexorder($set2);
#   $set1->Compare($set2);
#   $set1->Copy($set2);
# ======================================================================

print "1..41\n";

$set1 = Set::IntegerFast::Create(1);
$set2 = Set::IntegerFast::Create(2);
$set2->Fill;

$n = 1;
eval "\$set1->Insert(0)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Insert(1)";
if ($@ =~ /'Set::IntegerFast': index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Insert(-1)";
if ($@ =~ /'Set::IntegerFast': index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Delete(0)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Delete(1)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Delete(2)";
if ($@ =~ /'Set::IntegerFast': index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Delete(-1)";
if ($@ =~ /'Set::IntegerFast': index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->in(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->in(1)";
if ($@ =~ /'Set::IntegerFast': index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->in(-1)";
if ($@ =~ /'Set::IntegerFast': index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->in(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set2->in(1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->in(2)";
if ($@ =~ /'Set::IntegerFast': index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->in(-1)";
if ($@ =~ /'Set::IntegerFast': index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Union(\$set1,\$set1)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Union(\$set2,\$set2)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Union(\$set1,\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Intersection(\$set1,\$set1)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Intersection(\$set2,\$set2)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Intersection(\$set1,\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Difference(\$set1,\$set1)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Difference(\$set2,\$set2)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Difference(\$set1,\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Complement(\$set1)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Complement(\$set2)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Complement(\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->equal($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->equal($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->equal(\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->inclusion($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->inclusion($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->inclusion(\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->lexorder($set1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->lexorder($set2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->lexorder(\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set1) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set2) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Compare(\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Copy(\$set1)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set2->Copy(\$set2)";
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval "\$set1->Copy(\$set2)";
if ($@ =~ /'Set::IntegerFast': set size mismatch/)
{print "ok $n\n";} else {print "not ok $n\n";}

$set1->Destroy;
$set2->Destroy;

__END__
