#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set = Set::IntegerFast::Create($elements);
#   $set->Destroy;
# ======================================================================

print "1..10\n";

$n = 1;
$set = { '0' => 'an anonymous hash' };
bless $set, 'Not_this_package';
if (ref($set) eq 'Not_this_package')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { Set::IntegerFast::Empty($set); };
if ($@ =~ /Not a 'Set::IntegerFast' object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set = Set::IntegerFast::Create(1);
if (ref($set) eq "Set::IntegerFast")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->Destroy; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->Destroy; };
if ($@ =~ /Can't call method "Destroy" without a package or object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set = Set::IntegerFast::Create(0);
eval { $set->Destroy; };
if ($@ =~ /Can't call method "Destroy" without a package or object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! defined Set::IntegerFast::Create(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set = Set::IntegerFast::Create(1000000);
if (ref($set) eq "Set::IntegerFast")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->Destroy; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->Destroy; };
if ($@ =~ /Can't call method "Destroy" without a package or object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}

__END__
