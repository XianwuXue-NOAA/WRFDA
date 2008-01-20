/* -*- Mode: C; c-basic-offset:4 ; -*- */
/*  
 *  (C) 2001 by Argonne National Laboratory.
 *      See COPYRIGHT in top-level directory.
 *
 * This file is automatically generated by buildiface -infile=../lib/pnetcdf.h -deffile=defs
 * DO NOT EDIT
 */
#include "mpinetcdf_impl.h"


#ifdef F77_NAME_UPPER
#define nfmpi_inq_varname_ NFMPI_INQ_VARNAME
#elif defined(F77_NAME_LOWER_2USCORE)
#define nfmpi_inq_varname_ nfmpi_inq_varname__
#elif !defined(F77_NAME_LOWER_USCORE)
#define nfmpi_inq_varname_ nfmpi_inq_varname
/* Else leave name alone */
#endif


/* Prototypes for the Fortran interfaces */
#include "mpifnetcdf.h"
FORTRAN_API int FORT_CALL nfmpi_inq_varname_ ( int *v1, int *v2, char *v3 FORT_MIXED_LEN(d3) FORT_END_LEN(d3) ){
    int ierr;
    int l2 = *v2 - 1;
    ierr = ncmpi_inq_varname( *v1, l2, v3 );

    {char *p = v3;
        while (*p) p++;
        while ((p-v3) < d3) { *p++ = ' '; }
    }
    return ierr;
}