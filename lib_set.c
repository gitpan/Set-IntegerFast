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
//      automatic self-configuring routine:

word    Set_Auto_config(void);              // 0 = ok, 1..5 = error

//      low-level routines:

void    Bit0(wordptr addr, word index, word bitno);         // clear bit
void    Bit1(wordptr addr, word index, word bitno);         // set bit
void    BitX(wordptr addr, word index, word bitno);         // flip bit
boolean Bit (wordptr addr, word index, word bitno);         // return bit

//      auxiliary routines:

word    Set_Size(word elements);            // calc set size (# of words)
word    Set_Mask(word elements);            // calc set mask (unused bits)

//      object creation/destruction/initialization routines:

wordptr Set_Create (word elements);                         // malloc
void    Set_Destroy(wordptr addr);                          // free
wordptr Set_Resize (wordptr oldaddr, word elements);        // realloc
void    Set_Empty  (wordptr addr);                          // X = {}   clr all
void    Set_Fill   (wordptr addr);                          // X = ~{}  set all

//      set operations on elements:

void    Set_Insert(wordptr addr, word index);               // X = X + {x}
void    Set_Delete(wordptr addr, word index);               // X = X \ {x}

//      set test functions on elements:

boolean Set_in    (wordptr addr, word index);               // {x} in X ?

void    Set_in_Init  (word index, word *pos, word *mask);   // prepare test loop
boolean Set_in_up  (wordptr addr, word *pos, word *mask);   // {x++} in X ?
boolean Set_in_down(wordptr addr, word *pos, word *mask);   // {x--} in X ?

//      set operations on whole sets:

void    Set_Union       (wordptr X, wordptr Y, wordptr Z);  // X = Y + Z
void    Set_Intersection(wordptr X, wordptr Y, wordptr Z);  // X = Y * Z
void    Set_Difference  (wordptr X, wordptr Y, wordptr Z);  // X = Y \ Z
void    Set_ExclusiveOr (wordptr X, wordptr Y, wordptr Z);  // X=(Y+Z)\(Y*Z)
void    Set_Complement  (wordptr X, wordptr Y);             // X = ~Y

//      set test functions on whole sets:

boolean Set_equal    (wordptr X, wordptr Y);                // X == Y ?
boolean Set_inclusion(wordptr X, wordptr Y);                // X in Y ?
boolean Set_lexorder (wordptr X, wordptr Y);                // X <= Y ?
int     Set_Compare  (wordptr X, wordptr Y);                // X <,=,> Y ?

//      set functions:

word    Set_Norm(wordptr addr);                             // = | X |
long    Set_Min (wordptr addr);                             // = min X
long    Set_Max (wordptr addr);                             // = max X

//      set copy:

void    Set_Copy(wordptr X, wordptr Y);                     // X = Y
*/
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

#ifdef ENABLE_BOUNDS_CHECKING
#define HIDDEN_WORDS 3
#else
#define HIDDEN_WORDS 2
#endif

    /************************************************************************/
    /* machine dependent constants (will be determined by Set_Auto_config): */
    /************************************************************************/

static word BITS;       /* = # of bits of a machine word (must be power of 2) */
static word MODMASK;    /* = BITS - 1 (mask for calculating modulo BITS) */
static word LOGBITS;    /* = ld(BITS) (logarithmus dualis) */
static word FACTOR;     /* = ld(BITS / 8) (ld of # of bytes) */

#define     LSB   1     /* mask for least significant bit */
static word MSB;        /* mask for most significant bit */

    /***********************************************************************/
    /* bit mask table for fast access (will be set up by Set_Auto_config): */
    /***********************************************************************/

static wordptr BITMASKTAB;

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

word Set_Auto_config(void)
{
    word sample = LSB;
    word lsb;

    if (sizeof(word) != sizeof(size_t)) return(1);

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

    if (sample) return(2);          /* # of bits is not a power of 2! */

    if (LOGBITS < 3) return(3);     /* # of bits too small - minimum is 8! */

    if (BITS != (sizeof(word) << 3)) return(4);  /* BITS != sizeof(word)*8 */

    MODMASK = BITS - 1;
    FACTOR = LOGBITS - 3; /* ld(BITS / 8) = ld(BITS) - ld(8) = ld(BITS) - 3 */
    MSB = (LSB << MODMASK);

    BITMASKTAB = (wordptr) malloc(BITS << FACTOR);

    if (BITMASKTAB == NULL) return(5);

    for ( sample = 0; sample < BITS; ++sample )
    {
        BITMASKTAB[sample] = (LSB << sample);
    }
    return(0);
}

    /***********************/
    /* low-level routines: */
    /***********************/

void Bit0(wordptr addr, word index, word bitno)             /* clear bit */
{
    *(addr+index) &= NOT BITMASKTAB[bitno AND MODMASK];
}

void Bit1(wordptr addr, word index, word bitno)             /* set bit */
{
    *(addr+index) |= BITMASKTAB[bitno AND MODMASK];
}

void BitX(wordptr addr, word index, word bitno)             /* flip bit */
{
    *(addr+index) ^= BITMASKTAB[bitno AND MODMASK];
}

boolean Bit(wordptr addr, word index, word bitno)           /* return bit */
{
    return( (*(addr+index) AND BITMASKTAB[bitno AND MODMASK]) != 0 );
}

    /***********************/
    /* auxiliary routines: */
    /***********************/

word Set_Size(word elements)                /* calc set size (# of words) */
{
    word size;

    size = elements >> LOGBITS;
    if (elements AND MODMASK) ++size;
    return(size);
}

word Set_Mask(word elements)                /* calc set mask (unused bits) */
{
    word mask;

    mask = elements AND MODMASK;
    if (mask) mask = (word) ((LSB << mask) - 1); else mask = (word) (-1L);
    return(mask);
}

    /********************************************************/
    /* object creation/destruction/initialization routines: */
    /********************************************************/

void Set_Empty(wordptr addr)                            /* X = {}   clr all */
{
    word size;

    size = *(addr-2);
    while (size-- > 0) *addr++ = 0;
}

void Set_Fill(wordptr addr)                             /* X = ~{}  set all */
{
    word size;
    word mask;
    word fill;

    size = *(addr-2);
    mask = *(addr-1);
    fill = (word) (-1L);
    if (size > 0)
    {
        while (size-- > 0) *addr++ = fill;
        *(--addr) &= mask;
    }
}

wordptr Set_Create(word elements)                       /* malloc */
{
    word size;
    word mask;
    word bytes;
    wordptr addr;

    addr = NULL;
    size = Set_Size(elements);
    mask = Set_Mask(elements);
    if (size > 0)
    {
        bytes = (size + HIDDEN_WORDS) << FACTOR;
        addr = (wordptr) malloc(bytes);
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

void Set_Destroy(wordptr addr)                          /* free */
{
    if (addr != NULL)
    {
        addr -= HIDDEN_WORDS;
        free((voidptr) addr);
    }
}

wordptr Set_Resize(wordptr oldaddr, word elements)      /* realloc */
{
    word bytes;
    word oldsize;
    word newsize;
    word oldmask;
    word newmask;
    wordptr source;
    wordptr target;
    wordptr newaddr;

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
            newaddr = (wordptr) malloc(bytes);
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

void Set_Insert(wordptr addr, word index)                   /* X = X + {x} */
{
    *(addr+(index>>LOGBITS)) |= BITMASKTAB[index AND MODMASK];
}

void Set_Delete(wordptr addr, word index)                   /* X = X \ {x} */
{
    *(addr+(index>>LOGBITS)) &= NOT BITMASKTAB[index AND MODMASK];
}

    /***********************************/
    /* set test functions on elements: */
    /***********************************/

boolean Set_in(wordptr addr, word index)                    /* {x} in X ? */
{
    return( (*(addr+(index>>LOGBITS)) AND BITMASKTAB[index AND MODMASK]) != 0 );
}

void Set_in_Init(word index, word *pos, word *mask)     /* prepare test loop */
{
    (*pos) = index >> LOGBITS;
    (*mask) = BITMASKTAB[index AND MODMASK];
}

boolean Set_in_up(wordptr addr, word *pos, word *mask)      /* {x++} in X ? */
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

boolean Set_in_down(wordptr addr, word *pos, word *mask)    /* {x--} in X ? */
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

    /*********************************/
    /* set operations on whole sets: */
    /*********************************/

void Set_Union(wordptr X, wordptr Y, wordptr Z)             /* X = Y + Z */
{
    word size;
    word mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ OR *Z++;
        *(--X) &= mask;
    }
}

void Set_Intersection(wordptr X, wordptr Y, wordptr Z)      /* X = Y * Z */
{
    word size;
    word mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ AND *Z++;
        *(--X) &= mask;
    }
}

void Set_Difference(wordptr X, wordptr Y, wordptr Z)        /* X = Y \ Z */
{
    word size;
    word mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ AND NOT *Z++;
        *(--X) &= mask;
    }
}

void Set_ExclusiveOr(wordptr X, wordptr Y, wordptr Z)       /* X=(Y+Z)\(Y*Z) */
{
    word size;
    word mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ XOR *Z++;
        *(--X) &= mask;
    }
}

void Set_Complement(wordptr X, wordptr Y)                   /* X = ~Y */
{
    word size;
    word mask;

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

boolean Set_equal(wordptr X, wordptr Y)                     /* X == Y ? */
{
    word size;
    boolean r = true;

    size = *(X-2);
    while (r and (size-- > 0)) r = (*X++ == *Y++);
    return(r);
}

boolean Set_inclusion(wordptr X, wordptr Y)                 /* X in Y ? */
{
    word size;
    boolean r = true;

    size = *(X-2);
    while (r and (size-- > 0)) r = ((*X++ AND NOT *Y++) == 0);
    return(r);
}

boolean Set_lexorder(wordptr X, wordptr Y)                  /* X <= Y ? */
{
    word size;

    size = *(X-2) << FACTOR;
    return(memcmp(X,Y,size) <= 0);
}

int Set_Compare(wordptr X, wordptr Y)                       /* X <,=,> Y ? */
{
    word size;

    size = *(X-2) << FACTOR;
    return(memcmp(X,Y,size));
}

    /******************/
    /* set functions: */
    /******************/

word Set_Norm(wordptr addr)                                 /* = | X | */
{
    word c;
    word size;
    word count = 0;

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

long Set_Min(wordptr addr)                                  /* = min X */
{
    word c;
    word i;
    word size;
    boolean empty = true;

    size = *(addr-2);
    i = 0;
    while (empty and (size-- > 0))
    {
        if (c = *addr++) empty = false; else ++i;
    }
    if (empty) return(LONG_MAX);                            /* plus infinity */
    i <<= LOGBITS;
    while (not (c AND LSB))
    {
        c >>= 1;
        ++i;
    }
    return((long) i);
}

long Set_Max(wordptr addr)                                  /* = max X */
{
    word c;
    word i;
    word size;
    boolean empty = true;

    size = *(addr-2);
    i = size;
    addr += size-1;
    while (empty and (size-- > 0))
    {
        if (c = *addr--) empty = false; else --i;
    }
    if (empty) return(LONG_MIN);                            /* minus infinity */
    i <<= LOGBITS;
    while (not (c AND MSB))
    {
        c <<= 1;
        --i;
    }
    return((long) --i);
}

    /*************/
    /* set copy: */
    /*************/

void Set_Copy(wordptr X, wordptr Y)                         /* X = Y */
{
    word size;
    word mask;

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
/* MODIFIED     16.12.95              */
/**************************************/
/* COPYRIGHT    Steffen Beyer         */
/**************************************/
#endif
