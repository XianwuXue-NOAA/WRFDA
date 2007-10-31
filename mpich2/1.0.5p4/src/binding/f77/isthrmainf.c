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
extern FORT_DLL_SPEC void FORT_CALL MPI_IS_THREAD_MAIN( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main_( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_is_thread_main_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_IS_THREAD_MAIN = pmpi_is_thread_main__
#pragma weak mpi_is_thread_main__ = pmpi_is_thread_main__
#pragma weak mpi_is_thread_main_ = pmpi_is_thread_main__
#pragma weak mpi_is_thread_main = pmpi_is_thread_main__
#pragma weak pmpi_is_thread_main_ = pmpi_is_thread_main__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_IS_THREAD_MAIN( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_IS_THREAD_MAIN = PMPI_IS_THREAD_MAIN
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main__( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_is_thread_main__ = pmpi_is_thread_main__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_is_thread_main = pmpi_is_thread_main
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main_( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_is_thread_main_ = pmpi_is_thread_main_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_IS_THREAD_MAIN  MPI_IS_THREAD_MAIN
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_is_thread_main__  mpi_is_thread_main__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_is_thread_main  mpi_is_thread_main
#else
#pragma _HP_SECONDARY_DEF pmpi_is_thread_main_  mpi_is_thread_main_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_IS_THREAD_MAIN as PMPI_IS_THREAD_MAIN
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_is_thread_main__ as pmpi_is_thread_main__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_is_thread_main as pmpi_is_thread_main
#else
#pragma _CRI duplicate mpi_is_thread_main_ as pmpi_is_thread_main_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_IS_THREAD_MAIN( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_IS_THREAD_MAIN = mpi_is_thread_main__
#pragma weak mpi_is_thread_main_ = mpi_is_thread_main__
#pragma weak mpi_is_thread_main = mpi_is_thread_main__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_is_thread_main_ PMPI_IS_THREAD_MAIN
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_is_thread_main_ pmpi_is_thread_main__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_is_thread_main_ pmpi_is_thread_main
#else
#define mpi_is_thread_main_ pmpi_is_thread_main_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Is_thread_main
#define MPI_Is_thread_main PMPI_Is_thread_main 

#else

#ifdef F77_NAME_UPPER
#define mpi_is_thread_main_ MPI_IS_THREAD_MAIN
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_is_thread_main_ mpi_is_thread_main__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_is_thread_main_ mpi_is_thread_main
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_is_thread_main_ ( MPI_Fint *v1, MPI_Fint *ierr ){
    *ierr = MPI_Is_thread_main( v1 );
}
