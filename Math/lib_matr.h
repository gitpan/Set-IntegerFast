#ifndef AUTO_CONF_MATRIX_OBJECTS
#define AUTO_CONF_MATRIX_OBJECTS
/**************************************/
/* MODULE   lib_matr.h          (adt) */
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

unit    Auto_config(void);

void    Multiply(unitptr X,    unit rowsX, unit colsX,
                 unitptr Y,    unit rowsY, unit colsY,
                 unitptr Z,    unit rowsZ, unit colsZ);

void    Closure (unitptr addr, unit rows,  unit cols);

/**************************************/
/* RESOURCES                          */
/**************************************/

/**************************************/
/* IMPLEMENTATION                     */
/**************************************/

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
