/*
  Copyright (c) 1995 Steffen Beyer. All rights reserved.
  This program is free software; you can redistribute it and/or
  modify it under the same terms as Perl itself.
*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "lib_defs.h"
#include "lib_set.h"

/*
static word loop_pointer;
static word loop_mask;
*/


MODULE = Set::IntegerFast		PACKAGE = Set::IntegerFast


BOOT:
    {
        word rc;
        if (rc = Set_Auto_config())
        {
            fprintf(stderr,
"'Set::IntegerFast' failed to auto-configure:\n");
            switch (rc)
            {
                case 1:
                    fprintf(stderr,
"The types 'word' and 'size_t' differ in size!\n");
                    break;
                case 2:
                    fprintf(stderr,
"The number of bits of a machine word is not a power of 2!\n");
                    break;
                case 3:
                    fprintf(stderr,
"The number of bits of a machine word is less than 8!\n");
                    break;
                case 4:
                    fprintf(stderr,
"The number of bits of a machine word and sizeof(word) are inconsistent!\n");
                    break;
                case 5:
                    fprintf(stderr,
"Unable to allocate memory with malloc()!\n");
                    break;
                default:
                    fprintf(stderr,
"Unforeseen error!\n");
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
    PUSHs(sv_2mortal(newSVpv("1.1",0)));
}


#void
#Bit0(addr,index,bitno)
#wordptr	addr
#word	index
#word	bitno


#void
#Bit1(addr,index,bitno)
#wordptr	addr
#word	index
#word	bitno


#void
#BitX(addr,index,bitno)
#wordptr	addr
#word	index
#word	bitno


#boolean
#Bit(addr,index,bitno)
#wordptr	addr
#word	index
#word	bitno


MODULE = Set::IntegerFast		PACKAGE = Set::IntegerFast		PREFIX = Set_


#word
#Set_Size(elements)
#word	elements


#word
#Set_Mask(elements)
#word	elements


wordptr
Set_Create(elements)
word	elements


void
Set_Destroy(addr)
wordptr	addr
CODE:
{
    if (addr != NULL)
        Set_Destroy(addr);
    addr = NULL;
}
OUTPUT:
addr


void
Set_Resize(addr,elements)
wordptr	addr
word	elements
CODE:
{
    addr = Set_Resize(addr,elements);
}
OUTPUT:
addr


void
Set_Empty(addr)
wordptr	addr


void
Set_Fill(addr)
wordptr	addr


void
Set_Insert(addr,index)
wordptr	addr
word	index
CODE:
{
    if (index >= *(addr-3))
        croak("'Set::IntegerFast': index out of range");
    else
        Set_Insert(addr,index);
}


void
Set_Delete(addr,index)
wordptr	addr
word	index
CODE:
{
    if (index >= *(addr-3))
        croak("'Set::IntegerFast': index out of range");
    else
        Set_Delete(addr,index);
}


boolean
Set_in(addr,index)
wordptr	addr
word	index
CODE:
{
    if (index >= *(addr-3))
        croak("'Set::IntegerFast': index out of range");
    else
        RETVAL = Set_in(addr,index);
}
OUTPUT:
RETVAL


#void
#Set_in_Init(index)
#word	index
#CODE:
#{
#    Set_in_Init(index,&loop_pointer,&loop_mask);
#}


#boolean
#Set_in_up(addr)
#wordptr	addr
#CODE:
#{
#    RETVAL = Set_in_up(addr,&loop_pointer,&loop_mask);
#}
#OUTPUT:
#RETVAL


#boolean
#Set_in_down(addr)
#wordptr	addr
#CODE:
#{
#    RETVAL = Set_in_down(addr,&loop_pointer,&loop_mask);
#}
#OUTPUT:
#RETVAL


void
Set_Union(X,Y,Z)
wordptr	X
wordptr	Y
wordptr	Z
CODE:
{
    if ((*(X-3) != *(Y-3)) or (*(X-3) != *(Z-3)))
        croak("'Set::IntegerFast': set size mismatch");
    else
        Set_Union(X,Y,Z);
}


void
Set_Intersection(X,Y,Z)
wordptr	X
wordptr	Y
wordptr	Z
CODE:
{
    if ((*(X-3) != *(Y-3)) or (*(X-3) != *(Z-3)))
        croak("'Set::IntegerFast': set size mismatch");
    else
        Set_Intersection(X,Y,Z);
}


void
Set_Difference(X,Y,Z)
wordptr	X
wordptr	Y
wordptr	Z
CODE:
{
    if ((*(X-3) != *(Y-3)) or (*(X-3) != *(Z-3)))
        croak("'Set::IntegerFast': set size mismatch");
    else
        Set_Difference(X,Y,Z);
}


void
Set_ExclusiveOr(X,Y,Z)
wordptr	X
wordptr	Y
wordptr	Z
CODE:
{
    if ((*(X-3) != *(Y-3)) or (*(X-3) != *(Z-3)))
        croak("'Set::IntegerFast': set size mismatch");
    else
        Set_ExclusiveOr(X,Y,Z);
}


void
Set_Complement(X,Y)
wordptr	X
wordptr	Y
CODE:
{
    if (*(X-3) != *(Y-3))
        croak("'Set::IntegerFast': set size mismatch");
    else
        Set_Complement(X,Y);
}


boolean
Set_equal(X,Y)
wordptr	X
wordptr	Y
CODE:
{
    if (*(X-3) != *(Y-3))
        croak("'Set::IntegerFast': set size mismatch");
    else
        RETVAL = Set_equal(X,Y);
}
OUTPUT:
RETVAL


boolean
Set_inclusion(X,Y)
wordptr	X
wordptr	Y
CODE:
{
    if (*(X-3) != *(Y-3))
        croak("'Set::IntegerFast': set size mismatch");
    else
        RETVAL = Set_inclusion(X,Y);
}
OUTPUT:
RETVAL


boolean
Set_lexorder(X,Y)
wordptr	X
wordptr	Y
CODE:
{
    if (*(X-3) != *(Y-3))
        croak("'Set::IntegerFast': set size mismatch");
    else
        RETVAL = Set_lexorder(X,Y);
}
OUTPUT:
RETVAL


int
Set_Compare(X,Y)
wordptr	X
wordptr	Y
CODE:
{
    if (*(X-3) != *(Y-3))
        croak("'Set::IntegerFast': set size mismatch");
    else
    {
        RETVAL = Set_Compare(X,Y);
        if (RETVAL != 0)
        {
            if (RETVAL > 0)
                RETVAL =  1;
            else
                RETVAL = -1;
        }
    }
}
OUTPUT:
RETVAL


word
Set_Norm(addr)
wordptr	addr


long
Set_Min(addr)
wordptr	addr


long
Set_Max(addr)
wordptr	addr


void
Set_Copy(X,Y)
wordptr	X
wordptr	Y
CODE:
{
    if (*(X-3) != *(Y-3))
        croak("'Set::IntegerFast': set size mismatch");
    else
        Set_Copy(X,Y);
}


