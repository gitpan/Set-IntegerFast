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

word    Set_Auto_config(void);              /* 0 = ok, 1..5 = error */

/*      low-level routines: */

void    Bit0(wordptr addr, word index, word bitno);     /* clear bit */
void    Bit1(wordptr addr, word index, word bitno);     /* set bit */
void    BitX(wordptr addr, word index, word bitno);     /* flip bit */
boolean Bit (wordptr addr, word index, word bitno);     /* return bit */

/*      auxiliary routines: */

word    Set_Size(word elements);            /* calc set size (# of words) */
word    Set_Mask(word elements);            /* calc set mask (unused bits) */

/*      object creation/destruction/initialization routines: */

wordptr Set_Create (word elements);                     /* malloc */
void    Set_Destroy(wordptr addr);                      /* free */
wordptr Set_Resize (wordptr oldaddr, word elements);    /* realloc */
void    Set_Empty  (wordptr addr);                      /* X = {}   clr all */
void    Set_Fill   (wordptr addr);                      /* X = ~{}  set all */

/*      set operations on elements: */

void    Set_Insert(wordptr addr, word index);               /* X = X + {x} */
void    Set_Delete(wordptr addr, word index);               /* X = X \ {x} */

/*      set test functions on elements: */

boolean Set_in    (wordptr addr, word index);               /* {x} in X ? */

void    Set_in_Init  (word index, word *pos, word *mask);   /* prepare test loop */
boolean Set_in_up  (wordptr addr, word *pos, word *mask);   /* {x++} in X ? */
boolean Set_in_down(wordptr addr, word *pos, word *mask);   /* {x--} in X ? */

/*      set operations on whole sets: */

void    Set_Union       (wordptr X, wordptr Y, wordptr Z);  /* X = Y + Z */
void    Set_Intersection(wordptr X, wordptr Y, wordptr Z);  /* X = Y * Z */
void    Set_Difference  (wordptr X, wordptr Y, wordptr Z);  /* X = Y \ Z */
void    Set_ExclusiveOr (wordptr X, wordptr Y, wordptr Z);  /* X=(Y+Z)\(Y*Z) */
void    Set_Complement  (wordptr X, wordptr Y);             /* X = ~Y */

/*      set test functions on whole sets: */

boolean Set_equal    (wordptr X, wordptr Y);                /* X == Y ? */
boolean Set_inclusion(wordptr X, wordptr Y);                /* X in Y ? */
boolean Set_lexorder (wordptr X, wordptr Y);                /* X <= Y ? */
int     Set_Compare  (wordptr X, wordptr Y);                /* X <,=,> Y ? */

/*      set functions: */

word    Set_Norm(wordptr addr);                             /* = | X | */
long    Set_Min (wordptr addr);                             /* = min X */
long    Set_Max (wordptr addr);                             /* = max X */

/*      set copy: */

void    Set_Copy(wordptr X, wordptr Y);                     /* X = Y */

/*
// The "mask" that is used in various functions throughout this package avoids
// problems that may arise when the number of elements used in a set is not a
// multiple of 16 (or whatever the size of a machine word is on your system).
//
// In these cases, comparisons between sets would fail to produce the expected
// results if in one set the unused bits were set, while they were cleared in
// the other. To prevent this, unused bits are systematically turned off by
// this package using this "mask".
//
// If the number of elements in a set is, say, 500, you need to define a
// contiguous block of memory with 32 words (if a word is worth 16 bits)
// to store any such set, or
//
//                          word your_set[32];
//
// 32 words contain a total of 512 bits, which means (since only one bit
// is needed for each element to flag its presence or absence in the set)
// that 12 bits remain unused.
//
// Since element #0 corresponds to bit #0 in word #0 of your_set, and
// element 499 corresponds to bit #3 in word #31, the 12 most significant
// bits of word #31 remain unused.
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
//           If you don't, you may blow up your system or receive "segmentation
//           violation" errors. To do bounds checking more easily, define
//           ENABLE_BOUNDS_CHECKING at the top of the file "lib_set.c".
//           An index is invalid for any set (given by its pointer "addr")
//           if it is greater than or equal to *(addr-3) (or less than zero).
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
//              1      The types 'word' and 'size_t' differ in size
//              2      The number of bits of a machine word is not a power of 2
//              3      The number of bits of a machine word is less than 8
//                     (This would constitute a violation of ANSI C standards)
//              4      The number of bits in a word and sizeof(word)*8 differ
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
/* MODIFIED     16.12.95              */
/**************************************/
/* COPYRIGHT    Steffen Beyer         */
/**************************************/
#endif
