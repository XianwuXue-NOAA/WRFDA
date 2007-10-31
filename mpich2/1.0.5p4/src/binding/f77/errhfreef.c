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
extern FORT_DLL_SPEC void FORT_CALL MPI_ERRHANDLER_FREE( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free_( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_errhandler_free_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_ERRHANDLER_FREE = pmpi_errhandler_free__
#pragma weak mpi_errhandler_free__ = pmpi_errhandler_free__
#pragma weak mpi_errhandler_free_ = pmpi_errhandler_free__
#pragma weak mpi_errhandler_free = pmpi_errhandler_free__
#pragma weak pmpi_errhandler_free_ = pmpi_errhandler_free__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_ERRHANDLER_FREE( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_ERRHANDLER_FREE = PMPI_ERRHANDLER_FREE
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free__( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_errhandler_free__ = pmpi_errhandler_free__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_errhandler_free = pmpi_errhandler_free
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free_( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_errhandler_free_ = pmpi_errhandler_free_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_ERRHANDLER_FREE  MPI_ERRHANDLER_FREE
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_errhandler_free__  mpi_errhandler_free__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_errhandler_free  mpi_errhandler_free
#else
#pragma _HP_SECONDARY_DEF pmpi_errhandler_free_  mpi_errhandler_free_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_ERRHANDLER_FREE as PMPI_ERRHANDLER_FREE
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_errhandler_free__ as pmpi_errhandler_free__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_errhandler_free as pmpi_errhandler_free
#else
#pragma _CRI duplicate mpi_errhandler_free_ as pmpi_errhandler_free_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_ERRHANDLER_FREE( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_ERRHANDLER_FREE = mpi_errhandler_free__
#pragma weak mpi_errhandler_free_ = mpi_errhandler_free__
#pragma weak mpi_errhandler_free = mpi_errhandler_free__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_errhandler_free_ PMPI_ERRHANDLER_FREE
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_errhandler_free_ pmpi_errhandler_free__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_errhandler_free_ pmpi_errhandler_free
#else
#define mpi_errhandler_free_ pmpi_errhandler_free_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Errhandler_free
#define MPI_Errhandler_free PMPI_Errhandler_free 

#else

#ifdef F77_NAME_UPPER
#define mpi_errhandler_free_ MPI_ERRHANDLER_FREE
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_errhandler_free_ mpi_errhandler_free__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_errhandler_free_ mpi_errhandler_free
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_errhandler_free_ ( MPI_Fint *v1, MPI_Fint *ierr ){
    *ierr = MPI_Errhandler_free( v1 );
}
