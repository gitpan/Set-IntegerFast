#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $ver = Set::IntegerFast::Version();
# ======================================================================

print "1..1\n";

$n = 1;
if (Set::IntegerFast::Version() eq "1.0") {print "ok $n\n";} else {print "not ok $n\n";}

__END__
