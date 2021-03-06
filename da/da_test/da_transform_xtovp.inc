subroutine da_transform_xtovp(grid, xb, xbx, xa, vp, be)

   !---------------------------------------------------------------------------
   ! Purpose: Transforms analysis to control variables (Vp-type)
   !---------------------------------------------------------------------------

   implicit none

   type(domain),            intent(inout) :: grid
   type(xb_type),           intent(in)    :: xb         ! First guess structure.
   type(xbx_type),          intent(in)    :: xbx        ! Header/non-gridded vars.
   type(x_type),            intent(inout) :: xa         ! Analysis increments.
   type(vp_type),           intent(out)   :: vp         ! CV on grid structure.
   type(be_type), optional, intent(in)    :: be         ! Background errors.

   real    :: vor(ims:ime,jms:jme,kms:kme) ! Vorticity.
   real    :: div(ims:ime,jms:jme,kms:kme) ! Divergence.

   real    :: one_over_m2(ims:ime,jms:jme) !   Multiplicative coeff.

   integer :: i, j, k                      ! Loop counters.

   if (trace_use) call da_trace_entry("da_transform_xtovp")

   !----------------------------------------------------------------
   ! [1.0] Perform transform v = U^{-1} x
   !----------------------------------------------------------------      

   call da_zero_vp_type (vp)

   ! [2.2] Transform u, v to streamfunction via vorticity:

#ifdef DM_PARALLEL
#include "HALO_PSICHI_UV_ADJ.inc"
#endif

   call da_uv_to_vorticity(xb, xa % u, xa % v, vor)

   ! Convert vorticity to Del**2 psi:
   if (.not. global) then               
      if (fg_format == fg_format_wrf) then
         one_over_m2(its:ite,jts:jte) = 1.0 / (xb % map_factor(its:ite,jts:jte) * &
                                        xb % map_factor(its:ite,jts:jte))
         do k = kts, kte
            vor(its:ite,jts:jte,k) = &
              one_over_m2(its:ite,jts:jte)*vor(its:ite,jts:jte,k)
         end do
      else
         write(unit=message(1),fmt='(A,I5,A,L10)') &
            ' Wrong choice of fg_format= ',fg_format,' with global = ',global
         call da_error(__FILE__,__LINE__,message(1:1))
      end if
   end if

   ! Calculate psi:
   write (unit=stdout,fmt=*) ' calling Solve_PoissonEquation for Psi'
   call da_solve_poissoneqn_fct(grid,xbx, vor, vp%v1)

   ! [2.3] Transform u, v to velocity potential via divergence:

   call da_message((/'calling UV_To_Divergence'/))
   call da_uv_to_divergence(xb, xa % u, xa % v, div)

   ! Convert divergence to Del**2 chi:
   if (.not. global)  then              
      if (fg_format == fg_format_wrf) then
         do k = kts, kte
            div(its:ite,jts:jte,k) = &
               one_over_m2(its:ite,jts:jte) * div(its:ite,jts:jte,k)
         end do
      else
         write(unit=message(1),fmt='(A,I5,A,L10)') &
            ' Wrong choice of fg_format= ',fg_format,' with global = ',global
         call da_error(__FILE__,__LINE__,message(1:1))
      end if
   end if

   ! Calculate chi:

   call da_message((/' calling Solve_PoissonEquation for Chi'/))
   call da_solve_poissoneqn_fct(grid,xbx, div, vp%v2)

   ! [2.4] Transform chi to chi_u:
   call da_message((/' calculating chi_u'/))
   do k=kts,kte
      do j=jts,jte
         vp%v2(its:ite,j,k) = vp%v2(its:ite,j,k) - &
            be%reg_chi(j,k)*vp%v1(its:ite,j,k)
      end do
   end do

   call da_message((/' calculating t_u'/))
   ! [2.4] Compute t_u:
   do k=kts,kte
      do j=jts,jte
         do i=its,ite
            vp%v3(i,j,k) = xa%t(i,j,k) - &
               sum(be%reg_t(j,k,kts:kte)*vp%v1(i,j,kts:kte))
         end do
      end do
   end do

   ! [2.6] Choice of moisture control variable: 
   
   call da_message((/' calculating psudo rh'/))
   vp % v4(its:ite,jts:jte,kts:kte) = xa % q  (its:ite,jts:jte,kts:kte) /   &
      xb % qs (its:ite,jts:jte,kts:kte) 

   ! [2.7] Choice of surface pressure control variable: 
      
   ! [2.7] compute psfc_u:
   call da_message((/' calculating psfc_u '/))
   do j=jts,jte
      do i=its,ite
         vp % v5(i,j,1) = xa%psfc(i,j) - sum(be%reg_ps(j,kts:kte)*vp%v1(i,j,kts:kte))
      end do
   end do

   if (trace_use) call da_trace_exit("da_transform_xtovp")

end subroutine da_transform_xtovp


