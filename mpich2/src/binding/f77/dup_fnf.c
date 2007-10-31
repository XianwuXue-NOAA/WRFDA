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
extern FORT_DLL_SPEC void FORT_CALL MPI_DUP_FN( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn__( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn_( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_dup_fn_( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );

#pragma weak MPI_DUP_FN = pmpi_dup_fn__
#pragma weak mpi_dup_fn__ = pmpi_dup_fn__
#pragma weak mpi_dup_fn_ = pmpi_dup_fn__
#pragma weak mpi_dup_fn = pmpi_dup_fn__
#pragma weak pmpi_dup_fn_ = pmpi_dup_fn__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_DUP_FN( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );

#pragma weak MPI_DUP_FN = PMPI_DUP_FN
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn__( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );

#pragma weak mpi_dup_fn__ = pmpi_dup_fn__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );

#pragma weak mpi_dup_fn = pmpi_dup_fn
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn_( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );

#pragma weak mpi_dup_fn_ = pmpi_dup_fn_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_DUP_FN  MPI_DUP_FN
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_dup_fn__  mpi_dup_fn__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_dup_fn  mpi_dup_fn
#else
#pragma _HP_SECONDARY_DEF pmpi_dup_fn_  mpi_dup_fn_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_DUP_FN as PMPI_DUP_FN
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_dup_fn__ as pmpi_dup_fn__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_dup_fn as pmpi_dup_fn
#else
#pragma _CRI duplicate mpi_dup_fn_ as pmpi_dup_fn_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_DUP_FN( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn__( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_dup_fn_( MPI_Fint, MPI_Fint*, void*, void**, void**, MPI_Fint*, MPI_Fint * );

#pragma weak MPI_DUP_FN = mpi_dup_fn__
#pragma weak mpi_dup_fn_ = mpi_dup_fn__
#pragma weak mpi_dup_fn = mpi_dup_fn__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_dup_fn_ PMPI_DUP_FN
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_dup_fn_ pmpi_dup_fn__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_dup_fn_ pmpi_dup_fn
#else
#define mpi_dup_fn_ pmpi_dup_fn_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_mpi_dup_fn
#define MPI_mpi_dup_fn PMPI_mpi_dup_fn 

#else

#ifdef F77_NAME_UPPER
#define mpi_dup_fn_ MPI_DUP_FN
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_dup_fn_ mpi_dup_fn__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_dup_fn_ mpi_dup_fn
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_dup_fn_ ( MPI_Fint v1, MPI_Fint*v2, void*v3, void**v4, void**v5, MPI_Fint*v6, MPI_Fint *ierr ){
        *v5 = *v4;
        *v6 = MPIR_TO_FLOG(1);
        *ierr = MPI_SUCCESS;
}
