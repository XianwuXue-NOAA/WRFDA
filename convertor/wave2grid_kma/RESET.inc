      SUBROUTINE RESET (DATA,N)
Crizvi      REAL*4 DATA(N)
      REAL DATA(N)
      DO 100 I=1,N
       DATA(I)=0.0
  100 CONTINUE
C
      RETURN
      END SUBROUTINE RESET
