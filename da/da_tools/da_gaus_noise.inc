real function da_gaus_noise(KDUM)

   !---------------------------------------------------------------------
   ! Purpose: return a normally(gaussian) distributed random variable ctions
   !     with 0 mean and 1 standard deviation
   !
   !   method :
   !   ------
   !
   !   input :
   !   -----
   !      argument
   !         kdum             : seed for random number generator 
   !                           (set to a large negative number on entry)
   !      common              : none
   !
   !   output :
   !   ------
   !      argument
   !         gauss_noise      : gaussian random betwen 
   !      common              : none
   !
   !   workspace :              none
   !   ---------
   !      local :
   !
   !   external :  
   !   --------
   !      unifva     
   !
   !   reference :
   !   ---------
   !      numerical recipes in fortran. the art of scientific computing.
   !      second edition.  cambridge university press.
   !      press et. al., 1986.
   !
   !   modifications:
   !   --------------
   !       original  : 95-01(f. vandenberghe)
   !       addition  : 96-06(a. weaver)
   !---------------------------------------------------------------------
 
   implicit none
 
   integer, intent(inout) :: kdum

   integer             :: niset
   real                :: gset
   save niset,gset
   data niset/0/

   real zfac,zrsq,zv1,zv2

   if (niset.eq.0) then

1000  continue
      zv1   = 2.*da_unifva(kdum) - 1.
      zv2   = 2.*da_unifva(kdum) - 1.
      zrsq  = zv1**2 + zv2**2
          
      if ((zrsq.ge.1.).or.(zrsq.eq.0.)) goto 1000

      zfac  = sqrt(-2.*log(zrsq)/zrsq)
      gset  = zv1*zfac
      da_gaus_noise = zv2*zfac
      niset = 1
   else
      da_gaus_noise = gset
      niset = 0
   end if
      
   return

end function da_gaus_noise

