subroutine da_transform_xtoy_sound (xa, iv, xp, y)

   !-----------------------------------------------------------------------
   ! Purpose: TBD
   !-----------------------------------------------------------------------

   implicit none

   type (x_type),     intent(in)    :: xa       ! gridded analysis increment.
   type (ob_type),    intent(in)    :: iv       ! Innovation vector (O-B).
   type (xpose_type), intent(in)    :: xp       ! Domain decomposition vars.
   type (y_type),     intent(inout) :: y        ! y = h (xa) (linear)

   integer                      :: n        ! Loop counter.
   integer                      :: i, j, k  ! Index dimension.
   real                         :: dx, dxm  ! 
   real                         :: dy, dym  !


   if (iv%num_sound > 0) then
      do n=iv%ob_numb(iv%current_ob_time-1)%sound + 1, iv%ob_numb(iv%current_ob_time)%sound

         ! [1.1] Get horizontal interpolation weights:

         i = iv%sound(n)%loc%i
         j = iv%sound(n)%loc%j
         dx = iv%sound(n)%loc%dx
         dy = iv%sound(n)%loc%dy
         dxm = iv%sound(n)%loc%dxm
         dym = iv%sound(n)%loc%dym

         !xyh y%sound(n)%u(:) = 0.0
         !xyh y%sound(n)%v(:) = 0.0
         !xyh y%sound(n)%t(:) = 0.0
         !xyh y%sound(n)%q(:) = 0.0

         k = iv % sound(n) % info % levels

         if (k < 1) cycle

         ! [1.2] Interpolate horizontally:
         call da_interp_lin_3d(xa % u, xp, i, j, dx, dy, dxm, dym, &
                            y%sound(n)%u, k, iv%sound(n)%zk, k)
         call da_interp_lin_3d(xa % v, xp, i, j, dx, dy, dxm, dym, &
                            y%sound(n)%v, k, iv%sound(n)%zk, k)
         call da_interp_lin_3d(xa % t, xp, i, j, dx, dy, dxm, dym, &
                            y%sound(n)%t, k, iv%sound(n)%zk, k)
         call da_interp_lin_3d(xa % q, xp, i, j, dx, dy, dxm, dym, &
                            y%sound(n)%q, k, iv%sound(n)%zk, k)
      end do
   end if

end subroutine da_transform_xtoy_sound

