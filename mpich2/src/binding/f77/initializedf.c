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
extern FORT_DLL_SPEC void FORT_CALL MPI_INITIALIZED( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized_( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_initialized_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_INITIALIZED = pmpi_initialized__
#pragma weak mpi_initialized__ = pmpi_initialized__
#pragma weak mpi_initialized_ = pmpi_initialized__
#pragma weak mpi_initialized = pmpi_initialized__
#pragma weak pmpi_initialized_ = pmpi_initialized__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_INITIALIZED( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_INITIALIZED = PMPI_INITIALIZED
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized__( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_initialized__ = pmpi_initialized__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_initialized = pmpi_initialized
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized_( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_initialized_ = pmpi_initialized_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_INITIALIZED  MPI_INITIALIZED
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_initialized__  mpi_initialized__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_initialized  mpi_initialized
#else
#pragma _HP_SECONDARY_DEF pmpi_initialized_  mpi_initialized_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_INITIALIZED as PMPI_INITIALIZED
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_initialized__ as pmpi_initialized__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_initialized as pmpi_initialized
#else
#pragma _CRI duplicate mpi_initialized_ as pmpi_initialized_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_INITIALIZED( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_initialized_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_INITIALIZED = mpi_initialized__
#pragma weak mpi_initialized_ = mpi_initialized__
#pragma weak mpi_initialized = mpi_initialized__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_initialized_ PMPI_INITIALIZED
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_initialized_ pmpi_initialized__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_initialized_ pmpi_initialized
#else
#define mpi_initialized_ pmpi_initialized_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Initialized
#define MPI_Initialized PMPI_Initialized 

#else

#ifdef F77_NAME_UPPER
#define mpi_initialized_ MPI_INITIALIZED
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_initialized_ mpi_initialized__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_initialized_ mpi_initialized
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_initialized_ ( MPI_Fint *v1, MPI_Fint *ierr ){
    int l1;
    *ierr = MPI_Initialized( &l1 );
    *v1 = MPIR_TO_FLOG(l1);
}
