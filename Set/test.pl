#!perl -w

use strict;
use vars qw(@ISA $set);

use Set::IntegerFast;

@ISA = qw(Set::IntegerFast);

eval { $set = new main(1); };

unless ($@)
{
    if (ref($set))
    {
        if (ref($set) eq 'Set::IntegerFast')
            { print ">>> 'Set::IntegerFast': Subclassing is disabled (default)\n"; }
        elsif (ref($set) eq 'main')
            { print ">>> 'Set::IntegerFast': SUBCLASSING IS ENABLED!!!\n"; }
        else
            { print "ERROR: ref(\$set) = '", ref($set), "'\n"; }
    }
    else { print "ERROR: \$set = '$set'\n"; }
}
else { chomp($@); print "ERROR: '$@'\n"; }

