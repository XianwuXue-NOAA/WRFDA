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
extern FORT_DLL_SPEC void FORT_CALL MPI_START( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_start__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_start( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_start_( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_start_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_START = pmpi_start__
#pragma weak mpi_start__ = pmpi_start__
#pragma weak mpi_start_ = pmpi_start__
#pragma weak mpi_start = pmpi_start__
#pragma weak pmpi_start_ = pmpi_start__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_START( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_START = PMPI_START
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_start__( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_start__ = pmpi_start__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_start( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_start = pmpi_start
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_start_( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_start_ = pmpi_start_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_START  MPI_START
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_start__  mpi_start__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_start  mpi_start
#else
#pragma _HP_SECONDARY_DEF pmpi_start_  mpi_start_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_START as PMPI_START
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_start__ as pmpi_start__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_start as pmpi_start
#else
#pragma _CRI duplicate mpi_start_ as pmpi_start_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_START( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_start__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_start( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_start_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_START = mpi_start__
#pragma weak mpi_start_ = mpi_start__
#pragma weak mpi_start = mpi_start__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_start_ PMPI_START
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_start_ pmpi_start__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_start_ pmpi_start
#else
#define mpi_start_ pmpi_start_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Start
#define MPI_Start PMPI_Start 

#else

#ifdef F77_NAME_UPPER
#define mpi_start_ MPI_START
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_start_ mpi_start__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_start_ mpi_start
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_start_ ( MPI_Fint *v1, MPI_Fint *ierr ){
    *ierr = MPI_Start( (MPI_Request *)(v1) );
}