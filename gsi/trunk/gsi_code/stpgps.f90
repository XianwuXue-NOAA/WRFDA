module stpgpsmod

!$$$  subprogram documentation block
!                .      .    .                                       .
! subprogram:    stpgpsmod    module for stpref and its tangent linear stpref_tl
!
! abstract: module for stpref and its tangent linear stpref_tl
!
! program history log:
!   2005-05-19  Yanqiu zhu - wrap stpref and its tangent linear stpref_tl into one module
!   2005-11-16  Derber - remove interfaces
!

implicit none

PRIVATE
PUBLIC stpgps

contains

subroutine stpgps(rt,rq,rp,st,sq,sp,out,sges,drt,drq,drp,dst,dsq,dsp)
!$$$  subprogram documentation block
!                .      .    .                                       .
! subprogram: stpref    compute contribution to penalty and stepsize
!                       from ref, using nonlinear qc    
!   prgmmr: cucurull,l.     org: JCSDA/NCEP           date: 2004-05-06
!
! abstract:  This routine applies the (linear) operator for local 
!            refractivity and linear linear estimate for step size. 
!            This version includes nonlinear qc.
!
! program history log:
!   2004-05-06  cucurull 
!   2004-06-21  treadon - update documentation
!   2004-08-02  treadon - add only to module use, add intent in/out
!   2004=10-08  parrish - add nonlinear qc option
!   2004-11-30  cucurull- add increments for surface pressure and temperature at levels
!                         below observation. Install non-linear forward operator.
!   2005-01-26  cucurull- Implement local GPS RO operator
!   2005-03-23  cucurull- correct bouds for obs below the second level
!   2005-04-11  treadon - merge stpref and stpref_qc into single routine
!   2005-08-02  derber  - modify for variational qc parameters for each ob
!   2005-09-28  derber  - consolidate location and weight arrays
!   2005-12-02  cucurull - fix bug for dimensions of sp and rp
!   2007-07-28  derber  - modify to use new inner loop obs data structure
!                       - unify NL qc
!   2006-09-06  cucurull - generalize code to hybrid vertical coordinate and modify to use 
!                          surface pressure
!   2007-01-13  derber - clean up code and use coding standards
!   2007-02-15  rancic - add foto
!   2007-06-04  derber  - use quad precision to get reproducability over number of processors
!   2007-07-26  cucurull - input 3d pressure to update code to generalized vertical coordinate
!
!   input argument list:
!     rt    - search direction (gradxJ) for virtual temperature
!     rq    - search direction (gradxJ) for specific humidity
!     rp    - search direction (gradxJ) for (3D) pressure
!     st    - analysis increment (correction) for virtual temperature
!     sq    - analysis increment (correction) for specific humidity
!     sp    - analysis increment (correction) for (3D) pressure
!     sges  - stepsize estimates (4)
!     drt   - search direction for time derivative of virtual temperature
!     drq   - search direction for time derivative of specific humidity
!     drp   - search direction for time derivative of (3D) pressure
!     dst   - analysis increment for time derivative of virtual temperature
!     dsq   - analysis increment for time derivative of specific humidity
!     dsp   - analysis increment for time derivative of (3D) pressure
!                                         
!   output argument list:
!     out(1)- contribution to penalty from local gps refractivity - sges(1)
!     out(2)- contribution to penalty from local gps refractivity - sges(2)
!     out(3)- contribution to penalty from local gps refractivity - sges(3)
!     out(4)- contribution to penalty from local gps refractivity - sges(4)
!     out(5)- pen(sges1)-pen(sges2)
!     out(6)- pen(sges3)-pen(sges2)
!
! attributes:
!   language: f90
!   machine:  ibm RS/6000 SP
!
!$$$
  use kinds, only: r_kind,i_kind,r_quad
  use obsmod, only: gpshead,gpsptr
  use qcmod, only: nlnqc_iter
  use constants, only: zero,one,two,n_a,n_b,half,tiny_r_kind,cg_term
  use gridmod, only: latlon1n,latlon11,nsig
  implicit none

! Declare local parameters
  real(r_kind),parameter:: ten = 10.0_r_kind

! Declare passed variables
  real(r_quad),dimension(6),intent(out):: out
  real(r_kind),dimension(latlon1n),intent(in):: rt,rq,st,sq,drt,drq,dst,dsq
  real(r_kind),dimension(latlon1n+latlon11),intent(in):: rp,sp,drp,dsp
  real(r_kind),dimension(4),intent(in):: sges

! Declare local variables
  integer(i_kind) i,j,k
  integer(i_kind),dimension(nsig):: i1,i2,i3,i4
  real(r_kind) :: val,val2
  real(r_kind) :: w1,w2,w3,w4
  real(r_kind) :: q_TL,p_TL,t_TL,time_gps
  real(r_kind) :: rq_TL,rp_TL,rt_TL

  real(r_kind) cg_gps,pen1,pen2,pen3,pencur,nref1,nref2,nref3,wgross,wnotgross
  real(r_kind) alpha,ccoef,bcoef1,bcoef2,cc,nref0

! Initialize penalty, b1, and b3 to zero
  out=0._r_quad
  alpha=one/(sges(3)-sges(2))
  ccoef=half*alpha*alpha
  bcoef1=half*half*alpha
  bcoef2=sges(3)*ccoef

! Loop over observations
  gpsptr => gpshead
  do while (associated(gpsptr))

    if(gpsptr%luse)then

      do j=1,nsig
        i1(j)= gpsptr%ij(1,j)
        i2(j)= gpsptr%ij(2,j)
        i3(j)= gpsptr%ij(3,j)
        i4(j)= gpsptr%ij(4,j)
      enddo
      w1=gpsptr%wij(1)
      w2=gpsptr%wij(2)
      w3=gpsptr%wij(3)
      w4=gpsptr%wij(4)
      time_gps=gpsptr%time
      val=zero
      val2=-gpsptr%res


      do j=1,nsig
        t_TL =w1* st(i1(j))+w2* st(i2(j))+w3* st(i3(j))+w4* st(i4(j))+ &
             (w1*dst(i1(j))+w2*dst(i2(j))+w3*dst(i3(j))+w4*dst(i4(j)))*time_gps
        rt_TL=w1* rt(i1(j))+w2* rt(i2(j))+w3* rt(i3(j))+w4* rt(i4(j))+ &
             (w1*drt(i1(j))+w2*drt(i2(j))+w3*drt(i3(j))+w4*drt(i4(j)))*time_gps
        q_TL =w1* sq(i1(j))+w2* sq(i2(j))+w3* sq(i3(j))+w4* sq(i4(j))+ &
             (w1*dsq(i1(j))+w2*dsq(i2(j))+w3*dsq(i3(j))+w4*dsq(i4(j)))*time_gps
        rq_TL=w1* rq(i1(j))+w2* rq(i2(j))+w3* rq(i3(j))+w4* rq(i4(j))+ &
             (w1*drq(i1(j))+w2*drq(i2(j))+w3*drq(i3(j))+w4*drq(i4(j)))*time_gps
        p_TL =w1* sp(i1(j))+w2* sp(i2(j))+w3* sp(i3(j))+w4* sp(i4(j))+ &
             (w1*dsp(i1(j))+w2*dsp(i2(j))+w3*dsp(i3(j))+w4*dsp(i4(j)))*time_gps
        rp_TL=w1* rp(i1(j))+w2* rp(i2(j))+w3* rp(i3(j))+w4* rp(i4(j))+ &
             (w1*drp(i1(j))+w2*drp(i2(j))+w3*drp(i3(j))+w4*drp(i4(j)))*time_gps
        val2 = val2 + t_tl*gpsptr%jac_t(j)+ q_tl*gpsptr%jac_q(j)+p_tl*gpsptr%jac_p(j) 
        val  = val + rt_tl*gpsptr%jac_t(j)+rq_tl*gpsptr%jac_q(j)+rp_tl*gpsptr%jac_p(j)

      enddo


!     penalty and gradient

      nref0=val2+sges(1)*val
      nref1=val2+sges(2)*val
      nref2=val2+sges(3)*val
      nref3=val2+sges(4)*val

      pencur = nref0*nref0*gpsptr%err2
      pen1   = nref1*nref1*gpsptr%err2
      pen2   = nref2*nref2*gpsptr%err2
      pen3   = nref3*nref3*gpsptr%err2

!      Modify penalty term if nonlinear QC
      if (nlnqc_iter .and. gpsptr%pg > tiny_r_kind .and. gpsptr%b > tiny_r_kind) then
         cg_gps=cg_term/gpsptr%b
         wnotgross= one-gpsptr%pg
         wgross = gpsptr%pg*cg_gps/wnotgross
         pencur = -two*log((exp(-half*pencur) + wgross)/(one+wgross))
         pen1   = -two*log((exp(-half*pen1  ) + wgross)/(one+wgross))
         pen2   = -two*log((exp(-half*pen2  ) + wgross)/(one+wgross))
         pen3   = -two*log((exp(-half*pen3  ) + wgross)/(one+wgross))
      endif
  
!     Cost function, b1, and b3
      cc  = (pen1+pen3-two*pen2)*gpsptr%raterr2
      out(1) = out(1)+pencur*gpsptr%raterr2
      out(2) = out(2)+pen1  *gpsptr%raterr2
      out(3) = out(3)+pen2  *gpsptr%raterr2
      out(4) = out(4)+pen3  *gpsptr%raterr2
      out(5) = out(5)+(pen1-pen3)*gpsptr%raterr2*bcoef1+cc*bcoef2
      out(6) = out(6)+cc*ccoef

    endif
  
  gpsptr => gpsptr%llpoint

  end do

 return
end subroutine stpgps


end module stpgpsmod
