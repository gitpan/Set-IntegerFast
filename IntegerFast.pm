
#  Copyright (c) 1995 Steffen Beyer. All rights reserved.
#  This program is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.

package Set::IntegerFast;

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw();

@EXPORT_OK = qw();

# Available methods are:

# Set::IntegerFast::Version   returns a version string
# Set::IntegerFast::Create    the set object constructor
# Destroy                     free() the memory occupied by a set
# Resize                  change the size of a set
# Empty                   delete all elements in the set
# Fill                    insert all possible elements into the set
# Insert                  insert a given element
# Delete                  delete a given element
# in                      test the presence of a given element
# Union                   calculate the union of two sets   (in-place possible)
# Intersection            calculate the intersection of two sets         (idem)
# Difference              calculate the difference of two sets ("A\B")   (idem)
# ExclusiveOr             calculate the symmetric difference of two sets (idem)
# Complement              calculate the complement of a set (in-place possible)
# equal                   test two sets for equality relation
# inclusion               test two sets for inclusion relation
# lexorder                test two sets for lexical order relation
# Compare                 compare two sets - yields -1, 0 or 1 for <, = or >
# Norm                    calculate the norm (number of elements) of the set
# Min                     return the minimum of the set ( min{} = +infinity )
# Max                     return the maximum of the set ( max{} = -infinity )
# Copy                    copy one set to another

bootstrap Set::IntegerFast;

1;
__END__
