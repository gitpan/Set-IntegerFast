#ifndef AUTO_CONF_MATRIX_OBJECTS
#define AUTO_CONF_MATRIX_OBJECTS
/**************************************/
/* MODULE   lib_matr.c          (adt) */
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
unit    Auto_config(void);

void    Multiply(unitptr X,    unit rowsX, unit colsX,
                 unitptr Y,    unit rowsY, unit colsY,
                 unitptr Z,    unit rowsZ, unit colsZ);

void    Closure (unitptr addr, unit rows,  unit cols);
*/
/**************************************/
/* RESOURCES                          */
/**************************************/

/**************************************/
/* IMPLEMENTATION                     */
/**************************************/

    /********************************************************************/
    /* machine dependent constants (will be determined by Auto_config): */
    /********************************************************************/

static unit BITS;       /* = # of bits in machine word (must be power of 2)  */
static unit MODMASK;    /* = BITS - 1 (mask for calculating modulo BITS)     */
static unit LOGBITS;    /* = ld(BITS) (logarithmus dualis)                   */
static unit FACTOR;     /* = ld(BITS / 8) (ld of # of bytes)                 */

static unit LSB = 1;    /* mask for least significant bit                    */
static unit MSB;        /* mask for most significant bit                     */

    /*******************************************************************/
    /* bit mask table for fast access (will be set up by Auto_config): */
    /*******************************************************************/

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

unit Auto_config(void)
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

void Multiply(unitptr X, unit rowsX, unit colsX,
              unitptr Y, unit rowsY, unit colsY,
              unitptr Z, unit rowsZ, unit colsZ)
{
    unit i;
    unit j;
    unit k;
    unit indxX;
    unit indxY;
    unit indxZ;
    unit termX;
    unit termY;
    unit sum;

#ifdef ENABLE_BOUNDS_CHECKING
  if ((colsY == rowsZ) and (rowsX == rowsY) and (colsX == colsZ) and
      (*(X-3) == rowsX*colsX) and
      (*(Y-3) == rowsY*colsY) and
      (*(Z-3) == rowsZ*colsZ))
#else
  if ((colsY == rowsZ) and (rowsX == rowsY) and (colsX == colsZ))
#endif
  {
    for ( i = 0; i < rowsY; i++ )
    {
        termX = i * colsX;
        termY = i * colsY;
        for ( j = 0; j < colsZ; j++ )
        {
            indxX = termX + j;
            sum = 0;
            for ( k = 0; k < colsY; k++ )
            {
                indxY = termY + k;
                indxZ = k * colsZ + j;
                if ((*(Y+(indxY>>LOGBITS)) AND BITMASKTAB[indxY AND MODMASK]) &&
                    (*(Z+(indxZ>>LOGBITS)) AND BITMASKTAB[indxZ AND MODMASK]))
                    sum ^= 1;
            }
            if (sum)
                 *(X+(indxX>>LOGBITS)) |=     BITMASKTAB[indxX AND MODMASK];
            else
                 *(X+(indxX>>LOGBITS)) &= NOT BITMASKTAB[indxX AND MODMASK];
        }
    }
  }
}

void Closure(unitptr addr, unit rows, unit cols)
{
    unit i;
    unit j;
    unit k;
    unit ii;
    unit ij;
    unit ik;
    unit kj;
    unit termi;
    unit termk;

#ifdef ENABLE_BOUNDS_CHECKING
  if ((rows == cols) and (*(addr-3) == rows*cols))
#else
  if (rows == cols)
#endif
  {
    for ( i = 0; i < rows; i++ )
    {
        ii = i * cols + i;
        *(addr+(ii>>LOGBITS)) |= BITMASKTAB[ii AND MODMASK];
    }
    for ( k = 0; k < rows; k++ )
    {
        termk = k * cols;
        for ( i = 0; i < rows; i++ )
        {
            termi = i * cols;
            ik = termi + k;
            for ( j = 0; j < rows; j++ )
            {
                ij = termi + j;
                kj = termk + j;
                if ((*(addr+(ik>>LOGBITS)) AND BITMASKTAB[ik AND MODMASK]) &&
                    (*(addr+(kj>>LOGBITS)) AND BITMASKTAB[kj AND MODMASK]))
                     *(addr+(ij>>LOGBITS)) |=  BITMASKTAB[ij AND MODMASK];
            }
        }
    }
  }
}
/**************************************/
/* PROGRAMMER   Steffen Beyer         */
/**************************************/
/* CREATED      03.02.97              */
/**************************************/
/* MODIFIED     04.02.97              */
/**************************************/
/* COPYRIGHT    Steffen Beyer         */
/**************************************/
#endif
