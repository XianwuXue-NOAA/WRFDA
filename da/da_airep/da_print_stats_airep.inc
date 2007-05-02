subroutine da_print_stats_airep(stats_unit, nu, nv, nt, Airep)

   !-----------------------------------------------------------------------
   ! Purpose: TBD
   !-----------------------------------------------------------------------

    implicit none

    integer,           intent(in)    :: stats_unit
    integer,           intent(inout) :: nu, nv, nt
    type (stats_airep_type), intent(in):: Airep

    write(unit=stats_unit, fmt='(4a/)') &
       '   var             ', &
       'u (m/s)     n    k    ', &
       'v (m/s)     n    k    ', &
       't (K)       n    k    '

    write(unit=stats_unit, fmt='(a,i16,3i22)') &
       '  Number: ', nu, nv, nt

    if (nu < 1) nu = 1
    if (nv < 1) nv = 1
    if (nt < 1) nt = 1

    write(unit=stats_unit, fmt='((a,3(f12.4,2i5)))') &
       ' Minimum(n,k): ', Airep%minimum%u, Airep%minimum%v, Airep%minimum%t, &
       ' Maximum(n,k): ', Airep%maximum%u, Airep%maximum%v, Airep%maximum%t
    write(unit=stats_unit, fmt='((a,3(f12.4,10x)))') &
       ' Average     : ', Airep%average%u/real(nu), &
                          Airep%average%v/real(nv), &
                          Airep%average%t/real(nt), &
       '    RMSE     : ', sqrt(Airep%rms_err%u/real(nu)), &
                         sqrt(Airep%rms_err%v/real(nv)), &
                         sqrt(Airep%rms_err%t/real(nt))

end subroutine da_print_stats_airep

