#ifndef AUTO_CONF_SET_OBJECTS
#define AUTO_CONF_SET_OBJECTS
/**************************************/
/* MODULE   lib_set.c           (adt) */
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

/*      define ENABLE_BOUNDS_CHECKING here to do bounds checking! */

#define ENABLE_BOUNDS_CHECKING
/*
(*      automatic self-configuring routine: *)

unit    Set_Auto_config(void);                       (* 0 = ok, 1..5 = error *)

(*      auxiliary routines: *)

unit    Set_Size(N_int elements);             (* calc set size (# of units)  *)
unit    Set_Mask(N_int elements);             (* calc set mask (unused bits) *)

(*      object creation/destruction/initialization routines: *)

unitptr Set_Create (N_int   elements);                      (* malloc        *)
void    Set_Destroy(unitptr addr);                          (* free          *)
unitptr Set_Resize (unitptr oldaddr, N_int elements);       (* realloc       *)
void    Set_Empty  (unitptr addr);                          (* X = {}        *)
void    Set_Fill   (unitptr addr);                          (* X = ~{}       *)

void    Set_Empty_Interval(unitptr addr, N_int lower, N_int upper);
void    Set_Fill_Interval (unitptr addr, N_int lower, N_int upper);
void    Set_Flip_Interval (unitptr addr, N_int lower, N_int upper);

(*      set operations on elements: *)

void    Set_Insert (unitptr addr, N_int index);             (* X = X + {x}   *)
void    Set_Delete (unitptr addr, N_int index);             (* X = X \ {x}   *)

(*      hybrid set operation and test function on element: *)

boolean Set_flip   (unitptr addr, N_int index);         (* X=(X+{x})\(X*{x}) *)

(*      set test functions on elements: *)

boolean Set_in     (unitptr addr, N_int index);             (* {x} in X ?    *)

void    Set_in_Init (N_int index, unit *pos, unit *mask);   (* init. loop    *)
boolean Set_in_up  (unitptr addr, unit *pos, unit *mask);   (* {x++} in X ?  *)
boolean Set_in_down(unitptr addr, unit *pos, unit *mask);   (* {x--} in X ?  *)

(*      set functions: *)

N_int   Set_Norm   (unitptr addr);                          (* = | X |       *)
Z_long  Set_Min    (unitptr addr);                          (* = min(X)      *)
Z_long  Set_Max    (unitptr addr);                          (* = max(X)      *)

(*      set operations on whole sets: *)

void    Set_Union       (unitptr X, unitptr Y, unitptr Z);  (* X = Y + Z     *)
void    Set_Intersection(unitptr X, unitptr Y, unitptr Z);  (* X = Y * Z     *)
void    Set_Difference  (unitptr X, unitptr Y, unitptr Z);  (* X = Y \ Z     *)
void    Set_ExclusiveOr (unitptr X, unitptr Y, unitptr Z);  (* X=(Y+Z)\(Y*Z) *)
void    Set_Complement  (unitptr X, unitptr Y);             (* X = ~Y        *)

(*      set test functions on whole sets: *)

boolean Set_equal       (unitptr X, unitptr Y);             (* X == Y ?      *)
boolean Set_inclusion   (unitptr X, unitptr Y);             (* X in Y ?      *)
boolean Set_lexorder    (unitptr X, unitptr Y);             (* X <= Y ?      *)
Z_int   Set_Compare     (unitptr X, unitptr Y);             (* X <,=,> Y ?   *)

(*      set copy: *)

void    Set_Copy        (unitptr X, unitptr Y);             (* X = Y         *)
*/
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

#ifdef ENABLE_BOUNDS_CHECKING
#define HIDDEN_WORDS 3
#else
#define HIDDEN_WORDS 2
#endif

    /************************************************************************/
    /* machine dependent constants (will be determined by Set_Auto_config): */
    /************************************************************************/

static unit BITS;       /* = # of bits in machine word (must be power of 2)  */
static unit MODMASK;    /* = BITS - 1 (mask for calculating modulo BITS)     */
static unit LOGBITS;    /* = ld(BITS) (logarithmus dualis)                   */
static unit FACTOR;     /* = ld(BITS / 8) (ld of # of bytes)                 */

static unit LSB = 1;    /* mask for least significant bit                    */
static unit MSB;        /* mask for most significant bit                     */

    /***********************************************************************/
    /* bit mask table for fast access (will be set up by Set_Auto_config): */
    /***********************************************************************/

static unitptr BITMASKTAB;

    /***************************************/
    /* automatic self-configuring routine: */
    /***************************************/

    /*******************************************************/
    /*                                                     */
    /*   MUST be called once prior to any other function   */
    /*   to initialize the machine dependent constants     */
    /*   of this package! (But call only ONCE!)            */
    /*                                                     */
    /*******************************************************/

unit Set_Auto_config(void)
{
    unit sample = LSB;
    unit lsb;

    if (sizeof(unit) > sizeof(size_t)) return(1);

    BITS = 1;

    while (sample <<= 1) ++BITS;    /* determine # of bits in a machine word */

    LOGBITS = 0;
    sample = BITS;
    lsb = (sample AND LSB);
    while ((sample >>= 1) and (not lsb))
    {
        ++LOGBITS;
        lsb = (sample AND LSB);
    }

    if (sample) return(2);                 /* # of bits is not a power of 2! */

    if (LOGBITS < 3) return(3);       /* # of bits too small - minimum is 8! */

    if (BITS != (sizeof(unit) << 3)) return(4);    /* BITS != sizeof(unit)*8 */

    MODMASK = BITS - 1;
    FACTOR = LOGBITS - 3;  /* ld(BITS / 8) = ld(BITS) - ld(8) = ld(BITS) - 3 */
    MSB = (LSB << MODMASK);

    BITMASKTAB = (unitptr) malloc((size_t) (BITS << FACTOR));

    if (BITMASKTAB == NULL) return(5);

    for ( sample = 0; sample < BITS; ++sample )
    {
        BITMASKTAB[sample] = (LSB << sample);
    }
    return(0);
}

    /***********************/
    /* auxiliary routines: */
    /***********************/

unit Set_Size(N_int elements)                 /* calc set size (# of units)  */
{
    unit size;

    size = elements >> LOGBITS;
    if (elements AND MODMASK) ++size;
    return(size);
}

unit Set_Mask(N_int elements)                 /* calc set mask (unused bits) */
{
    unit mask;

    mask = elements AND MODMASK;
    if (mask) mask = (LSB << mask) - 1; else mask = (unit) -1L;
    return(mask);
}

    /********************************************************/
    /* object creation/destruction/initialization routines: */
    /********************************************************/

void Set_Empty(unitptr addr)                              /* X = {}  clr all */
{
    unit size;

    size = *(addr-2);
    while (size-- > 0) *addr++ = 0;
}

void Set_Fill(unitptr addr)                               /* X = ~{} set all */
{
    unit size;
    unit mask;
    unit fill;

    size = *(addr-2);
    mask = *(addr-1);
    fill = (unit) -1L;
    if (size > 0)
    {
        while (size-- > 0) *addr++ = fill;
        *(--addr) &= mask;
    }
}

void Set_Empty_Interval(unitptr addr, N_int lower, N_int upper)
{                                                  /* X = X \ [lower..upper] */
    unitptr loaddr;
    unitptr hiaddr;
    unit    lobase;
    unit    hibase;
    unit    lomask;
    unit    himask;
    unit    size;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = NOT ( (LSB << (lower AND MODMASK)) - 1 );
    himask = (upper AND MODMASK) + 1;
    if (himask < BITS) himask = (LSB << himask) - 1; else himask = (unit) -1L;

    if (size == 0)
    {
        *loaddr &= NOT (lomask AND himask);
    }
    else if (size > 0)
    {
        *loaddr++ &= NOT lomask;
        while (--size > 0)
        {
            *loaddr++ = 0;
        }
        *hiaddr &= NOT himask;
    }
}

void Set_Fill_Interval(unitptr addr, N_int lower, N_int upper)
{                                                  /* X = X + [lower..upper] */
    unitptr loaddr;
    unitptr hiaddr;
    unit    lobase;
    unit    hibase;
    unit    lomask;
    unit    himask;
    unit    size;
    unit    fill;

    fill = (unit) -1L;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = NOT ( (LSB << (lower AND MODMASK)) - 1 );
    himask = (upper AND MODMASK) + 1;
    if (himask < BITS) himask = (LSB << himask) - 1; else himask = (unit) -1L;

    if (size == 0)
    {
        *loaddr |= (lomask AND himask);
    }
    else if (size > 0)
    {
        *loaddr++ |= lomask;
        while (--size > 0)
        {
            *loaddr++ = fill;
        }
        *hiaddr |= himask;
    }
    *(addr + (*(addr-2) - 1))  &=  *(addr-1);
}

void Set_Flip_Interval(unitptr addr, N_int lower, N_int upper)
{                                                  /* X = X ^ [lower..upper] */
    unitptr loaddr;
    unitptr hiaddr;
    unit    lobase;
    unit    hibase;
    unit    lomask;
    unit    himask;
    unit    size;
    unit    fill;

    fill = (unit) -1L;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = NOT ( (LSB << (lower AND MODMASK)) - 1 );
    himask = (upper AND MODMASK) + 1;
    if (himask < BITS) himask = (LSB << himask) - 1; else himask = (unit) -1L;

    if (size == 0)
    {
        *loaddr ^= (lomask AND himask);
    }
    else if (size > 0)
    {
        *loaddr++ ^= lomask;
        while (--size > 0)
        {
            *loaddr++ ^= fill;
        }
        *hiaddr ^= himask;
    }
    *(addr + (*(addr-2) - 1))  &=  *(addr-1);
}

unitptr Set_Create(N_int elements)                          /* malloc        */
{
    unit    size;
    unit    mask;
    unit    bytes;
    unitptr addr;

    addr = NULL;
    size = Set_Size(elements);
    mask = Set_Mask(elements);
    if (size > 0)
    {
        bytes = (size + HIDDEN_WORDS) << FACTOR;
        addr = (unitptr) malloc((size_t) bytes);
        if (addr != NULL)
        {
#ifdef ENABLE_BOUNDS_CHECKING
            *addr++ = elements;
#endif
            *addr++ = size;
            *addr++ = mask;
            Set_Empty(addr);
        }
    }
    return(addr);
}

void Set_Destroy(unitptr addr)                              /* free          */
{
    if (addr != NULL)
    {
        addr -= HIDDEN_WORDS;
        free((voidptr) addr);
    }
}

unitptr Set_Resize(unitptr oldaddr, N_int elements)         /* realloc       */
{
    unit bytes;
    unit oldsize;
    unit newsize;
    unit oldmask;
    unit newmask;
    unitptr source;
    unitptr target;
    unitptr newaddr;

    newaddr = NULL;
    newsize = Set_Size(elements);
    newmask = Set_Mask(elements);
    oldsize = *(oldaddr-2);
    oldmask = *(oldaddr-1);
    if ((oldsize > 0) and (newsize > 0))
    {
        *(oldaddr+oldsize-1) &= oldmask;
        if (oldsize >= newsize)
        {
            newaddr = oldaddr;
#ifdef ENABLE_BOUNDS_CHECKING
            *(newaddr-3) = elements;
#endif
            *(newaddr-2) = newsize;
            *(newaddr-1) = newmask;
            *(newaddr+newsize-1) &= newmask;
        }
        else
        {
            bytes = (newsize + HIDDEN_WORDS) << FACTOR;
            newaddr = (unitptr) malloc((size_t) bytes);
            if (newaddr != NULL)
            {
#ifdef ENABLE_BOUNDS_CHECKING
                *newaddr++ = elements;
#endif
                *newaddr++ = newsize;
                *newaddr++ = newmask;
                source = oldaddr;
                target = newaddr;
                while (newsize-- > 0)
                {
                    if (oldsize > 0)
                    {
                        --oldsize;
                        *target++ = *source++;
                    }
                    else *target++ = 0;
                }
            }
            Set_Destroy(oldaddr);
        }
    }
    else Set_Destroy(oldaddr);
    return(newaddr);
}

    /*******************************/
    /* set operations on elements: */
    /*******************************/

void Set_Insert(unitptr addr, N_int index)                  /* X = X + {x}   */
{
    *(addr+(index>>LOGBITS)) |= BITMASKTAB[index AND MODMASK];
}

void Set_Delete(unitptr addr, N_int index)                  /* X = X \ {x}   */
{
    *(addr+(index>>LOGBITS)) &= NOT BITMASKTAB[index AND MODMASK];
}

    /******************************************************/
    /* hybrid set operation and test function on element: */
    /******************************************************/

boolean Set_flip(unitptr addr, N_int index)             /* X=(X+{x})\(X*{x}) */
{
    unit mask;

    return( (
        ( *(addr+(index>>LOGBITS)) ^= (mask = BITMASKTAB[index AND MODMASK]) )
        AND mask ) != 0 );
}

    /***********************************/
    /* set test functions on elements: */
    /***********************************/

boolean Set_in(unitptr addr, N_int index)                   /* {x} in X ?    */
{
    return( (*(addr+(index>>LOGBITS)) AND BITMASKTAB[index AND MODMASK]) != 0 );
}

void Set_in_Init(N_int index, unit *pos, unit *mask)    /* prepare test loop */
{
    (*pos) = index >> LOGBITS;
    (*mask) = BITMASKTAB[index AND MODMASK];
}

boolean Set_in_up(unitptr addr, unit *pos, unit *mask)      /* {x++} in X ?  */
{
    boolean r;

    r = ( (*(addr+(*pos)) AND (*mask)) != 0 );
    (*mask) <<= 1;
    if (*mask == 0)
    {
        (*mask) = LSB;
        (*pos)++;
    }
    return(r);
}

boolean Set_in_down(unitptr addr, unit *pos, unit *mask)    /* {x--} in X ?  */
{
    boolean r;

    r = ( (*(addr+(*pos)) AND (*mask)) != 0 );
    (*mask) >>= 1;
    if (*mask == 0)
    {
        (*mask) = MSB;
        (*pos)--;
    }
    return(r);
}

    /******************/
    /* set functions: */
    /******************/

N_int Set_Norm(unitptr addr)                                /* = | X |       */
{
    unit c;
    unit size;
    N_int count = 0;

    size = *(addr-2);
    while (size-- > 0)
    {
        c = *addr++;
        while (c)
        {
            if (c AND LSB) ++count;
            c >>= 1;
        }
    }
    return(count);
}

Z_long Set_Min(unitptr addr)                                /* = min(X)      */
{
    unit c;
    unit i;
    unit size;
    boolean empty = true;

    size = *(addr-2);
    i = 0;
    while (empty and (size-- > 0))
    {
        if (c = *addr++) empty = false; else ++i;
    }
    if (empty) return((Z_long) LONG_MAX);                  /* plus infinity  */
    i <<= LOGBITS;
    while (not (c AND LSB))
    {
        c >>= 1;
        ++i;
    }
    return((Z_long) i);
}

Z_long Set_Max(unitptr addr)                                /* = max(X)      */
{
    unit c;
    unit i;
    unit size;
    boolean empty = true;

    size = *(addr-2);
    i = size;
    addr += size-1;
    while (empty and (size-- > 0))
    {
        if (c = *addr--) empty = false; else --i;
    }
    if (empty) return((Z_long) LONG_MIN);                  /* minus infinity */
    i <<= LOGBITS;
    while (not (c AND MSB))
    {
        c <<= 1;
        --i;
    }
    return((Z_long) --i);
}

    /*********************************/
    /* set operations on whole sets: */
    /*********************************/

void Set_Union(unitptr X, unitptr Y, unitptr Z)             /* X = Y + Z     */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ OR *Z++;
        *(--X) &= mask;
    }
}

void Set_Intersection(unitptr X, unitptr Y, unitptr Z)      /* X = Y * Z     */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ AND *Z++;
        *(--X) &= mask;
    }
}

void Set_Difference(unitptr X, unitptr Y, unitptr Z)        /* X = Y \ Z     */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ AND NOT *Z++;
        *(--X) &= mask;
    }
}

void Set_ExclusiveOr(unitptr X, unitptr Y, unitptr Z)       /* X=(Y+Z)\(Y*Z) */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ XOR *Z++;
        *(--X) &= mask;
    }
}

void Set_Complement(unitptr X, unitptr Y)                   /* X = ~Y        */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = NOT *Y++;
        *(--X) &= mask;
    }
}

    /*************************************/
    /* set test functions on whole sets: */
    /*************************************/

boolean Set_equal(unitptr X, unitptr Y)                     /* X == Y ?      */
{
    unit size;
    boolean r = true;

    size = *(X-2);
    while (r and (size-- > 0)) r = (*X++ == *Y++);
    return(r);
}

boolean Set_inclusion(unitptr X, unitptr Y)                 /* X in Y ?      */
{
    unit size;
    boolean r = true;

    size = *(X-2);
    while (r and (size-- > 0)) r = ((*X++ AND NOT *Y++) == 0);
    return(r);
}

boolean Set_lexorder(unitptr X, unitptr Y)                  /* X <= Y ?      */
{
    unit size;
    boolean r = true;

    size = *(X-2);
    X += size;
    Y += size;
    while (r and (size-- > 0)) r = (*(--X) == *(--Y));
    return(*X <= *Y);
}

Z_int Set_Compare(unitptr X, unitptr Y)                     /* X <,=,> Y ?   */
{
    unit size;
    boolean r = true;

    size = *(X-2);
    X += size;
    Y += size;
    while (r and (size-- > 0)) r = (*(--X) == *(--Y));
    if (r) return((Z_int) 0);
    else
    {
        if (*X < *Y) return((Z_int) -1); else return((Z_int) 1);
    }
}

    /*************/
    /* set copy: */
    /*************/

void Set_Copy(unitptr X, unitptr Y)                         /* X = Y         */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++;
        *(--X) &= mask;
    }
}
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
