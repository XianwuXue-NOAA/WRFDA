subroutine da_check_max_iv_qscat(it, qscat, itu, itvv, ituf, itvvf)

   !-----------------------------------------------------------------------
   ! Purpose: TBD
   !-----------------------------------------------------------------------

   implicit none

   integer,           intent (in)         :: it
   integer,           intent (inout)      :: itu, itvv, ituf, itvvf
   type (qscat_type), intent(inout)       :: qscat

   logical                                :: failed

   !---------------------------------------------------------------------------
   ! [1.0] Open diagnostic file:
   !---------------------------------------------------------------------------

   if (rootproc .and. check_max_iv_print) then
      write (check_max_iv_unit,'(A)')  &
         '----------------------------------------------------------------'
      write (unit = check_max_iv_unit, fmt = '(A,/)') 'MAX ERROR TEST QC:'

      write (unit = check_max_iv_unit, fmt = '(/,9(A,F3.0,/))')  &
         'Error max test ratio for Qscat_U   = ',max_error_uv, &
         'Error max test ratio for Qscat_V   = ',max_error_uv
   end if

   !---------------------------------------------------------------------------
   ! [2.0] Perform maximum innovation vector check:
   !---------------------------------------------------------------------------

   failed = .false.

   ! U-wind

   call da_max_error_qc(it, qscat % info, qscat % u, &
              max_error_uv, itu, ituf, check_max_iv_unit, 'U    ', &
                            failed, check_max_iv_print)
   ! V-wind

   call da_max_error_qc (it, qscat % info, qscat % v,&
              max_error_uv, itvv, itvvf, check_max_iv_unit, 'V    ', &
                             failed, check_max_iv_print)                           

   !---------------------------------------------------------------------------
   ! [3.0] Output test failed results:
   !---------------------------------------------------------------------------
 
   if (rootproc .and. check_max_iv_print .and. failed) then
      write (unit = check_max_iv_unit, fmt = '(/,10(2(A,I6),/))') & 
         'Number of failed qscat u-wind observations:       ', &
         ituf,  ' on ',itu,   &
         'Number of failed qscat v-wind observations:       ', &
         itvvf,  ' on ',itvv
   end if

end subroutine da_check_max_iv_qscat

