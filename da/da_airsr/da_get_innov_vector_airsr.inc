subroutine da_get_innov_vector_airsr ( it, xb, xp, ob, iv )
!-------------------------------------------------------------------------
!  History:
!
!     Creation:        03/07/2006                Syed RH Rizvi        
!    
!     Purpose:   a) Rcomputes innovation vecrot at
!                   AIRS retrieval locations 
!                b) Does quality control check on innovation vector
!                   if required.
!
!-------------------------------------------------------------------------
  IMPLICIT NONE

  INTEGER,           INTENT(IN)    :: it       ! External iteration.
  TYPE (xb_type),    INTENT(IN)    :: xb       ! first guess state.
  TYPE (xpose_type), INTENT(IN)    :: xp       ! Domain decomposition vars.
  TYPE (y_type),     INTENT(INOUT) :: ob       ! Observation structure.
  TYPE (ob_type),    INTENT(INOUT) :: iv       ! O-B structure.

  INTEGER                        :: n        ! Loop counter.
  INTEGER                        :: i, j, k  ! Index dimension.
  INTEGER                        :: num_levs ! Number of obs levels.
  REAL                           :: dx, dxm  ! Interpolation weights.
  REAL                           :: dy, dym  ! Interpolation weights.

  REAL, DIMENSION(1:max_ob_levels) :: model_t  ! Model value t at ob location.
  REAL, DIMENSION(1:max_ob_levels) :: model_q  ! Model value q at ob location.
  ! REAL, DIMENSION(1:max_ob_levels) :: model_h  ! Model value h at ob location.

  REAL, DIMENSION(xp%kms:xp%kme)   :: v_h      ! Model value h at ob hor. location.
  REAL, DIMENSION(xp%kms:xp%kme)   :: v_p      ! Model value p at ob hor. location.

  REAL                         :: model_p  ! Model value p at oblocation.
  REAL                         :: model_h  ! Model value h at oblocation.

  INTEGER                      :: itt,ittf,itqv,itqvf
  !-------------------------------------------------------------------------
  IF ( iv%num_airsr < 1 ) return
  itt  = 0; itqv  = 0;
  ittf = 0; itqvf = 0;

  DO n=iv%ob_numb(iv%current_ob_time-1)%airsr + 1, iv%ob_numb(iv%current_ob_time)%airsr
    if(iv%airsr(n)%loc%proc_domain_with_halo) then
      num_levs = iv%airsr(n)%info%levels

      if ( num_levs < 1 ) cycle

      model_t(:) = 0.0
      model_q(:) = 0.0
      ! model_h(:) = 0.0

      ! [1.1] Get horizontal interpolation weights:

      i = iv%airsr(n)%loc%i
      j = iv%airsr(n)%loc%j
      dx = iv%airsr(n)%loc%dx
      dy = iv%airsr(n)%loc%dy
      dxm = iv%airsr(n)%loc%dxm
      dym = iv%airsr(n)%loc%dym

      do k=xp%kts,xp%kte
        v_h(k) = dym*(dxm*xb%h(i,j  ,k) + dx*xb%h(i+1,j  ,k)) &
                + dy *(dxm*xb%h(i,j+1,k) + dx*xb%h(i+1,j+1,k))
        v_p(k) = dym*(dxm*xb%p(i,j  ,k) + dx*xb%p(i+1,j  ,k)) &
                + dy *(dxm*xb%p(i,j+1,k) + dx*xb%p(i+1,j+1,k))
      enddo

      do k=1, num_levs
        iv%airsr(n)%zk(k)=missing_r

        IF ( iv%airsr(n)%p(k) > 1.0 ) THEN
          call da_to_zk(iv%airsr(n)%p(k), v_p, xp, v_interp_p, iv%airsr(n)%zk(k))
        ELSE IF ( iv%airsr(n)%h(k) > 0.0 ) THEN
          call da_to_zk(iv%airsr(n)%h(k), v_h, xp, v_interp_h, iv%airsr(n)%zk(k))
        ENDIF

        if (iv%airsr(n)%zk(k) < 0.0) then
          iv%airsr(n)%t(k)%qc = missing
          iv%airsr(n)%q(k)%qc = missing
        endif
      enddo

      ! [1.2] Interpolate horizontally to ob:

#ifndef DEREF_KLUDGE
      call da_interp_lin_3d( xb%t, xp, i, j, dx, dy, dxm, dym, &
                           model_t, max_ob_levels, iv%airsr(n)%zk, num_levs )
      call da_interp_lin_3d( xb%q, xp, i, j, dx, dy, dxm, dym, &
                           model_q, max_ob_levels, iv%airsr(n)%zk, num_levs )

      ! call da_interp_lin_3d( xb%h, xp, i, j, dx, dy, dxm, dym, &
      !   model_h, max_ob_levels, iv%airsr(n)%zk, num_levs )
#else
      call da_interp_lin_3d( xb%t(xp%ims,xp%jms,xp%kms), xp, i, j, dx, dy, dxm, dym, &
                           model_t(1), max_ob_levels, iv%airsr(n)%zk(1), num_levs )
      call da_interp_lin_3d( xb%q(xp%ims,xp%jms,xp%kms), xp, i, j, dx, dy, dxm, dym, &
                           model_q(1), max_ob_levels, iv%airsr(n)%zk(1), num_levs )

#endif

      !------------------------------------------------------------------------
      ! [2.0] Initialise components of innovation vector:
      !------------------------------------------------------------------------

      do k = 1, iv%airsr(n)%info%levels
        iv%airsr(n)%t(k)%inv = 0.0
        iv%airsr(n)%q(k)%inv = 0.0

        !------------------------------------------------------------------------
        ! [3.0] Interpolation:
        !------------------------------------------------------------------------

        IF ( ob%airsr(n)%t(k) > missing_r .AND. &
             iv%airsr(n)%t(k)%qc >= obs_qc_pointer ) THEN
          iv%airsr(n)%t(k)%inv = ob%airsr(n)%t(k) - model_t(k)
        ENDIF

        IF ( ob%airsr(n)%q(k) > missing_r .AND. &
             iv%airsr(n)%q(k)%qc >= obs_qc_pointer ) THEN
          iv%airsr(n)%q(k)%inv = ob%airsr(n)%q(k) - model_q(k)
        ENDIF
      END DO

      !------------------------------------------------------------------------
      ! [5.0] Perform optional maximum error check:
      !------------------------------------------------------------------------

      IF ( check_max_iv ) &    
      CALL da_check_max_iv_airsr(it, iv % airsr(n),itt,ittf,itqv,itqvf)
    endif
  END DO

  write(unit = check_max_iv_unit, FMT ='(A,i5,A)')'For outer iteration ',it, &
    ', Total Rejections for airsr follows:'

  WRITE (UNIT = check_max_iv_unit, FMT = '(/,10(2(A,I6),/))') &
    'Number of failed temperature observations:',ittf, ' on ',itt,   &
    'Number of failed mixing ratio observations:',itqvf,' on ',itqv, &
    'Finally Total airsr rejections: ',ittf+itqvf,' on ',itt +itqv

end subroutine da_get_innov_vector_airsr
