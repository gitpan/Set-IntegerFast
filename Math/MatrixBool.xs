/*
  Copyright (c) 1995, 1996, 1997 by Steffen Beyer. All rights reserved.
  This package is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself.
*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "lib_defs.h"
#include "lib_matr.h"


typedef   SV *Class_Type;
typedef   SV *Set_Object;
typedef   SV *Set_Handle;
typedef unit *Set_Address;


static  char *Class_Name = "Set::IntegerFast";


#ifdef  ENABLE_SUBCLASSING

#define SET_OBJECT_CHECK(ref,hdl,adr,nam) \
    ( ref &&                              \
    SvROK(ref) &&                         \
    (hdl = (Set_Handle)SvRV(ref)) &&      \
    SvOBJECT(hdl) &&                      \
    (SvTYPE(hdl) == SVt_PVMG) &&          \
    SvREADONLY(hdl) &&                    \
    (adr = (Set_Address)SvIV(hdl)) )

#else

#define SET_OBJECT_CHECK(ref,hdl,adr,nam) \
    ( ref &&                              \
    SvROK(ref) &&                         \
    (hdl = (Set_Handle)SvRV(ref)) &&      \
    SvOBJECT(hdl) &&                      \
    (SvTYPE(hdl) == SVt_PVMG) &&          \
    (strEQ(HvNAME(SvSTASH(hdl)),nam)) &&  \
    SvREADONLY(hdl) &&                    \
    (adr = (Set_Address)SvIV(hdl)) )

#endif


MODULE = Math::MatrixBool		PACKAGE = Math::MatrixBool


PROTOTYPES: DISABLE


BOOT:
{
    unit rc;
    if (rc = Auto_config())
    {
        fprintf(stderr,
"'Math::MatrixBool' failed to auto-configure:\n");
        switch (rc)
        {
            case 1:
                fprintf(stderr,
"the type 'unit' is larger (has more bits) than the type 'size_t'!\n");
                break;
            case 2:
                fprintf(stderr,
"the number of bits of a machine word is not a power of 2!\n");
                break;
            case 3:
                fprintf(stderr,
"the number of bits of a machine word is less than 8!\n");
                break;
            case 4:
                fprintf(stderr,
"the number of bits of a machine word and 'sizeof(unit)' are inconsistent!\n");
                break;
            case 5:
                fprintf(stderr,
"unable to allocate memory with 'malloc()'!\n");
                break;
            default:
                fprintf(stderr,
"unexpected (unknown) error!\n");
                break;
        }
        exit(rc);
    }
}


void
Multiply(Xref,rowsX,colsX,Yref,rowsY,colsY,Zref,rowsZ,colsZ)
Set_Object	Xref
N_int	rowsX
N_int	colsX
Set_Object	Yref
N_int	rowsY
N_int	colsY
Set_Object	Zref
N_int	rowsZ
N_int	colsZ
CODE:
{
    Set_Handle  Xhdl;
    Set_Address Xadr;
    Set_Handle  Yhdl;
    Set_Address Yadr;
    Set_Handle  Zhdl;
    Set_Address Zadr;

    if ( SET_OBJECT_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         SET_OBJECT_CHECK(Yref,Yhdl,Yadr,Class_Name) &&
         SET_OBJECT_CHECK(Zref,Zhdl,Zadr,Class_Name) )
    {
        if ((colsY == rowsZ) and (rowsX == rowsY) and (colsX == colsZ) and
            (*(Xadr-3) == rowsX*colsX) and
            (*(Yadr-3) == rowsY*colsY) and
            (*(Zadr-3) == rowsZ*colsZ))
            Multiply(Xadr,rowsX,colsX,Yadr,rowsY,colsY,Zadr,rowsZ,colsZ);
        else
            croak("Math::MatrixBool::Multiply(): matrix size mismatch");
    }
    else
        croak("Math::MatrixBool::Multiply(): not a 'Set::IntegerFast' object reference");
}


void
Closure(reference,rows,cols)
Set_Object	reference
N_int	rows
N_int	cols
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        if (rows != cols)
            croak("Math::MatrixBool::Closure(): matrix is not quadratic");
        if (*(address-3) == rows*cols)
            Closure(address,rows,cols);
        else
            croak("Math::MatrixBool::Closure(): matrix size mismatch");
    }
    else
        croak("Math::MatrixBool::Closure(): not a 'Set::IntegerFast' object reference");
}


