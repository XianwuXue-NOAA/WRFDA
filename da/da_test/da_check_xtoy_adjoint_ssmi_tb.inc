subroutine da_check_xtoy_adjoint_ssmi_tb (oi, y, adjtest_lhs, pertile_lhs)

   !-----------------------------------------------------------------------
   ! Purpose: TBD
   !-----------------------------------------------------------------------

   implicit none

   type (ob_type), intent(in)     :: oi            ! obs. inc. vector (o-b).
   type (y_type) , intent(inout)  :: y             ! y = h (xa)
   real          , intent(inout)  :: adjtest_lhs, pertile_lhs   


   integer                        :: n             ! loop counter.
   real :: var

   if (oi%num_ssmi_tb > 0) then
      do n=1, oi%num_ssmi_tb
         y%ssmi_tb(n)%tb19v = y%ssmi_tb(n)%tb19v/typical_tb19v_rms
         y%ssmi_tb(n)%tb19h = y%ssmi_tb(n)%tb19h/typical_tb19h_rms
         y%ssmi_tb(n)%tb22v = y%ssmi_tb(n)%tb22v/typical_tb22v_rms
         y%ssmi_tb(n)%tb37v = y%ssmi_tb(n)%tb37v/typical_tb37v_rms
         y%ssmi_tb(n)%tb37h = y%ssmi_tb(n)%tb37h/typical_tb37h_rms
         y%ssmi_tb(n)%tb85v = y%ssmi_tb(n)%tb85v/typical_tb85v_rms
         y%ssmi_tb(n)%tb85h = y%ssmi_tb(n)%tb85h/typical_tb85h_rms

          var = (y%ssmi_tb(n)%tb19v) ** 2 &
              + (y%ssmi_tb(n)%tb19h) ** 2 &
              + (y%ssmi_tb(n)%tb22v) ** 2 &
              + (y%ssmi_tb(n)%tb37v) ** 2 &
              + (y%ssmi_tb(n)%tb37h) ** 2 &
              + (y%ssmi_tb(n)%tb85v) ** 2 &
              + (y%ssmi_tb(n)%tb85h) ** 2 

         pertile_lhs = pertile_lhs + var

         if (oi%ssmi_tb(n)%loc%proc_domain) then
            adjtest_lhs = adjtest_lhs + var
         end if
         y%ssmi_tb(n)%tb19v = y%ssmi_tb(n)%tb19v/typical_tb19v_rms
         y%ssmi_tb(n)%tb19h = y%ssmi_tb(n)%tb19h/typical_tb19h_rms
         y%ssmi_tb(n)%tb22v = y%ssmi_tb(n)%tb22v/typical_tb22v_rms
         y%ssmi_tb(n)%tb37v = y%ssmi_tb(n)%tb37v/typical_tb37v_rms
         y%ssmi_tb(n)%tb37h = y%ssmi_tb(n)%tb37h/typical_tb37h_rms
         y%ssmi_tb(n)%tb85v = y%ssmi_tb(n)%tb85v/typical_tb85v_rms
         y%ssmi_tb(n)%tb85h = y%ssmi_tb(n)%tb85h/typical_tb85h_rms
      end do
   end if

end subroutine da_check_xtoy_adjoint_ssmi_tb

