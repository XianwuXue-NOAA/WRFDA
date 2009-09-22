subroutine da_check_max_iv_profiler(iv, it, num_qcstat_conv)   

   !-----------------------------------------------------------------------
   ! Purpose: TBD
   !-----------------------------------------------------------------------

   implicit none

   type(iv_type), intent(inout) :: iv
   integer,       intent(in)    :: it      ! Outer iteration 
   integer,       intent(inout) :: num_qcstat_conv(:,:,:,:)

   integer :: k,n, ipr
   logical :: failed
   
   if (trace_use_dull) call da_trace_entry("da_check_max_iv_profiler")

   !---------------------------------------------------------------------------
   ! [1.0] Perform maximum innovation vector check:
   !---------------------------------------------------------------------------

   do n = iv%info(profiler)%n1,iv%info(profiler)%n2
      do k = 1, iv%info(profiler)%levels(n)

       call da_get_print_lvl(iv%profiler(n)%p(k),ipr)

        if( iv%profiler(n)%u(k)%qc == fails_error_max .and. it > 1 )iv%profiler(n)%u(k)%qc =0
        if( iv%profiler(n)%u(k)%qc >= obs_qc_pointer ) then
         failed=.false.
         if( check_max_iv) &
         call da_max_error_qc(it, iv%info(profiler), n, iv%profiler(n)%u(k), max_error_uv, failed)
        if( iv%info(profiler)%proc_domain(k,n) ) then
                    num_qcstat_conv(1,profiler,1,ipr) = num_qcstat_conv(1,profiler,1,ipr) + 1
         if(failed)then
          num_qcstat_conv(2,profiler,1,ipr) = num_qcstat_conv(2,profiler,1,ipr) + 1
        write(qcstat_conv_unit,'(2x,a10,2x,a4,3f12.2)')&
        'profiler',ob_vars(1),iv%info(profiler)%lat(k,n),iv%info(profiler)%lon(k,n),0.01*iv%profiler(n)%p(k)
         end if 
         end if 
         end if 

        if( iv%profiler(n)%v(k)%qc == fails_error_max .and. it > 1 )iv%profiler(n)%v(k)%qc =0
        if( iv%profiler(n)%v(k)%qc >= obs_qc_pointer ) then
         failed=.false.
         if( check_max_iv) &
         call da_max_error_qc(it, iv%info(profiler), n, iv%profiler(n)%v(k), max_error_uv, failed)
        if( iv%info(profiler)%proc_domain(k,n) ) then
                    num_qcstat_conv(1,profiler,2,ipr) = num_qcstat_conv(1,profiler,2,ipr) + 1
         if(failed)then
          num_qcstat_conv(2,profiler,2,ipr) = num_qcstat_conv(2,profiler,2,ipr) + 1
        write(qcstat_conv_unit,'(2x,a10,2x,a4,3f12.2)')&
        'profiler',ob_vars(2),iv%info(profiler)%lat(k,n),iv%info(profiler)%lon(k,n),0.01*iv%profiler(n)%p(k)
         end if 
         end if 
         end if 

      end do
   end do
   
   if (trace_use_dull) call da_trace_exit("da_check_max_iv_profiler")

end subroutine da_check_max_iv_profiler