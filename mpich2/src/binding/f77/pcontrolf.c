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
extern FORT_DLL_SPEC void FORT_CALL MPI_PCONTROL( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol_( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_pcontrol_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_PCONTROL = pmpi_pcontrol__
#pragma weak mpi_pcontrol__ = pmpi_pcontrol__
#pragma weak mpi_pcontrol_ = pmpi_pcontrol__
#pragma weak mpi_pcontrol = pmpi_pcontrol__
#pragma weak pmpi_pcontrol_ = pmpi_pcontrol__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_PCONTROL( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_PCONTROL = PMPI_PCONTROL
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol__( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_pcontrol__ = pmpi_pcontrol__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_pcontrol = pmpi_pcontrol
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol_( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_pcontrol_ = pmpi_pcontrol_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_PCONTROL  MPI_PCONTROL
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_pcontrol__  mpi_pcontrol__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_pcontrol  mpi_pcontrol
#else
#pragma _HP_SECONDARY_DEF pmpi_pcontrol_  mpi_pcontrol_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_PCONTROL as PMPI_PCONTROL
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_pcontrol__ as pmpi_pcontrol__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_pcontrol as pmpi_pcontrol
#else
#pragma _CRI duplicate mpi_pcontrol_ as pmpi_pcontrol_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_PCONTROL( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_pcontrol_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_PCONTROL = mpi_pcontrol__
#pragma weak mpi_pcontrol_ = mpi_pcontrol__
#pragma weak mpi_pcontrol = mpi_pcontrol__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_pcontrol_ PMPI_PCONTROL
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_pcontrol_ pmpi_pcontrol__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_pcontrol_ pmpi_pcontrol
#else
#define mpi_pcontrol_ pmpi_pcontrol_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Pcontrol
#define MPI_Pcontrol PMPI_Pcontrol 

#else

#ifdef F77_NAME_UPPER
#define mpi_pcontrol_ MPI_PCONTROL
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_pcontrol_ mpi_pcontrol__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_pcontrol_ mpi_pcontrol
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_pcontrol_ ( MPI_Fint *v1, MPI_Fint *ierr ){
    *ierr = MPI_Pcontrol( (int)*v1 );
}
