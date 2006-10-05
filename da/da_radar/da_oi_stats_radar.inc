subroutine da_oi_stats_radar ( stats_unit, oi )

   IMPLICIT NONE

   INTEGER,        INTENT (in)      :: stats_unit    ! Output unit for stats.
   TYPE (ob_type), INTENT (in)      :: oi            ! OI

   TYPE (stats_Radar_type)          :: Radar
   INTEGER                          :: nrv, nrf
   INTEGER                          :: n, k

   nrv = 0
   nrf = 0
      
   Radar%maximum%rv = maxmin_type( missing_r, 0, 0)
   Radar%minimum%rv = maxmin_type(-missing_r, 0, 0)
   Radar%maximum%rf = maxmin_type( missing_r, 0, 0)
   Radar%minimum%rf = maxmin_type(-missing_r, 0, 0)
   Radar%average = residual_Radar1_type(0.0, 0.0)
   Radar%rms_err = Radar%average

   IF (oi%num_Radar > 0 ) THEN
      DO n=1, oi%num_Radar
         if (oi%Radar(n)%loc%proc_domain ) then
            do k=1, oi%Radar(n)%info%levels
               IF ( USE_Radar_rv ) THEN
                  call da_stats_calculate( oi%Radar(n)%loc%obs_global_index, &
                                     k, oi%Radar(n)%rv(k)%qc, &
                                     oi%Radar(n)%rv(k)%inv, nrv, &
                                     Radar%minimum%rv, Radar%maximum%rv, &
                                     Radar%average%rv, Radar%rms_err%rv)
               ENDIF

               IF ( USE_Radar_rf ) THEN
                  call da_stats_calculate( oi%Radar(n)%loc%obs_global_index, &
                                     k, oi%Radar(n)%rf(k)%qc, &
                                     oi%Radar(n)%rf(k)%inv, nrf, &
                                     Radar%minimum%rf, Radar%maximum%rf, &
                                     Radar%average%rf, Radar%rms_err%rf)
               ENDIF
            end do
         end if
      END DO
   END IF

   ! Do inter-processor communication to gather statistics.

   IF (USE_Radar_rv) THEN
      call da_proc_sum_int( nrv )
      call da_proc_stats_combine(Radar%average%rv, Radar%rms_err%rv, &
                             Radar%minimum%rv%value, Radar%maximum%rv%value, &
                             Radar%minimum%rv%n, Radar%maximum%rv%n, &
                             Radar%minimum%rv%l, Radar%maximum%rv%l )
   ENDIF
   
   IF (USE_Radar_rf) THEN
      call da_proc_sum_int( nrf )
      call da_proc_stats_combine(Radar%average%rf, Radar%rms_err%rf, &
                             Radar%minimum%rf%value, Radar%maximum%rf%value, &
                             Radar%minimum%rf%n, Radar%maximum%rf%n, &
                             Radar%minimum%rf%l, Radar%maximum%rf%l )
   ENDIF

   IF (rootproc) THEN
      IF (nrv /= 0 .or. nrf /= 0) THEN
         write(unit=stats_unit, fmt='(/a/)') ' Diagnostics of OI for Radar'
         call da_print_stats_radar( stats_unit, nrv, nrf, Radar )
      END IF
   END IF

end subroutine da_oi_stats_radar