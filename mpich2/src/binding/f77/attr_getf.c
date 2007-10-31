/* -*- Mode: C; c-basic-offset:4 ; -*- */
/*  
 *  (C) 2001 by Argonne National Laboratory.
 *      See COPYRIGHT in top-level directory.
 *
 * This file is automatically generated by buildiface 
 * DO NOT EDIT
 */
#include "mpi_fortimpl.h"


/* Begin MPI profiling block */
#if defined(USE_WEAK_SYMBOLS) && !defined(USE_ONLY_MPI_NAMES) 
#if defined(HAVE_MULTIPLE_PRAGMA_WEAK) && defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL MPI_ATTR_GET( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get__( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get_( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_attr_get_( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_ATTR_GET = pmpi_attr_get__
#pragma weak mpi_attr_get__ = pmpi_attr_get__
#pragma weak mpi_attr_get_ = pmpi_attr_get__
#pragma weak mpi_attr_get = pmpi_attr_get__
#pragma weak pmpi_attr_get_ = pmpi_attr_get__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_ATTR_GET( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_ATTR_GET = PMPI_ATTR_GET
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get__( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_attr_get__ = pmpi_attr_get__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_attr_get = pmpi_attr_get
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get_( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_attr_get_ = pmpi_attr_get_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_ATTR_GET  MPI_ATTR_GET
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_attr_get__  mpi_attr_get__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_attr_get  mpi_attr_get
#else
#pragma _HP_SECONDARY_DEF pmpi_attr_get_  mpi_attr_get_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_ATTR_GET as PMPI_ATTR_GET
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_attr_get__ as pmpi_attr_get__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_attr_get as pmpi_attr_get
#else
#pragma _CRI duplicate mpi_attr_get_ as pmpi_attr_get_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_ATTR_GET( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get__( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_attr_get_( MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_ATTR_GET = mpi_attr_get__
#pragma weak mpi_attr_get_ = mpi_attr_get__
#pragma weak mpi_attr_get = mpi_attr_get__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_attr_get_ PMPI_ATTR_GET
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_attr_get_ pmpi_attr_get__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_attr_get_ pmpi_attr_get
#else
#define mpi_attr_get_ pmpi_attr_get_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Attr_get
#define MPI_Attr_get PMPI_Attr_get 

#else

#ifdef F77_NAME_UPPER
#define mpi_attr_get_ MPI_ATTR_GET
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_attr_get_ mpi_attr_get__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_attr_get_ mpi_attr_get
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_attr_get_ ( MPI_Fint *v1, MPI_Fint *v2, void*v3, MPI_Fint *v4, MPI_Fint *ierr ){
    void *attrv3;
    int l4;
    *ierr = MPI_Attr_get( (MPI_Comm)(*v1), *v2, &attrv3, &l4 );

    if ((int)*ierr || !l4) {
        *(MPI_Fint*)v3 = 0;
    }
    else {
        *(MPI_Fint*)v3 = (MPI_Fint)(MPI_Aint)attrv3;
    }
    *v4 = MPIR_TO_FLOG(l4);
}
