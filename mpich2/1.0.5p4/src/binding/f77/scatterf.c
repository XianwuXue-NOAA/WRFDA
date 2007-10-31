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
extern FORT_DLL_SPEC void FORT_CALL MPI_SCATTER( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter__( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter_( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_scatter_( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_SCATTER = pmpi_scatter__
#pragma weak mpi_scatter__ = pmpi_scatter__
#pragma weak mpi_scatter_ = pmpi_scatter__
#pragma weak mpi_scatter = pmpi_scatter__
#pragma weak pmpi_scatter_ = pmpi_scatter__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_SCATTER( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_SCATTER = PMPI_SCATTER
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter__( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_scatter__ = pmpi_scatter__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_scatter = pmpi_scatter
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter_( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_scatter_ = pmpi_scatter_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_SCATTER  MPI_SCATTER
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_scatter__  mpi_scatter__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_scatter  mpi_scatter
#else
#pragma _HP_SECONDARY_DEF pmpi_scatter_  mpi_scatter_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_SCATTER as PMPI_SCATTER
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_scatter__ as pmpi_scatter__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_scatter as pmpi_scatter
#else
#pragma _CRI duplicate mpi_scatter_ as pmpi_scatter_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_SCATTER( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter__( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_scatter_( void*, MPI_Fint *, MPI_Fint *, void*, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_SCATTER = mpi_scatter__
#pragma weak mpi_scatter_ = mpi_scatter__
#pragma weak mpi_scatter = mpi_scatter__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_scatter_ PMPI_SCATTER
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_scatter_ pmpi_scatter__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_scatter_ pmpi_scatter
#else
#define mpi_scatter_ pmpi_scatter_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Scatter
#define MPI_Scatter PMPI_Scatter 

#else

#ifdef F77_NAME_UPPER
#define mpi_scatter_ MPI_SCATTER
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_scatter_ mpi_scatter__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_scatter_ mpi_scatter
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_scatter_ ( void*v1, MPI_Fint *v2, MPI_Fint *v3, void*v4, MPI_Fint *v5, MPI_Fint *v6, MPI_Fint *v7, MPI_Fint *v8, MPI_Fint *ierr ){

    if (MPIR_F_NeedInit){ mpirinitf_(); MPIR_F_NeedInit = 0; }
    if (v4 == MPIR_F_MPI_IN_PLACE) v4 = MPI_IN_PLACE;
    *ierr = MPI_Scatter( v1, *v2, (MPI_Datatype)(*v3), v4, *v5, (MPI_Datatype)(*v6), *v7, (MPI_Comm)(*v8) );
}
