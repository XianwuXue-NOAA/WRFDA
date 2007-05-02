subroutine da_transform_xtogpsref_adj(xa, xb, xp)

   !-----------------------------------------------------------------------
   ! Purpose: TBD
   ! input: xb%q, xb%p, xb%t, xa%ref, and xp
   ! output: xa%q, xa%p, xa%t
   !-----------------------------------------------------------------------

   implicit none

   type (x_type),  intent(inout) :: xa       ! gridded analysis increment.
   type (xb_type), intent(in)    :: xb       ! first guess state.
   type (xpose_type), intent(in) :: xp       ! domain decomposition vars.

   integer :: i, j, k, is, ie, js, je, ks, ke
   real    :: partone, parttwo, dividnd
   real    :: partone9,parttwo9,dividnd9

   if (trace_use) call da_trace_entry("da_transform_xtogpsref_adj")

   ! 1.0 Get the range for a tile

   is = xp%its; ie = xp%ite
   js = xp%jts; je = xp%jte
   ks = xp%kts; ke = xp%kte      

   if (Testing_WRFVAR) then
      is = xb%its-1
      js = xb%jts-1

      ie = xb%ite+1
      je = xb%jte+1

      if (is < xb%ids) is = xb%ids
      if (js < xb%jds) js = xb%jds

      if (ie > xb%ide) ie = xb%ide
      if (je > xb%jde) je = xb%jde
   end if

   !------------------------------------------------------------------------------
   !  [2.0] Calculate the adjoint for GPS refractivity:
   !------------------------------------------------------------------------------

   do k = ks, ke
      do j = js, je
         do i = is, ie

            !  Note: p in Pascal, q is the specific humidity

            !   2.1 basic state

            partone9 = 0.776*xb%p(i,j,k)/xb%t(i,j,k)
            dividnd9 = xb%t(i,j,k)*(0.622+0.378*xb%q(i,j,k))
            parttwo9 = 1.0+coeff*xb%q(i,j,k)/dividnd9

            !   2.2 Adjoint of partone and parttwo

            partone = xa%ref(i,j,k) * parttwo9
            parttwo = xa%ref(i,j,k) * partone9

            !   2.3 Adjoint of q and dividnd

            xa%q(i,j,k) = xa%q(i,j,k) + coeff*parttwo/dividnd9
            dividnd=-coeff*xb%q(i,j,k)*parttwo/(dividnd9*dividnd9)

            !   2.4 Adjoint of t, q, and p

            xa%t(i,j,k) = xa%t(i,j,k) + dividnd*(0.622+0.378*xb%q(i,j,k))
            xa%q(i,j,k) = xa%q(i,j,k) + xb%t(i,j,k)*0.378*dividnd

            xa%p(i,j,k) = xa%p(i,j,k) + 0.776*partone/xb%t(i,j,k)
            xa%t(i,j,k) = xa%t(i,j,k) - &
               0.776*xb%p(i,j,k)*partone/(xb%t(i,j,k)*xb%t(i,j,k))

            !  [3.0] Clean the xa%ref    

            xa%ref(i,j,k) = 0.0

         end do
      end do
   end do

   if (trace_use) call da_trace_exit("da_transform_xtogpsref_adj")

end subroutine da_transform_xtogpsref_adj

