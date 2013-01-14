      SUBROUTINE PAD(IBAY,IBIT,IBYT,IPADB)

!$$$  SUBPROGRAM DOCUMENTATION BLOCK
!
! SUBPROGRAM:    PAD
!   PRGMMR: WOOLLEN          ORG: NP20       DATE: 1994-01-06
!
! ABSTRACT: THIS SUBROUTINE FIRST PACKS THE VALUE FOR THE NUMBER OF
!   BITS BEING "PADDED" (WE'LL GET TO THAT LATER), STARTING WITH BIT
!   IBIT+1 AND USING EIGHT BITS IN THE PACKED ARRAY IBAY (WHICH
!   REPRESENTS A SUBSET PACKED INTO IBIT BITS).  THEN, STARTING WITH
!   IBIT+9, IT PACKS ZEROES (I.E., "PADS") TO THE SPECIFIED BIT
!   BOUNDARY (IPADB).  (NOTE: IT'S THE NUMBER OF BITS PADDED HERE THAT
!   WAS PACKED IN BITS IBIT+1 THROUGH IBIT+8 - THIS IS ACTUALLY A
!   DELAYED REPLICATION FACTOR).  IPADB MUST BE A MULTIPLE OF EIGHT AND
!   REPRESENTS THE BIT BOUNDARY ON WHICH THE PACKED SUBSET IN IBAY
!   SHOULD END AFTER PADDING.  FOR EXAMPLE, IF IPABD IS "8", THEN THE
!   NUMBER OF BITS IN IBAY ACTUALLY CONSUMED BY PACKED DATA (INCLUDING
!   THE PADDING) WILL BE A MULTIPLE OF EIGHT.  IF IPADB IS "16", IT
!   WILL BE A MULTIPLE OF SIXTEEN.  IN EITHER (OR ANY) CASE, THIS
!   ENSURES THAT THE PACKED SUBSET WILL ALWAYS END ON A FULL BYTE
!   BOUNDARY.
!
! PROGRAM HISTORY LOG:
! 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
! 1998-07-08  J. WOOLLEN -- REPLACED CALL TO CRAY LIBRARY ROUTINE
!                           "ABORT" WITH CALL TO NEW INTERNAL BUFRLIB
!                           ROUTINE "BORT"
! 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
!                           INTERDEPENDENCIES
! 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED
!                           DOCUMENTATION (INCLUDING HISTORY); OUTPUTS
!                           MORE COMPLETE DIAGNOSTIC INFO WHEN ROUTINE
!                           TERMINATES ABNORMALLY
!
! USAGE:    CALL PAD (IBAY, IBIT, IBYT, IPADB)
!   INPUT ARGUMENT LIST:
!     IBAY     - INTEGER: *-WORD PACKED BINARY ARRAY NOT YET PADDED
!     IBIT     - INTEGER: BIT POINTER WITHIN IBAY TO START PADDING FROM
!     IPADB    - INTEGER: BIT BOUNDARY TO PAD TO (MUST BE A MULTIPLE OF
!                8)
!
!   OUTPUT ARGUMENT LIST:
!     IBAY     - INTEGER: *-WORD PACKED BINARY ARRAY NOW PADDED
!     IBIT     - INTEGER: NUMBER OF BITS WITHIN IBAY CONTAINING PACKED
!                DATA (INCLUDING PADDING, MUST BE A MULTIPLE OF 8)
!     IBYT     - INTEGER: NUMBER OF BYTES WITHIN IBAY CONTAINING PACKED
!                DATA (INCLUDING PADDING) (I.E., IBIT/8)
!
! REMARKS:
!    THIS ROUTINE CALLS:        BORT     PKB
!    THIS ROUTINE IS CALLED BY: MSGUPD
!                               Normally not called by any application
!                               programs.
!
! ATTRIBUTES:
!   LANGUAGE: FORTRAN 77
!   MACHINE:  PORTABLE TO ALL PLATFORMS
!
!$$$

      CHARACTER*128 BORT_STR
      DIMENSION     IBAY(*)

!----------------------------------------------------------------------
!----------------------------------------------------------------------

!  PAD THE SUBSET TO AN IPADB BIT BOUNDARY
!  ----------------------------------------

      IPAD = IPADB - MOD(IBIT+8,IPADB)
!  .... First pack the # of bits being padded this is a delayed
!       replication factor
      CALL PKB(IPAD,8,IBAY,IBIT)
!  .... Now pad with zeroes to the bit bdry
      CALL PKB(0,IPAD,IBAY,IBIT)
      IBYT = IBIT/8

      IF(MOD(IBIT,IPADB).NE.0) GOTO 900
      IF(MOD(IBIT,8    ).NE.0) GOTO 901

!  EXITS
!  -----

      RETURN
900   WRITE(BORT_STR,'("BUFRLIB: PAD - THE INPUT BIT BOUNDARY TO PAD '// &
       'TO (",I8,") IS NOT A MULTIPLE OF 8")') IPADB
      CALL BORT(BORT_STR)
901   WRITE(BORT_STR,'("BUFRLIB: PAD - THE NUMBER OF BITS IN A PACKED'// &
       ' SUBSET AFTER PADDING (",I8,") IS NOT A MULTIPLE OF 8")') IBIT
      CALL BORT(BORT_STR)
      END SUBROUTINE PAD