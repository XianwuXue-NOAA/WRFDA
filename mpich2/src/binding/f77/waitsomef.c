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
extern FORT_DLL_SPEC void FORT_CALL MPI_WAITSOME( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome__( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome_( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL pmpi_waitsome_( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_WAITSOME = pmpi_waitsome__
#pragma weak mpi_waitsome__ = pmpi_waitsome__
#pragma weak mpi_waitsome_ = pmpi_waitsome__
#pragma weak mpi_waitsome = pmpi_waitsome__
#pragma weak pmpi_waitsome_ = pmpi_waitsome__


#elif defined(HAVE_PRAGMA_WEAK)

#if defined(F77_NAME_UPPER)
extern FORT_DLL_SPEC void FORT_CALL MPI_WAITSOME( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_WAITSOME = PMPI_WAITSOME
#elif defined(F77_NAME_LOWER_2USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome__( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_waitsome__ = pmpi_waitsome__
#elif !defined(F77_NAME_LOWER_USCORE)
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_waitsome = pmpi_waitsome
#else
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome_( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak mpi_waitsome_ = pmpi_waitsome_
#endif

#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#if defined(F77_NAME_UPPER)
#pragma _HP_SECONDARY_DEF PMPI_WAITSOME  MPI_WAITSOME
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _HP_SECONDARY_DEF pmpi_waitsome__  mpi_waitsome__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _HP_SECONDARY_DEF pmpi_waitsome  mpi_waitsome
#else
#pragma _HP_SECONDARY_DEF pmpi_waitsome_  mpi_waitsome_
#endif

#elif defined(HAVE_PRAGMA_CRI_DUP)
#if defined(F77_NAME_UPPER)
#pragma _CRI duplicate MPI_WAITSOME as PMPI_WAITSOME
#elif defined(F77_NAME_LOWER_2USCORE)
#pragma _CRI duplicate mpi_waitsome__ as pmpi_waitsome__
#elif !defined(F77_NAME_LOWER_USCORE)
#pragma _CRI duplicate mpi_waitsome as pmpi_waitsome
#else
#pragma _CRI duplicate mpi_waitsome_ as pmpi_waitsome_
#endif
#endif /* HAVE_PRAGMA_WEAK */
#endif /* USE_WEAK_SYMBOLS */
/* End MPI profiling block */


/* These definitions are used only for generating the Fortran wrappers */
#if defined(USE_WEAK_SYBMOLS) && defined(HAVE_MULTIPLE_PRAGMA_WEAK) && \
    defined(USE_ONLY_MPI_NAMES)
extern FORT_DLL_SPEC void FORT_CALL MPI_WAITSOME( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome__( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );
extern FORT_DLL_SPEC void FORT_CALL mpi_waitsome_( MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint *, MPI_Fint * );

#pragma weak MPI_WAITSOME = mpi_waitsome__
#pragma weak mpi_waitsome_ = mpi_waitsome__
#pragma weak mpi_waitsome = mpi_waitsome__
#endif

/* Map the name to the correct form */
#ifndef MPICH_MPI_FROM_PMPI
#ifdef F77_NAME_UPPER
#define mpi_waitsome_ PMPI_WAITSOME
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_waitsome_ pmpi_waitsome__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_waitsome_ pmpi_waitsome
#else
#define mpi_waitsome_ pmpi_waitsome_
#endif
/* This defines the routine that we call, which must be the PMPI version
   since we're renaming the Fortran entry as the pmpi version.  The MPI name
   must be undefined first to prevent any conflicts with previous renamings,
   such as those put in place by the globus device when it is building on
   top of a vendor MPI. */
#undef MPI_Waitsome
#define MPI_Waitsome PMPI_Waitsome 

#else

#ifdef F77_NAME_UPPER
#define mpi_waitsome_ MPI_WAITSOME
#elif defined(F77_NAME_LOWER_2USCORE)
#define mpi_waitsome_ mpi_waitsome__
#elif !defined(F77_NAME_LOWER_USCORE)
#define mpi_waitsome_ mpi_waitsome
/* Else leave name alone */
#endif


#endif /* MPICH_MPI_FROM_PMPI */

/* Prototypes for the Fortran interfaces */
#include "fproto.h"
FORT_DLL_SPEC void FORT_CALL mpi_waitsome_ ( MPI_Fint *v1, MPI_Fint *v2, MPI_Fint *v3, MPI_Fint *v4, MPI_Fint *v5, MPI_Fint *ierr ){

    if (MPIR_F_NeedInit){ mpirinitf_(); MPIR_F_NeedInit = 0; }

    if (v5 == MPI_F_STATUSES_IGNORE) { v5 = (MPI_Fint *)MPI_STATUSES_IGNORE; }
    *ierr = MPI_Waitsome( *v1, (MPI_Request *)(v2), v3, v4, (MPI_Status *)v5 );

    {int li;
     for (li=0; li<*v3; li++) {
        if (v4[li] >= 0) v4[li] += 1;
     }
    }
}
