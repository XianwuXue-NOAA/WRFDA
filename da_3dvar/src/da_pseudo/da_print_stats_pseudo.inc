SUBROUTINE da_print_stats_pseudo( stats_unit, nu, nv, nt, np, nq, pseudo )

   implicit none

   INTEGER,           intent(in)    :: stats_unit
   INTEGER,           intent(inout) :: nu, nv, nt, np, nq
   TYPE (stats_pseudo_type), intent(in):: pseudo

   write(unit=stats_unit, fmt='(6a/)') &
        '   var             ', &
        'u (m/s)     n    k    ', &
        'v (m/s)     n    k    ', &
        't (K)       n    k    ', &
        'p (Pa)      n    k    ', &
        'q (kg/kg)   n    k'

   write(unit=stats_unit, fmt='(a,i16,4i22)') &
        '  Number: ', nu, nv, nt, np, nq

   if(nu < 1) nu = 1
   if(nv < 1) nv = 1
   if(nt < 1) nt = 1
   if(np < 1) np = 1
   if(nq < 1) nq = 1
   
   write(unit=stats_unit, fmt='((a,4(f12.4,2i5),e12.4,2i5))') &
        ' Minimum(n,k): ', pseudo%minimum%u, pseudo%minimum%v, pseudo%minimum%t, &
                      pseudo%minimum%p, pseudo%minimum%q, &
        ' Maximum(n,k): ', pseudo%maximum%u, pseudo%maximum%v, pseudo%maximum%t, &
                      pseudo%maximum%p, pseudo%maximum%q
   write(unit=stats_unit, fmt='((a,4(f12.4,10x),e12.4,10x))') &
        ' Average     : ', pseudo%average%u/real(nu), pseudo%average%v/real(nv), &
                      pseudo%average%t/real(nt), pseudo%average%p/real(np), &
                      pseudo%average%q/real(nq), &
        '    RMSE     : ', sqrt(pseudo%rms_err%u/real(nu)), &
                      sqrt(pseudo%rms_err%v/real(nv)), &
                      sqrt(pseudo%rms_err%t/real(nt)), &
                      sqrt(pseudo%rms_err%p/real(np)), &
                      sqrt(pseudo%rms_err%q/real(nq))

END SUBROUTINE da_print_stats_pseudo