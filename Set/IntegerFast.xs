/*
  Copyright (c) 1995, 1996, 1997 by Steffen Beyer. All rights reserved.
  This package is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself.
*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "lib_defs.h"
#include "lib_set.h"


typedef   SV *Class_Type;
typedef   SV *Set_Object;
typedef   SV *Set_Handle;
typedef unit *Set_Address;


static  char *Class_Name = "Set::IntegerFast";


#ifdef  DEBUG_SET_OBJECT

#define DEBUG_CONSTRUCTOR(elem,ref,hdl,adr) fprintf(stderr, \
"Set::IntegerFast::new(%u): ref=0x%.8X hdl=0x%.8X adr=0x%.8X\n", elem, \
(N_long) ref, (N_long) hdl, (N_long) adr);

#define DEBUG_DESTRUCTOR(ref,hdl,adr) fprintf(stderr, \
"Set::IntegerFast::DESTROY(): ref=0x%.8X hdl=0x%.8X adr=0x%.8X\n", \
(N_long) ref, (N_long) hdl, (N_long) adr);

#else

#define DEBUG_CONSTRUCTOR(elem,ref,hdl,adr) ;
#define DEBUG_DESTRUCTOR(ref,hdl,adr) ;

#endif


#ifdef  ENABLE_SUBCLASSING

#define OVERRIDE_CLASS(class,type,name) ;

#define SET_OBJECT_CHECK(ref,hdl,adr,nam) \
    ( ref &&                              \
    SvROK(ref) &&                         \
    (hdl = (Set_Handle)SvRV(ref)) &&      \
    SvOBJECT(hdl) &&                      \
    (SvTYPE(hdl) == SVt_PVMG) &&          \
    SvREADONLY(hdl) &&                    \
    (adr = (Set_Address)SvIV(hdl)) )

#else

#define OVERRIDE_CLASS(class,type,name) class = (type) name;

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


MODULE = Set::IntegerFast		PACKAGE = Set::IntegerFast


PROTOTYPES: DISABLE


BOOT:
{
    unit rc;
    if (rc = Set_Auto_config())
    {
        fprintf(stderr,
"'Set::IntegerFast' failed to auto-configure:\n");
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
Version()
PPCODE:
{
    EXTEND(sp,1);
    PUSHs(sv_2mortal(newSVpv("3.0",0)));
}


N_int
Size(reference)
Set_Object	reference
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
        RETVAL = *(address-3);
    else
        croak("Set::IntegerFast::Size(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


MODULE = Set::IntegerFast		PACKAGE = Set::IntegerFast		PREFIX = Set_


void
Set_new(class,elements)
Class_Type	class
N_int	elements
PPCODE:
{
    Set_Address address;
    Set_Handle  handle;
    Set_Object  reference;

    if ( class && SvROK(class) && (handle = (SV *)SvRV(class)) &&
         SvOBJECT(handle) && (SvTYPE(handle) == SVt_PVMG) )
    {
        class = (Class_Type)HvNAME(SvSTASH(handle));
    }
    else
    {
        if ( class && SvPOK(class) && SvCUR(class) )
        {
            class = (Class_Type)SvPV(class,na);
        }
        else
        {
            croak("Set::IntegerFast::new(): error in first parameter (class name or reference)");
        }
    }

    /* overrides input parameter unless ENABLE_SUBCLASSING is defined: */

    OVERRIDE_CLASS(class,Class_Type,Class_Name)

    address = Set_Create(elements);

    if (address != NULL)
    {
        handle = newSViv((IV)address);
        reference = sv_bless(sv_2mortal(newRV(handle)),
            gv_stashpv((char *)class,1));
        SvREFCNT_dec(handle);
        SvREADONLY_on(handle);
        PUSHs(reference);
    }
    else
        PUSHs(&sv_undef);
    DEBUG_CONSTRUCTOR(elements,reference,handle,address)
}


void
Set_DESTROY(reference)
Set_Object	reference
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        DEBUG_DESTRUCTOR(reference,handle,address)
        Set_Destroy(address);
        SvREADONLY_off(handle);
        sv_setiv(handle,(IV)NULL);
        SvREADONLY_on(handle);
    }
    else
        croak("Set::IntegerFast::DESTROY(): not a 'Set::IntegerFast' object reference");
}


void
Set_Resize(reference,elements)
Set_Object	reference
N_int	elements
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        address = Set_Resize(address,elements);

        SvREADONLY_off(handle);
        sv_setiv(handle,(IV)address);
        SvREADONLY_on(handle);
    }
    else
        croak("Set::IntegerFast::Resize(): not a 'Set::IntegerFast' object reference");
}


void
Set_Empty(reference)
Set_Object	reference
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        Set_Empty(address);
    }
    else
        croak("Set::IntegerFast::Empty(): not a 'Set::IntegerFast' object reference");
}


void
Set_Fill(reference)
Set_Object	reference
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        Set_Fill(address);
    }
    else
        croak("Set::IntegerFast::Fill(): not a 'Set::IntegerFast' object reference");
}


void
Set_Empty_Interval(reference,lower,upper)
Set_Object	reference
N_int	lower
N_int	upper
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        if (lower >= *(address-3))
            croak("Set::IntegerFast::Empty_Interval(): lower index out of range");
        if (upper >= *(address-3))
            croak("Set::IntegerFast::Empty_Interval(): upper index out of range");
        if (lower > upper)
            croak("Set::IntegerFast::Empty_Interval(): lower > upper index");
        Set_Empty_Interval(address,lower,upper);
    }
    else
        croak("Set::IntegerFast::Empty_Interval(): not a 'Set::IntegerFast' object reference");
}


void
Set_Fill_Interval(reference,lower,upper)
Set_Object	reference
N_int	lower
N_int	upper
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        if (lower >= *(address-3))
            croak("Set::IntegerFast::Fill_Interval(): lower index out of range");
        if (upper >= *(address-3))
            croak("Set::IntegerFast::Fill_Interval(): upper index out of range");
        if (lower > upper)
            croak("Set::IntegerFast::Fill_Interval(): lower > upper index");
        Set_Fill_Interval(address,lower,upper);
    }
    else
        croak("Set::IntegerFast::Fill_Interval(): not a 'Set::IntegerFast' object reference");
}


void
Set_Flip_Interval(reference,lower,upper)
Set_Object	reference
N_int	lower
N_int	upper
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        if (lower >= *(address-3))
            croak("Set::IntegerFast::Flip_Interval(): lower index out of range");
        if (upper >= *(address-3))
            croak("Set::IntegerFast::Flip_Interval(): upper index out of range");
        if (lower > upper)
            croak("Set::IntegerFast::Flip_Interval(): lower > upper index");
        Set_Flip_Interval(address,lower,upper);
    }
    else
        croak("Set::IntegerFast::Flip_Interval(): not a 'Set::IntegerFast' object reference");
}


void
Set_Insert(reference,index)
Set_Object	reference
N_int	index
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        if (index >= *(address-3))
            croak("Set::IntegerFast::Insert(): index out of range");
        else
            Set_Insert(address,index);
    }
    else
        croak("Set::IntegerFast::Insert(): not a 'Set::IntegerFast' object reference");
}


void
Set_Delete(reference,index)
Set_Object	reference
N_int	index
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        if (index >= *(address-3))
            croak("Set::IntegerFast::Delete(): index out of range");
        else
            Set_Delete(address,index);
    }
    else
        croak("Set::IntegerFast::Delete(): not a 'Set::IntegerFast' object reference");
}


boolean
Set_flip(reference,index)
Set_Object	reference
N_int	index
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        if (index >= *(address-3))
            croak("Set::IntegerFast::flip(): index out of range");
        else
            RETVAL = Set_flip(address,index);
    }
    else
        croak("Set::IntegerFast::flip(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


boolean
Set_in(reference,index)
Set_Object	reference
N_int	index
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        if (index >= *(address-3))
            croak("Set::IntegerFast::in(): index out of range");
        else
            RETVAL = Set_in(address,index);
    }
    else
        croak("Set::IntegerFast::in(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


N_int
Set_Norm(reference)
Set_Object	reference
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = Set_Norm(address);
    }
    else
        croak("Set::IntegerFast::Norm(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


Z_long
Set_Min(reference)
Set_Object	reference
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = Set_Min(address);
    }
    else
        croak("Set::IntegerFast::Min(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


Z_long
Set_Max(reference)
Set_Object	reference
CODE:
{
    Set_Handle  handle;
    Set_Address address;

    if ( SET_OBJECT_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = Set_Max(address);
    }
    else
        croak("Set::IntegerFast::Max(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


void
Set_Union(Xref,Yref,Zref)
Set_Object	Xref
Set_Object	Yref
Set_Object	Zref
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
        if ((*(Xadr-3) != *(Yadr-3)) or (*(Xadr-3) != *(Zadr-3)))
            croak("Set::IntegerFast::Union(): set size mismatch");
        else
            Set_Union(Xadr,Yadr,Zadr);
    }
    else
        croak("Set::IntegerFast::Union(): not a 'Set::IntegerFast' object reference");
}


void
Set_Intersection(Xref,Yref,Zref)
Set_Object	Xref
Set_Object	Yref
Set_Object	Zref
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
        if ((*(Xadr-3) != *(Yadr-3)) or (*(Xadr-3) != *(Zadr-3)))
            croak("Set::IntegerFast::Intersection(): set size mismatch");
        else
            Set_Intersection(Xadr,Yadr,Zadr);
    }
    else
        croak("Set::IntegerFast::Intersection(): not a 'Set::IntegerFast' object reference");
}


void
Set_Difference(Xref,Yref,Zref)
Set_Object	Xref
Set_Object	Yref
Set_Object	Zref
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
        if ((*(Xadr-3) != *(Yadr-3)) or (*(Xadr-3) != *(Zadr-3)))
            croak("Set::IntegerFast::Difference(): set size mismatch");
        else
            Set_Difference(Xadr,Yadr,Zadr);
    }
    else
        croak("Set::IntegerFast::Difference(): not a 'Set::IntegerFast' object reference");
}


void
Set_ExclusiveOr(Xref,Yref,Zref)
Set_Object	Xref
Set_Object	Yref
Set_Object	Zref
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
        if ((*(Xadr-3) != *(Yadr-3)) or (*(Xadr-3) != *(Zadr-3)))
            croak("Set::IntegerFast::ExclusiveOr(): set size mismatch");
        else
            Set_ExclusiveOr(Xadr,Yadr,Zadr);
    }
    else
        croak("Set::IntegerFast::ExclusiveOr(): not a 'Set::IntegerFast' object reference");
}


void
Set_Complement(Xref,Yref)
Set_Object	Xref
Set_Object	Yref
CODE:
{
    Set_Handle  Xhdl;
    Set_Address Xadr;
    Set_Handle  Yhdl;
    Set_Address Yadr;

    if ( SET_OBJECT_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         SET_OBJECT_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) != *(Yadr-3))
            croak("Set::IntegerFast::Complement(): set size mismatch");
        else
            Set_Complement(Xadr,Yadr);
    }
    else
        croak("Set::IntegerFast::Complement(): not a 'Set::IntegerFast' object reference");
}


boolean
Set_equal(Xref,Yref)
Set_Object	Xref
Set_Object	Yref
CODE:
{
    Set_Handle  Xhdl;
    Set_Address Xadr;
    Set_Handle  Yhdl;
    Set_Address Yadr;

    if ( SET_OBJECT_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         SET_OBJECT_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) != *(Yadr-3))
            croak("Set::IntegerFast::equal(): set size mismatch");
        else
            RETVAL = Set_equal(Xadr,Yadr);
    }
    else
        croak("Set::IntegerFast::equal(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


boolean
Set_inclusion(Xref,Yref)
Set_Object	Xref
Set_Object	Yref
CODE:
{
    Set_Handle  Xhdl;
    Set_Address Xadr;
    Set_Handle  Yhdl;
    Set_Address Yadr;

    if ( SET_OBJECT_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         SET_OBJECT_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) != *(Yadr-3))
            croak("Set::IntegerFast::inclusion(): set size mismatch");
        else
            RETVAL = Set_inclusion(Xadr,Yadr);
    }
    else
        croak("Set::IntegerFast::inclusion(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


boolean
Set_lexorder(Xref,Yref)
Set_Object	Xref
Set_Object	Yref
CODE:
{
    Set_Handle  Xhdl;
    Set_Address Xadr;
    Set_Handle  Yhdl;
    Set_Address Yadr;

    if ( SET_OBJECT_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         SET_OBJECT_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) != *(Yadr-3))
            croak("Set::IntegerFast::lexorder(): set size mismatch");
        else
            RETVAL = Set_lexorder(Xadr,Yadr);
    }
    else
        croak("Set::IntegerFast::lexorder(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


Z_int
Set_Compare(Xref,Yref)
Set_Object	Xref
Set_Object	Yref
CODE:
{
    Set_Handle  Xhdl;
    Set_Address Xadr;
    Set_Handle  Yhdl;
    Set_Address Yadr;

    if ( SET_OBJECT_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         SET_OBJECT_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) != *(Yadr-3))
            croak("Set::IntegerFast::Compare(): set size mismatch");
        else
            RETVAL = Set_Compare(Xadr,Yadr);
    }
    else
        croak("Set::IntegerFast::Compare(): not a 'Set::IntegerFast' object reference");
}
OUTPUT:
RETVAL


void
Set_Copy(Xref,Yref)
Set_Object	Xref
Set_Object	Yref
CODE:
{
    Set_Handle  Xhdl;
    Set_Address Xadr;
    Set_Handle  Yhdl;
    Set_Address Yadr;

    if ( SET_OBJECT_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         SET_OBJECT_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) != *(Yadr-3))
            croak("Set::IntegerFast::Copy(): set size mismatch");
        else
            Set_Copy(Xadr,Yadr);
    }
    else
        croak("Set::IntegerFast::Copy(): not a 'Set::IntegerFast' object reference");
}


