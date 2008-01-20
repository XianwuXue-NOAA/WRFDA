      SUBROUTINE READNS(LUNIT,SUBSET,JDATE,IRET)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    READNS
C   PRGMMR: WOOLLEN          ORG: NP20       DATE: 1994-01-06
C
C ABSTRACT: THIS SUBROUTINE SHOULD ONLY BE CALLED WHEN LOGICAL UNIT
C   LUNIT HAS BEEN OPENED FOR INPUT OPERATIONS.  IT READS THE NEXT
C   SUBSET FROM LOGICAL UNIT NUMBER LUNIT INTO INTERNAL SUBSET ARRAYS.
C   BUFR MESSAGES IN LUNIT MAY BE EITHER COMPRESSED OR UNCOMPRESSED.
C   THIS SUBROUTINE IS ACTUALLY A COMBINATION OF BUFR ARCHIVE LIBRARY
C   SUBROUTINES READMG AND READSB.
C
C PROGRAM HISTORY LOG:
C 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C 1998-07-08  J. WOOLLEN -- REPLACED CALL TO CRAY LIBRARY ROUTINE
C                           "ABORT" WITH CALL TO NEW INTERNAL BUFRLIB
C                           ROUTINE "BORT"
C 1999-11-18  J. WOOLLEN -- THE NUMBER OF BUFR FILES WHICH CAN BE
C                           OPENED AT ONE TIME INCREASED FROM 10 TO 32
C                           (NECESSARY IN ORDER TO PROCESS MULTIPLE
C                           BUFR FILES UNDER THE MPI)
C 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C                           INTERDEPENDENCIES
C 2003-11-04  D. KEYSER  -- MAXJL (MAXIMUM NUMBER OF JUMP/LINK ENTRIES)
C                           INCREASED FROM 15000 TO 16000 (WAS IN
C                           VERIFICATION VERSION); UNIFIED/PORTABLE FOR
C                           WRF; ADDED DOCUMENTATION (INCLUDING
C                           HISTORY); OUTPUTS MORE COMPLETE DIAGNOSTIC
C                           INFO WHEN ROUTINE TERMINATES ABNORMALLY
C
C USAGE:    CALL READNS (LUNIT, SUBSET, JDATE, IRET)
C   INPUT ARGUMENT LIST:
C     LUNIT    - INTEGER: FORTRAN LOGICAL UNIT NUMBER FOR BUFR FILE
C
C   OUTPUT ARGUMENT LIST:
C     SUBSET   - CHARACTER*8: TABLE A MNEMONIC FOR BUFR MESSAGE
C                CONTAINING SUBSET BEING READ
C     JDATE    - INTEGER: DATE-TIME STORED WITHIN SECTION 1 OF BUFR
C                MESSAGE CONTAINING SUBSET BEING READ, IN FORMAT OF
C                EITHER YYMMDDHH OR YYYYMMDDHH, DEPENDING ON DATELEN()
C                VALUE
C     IREADNS  - INTEGER: RETURN CODE:
C                       0 = normal return
C                      -1 = there are no more subsets in the BUFR file
C
C REMARKS:
C    THIS ROUTINE CALLS:        BORT     READMG   READSB   STATUS
C    THIS ROUTINE IS CALLED BY: IREADNS
C                               Also called by application programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      INCLUDE 'bufrlib.prm'

      COMMON /MSGCWD/ NMSG(NFILES),NSUB(NFILES),MSUB(NFILES),
     .                INODE(NFILES),IDATE(NFILES)
      COMMON /TABLES/ MAXTAB,NTAB,TAG(MAXJL),TYP(MAXJL),KNT(MAXJL),
     .                JUMP(MAXJL),LINK(MAXJL),JMPB(MAXJL),
     .                IBT(MAXJL),IRF(MAXJL),ISC(MAXJL),
     .                ITP(MAXJL),VALI(MAXJL),KNTI(MAXJL),
     .                ISEQ(MAXJL,2),JSEQ(MAXJL)

      CHARACTER*10 TAG
      CHARACTER*8  SUBSET
      CHARACTER*3  TYP

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C  REFRESH THE SUBSET AND JDATE PARAMETERS
C  ---------------------------------------

      CALL STATUS(LUNIT,LUN,IL,IM)
      IF(IL.EQ.0) GOTO 900
      IF(IL.GT.0) GOTO 901
      SUBSET = TAG(INODE(LUN))
      JDATE  = IDATE(LUN)

C  READ THE NEXT SUBSET IN THE BUFR FILE
C  -------------------------------------

1     CALL READSB(LUNIT,IRET)
      IF(IRET.NE.0) THEN
         CALL READMG(LUNIT,SUBSET,JDATE,IRET)
         IF(IRET.EQ.0) GOTO 1
      ENDIF

C  EXITS
C  -----

      RETURN
900   CALL BORT('BUFRLIB: READNS - INPUT BUFR FILE IS CLOSED, IT MUST'//
     . ' BE OPEN FOR INPUT')
901   CALL BORT('BUFRLIB: READNS - INPUT BUFR FILE IS OPEN FOR OUTPUT'//
     . ', IT MUST BE OPEN FOR INPUT')
      END