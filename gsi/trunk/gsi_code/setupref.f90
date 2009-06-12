subroutine setupref(lunin,mype,awork,nele,nobs,super_gps,toss_gps)
!$$$  subprogram documentation block
!                .      .    .                                       .
! subprogram:    setupref    compute rhs of oi for gps refractivity
!   prgmmr: cucurull, l.    org: JCSDA/NCEP           date: 2004-03-24
!
! abstract:  For gps refractivity observations, this routine
!              a) reads obs assigned to given mpi task (geographic region),
!              b) simulates obs from guess,
!              c) apply some quality control to obs,
!              d) load weight and innovation arrays used in minimization
!              e) collects statistics for runtime diagnostic output
!              f) writes additional diagnostic information to output file
!
! program history log:
!   2004-03-24  cucurull
!   2004-06-17  treadon - update documentation
!   2004-08-02  treadon - add only to module use, add intent in/out
!   2004-10-06  parrish - increase size of refwork array for nonlinear qc
!   2004-11-22  derber - remove weight, add logical for boundary point
!   2004-11-29  cucurull- install non-linear forward operator
!   2004-12-22  treadon - move logical conv_diagsave from obsmod to argument list
!   2005-01-26  cucurull- save innovation vector for linear RO code
!   2005-03-09  parrish - nonlinear qc change to account for inflated obs error
!   2005-03-16  treadon - place upper bound on k1
!   2005-03-23  cucurull- correct bouds for obs below the second level;
!                         compute minimizations coeffs for 'acceptable' obs only;
!                         compute diagnostic file 
!   2005-05-27  derber - level output change
!   2005-07-27  derber  - add print of monitoring and reject data
!   2005-07-27  derber  - rewrite and combine with prepref and sprref
!   2005-10-14  derber  - input grid location and fix regional lat/lon
!   2005-11-29  derber - remove psfcg and use ges_lnps instead
!   2005-12-01  cucurull - change some indexes on input data; initialize some
!                          arrays; fix bug on counting obs below/above model
!   2005-12-21  treadon - add super_gps, move some diagnostics statistics
!                         to genstat_gps
!   2006-01-04  treadon - correct inconsistency when using qcfail
!   2006-02-02  treadon - rename lnprsl as ges_lnprsl
!   2006-02-24  derber  - modify to take advantage of convinfo module
!   2006-02-24  cucurull - update QC parameters and compute preliminary representativeness
!                          error, fix bug when countin obs that fail gross check
!   2006-04-14  middlecoff - changed IF test to avoid out-of-bounds-reference on DATA
!   2006-07-28  derber  - modify to use new inner loop obs data structure
!                       - unify NL qc
!   2006-07-31  kleist - use ges_ps instead of lnps
!   2006-09-20  cucurull - use geopotential heights at intermediate levels instead of mid
!                          layers,remove dlnp, new QC checks,
!                          penalize high elevation obs, remove termt1, modify the adjoint terms
!                          to generalize the GPS code to hybrid vertical coordinate,
!                          remove obs above 30km, remove psges, remove zsges
!   2006-10-20 cucurull - update QC statistical checks and representativeness error with the use of 
!                         COSMIC data
!                       - add information to diagnostic file
!   2007-03-01 derber - add toss_gps; simplify profile qc loop
!   2007-04-13 treadon - tighten data cutoff in tropics
!   2007-06-22 cucurull - generalize qc structure to enable regional GSI;
!                         reduce gpswork2; remove conv_diagsave from argument list; 
!                         consistent data counts for qc checks; 
!                         update diagnostic information to be consistent with other obs;
!                         modify diagnostic structure 
!  2007-07-26  cucurull - update code to generalized vertical coordinate (3d pressure)
!
!   input argument list:
!     lunin    - unit from which to read observations
!     mype     - mpi task id
!     nele     - number of data elements per observation
!     nobs     - number of observations
!
!   output argument list:
!     awork    - array containing information for data counts and gross checks
!
! attributes:
!   language: f90
!   machine:  ibm RS/6000 SP
!
!$$$
  use kinds, only: r_kind,i_kind,r_single,r_double
  use obsmod, only: nprof_gps,gpshead,gpstail,gps_allhead,gps_alltail
  use guess_grids, only: ges_lnprsi,hrdifsig,geop_hgti,geop_hgtl,nfldsig,&
       ntguessig,ges_z,ges_tv,ges_q
  use gridmod, only: lat2,lon2,nsig,bk5
  use gridmod, only: get_ijk,latlon11,get_ij
  use constants, only: fv,n_a,n_b,deg2rad,tiny_r_kind,huge_single
  use constants, only: zero,one,two,eccentricity,semi_major_axis,&
       grav_equator,somigliana,flattening,grav_ratio,grav,rd,eps,&
       three,four,five,one_tenth,half,r3600
  use qcmod, only: repe_gps
  use jfunc, only: jiter,last
  use jfunc, only: l_foto
  use convinfo, only: nconvtype,cermin,cermax,cgross,cvar_b,cvar_pg,ictype,icsubtype
  implicit none

! Declare local parameters
  real(r_kind),parameter:: r0_01 = 0.01_r_kind
  real(r_kind),parameter:: r0_1 = 0.1_r_kind
  real(r_kind),parameter:: r0_2 = 0.2_r_kind
  real(r_kind),parameter:: r0_25 = 0.25_r_kind
  real(r_kind),parameter:: r0_3 = 0.3_r_kind
  real(r_kind),parameter:: r0_4 = 0.4_r_kind
  real(r_kind),parameter:: r0_7 = 0.7_r_kind
  real(r_kind),parameter:: r2_5 = 2.5_r_kind
  real(r_kind),parameter:: r3_5 = 3.5_r_kind
  real(r_kind),parameter:: ten = 10.0_r_kind
  real(r_kind),parameter:: r25 = 25.0_r_kind
  real(r_kind),parameter:: r30 = 30.0_r_kind
  real(r_kind),parameter:: r1em3 = 1.0e-3_r_kind
  real(r_kind),parameter:: r1e2 = 1.0e+2_r_kind
  real(r_kind),parameter:: six = 6.0_r_kind
  real(r_kind),parameter:: seven = 7.0_r_kind
  real(r_kind),parameter:: eight = 8.0_r_kind

! Declare passed variables
  integer(i_kind),intent(in):: lunin,mype,nele,nobs
  real(r_kind),dimension(100+7*nsig),intent(inout):: awork
  real(r_kind),dimension(nsig,max(1,nprof_gps)),intent(inout):: super_gps
  real(r_kind),dimension(max(1,nprof_gps)),intent(inout):: toss_gps

! Declare local variables

  real(r_kind) rsig,dtime,dlat,dlon,tmean,mult_p
  real(r_kind) errinv_input,errinv_adjst,errinv_final,err_final
  real(r_kind) dlnp,hgeso,trefges,pobl
  real(r_kind) sin2,termg,termr,termrg,hob,hobl,qrefges
  real(r_kind) fact,pw,nrefges1,nrefges2,nrefges,dpres,elev
  real(r_kind) ratio,residual,obserror,obserrlm,delz
  real(r_kind),dimension(nobs):: termq,termpk,termt,termtk
  real(r_kind),dimension(nobs):: pressure,error,error_adjst
  real(r_kind),dimension(3,nobs):: gps2work
  real(r_kind),dimension(nele,nobs):: data
  real(r_kind),dimension(nobs):: ratio_errors,cutoff
  real(r_kind),dimension(nsig):: tges,hges,hgesl
  real(r_kind),dimension(nsig+1) :: prsltmp
  real(r_kind),dimension(nsig,nobs):: termtl,termpl1,termpl2
  real(r_kind),dimension(lat2,lon2,nsig,nfldsig)::geop_height,geop_heightl
  real(r_kind),allocatable,dimension(:,:)::rdiagbuf
  real(r_single),dimension(nobs):: qcfail_loc,qcfail_high,qcfail_gross
  real(r_single),dimension(nobs):: qcfail_stats_1,qcfail_stats_2
  
  integer(i_kind):: ier,ilon,ilat,ihgt,igps,itime,ikx,iuse,ikxx
  integer(i_kind):: iprof,ipctc,iroc,isatid,iptid
  integer(i_kind):: ilate,ilone,mm1
  integer(i_kind) i,j,k,k1,k2,n,it,nreal,jj,ip1
  integer(i_kind) kprof,istat,jprof
  integer(i_kind),dimension(8):: jgrd
  integer(i_kind),dimension(4):: gps_ij
  integer(i_kind):: satellite_id,transmitter_id

  character(8),allocatable,dimension(:):: cdiagbuf

  logical,dimension(nobs):: luse,muse
  logical,dimension(nobs):: qcfail

!*******************************************************************************

! Read and reformat observations in work arrays.
  read(lunin)data,luse


! Set indices for quantities in data array
  ier=1        ! index of obs error in data array (now 1/(original obs error))
  ilon=2       ! index of grid relative obs location (x)
  ilat=3       ! index of grid relative obs location (y)
  ihgt=4       ! index of obs vertical coordinate in data array
  igps=5       ! index of gps data (or residual) in data array
  itime=6      ! index of obs time in data array
  ikxx=7       ! index of observation type
  iprof=8      ! index of profile
  ipctc=9      ! index of percent confidence
  iroc=10      ! index of local radius of curvature
  isatid=11    ! index of satellite identifier
  iptid=12     ! index of platform transmitter id number
  iuse=13      ! index of use parameter
  ilone=14     ! index of earth relative longitude (degrees)
  ilate=15     ! index of earth relative latitude (degrees)

! Initialize variables
  rsig=float(nsig)
  mm1=mype+1
  qcfail=.false.
  qcfail_loc=zero;qcfail_gross=zero;qcfail_stats_1=zero
  qcfail_stats_2=zero
  qcfail_high=zero 
  toss_gps=zero

! Convert model geopotential heights to msl units - only nsig levels
  do jj=1,nfldsig
     do j=1,lon2
        do i=1,lat2
           do k=1,nsig
              geop_height(i,j,k,jj) = geop_hgti(i,j,k,jj)
              if (ges_z(i,j,jj)>zero) geop_height(i,j,k,jj) = &
                   geop_height(i,j,k,jj) + ges_z(i,j,jj)
              geop_heightl(i,j,k,jj) = geop_hgtl(i,j,k,jj)
              if (ges_z(i,j,jj)>zero) geop_heightl(i,j,k,jj) = &
                   geop_heightl(i,j,k,jj) + ges_z(i,j,jj)
           end do
        end do
     end do
  end do
  
! Allocate arrays for output to diagnostic file
  nreal=19
  allocate(cdiagbuf(nobs),rdiagbuf(nreal,nobs))

! Initialize arrays
  termtl=zero; termt= zero; termtk=zero; termq=zero
  termpk=zero; termpl1=zero; termpl2=zero

! Save height,lat, and lon of the observations for later
  do i=1,nobs
     gps2work(1,i)=r1em3*data(ihgt,i)   !height in km
     gps2work(2,i)=data(ilate,i)        !lat in degree
     muse(i)=nint(data(iuse,i)) <= jiter
     sin2  = sin(data(ilate,i)*deg2rad)**2
     dlon=data(ilon,i)
     dlat=data(ilat,i)
     dpres=data(ihgt,i)
     elev=dpres
     dtime=data(itime,i)
     ikx=nint(data(ikxx,i))

!    Interpolate log(pres), temp profile and geop heights to obs location
     call tintrp2a(ges_lnprsi,prsltmp,dlat,dlon,dtime,hrdifsig,&
          1,nsig+1,mype,nfldsig)
     call tintrp2a(ges_tv,tges,dlat,dlon,dtime,hrdifsig,&
          1,nsig,mype,nfldsig)
     call tintrp2a(geop_height,hges,dlat,dlon,dtime,hrdifsig,&
          1,nsig,mype,nfldsig)
     call tintrp2a(geop_heightl,hgesl,dlat,dlon,dtime,hrdifsig,&
          1,nsig,mype,nfldsig)

!    Convert geometric height at observation to geopotential height using
!    equations (17, 20, 23) in MJ Mahoney's note "A discussion of various
!    measures of altitude" (2001).  Available on the web at
!    http://mtp.jpl.nasa.gov/notes/altitude/altitude.html
!
!    termg  = equation 17
!    termr  = equation 21
!    termrg = first term in the denominator of equation 23

     termg = grav_equator * &
          ( (one+somigliana*sin2)/sqrt(one-eccentricity*eccentricity*sin2) )
     termr = semi_major_axis / (one + flattening + grav_ratio - two*flattening*sin2)
     termrg = (termg/grav)*termr

!    Geopotential height of the observation
     hgeso=(termg/grav)*((termr*dpres)/(termr+dpres))

!    Convert observation height (in dpres) from meters to grid relative units
     hob=hgeso
     hobl=hgeso
     call grdcrd(hob,1,hges,nsig,1)   ! interface levels
     call grdcrd(hobl,1,hgesl,nsig,1) ! midpoint layers
     dpres=hob 
     data(ihgt,i)=dpres

!    Get temperature at observation location
     call tintrp3(ges_tv,trefges,dlat,dlon,hobl,&
          dtime,hrdifsig,1,mype,nfldsig)

!    Set indices of model levels below (k1) and above (k2) observation.
     k=dpres
     k1=min(max(1,k),nsig)
     k2=max(1,min(k+1,nsig))

!    Get observation pressure from hypsometric equation
     if(k1==1) then
      pobl=two*grav*(hgeso-hges(k1))/(rd*(trefges+tges(k1)))
     else
      tmean=(tges(k1)+tges(k1-1))/two ! temperature at interface level k1
      pobl=two*grav*(hgeso-hges(k1))/(rd*(trefges+tmean))
     endif
     pobl=prsltmp(k1)-pobl

!    Get finite pressure when obs is above the top model or below first level
     if(k1 == k2) pobl= prsltmp(k1)
     pressure(i)=ten*exp(pobl) !in hPa

!    Tune observation error to account for representativeness error.
!    Preliminary values

     repe_gps=one
     if(gps2work(1,i) > r30)then
!     repe_gps=0.5_r_kind
     else
       if(gps2work(1,i) < eight)then
         repe_gps=1.5_r_kind
       else
          repe_gps=0.5_r_kind
       end if
     end if

     if (gps2work(1,i) >= 25_r_kind) then
          repe_gps = (0.6_r_kind*gps2work(1,i)-14_r_kind)*repe_gps
     endif

     ratio_errors(i) = data(ier,i)/abs(data(ier,i)*repe_gps)
     error(i)=one/data(ier,i) ! one/original error
     data(ier,i)=one/data(ier,i)
     error_adjst(i)= ratio_errors(i)* data(ier,i) !one/adjusted error

!    Remove observation if below surface or at/above the top layer 
!    of the model by setting observation (1/error) to zero.
!    Make no adjustment if observation falls within vertical
!    domain.

     if (dpres < one .or. dpres > rsig) then
        data(ier,i) = zero
        ratio_errors(i) = zero
        muse(i)=.false.
        qcfail_loc(i)=one
     endif

!    Increment obs counter along with low and high obs counters
     if(luse(i))then
        awork(1)=awork(1)+one
        if(dpres <  one) awork(2)=awork(2)+one
        if(dpres > rsig) awork(3)=awork(3)+one
     endif

!    Save some diagnostic information

!    occultation identification
     satellite_id         = data(isatid,i) ! receiver occ id 
     transmitter_id       = data(iptid,i)  ! transmitter occ id 
     write(cdiagbuf(i),'(2(i4))') satellite_id,transmitter_id

     rdiagbuf(:,i)         = zero

     rdiagbuf(1,i)         = ictype(ikx)    ! observation type
!    rdiagbuf(2,i)         = icsubtype(ikx) ! observation subtype (not defined yet)
     rdiagbuf(2,i)         = zero           ! uses gps_ref (one=use of bending angle)
     rdiagbuf(3,i)         = data(ilate,i)  ! lat in degrees
     rdiagbuf(4,i)         = data(ilone,i)  ! lon in degrees
     rdiagbuf(6,i)         = pressure(i)    ! guess observation pressure (hPa)
     rdiagbuf(7,i)         = elev           ! height in meters
     rdiagbuf(8,i)         = dtime          ! obs time (hours relative to analysis time)
     rdiagbuf(9,i)         = data(ipctc,i)  ! input bufr qc - index of per cent confidence    
     rdiagbuf(11,i)        = data(iuse,i)   ! data usage flag
 
     if (ratio_errors(i) > tiny_r_kind) then  ! obs inside vertical grid

!      Compute guess local refractivity at obs location.
!      Also compute terms needed in minimization

       call tintrp3(ges_q,qrefges,dlat,dlon,hobl,dtime,&
             hrdifsig,1,mype,nfldsig)

!      Compute guess local refractivity
       fact=(one+fv*qrefges)
       pw=eps+qrefges*(one-eps)
       nrefges1=n_a*(pressure(i)/trefges)*fact
       nrefges2=n_b*qrefges*pressure(i)*fact**2/(trefges**2*pw)
       nrefges=nrefges1+nrefges2

!      Accumulate diagnostic information        
       gps2work(3,i)=(data(igps,i)-nrefges)/((data(igps,i)+nrefges)/two)
       rdiagbuf(5,i)    = gps2work(3,i) ! incremental refractivity (x100 %)
       rdiagbuf (17,i)  = data(igps,i)  ! refractivity observation (units of N)
       rdiagbuf (18,i)  = data(igps,i)-nrefges ! obs-ges used in analysis (units of N) 
       rdiagbuf (19,i)  = data(igps,i)-nrefges ! obs-ges w/o bias correction (future slot)  
     
       data(igps,i)=data(igps,i)-nrefges  ! innovation vector

!      Gross error check 
       obserror = one/max(ratio_errors(i)*data(ier,i),tiny_r_kind)
       obserrlm = max(cermin(ikx),min(cermax(ikx),obserror))
       residual = abs(data(igps,i))
       ratio    = residual/obserrlm
       if (ratio > cgross(ikx)) then
           if (luse(i)) then
              awork(4) = awork(4)+one
           endif
           qcfail_gross(i)=one
           data(ier,i) = zero
           ratio_errors(i) = zero
           muse(i)=.false.
       else 
!          Statistics QC check if obs passed gross error check 
!          QC checks based on latitude and height
           if(gps2work(2,i) < -r30) then                !SH
              if(gps2work(1,i) >= r30)then
                 cutoff(i)=r0_2*gps2work(1,i)-five
              else
                if(gps2work(1,i) > r25)then
                   cutoff(i)=one
                else
                  if(gps2work(1,i) <= eight)then
                    cutoff(i)=-r0_2*gps2work(1,i)+two
                  else
                    cutoff(i)=half
                  end if
                endif
              end if
           else if(gps2work(2,i) > r30) then            !NH
              if(gps2work(1,i) >= r30)then
                 cutoff(i)=r0_1*gps2work(1,i)-two
              else
                if(gps2work(1,i) > r25)then
                   cutoff(i)=one
                else
                  if(gps2work(1,i) <= eight)then
                    cutoff(i)=-r0_25*gps2work(1,i)+r2_5
                  else
                    cutoff(i)=half
                  end if
                endif
              end if
           else                                         !TR
              if(gps2work(1,i) >= r30)then
                 cutoff(i)=r0_1*gps2work(1,i)-two
              else
                if(gps2work(1,i) > r25)then
                   cutoff(i)=one
                else
                  if(gps2work(1,i) <= ten)then
                    cutoff(i)=-r0_3*gps2work(1,i)+r3_5
                  else
                    cutoff(i)=r0_7
                  end if
                endif
              end if
           end if

           if(gps2work(1,i) >= r30)then
              cutoff(i)=two*cutoff(i)*r0_01
           else
             if(gps2work(1,i) > r25)then
                cutoff(i)=three*cutoff(i)*r0_01
             else
               if(gps2work(1,i) <= eight)then
                  cutoff(i)=three*cutoff(i)*r0_01
               else
                  cutoff(i)=four*cutoff(i)*r0_01
               end if
             end if
           end if

!          Tighten qc limits in tropics
           if (abs(gps2work(2,i)) <= r30) then
              cutoff(i)=r0_4*cutoff(i)
           endif
      
           if(abs(gps2work(3,i))> cutoff(i)) then
              qcfail(i)=.true.
              qcfail_stats_1(i)=one
           end if
       end if ! gross qc check 

!      Remove obs above 30 km in order to avoid increments at top model
       if(gps2work(1,i) > r30) then
          data(ier,i) = zero
          ratio_errors(i) = zero
          qcfail_high(i)=one 
          muse(i)=.false.
       endif

!      If obs is "acceptable", compute coefficients for adjoint
       if ((data(ier,i)*ratio_errors(i)) > tiny_r_kind) then

       if(k1==1) then
         tmean=tges(k1)
       else
         tmean=(tges(k1)+tges(k1-1))/two
       endif

       mult_p=pressure(i)*((n_a/trefges)*fact+&
              (n_b/(trefges**2*pw))*qrefges*fact**2)

!      term for q_TL
       termq(i)   = n_a*(pressure(i)/trefges)*fv+&
            (n_b/(trefges**2*pw))*pressure(i)*fact**2+&
            (n_b/(trefges**2*pw))*pressure(i)*qrefges*two*fv*fact-&
            (n_b/(trefges**2*pw**2))*pressure(i)*qrefges*fact**2*(one-eps)

!      term for pk_TL
       termpk(i) = mult_p/exp(prsltmp(k1))

!      term for pl_TL(j) and pl_TL(j-1)
       if (k1 >= 2) then
         do j=2,k1
            termpl1(j,i) = mult_p*two*tges(j-1)/&
                          ((trefges+tmean)*exp(prsltmp(j-1)))
            termpl2(j,i) = mult_p*two*tges(j-1)/&
                          ((trefges+tmean)*exp(prsltmp(j)))
         end do
       endif

!      term for t_TL
       termt(i) = mult_p*(prsltmp(k1)-pobl)/(trefges+tmean)-&
           n_a*fact*(pressure(i)/trefges**2)-n_b*qrefges*fact**2*two*&
           (pressure(i)/(trefges**3*pw))

!      term for tk_TL and tk-1_TL
       termtk(i) =mult_p*(prsltmp(k1)-pobl)/(two*(trefges+tmean))

!      term for tl_TL(j-1)
       if (k1 >= 2) then
          do j=2,k1
             termtl(j,i)= mult_p*&
                 two*((prsltmp(j-1)-prsltmp(j))/(trefges+tmean))
          end do
       endif
    endif

     end if ! obs inside the vertical grid
  end do ! end of loop over observations

! Loop over observation profiles. Compute penalty
! terms, and accumulate statistics.
  do i=1,nobs
     kprof = data(iprof,i)
     
     if(qcfail(i)) then
        do j=1,nobs
           jprof = data(iprof,j)
           if( kprof == jprof .and. .not. qcfail(j))then
           
!          Remove data below
             if(gps2work(1,j) < gps2work(1,i))then
               if(gps2work(1,i) < r30) then
                 qcfail(j) = .true. 
                 qcfail_stats_2(j)=one
               else
                 if(abs(gps2work(3,i))> two*cutoff(i)) then
                   qcfail(j) = .true. 
                   qcfail_stats_2(j)=one
                 endif
               endif
             endif
           end if
        end do
     endif
  end do

  do i=1,nobs
     kprof = data(iprof,i)
     
     if(qcfail(i)) then
        data(ier,i) = zero
        ratio_errors(i) = zero
        muse(i) = .false.
        if(gps2work(1,i) < r30) then
           toss_gps(kprof) = max(toss_gps(kprof),data(ihgt,i))
        else
          if(abs(gps2work(3,i))> two*cutoff(i)) then
             toss_gps(kprof) = max(toss_gps(kprof),data(ihgt,i))
          endif
        endif

!    Counting obs tossed due to the stats qc check 
!    This calculation will be updated in genstats_gps due to toss_gps

        if (luse(i)) then
            if(gps2work(2,i)> r30) then
               awork(22) = awork(22)+one                !NH
            else if(gps2work(2,i)< -r30)then
               awork(23) = awork(23)+one                !SH
            else
               awork(24) = awork(24)+one                !TR
            end if
        end if
     else
!    Save superobs factors.    Also save maximum k index of qcfail
        if(ratio_errors(i)*data(ier,i)>tiny_r_kind .and. luse(i)) then
           j=data(ihgt,i)
           super_gps(j,kprof)=super_gps(j,kprof)+one
        endif
     endif
  end do


! Loop to load arrays used in statistics output
  do i=1,nobs
     if (ratio_errors(i)*data(ier,i) <= tiny_r_kind) muse(i) = .false.
     ikx=nint(data(ikxx,i))

     ! flags for observations that failed qc checks
     ! zero = observation is good

     if(qcfail_loc(i) == one) rdiagbuf(10,i) = one
     if(qcfail_high(i) == one) rdiagbuf(10,i) = two

     if(qcfail_gross(i) == one) then
         if(qcfail_high(i) == one) then
            rdiagbuf(10,i) = four
         else
            rdiagbuf(10,i) = three
         endif
     else if(qcfail_stats_1(i) == one) then
        if(qcfail_high(i) == one) then
            rdiagbuf(10,i) = six
         else
            rdiagbuf(10,i) = five
         endif
     else if(qcfail_stats_2(i) == one) then
        if(qcfail_high(i) == one) then
            rdiagbuf(10,i) = eight
         else
            rdiagbuf(10,i) = seven
         endif
     end if

     if(muse(i)) then            ! modified in genstats_gps due to toss_gps
        rdiagbuf(12,i) = one     ! minimization usage flag (1=use, -1=not used)
     else
        rdiagbuf(12,i) = -one
     endif

     if (ratio_errors(i)*data(ier,i)>tiny_r_kind) then
        err_final = ratio_errors(i)*data(ier,i)
     else
        err_final = huge_single
     endif

     errinv_input  = huge_single
     errinv_adjst  = huge_single
     errinv_final  = huge_single

     if (error(i)>tiny_r_kind) errinv_input=error(i)
     if (error_adjst(i)>tiny_r_kind) errinv_adjst=error_adjst(i)
     if (err_final>tiny_r_kind) errinv_final=err_final

     rdiagbuf(13,i) = zero !nonlinear qc relative weight - will be defined in genstats_gps
     rdiagbuf(14,i) = errinv_input ! original inverse gps obs error (N**-1)
     rdiagbuf(15,i) = errinv_adjst ! original + represent error inverse gps 
                                   ! obs error (N**-1)
     rdiagbuf(16,i) = errinv_final ! final inverse observation error due to 
                                   ! superob factor (N**-1)
                                   ! modified in genstats_gps


!    Save values needed for generation of statistics for all observations
     if(.not. associated(gps_allhead))then
         allocate(gps_allhead,stat=istat)
         if(istat /= 0)write(6,*)' failure to write gps_allhead '
         gps_alltail => gps_allhead
     else
         allocate(gps_alltail%llpoint,stat=istat)
         gps_alltail => gps_alltail%llpoint
         if(istat /= 0)write(6,*)' failure to write gps_alltail%llpoint '
     end if
     allocate(gps_alltail%rdiag(nreal),stat=istat)
     if (istat/=0) write(6,*)'SETUPREF:  allocate error for gps_point, istat=',istat

     gps_alltail%ratio_err= ratio_errors(i)
     gps_alltail%obserr   = data(ier,i)
     gps_alltail%dataerr  = data(ier,i)*data(igps,i)
     gps_alltail%pg       = cvar_pg(ikx)
     gps_alltail%b        = cvar_b(ikx)
     gps_alltail%loc      = data(ihgt,i)
     gps_alltail%kprof    = data(iprof,i)
     gps_alltail%type     = data(ikxx,i)
     gps_alltail%luse     = luse(i) ! logical
     gps_alltail%muse     = muse(i) ! logical
     gps_alltail%cdiag    = cdiagbuf(i)
     do j=1,nreal
        gps_alltail%rdiag(j)= rdiagbuf(j,i)
     end do

!    If obs is "acceptable", load array with obs info for use
!    in inner loop minimization (int* and stp* routines)

     if (.not. last .and. muse(i) ) then

        if(.not. associated(gpshead))then
            allocate(gpshead,stat=istat)
            if(istat /= 0)write(6,*)' failure to write gpshead '
            gpstail => gpshead
        else
            allocate(gpstail%llpoint,stat=istat)
            gpstail => gpstail%llpoint
            if(istat /= 0)write(6,*)' failure to write gpstail%llpoint '
        end if
        allocate(gpstail%jac_t(nsig),gpstail%jac_q(nsig), &
                 gpstail%jac_p(nsig+1),gpstail%ij(4,nsig),stat=istat)
        if (istat/=0) write(6,*)'SETUPREF:  allocate error for gps_point, istat=',istat


        gps_alltail%mmpoint => gpstail

!       Set (i,j,k) indices of guess gridpoint that bound obs location
        call get_ij(mm1,data(ilat,i),data(ilon,i),gps_ij,gpstail%wij(1))

        do j=1,nsig
          gpstail%ij(1,j)=gps_ij(1)+(j-1)*latlon11
          gpstail%ij(2,j)=gps_ij(2)+(j-1)*latlon11
          gpstail%ij(3,j)=gps_ij(3)+(j-1)*latlon11
          gpstail%ij(4,j)=gps_ij(4)+(j-1)*latlon11
        enddo
        do j=1,nsig
           gpstail%jac_q(j)=zero
           gpstail%jac_t(j)=zero
           gpstail%jac_p(j)=zero
        enddo
        gpstail%jac_p(nsig+1)=zero
        dpres=data(ihgt,i)
        k=dpres
        k1=min(max(1,k),nsig)
        k2=max(1,min(k+1,nsig))
        gpstail%jac_t(k1)=gpstail%jac_t(k1)+termtk(i)
        gpstail%jac_p(k1)=gpstail%jac_p(k1)+termpk(i)
        if(k1 == 1)then
          gpstail%jac_t(k1)=gpstail%jac_t(k1)+termtk(i)
        else
          gpstail%jac_t(k1-1)=gpstail%jac_t(k1-1)+termtk(i)
          do j=2,k1
            gpstail%jac_t(j-1)=gpstail%jac_t(j-1)+termtl(j,i)
            gpstail%jac_p(j-1)=gpstail%jac_p(j-1)+termpl1(j,i)
            gpstail%jac_p(j)=gpstail%jac_p(j)-termpl2(j,i)
          end do
        end if
        delz=dpres-float(k1)
        delz=max(zero,min(delz,one))
        gpstail%jac_t(k1)=gpstail%jac_t(k1)+termt(i)*(one-delz)
        gpstail%jac_t(k2)=gpstail%jac_t(k2)+termt(i)*delz
        gpstail%jac_q(k1)=gpstail%jac_q(k1)+termq(i)*(one-delz)
        gpstail%jac_q(k2)=gpstail%jac_q(k2)+termq(i)*delz
        gpstail%res     = data(igps,i)
        gpstail%err2    = data(ier,i)**2
        gpstail%raterr2 = ratio_errors(i)**2    
        if(l_foto)then
          gpstail%time  = data(itime,i)*r3600
        else
          gpstail%time  = zero
        end if
        gpstail%b       = cvar_b(ikx)
        gpstail%pg      = cvar_pg(ikx)
        gpstail%luse    = luse(i)
        
     endif
  end do
  deallocate(cdiagbuf,rdiagbuf)

end subroutine setupref
