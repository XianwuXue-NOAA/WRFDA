!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!                                                                       
!   FFTPACK 5.0                                                         
!   Copyright (C) 1995-2004, Scientific Computing Division,             
!   University Corporation for Atmospheric Research                     
!   Licensed under the GNU General Public License (GPL)                 
!                                                                       
!   Authors:  Paul N. Swarztrauber and Richard A. Valent                
!                                                                       
!   $Id: sinqmf.f,v 1.2 2004/06/15 21:29:20 rodney Exp $                
!                                                                       
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
                                                                        
      SUBROUTINE SINQMF (LOT, JUMP, N, INC, X, LENX, WSAVE, LENSAV,     &
     &                   WORK, LENWRK, IER)                             
      INTEGER    LOT, JUMP, N, INC, LENX, LENSAV, LENWRK, IER 
      REAL       X(INC,*), WSAVE(LENSAV), WORK(LENWRK) 
      LOGICAL    XERCON 
!                                                                       
      IER = 0 
!                                                                       
      IF (LENX .LT. (LOT-1)*JUMP + INC*(N-1) + 1) THEN 
        IER = 1 
        CALL XERFFT ('SINQMF', 6) 
        GO TO 300 
      ELSEIF (LENSAV .LT. 2*N + INT(LOG(REAL(N))) +4) THEN 
        IER = 2 
        CALL XERFFT ('SINQMF', 8) 
        GO TO 300 
      ELSEIF (LENWRK .LT. LOT*N) THEN 
        IER = 3 
        CALL XERFFT ('SINQMF', 10) 
        GO TO 300 
      ELSEIF (.NOT. XERCON(INC,JUMP,N,LOT)) THEN 
        IER = 4 
        CALL XERFFT ('SINQMF', -1) 
        GO TO 300 
      ENDIF 
!                                                                       
      IF (N .EQ. 1) RETURN 
      NS2 = N/2 
      LJ = (LOT-1)*JUMP+1 
      DO 101 K=1,NS2 
         KC = N-K 
         DO 201 M=1,LJ,JUMP 
         XHOLD = X(M,K) 
         X(M,K) = X(M,KC+1) 
         X(M,KC+1) = XHOLD 
  201    CONTINUE 
  101 END DO 
      CALL COSQMF (LOT,JUMP,N,INC,X,LENX,WSAVE,LENSAV,WORK,LENWRK,IER1) 
      IF (IER1 .NE. 0) THEN 
        IER = 20 
        CALL XERFFT ('SINQMF',-5) 
        GO TO 300 
      ENDIF 
      DO 102 K=2,N,2 
         DO 202 M=1,LJ,JUMP 
         X(M,K) = -X(M,K) 
  202    CONTINUE 
  102 END DO 
  300 CONTINUE 
      RETURN 
      END                                           
