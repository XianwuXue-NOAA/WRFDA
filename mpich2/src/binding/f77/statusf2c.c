
/* -*- Mode: C; c-basic-offset:4 ; -*- */
/*  
 *  (C) 2001 by Argonne National Laboratory.
 *      See COPYRIGHT in top-level directory.
 *
 * This file is automatically generated by buildiface 
 * DO NOT EDIT
 */
#include "mpi_fortimpl.h"
/* mpierrs.h and mpierror.h for the error code creation */
#include "mpierrs.h"
#include <stdio.h> 
#include "mpierror.h"

/* -- Begin Profiling Symbol Block for routine MPI_Status_f2c */
#if defined(USE_WEAK_SYMBOLS) && !defined(USE_ONLY_MPI_NAMES) 
#if defined(HAVE_PRAGMA_WEAK)
#pragma weak MPI_Status_f2c = PMPI_Status_f2c
#elif defined(HAVE_PRAGMA_HP_SEC_DEF)
#pragma _HP_SECONDARY_DEF PMPI_Status_f2c  MPI_Status_f2c
#elif defined(HAVE_PRAGMA_CRI_DUP)
#pragma _CRI duplicate MPI_Status_f2c as PMPI_Status_f2c
#endif
#endif
/* -- End Profiling Symbol Block */

/* Define MPICH_MPI_FROM_PMPI if weak symbols are not supported to build
   the MPI routines */
#ifndef MPICH_MPI_FROM_PMPI
#undef MPI_Status_f2c
#define MPI_Status_f2c PMPI_Status_f2c
#endif

#undef FUNCNAME
#define FUNCNAME MPI_Status_f2c

int MPI_Status_f2c( MPI_Fint *f_status, MPI_Status *c_status )
{
    int mpi_errno = MPI_SUCCESS;
    /* This code assumes that the ints are the same size */
    
    if (f_status == MPI_F_STATUS_IGNORE) {
	/* The call is erroneous (see 4.12.5 in MPI-2) */
        mpi_errno = MPIR_Err_create_code( MPI_SUCCESS, MPIR_ERR_RECOVERABLE,
		 "MPI_Status_f2c", __LINE__, MPI_ERR_OTHER, "**notfstatignore", 0 );
	return MPIR_Err_return_comm( 0, "MPI_Status_f2c",  mpi_errno );
    }
    *c_status = *(MPI_Status *)	f_status;
    return MPI_SUCCESS;  
}
