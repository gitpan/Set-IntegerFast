#!perl -w

use strict;
no strict "vars";

use Set::IntegerRange;

# ======================================================================
#   $set->Empty_Interval($lower,$upper);
#   $set->Fill_Interval($lower,$upper);
#   $set->Flip_Interval($lower,$upper);
# ======================================================================

print "1..456\n";

$lim = 16384;

$set = new Set::IntegerRange(-$lim,$lim-1);

$n = 1;
if ($set->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() > $lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() < -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Fill();

if ($set->Norm() == $lim * 2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == $lim-1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Empty();

if ($set->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() > $lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() < -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Complement($set);

if ($set->Norm() == $lim * 2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == $lim-1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Complement($set);

if ($set->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() > $lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() < -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

for ( $i = 0; $i < 32; $i++ )
{
    test_set_clr(-$i,$i);      test_flip(-$i,$i);
}

test_set_clr(-63,63);          test_flip(-63,63);
test_set_clr(-127,127);        test_flip(-127,127);
test_set_clr(-255,255);        test_flip(-255,255);

test_set_clr(-$lim,$lim-1);    test_flip(-$lim,$lim-1);

eval { $set->Empty_Interval(-$lim-1,$lim-1); };
if ($@ =~ /Set::IntegerRange::Empty_Interval\(\): lower index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Fill_Interval(-$lim-1,$lim-1); };
if ($@ =~ /Set::IntegerRange::Fill_Interval\(\): lower index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Flip_Interval(-$lim-1,$lim-1); };
if ($@ =~ /Set::IntegerRange::Flip_Interval\(\): lower index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Empty_Interval(-$lim,$lim); };
if ($@ =~ /Set::IntegerRange::Empty_Interval\(\): upper index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Fill_Interval(-$lim,$lim); };
if ($@ =~ /Set::IntegerRange::Fill_Interval\(\): upper index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Flip_Interval(-$lim,$lim); };
if ($@ =~ /Set::IntegerRange::Flip_Interval\(\): upper index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Empty_Interval(1,-1); };
if ($@ =~ /Set::IntegerRange::Empty_Interval\(\): lower > upper index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Fill_Interval(1,-1); };
if ($@ =~ /Set::IntegerRange::Fill_Interval\(\): lower > upper index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Flip_Interval(1,-1); };
if ($@ =~ /Set::IntegerRange::Flip_Interval\(\): lower > upper index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

exit;

sub test_set_clr
{
    my($lower,$upper) = @_;
    my($span) = $upper - $lower + 1;

    $set->Fill_Interval($lower,$upper);
    if ($set->Norm() == $span)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() == $lower)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() == $upper)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set->Empty_Interval($lower,$upper);
    if ($set->Norm() == 0)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() > $lim)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() < -$lim)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
}

sub test_flip
{
    my($lower,$upper) = @_;
    my($span) = $upper - $lower + 1;

    $set->Flip_Interval($lower,$upper);
    if ($set->Norm() == $span)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() == $lower)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() == $upper)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set->Flip_Interval($lower,$upper);
    if ($set->Norm() == 0)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() > $lim)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() < -$lim)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
}

__END__
