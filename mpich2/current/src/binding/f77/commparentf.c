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
extern FORT_DLL_SPEC void FORT_CALL MPI_COMM_GET_PARENT( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent_( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_comm_get_parent_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_COMM_GET_PARENT = pmpi_comm_get_parent__
#pragma weak mpi_comm_get_parent__ = pmpi_comm_get_parent__
#pragma weak mpi_comm_get_parent_ = pmpi_comm_get_parent__
#pragma weak mpi_comm_get_parent = pmpi_comm_get_parent__
#pragma weak pmpi_comm_get_parent_ = pmpi_comm_get_parent__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_COMM_GET_PARENT( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_COMM_GET_PARENT = PMPI_COMM_GET_PARENT
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent__( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_comm_get_parent__ = pmpi_comm_get_parent__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_comm_get_parent = pmpi_comm_get_parent
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent_( MPI_Fint *, MPI_Fint * );

#pragma weak mpi_comm_get_parent_ = pmpi_comm_get_parent_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_COMM_GET_PARENT  MPI_COMM_GET_PARENT
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_comm_get_parent__  mpi_comm_get_parent__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_comm_get_parent  mpi_comm_get_parent
#else
#pragma _HP_SECONDARY_DEF pmpi_comm_get_parent_  mpi_comm_get_parent_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_COMM_GET_PARENT as PMPI_COMM_GET_PARENT
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_comm_get_parent__ as pmpi_comm_get_parent__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_comm_get_parent as pmpi_comm_get_parent
#else
#pragma _CRI duplicate mpi_comm_get_parent_ as pmpi_comm_get_parent_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_COMM_GET_PARENT( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent__( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent( MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent_( MPI_Fint *, MPI_Fint * );

#pragma weak MPI_COMM_GET_PARENT = mpi_comm_get_parent__
#pragma weak mpi_comm_get_parent_ = mpi_comm_get_parent__
#pragma weak mpi_comm_get_parent = mpi_comm_get_parent__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_comm_get_parent_ PMPI_COMM_GET_PARENT
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_comm_get_parent_ pmpi_comm_get_parent__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_comm_get_parent_ pmpi_comm_get_parent
#else
#define mpi_comm_get_parent_ pmpi_comm_get_parent_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Comm_get_parent
#define MPI_Comm_get_parent PMPI_Comm_get_parent 

#else

#ifdef F77_NAME_UPPER
#define mpi_comm_get_parent_ MPI_COMM_GET_PARENT
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_comm_get_parent_ mpi_comm_get_parent__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_comm_get_parent_ mpi_comm_get_parent
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_comm_get_parent_ ( MPI_Fint *v1, MPI_Fint *ierr ){
    *ierr = MPI_Comm_get_parent( (MPI_Comm *)(v1) );
}