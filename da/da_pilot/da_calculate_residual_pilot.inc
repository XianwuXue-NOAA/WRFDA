subroutine da_calculate_residual_pilot( oi, y, re,                        &
                                        np_missing, np_bad_data,          &
                                        np_obs_used, np_available )

  IMPLICIT NONE

  TYPE (ob_type), INTENT(IN)        :: oi     ! Innovation vector (O-B).
  TYPE (y_type) , INTENT(IN)        :: y      ! y = H (xa)
  TYPE (y_type) , INTENT(INOUT)     :: re     ! Residual structure.

  INTEGER       , INTENT(INOUT)     :: np_available, np_obs_used,          &
                                       np_missing  , np_bad_data

  TYPE (bad_data_type)              :: n_obs_bad
  INTEGER                           :: n, k

  IF ( oi%num_Pilot > 0 ) THEN
    n_obs_bad % u % num = number(0, 0, 0)
    n_obs_bad % v % num = number(0, 0, 0)

    DO n=1, oi%num_Pilot
      if( oi%pilot(n)%loc%proc_domain_with_halo ) then
        do k=1, oi%Pilot(n)%info%levels
          np_available = np_available + 2
          re%Pilot(n)%u(k) = da_residual( n, k, y%Pilot(n)%u(k), &
                                  oi%Pilot(n)%u(k), n_obs_bad % u )
          re%Pilot(n)%v(k) = da_residual( n, k, y%Pilot(n)%v(k), &
                                  oi%Pilot(n)%v(k), n_obs_bad % v )
        end do
      endif
    END DO

    np_missing = np_missing + n_obs_bad % u % num % miss + &
                  n_obs_bad % v % num % miss
    np_bad_data = np_bad_data + n_obs_bad % u % num % bad + &
                   n_obs_bad % v % num % bad 
    np_obs_used = np_obs_used + n_obs_bad % u % num % use + &
                   n_obs_bad % v % num % use
  ENDIF

end subroutine da_calculate_residual_pilot
