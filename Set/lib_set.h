#ifndef AUTO_CONF_SET_OBJECTS
#define AUTO_CONF_SET_OBJECTS
/**************************************/
/* MODULE   lib_set.h           (adt) */
/**************************************/
/* IMPORTS                            */
/**************************************/
#include    <stdlib.h>       /* (sys) */
#include    <limits.h>       /* (sys) */
#include    <string.h>       /* (sys) */
#include    "lib_defs.h"     /* (dat) */
/**************************************/
/* INTERFACE                          */
/**************************************/

/*      automatic self-configuring routine: */

unit    Set_Auto_config(void);                       /* 0 = ok, 1..5 = error */

/*      auxiliary routines: */

unit    Set_Size(N_int elements);             /* calc set size (# of units)  */
unit    Set_Mask(N_int elements);             /* calc set mask (unused bits) */

/*      object creation/destruction/initialization routines: */

unitptr Set_Create (N_int   elements);                      /* malloc        */
void    Set_Destroy(unitptr addr);                          /* free          */
unitptr Set_Resize (unitptr oldaddr, N_int elements);       /* realloc       */
void    Set_Empty  (unitptr addr);                          /* X = {}        */
void    Set_Fill   (unitptr addr);                          /* X = ~{}       */

void    Set_Empty_Interval(unitptr addr, N_int lower, N_int upper);
void    Set_Fill_Interval (unitptr addr, N_int lower, N_int upper);
void    Set_Flip_Interval (unitptr addr, N_int lower, N_int upper);

/*      set operations on elements: */

void    Set_Insert (unitptr addr, N_int index);             /* X = X + {x}   */
void    Set_Delete (unitptr addr, N_int index);             /* X = X \ {x}   */

/*      hybrid set operation and test function on element: */

boolean Set_flip   (unitptr addr, N_int index);         /* X=(X+{x})\(X*{x}) */

/*      set test functions on elements: */

boolean Set_in     (unitptr addr, N_int index);             /* {x} in X ?    */

void    Set_in_Init (N_int index, unit *pos, unit *mask);   /* init. loop    */
boolean Set_in_up  (unitptr addr, unit *pos, unit *mask);   /* {x++} in X ?  */
boolean Set_in_down(unitptr addr, unit *pos, unit *mask);   /* {x--} in X ?  */

/*      set functions: */

N_int   Set_Norm   (unitptr addr);                          /* = | X |       */
Z_long  Set_Min    (unitptr addr);                          /* = min(X)      */
Z_long  Set_Max    (unitptr addr);                          /* = max(X)      */

/*      set operations on whole sets: */

void    Set_Union       (unitptr X, unitptr Y, unitptr Z);  /* X = Y + Z     */
void    Set_Intersection(unitptr X, unitptr Y, unitptr Z);  /* X = Y * Z     */
void    Set_Difference  (unitptr X, unitptr Y, unitptr Z);  /* X = Y \ Z     */
void    Set_ExclusiveOr (unitptr X, unitptr Y, unitptr Z);  /* X=(Y+Z)\(Y*Z) */
void    Set_Complement  (unitptr X, unitptr Y);             /* X = ~Y        */

/*      set test functions on whole sets: */

boolean Set_equal       (unitptr X, unitptr Y);             /* X == Y ?      */
boolean Set_inclusion   (unitptr X, unitptr Y);             /* X in Y ?      */
boolean Set_lexorder    (unitptr X, unitptr Y);             /* X <= Y ?      */
Z_int   Set_Compare     (unitptr X, unitptr Y);             /* X <,=,> Y ?   */

/*      set copy: */

void    Set_Copy        (unitptr X, unitptr Y);             /* X = Y         */

/*
// The "mask" that is used in various functions throughout this package avoids
// problems that may arise when the number of elements used in a set is not a
// multiple of 16 (or whatever the size of a machine word is on your system).
//
// (Note that in this program, the type name "unit" is used instead of "word"
// in order to avoid possible name conflicts with any system header files on
// other machines!)
//
// In these cases, comparisons between sets would fail to produce the expected
// results if in one set the unused bits were set, while they were cleared in
// the other. To prevent this, unused bits are systematically turned off by
// this package using this "mask".
//
// If the number of elements in a set is, say, 500, you need to define a
// contiguous block of memory with 32 units (if a unit (= machine word) is
// worth 16 bits) to store any such set, or
//
//                          unit your_set[32];
//
// 32 units contain a total of 512 bits, which means (since only one bit
// is needed for each element to flag its presence or absence in the set)
// that 12 bits remain unused.
//
// Since element #0 corresponds to bit #0 in unit #0 of your_set, and
// element 499 corresponds to bit #3 in unit #31, the 12 most significant
// bits of unit #31 remain unused.
//
// Therefore, the mask word should have the 12 most significant bits cleared
// while the remaining lower bits remain set; in the case of our example,
// the mask word would have the value 0x000F.
//
// Sets in this package cannot be defined like variables in C, however.
//
// In order to use a set variable, you have to invoke the "object constructor
// method" 'Set_Create', which dynamically creates a set variable of the
// desired size (maximum number of elements) by allocating the appropriate
// amount of memory on the system heap and initializing it to represent an
// empty set. 
//
// MNEMONIC: If the name of one of the functions in this package (that is,
//           the part of the name after the 'Set_') consists of only lower
//           case letters, this indicates that it returns a boolean function
//           result.
//
// REMINDER: All indices into your set range from zero to the maximum number
//           of elements in your set minus one!
//
// WARNING:  It is your, the user's responsibility to make sure that all
//           indices are within the appropriate range for any given set!
//           No bounds checking is performed by the functions of this package!
//           If you don't, you may get core dumps and receive "segmentation
//           violation" errors. To do bounds checking more easily, define
//           ENABLE_BOUNDS_CHECKING at the top of the file "lib_set.c".
//           Then check incoming indices as follows: An index is invalid
//           for any set (given by its pointer "addr") if it is greater
//           than or equal to *(addr-3) (or if it is less than zero).
//           Note that you don't need to check for negative indices, though,
//           because the type used for indices in this package is UNSIGNED.
//
// WARNING:  You shouldn't perform any set operations with sets of different
//           sizes unless you know exactly what you're doing. If the resulting
//           set is larger than the argument sets, or if the argument sets are
//           of different sizes, this may result in a segmentation violation
//           error, because you are actually reading beyond the allocated
//           length of the argument sets. If the resulting set is smaller
//           than the two argument sets (which have to be of equal size),
//           no error occurs, but you will of course lose some information.
//
// NOTE:     The auto-config initialization routine can fail for 5 reasons:
//
//           Result:                    Meaning:
//
//              1      The type 'unit' is larger (has more bits) than 'size_t'
//              2      The number of bits of a machine word is not a power of 2
//              3      The number of bits of a machine word is less than 8
//                     (This would constitute a violation of ANSI C standards)
//              4      The number of bits in a word and sizeof(unit)*8 differ
//              5      The attempt to allocate memory with malloc() failed
*/
/**************************************/
/* RESOURCES                          */
/**************************************/

/**************************************/
/* IMPLEMENTATION                     */
/**************************************/

/**************************************/
/* PROGRAMMER   Steffen Beyer         */
/**************************************/
/* CREATED      01.11.93              */
/**************************************/
/* MODIFIED     01.02.97              */
/**************************************/
/* COPYRIGHT    Steffen Beyer         */
/**************************************/
#endif
