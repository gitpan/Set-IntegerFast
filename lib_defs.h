#ifndef LIB_DEFINITIONS
#define LIB_DEFINITIONS
/**************************************/
/* MODULE   lib_defs.h          (dat) */
/**************************************/
/* IMPORTS                            */
/**************************************/

/**************************************/
/* INTERFACE                          */
/**************************************/

typedef  unsigned   char    byte;
typedef  unsigned   int     word;
typedef  unsigned   long    longword;
typedef  unsigned   short   shortword;

typedef  unsigned   char    isochar;  /* ISO-Latin-1 is an 8-bit code... */

typedef  unsigned   char    N_char;   /* natural numbers */
typedef  unsigned   int     N_int;    /* N = { 0, 1, 2, 3, ... } */
typedef  unsigned   long    N_long;
typedef  unsigned   short   N_short;

typedef  signed     char    Z_char;   /* whole numbers */
typedef  signed     int     Z_int;    /* Z = { 0, -1, 1, -2, 2, -3, 3, ... } */
typedef  signed     long    Z_long;
typedef  signed     short   Z_short;

typedef  void               *voidptr;
typedef  byte               *byteptr;
typedef  word               *wordptr;
typedef  longword           *longwordptr;
typedef  shortword          *shortwordptr;

typedef  isochar            *isocharptr;

#ifdef EXTENDED_LIB_DEFINITIONS

typedef             struct
{
    byte        l;
    byte        h;
}                   twobytes;

typedef             struct
{
    byte        a;
    byte        b;
    byte        c;
    byte        d;
}                   fourbytes;

typedef             struct
{
    word        l;
    word        h;
}                   twowords;

typedef             union       /********************************/
{                               /* implementation dependent !!! */
    word        x;              /********************************/
    twobytes    z;
}                   wordreg;    /* assumes int = 2 bytes */

typedef             union       /********************************/
{                               /* implementation dependent !!! */
    longword    x;              /********************************/
    twowords    y;
    fourbytes   z;              /* assumes long = 4 bytes and int = 2 bytes */
}                   longwordreg;    

#endif

#undef  FALSE
#define FALSE       (0==1)

#undef  TRUE
#define TRUE        (0==0)

typedef enum { false = FALSE , true = TRUE } boolean;

#define mod         %       /* arithmetic operators */

#define and         &&      /* logical (boolean) operators: lower case */
#define or          ||
#define not         !

#define AND         &       /* binary (bitwise) operators: UPPER CASE */
#define OR          |
#define XOR         ^
#define NOT         ~
#define SHL         <<
#define SHR         >>

#ifdef EXTENDED_LIB_DEFINITIONS

#define BELL        '\a'    /* bell             0x07 */
#define BEL         '\a'    /* bell             0x07 */
#define BACKSPACE   '\b'    /* backspace        0x08 */
#define BS          '\b'    /* backspace        0x08 */
#define TAB         '\t'    /* tab              0x09 */
#define HT          '\t'    /* horizontal tab   0x09 */
#define LINEFEED    '\n'    /* linefeed         0x0A */
#define NEWLINE     '\n'    /* newline          0x0A */
#define LF          '\n'    /* linefeed         0x0A */
#define VTAB        '\v'    /* vertical tab     0x0B */
#define VT          '\v'    /* vertical tab     0x0B */
#define FORMFEED    '\f'    /* formfeed         0x0C */
#define NEWPAGE     '\f'    /* newpage          0x0C */
#define CR          '\r'    /* carriage return  0x0D */

#define lobyte(x)           (((int)(x)) & 0xFF)
#define hibyte(x)           ((((int)(x)) >> 8) & 0xFF)

#endif

#define blockdef(name,size)         unsigned char name[size]
#define blocktypedef(name,size)     typedef unsigned char name[size]

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
/* MODIFIED     22.11.95              */
/**************************************/
/* COPYRIGHT    Steffen Beyer         */
/**************************************/
#endif
