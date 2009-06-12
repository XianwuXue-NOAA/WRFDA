!-------------------------------------------------------------------------
!    NOAA/NCEP, National Centers for Environmental Prediction GSI        !
!-------------------------------------------------------------------------
!BOP
!
! !ROUTINE:  setupt --- Compute rhs of oi for temperature obs
!
! !INTERFACE:
!
subroutine setupt(lunin,mype,bwork,awork,nele,nobs,conv_diagsave)

! !USES:

  use kinds, only: r_kind,r_single,r_double,i_kind

  use obsmod, only: ttail,thead,sfcmodel,rmiss_single,perturb_obs,perturb_fact,&
       ran01dom,oberrflg

  use qcmod, only: npres_print,dfact,dfact1,ptop,pbot

  use oneobmod, only: oneobtest
  use oneobmod, only: maginnov
  use oneobmod, only: magoberr

  use gridmod, only: lat2, lon2, nsig,rlats,rlons,nlat,nlon,twodvar_regional
  use gridmod, only: get_ijk
  use jfunc, only: jiter,first,last,jiterstart,l_foto

  use guess_grids, only: nfldsig, hrdifsig,ges_ps,ges_lnprsl,ges_tv,ges_q,&
       nfldsfc,ntguessig,sfct,isli,sfc_rough,ges_u,ges_v,geop_hgtl,ges_tsen

  use constants, only: zero, one, fv, rad2deg,four,t0c,rd_over_cp
  use constants, only: tiny_r_kind,half,two,one_tenth,cg_term,huge_r_kind
  use constants, only: huge_single,r1000,wgtlim,izero,r3600
  use convinfo, only: nconvtype,cermin,cermax,cgross,cvar_b,cvar_pg,ictype,icsubtype
  use converr, only: ptabl 

  implicit none

! !INPUT PARAMETERS:

  integer(i_kind), intent(in) :: lunin   ! file unit from which to read observations
  integer(i_kind), intent(in) :: mype    ! mpi task id
  integer(i_kind), intent(in) :: nele    ! number of data elements per observation
  integer(i_kind), intent(in) :: nobs    ! number of observations
  logical, intent(in) :: conv_diagsave   ! logical to save innovation dignostics


! !INPUT/OUTPUT PARAMETERS:

                                                            ! array containing information ...
  real(r_kind),dimension(npres_print,nconvtype,5,3),intent(inout):: bwork !  about o-g stats
  real(r_kind),dimension(100+7*nsig),intent(inout):: awork !  for data counts and gross checks

! !DESCRIPTION:  For temperature observations, this routine
! \begin{enumerate}
!       \item reads obs assigned to given mpi task (geographic region),
!       \item simulates obs from guess,
!       \item apply some quality control to obs,
!       \item load weight and innovation arrays used in minimization
!       \item collects statistics for runtime diagnostic output
!       \item writes additional diagnostic information to output file
! \end{enumerate}
!
! !REVISION HISTORY:
!
!   1990-10-06  parrish
!   1998-04-10  weiyu yang
!   1999-03-01  wu - ozone processing moved into setuprhs from setupoz
!   1999-08-24  derber, j., treadon, r., yang, w., first frozen mpp version
!   2004-06-17  treadon - update documentation
!   2004-07-15  todling - protex-compliant prologue; added intent/only's
!   2004-10-06  parrish - increase size of twork array for nonlinear qc
!   2004-11-22  derber - remove weight, add logical for boundary point
!   2004-12-22  treadon - move logical conv_diagsave from obsmod to argument list
!   2005-03-02  dee - remove garbage from diagnostic file
!   2005-03-09  parrish - nonlinear qc change to account for inflated obs error
!   2005-05-27  derber - level output change
!   2005-07-27  derber  - add print of monitoring and reject data
!   2005-09-28  derber  - combine with prep,spr,remove tran and clean up
!   2005-10-14  derber  - input grid location and fix regional lat/lon
!   2005-10-21  su  -modified variational qc and diagnostic output
!   2005-10-27  su - correct error in longitude index for diagnostic output
!   2005-11-03  treadon - correct error in ilone,ilate data array indices
!   2005-11-22  wu - add option to perturb conventional obs
!   2005-11-29 derber - remove psfcg and use ges_lnps instead
!   2005-12-20  parrish - add boundary layer forward model option
!   2005-12-20  parrish - correct dimension error in declaration of prsltmp
!   2006-01-31  todling - storing wgt/wgtlim in diag file instead of wgt only
!   2006-02-02  treadon - rename lnprsl as ges_lnprsl
!   2006-02-24  derber  - modify to take advantage of convinfo module
!   2006-03-21  treadon - modify optional perturbation to observation
!   2006-04-03  derber  - optimize and fix bugs due to virtual temperature
!   2006-04-11  park    - reset land mask for surface data based on observation type
!   2006-04-27  park    - remove sensitivity test for surface TLM routine
!   2006-05-30  su,derber,treadon - modify diagnostic output
!   2006-06-06  su - move to wgtlim to constants module
!   2006-07-28  derber  - modify to use new inner loop obs data structure
!                       - modify handling of multiple data at same location
!                       - unify NL qc for surface model
!   2006-07-31  kleist - use ges_ps instead of lnps
!   2006-08-28      su - fix a bug in variational qc
!   2006-09-28  treadon - add 10m wind factor to sfc_wtq_fwd call
!   2006-10-28       su - turn off rawinsonde Vqc at south hemisphere
!   2007-03-09      su - modify the observation perturbation 
!
! !REMARKS:
!   language: f90
!   machine:  ibm RS/6000 SP; SGI Origin 2000; Compaq/HP
!
! !AUTHOR: 
!   parrish          org: np22                date: 1990-10-06
!
!EOP
!-------------------------------------------------------------------------

! Declare local parameters
  real(r_kind),parameter:: r10=10.0_r_kind
  real(r_kind),parameter:: r0_001 = 0.001_r_kind
  real(r_kind),parameter:: r8 = 8.0_r_kind

! Declare local variables

  
  real(r_double) rstation_id
  real(r_kind) rsig,drpx
  real(r_kind) psges,sfcchk,pres_diff,rlow,rhgh
  real(r_kind) tges,qtges
  real(r_kind) dx,dy,ds,dx1,dy1,ds1,obserror,ratio,val2,obserrlm
  real(r_kind) residual,ressw2,scale,ress,ratio_errors,tob,ddiff,perturbb
  real(r_kind) val,valqc,dlon,dlat,dtime,dpres,error,prest,rwgt
  real(r_kind) errinv_input,errinv_adjst,errinv_final
  real(r_kind) err_input,err_adjst,err_final,tfact,cvar_pg1
  real(r_kind) cg_t,wgross,wnotgross,wgt,arg,exp_arg,term,rat_err2
  real(r_kind),dimension(nobs)::dup
  real(r_kind),dimension(nsig):: prsltmp
  real(r_kind),dimension(nele,nobs):: data
  real(r_single),allocatable,dimension(:,:)::rdiagbuf
  real(r_kind),dimension(lat2,lon2,nsig,nfldsig):: g_tv,g_q
  real(r_kind) tgges,roges,msges
  real(r_kind),dimension(nsig):: tvtmp,qtmp,utmp,vtmp,hsges
  real(r_kind) u10ges,v10ges,t2ges,q2ges,psges2,f10ges

  real(r_kind),dimension(nsig):: prsltmp2
  real(r_kind),dimension(lat2,lon2,nfldsfc):: rsli

  integer(i_kind) i,nchar,nreal,k,j,ii,it,jj,l,nn
  integer(i_kind) mm1,jlat,jon,jsig,iqt
  integer(i_kind) itype,jlon
  integer(i_kind) ier,ilon,ilat,ipres,itob,id,itime,ikx,iqc
  integer(i_kind) ier2,iuse,ilate,ilone,ikxx,istnelv,iobshgt
  integer(i_kind) regime,istat
  
  character(8) station_id
  character(8),allocatable,dimension(:):: cdiagbuf

  logical,dimension(nobs):: luse,muse
  logical sfctype
  logical iqtflg

  equivalence(rstation_id,station_id)

!*********************************************************************************
! Read and reformat observations in work arrays.
  read(lunin)data,luse

!    index information for data array (see reading routine)
  ier=1       ! index of obs error
  ilon=2      ! index of grid relative obs location (x)
  ilat=3      ! index of grid relative obs location (y)
  ipres=4     ! index of pressure
  itob=5      ! index of t observation
  id=6        ! index of station id
  itime=7     ! index of observation time in data array
  ikxx=8      ! index of ob type
  iqt=9       ! index of flag indicating if moisture ob available
  iqc=10      ! index of quality mark
  ier2=11     ! index of original-original obs error ratio
  iuse=12     ! index of use parameter
  ilone=13    ! index of longitude (degrees)
  ilate=14    ! index of latitude (degrees)
  istnelv=15  ! index of station elevation (m)
  iobshgt=16  ! index of observation height (m)


  do i=1,nobs
    muse(i)=nint(data(iuse,i)) <= jiter
  end do

  dup=one
  do k=1,nobs
     do l=k+1,nobs
        if(data(ilat,k) == data(ilat,l) .and.  &
           data(ilon,k) == data(ilon,l) .and.  &
           data(ipres,k) == data(ipres,l) .and. &
           data(ier,k) < r1000 .and. data(ier,l) < r1000 .and. &
           muse(k) .and. muse(l))then

          tfact=min(one,abs(data(itime,k)-data(itime,l))/dfact1)
          dup(k)=dup(k)+one-tfact*tfact*(one-dfact)
          dup(l)=dup(l)+one-tfact*tfact*(one-dfact)
        end if
     end do
  end do

! If requested, save select data for output to diagnostic file
  if(conv_diagsave)then
     ii=0
     nchar=1
     nreal=19
     allocate(cdiagbuf(nobs),rdiagbuf(nreal,nobs))
  end if
  scale=one
  rsig=float(nsig)
  mm1=mype+1

!  rsli=isli
  do i=1,nobs
! Convert obs lats and lons to grid coordinates
     dlat=data(ilat,i)
     dlon=data(ilon,i)
     dpres=data(ipres,i)
     dtime=data(itime,i)
     error=data(ier2,i)
     ikx=nint(data(ikxx,i))
     itype=ictype(ikx)
     prest=r10*exp(dpres)     ! in mb
     sfctype=itype>179.and.itype<190
  
     iqtflg=nint(data(iqt,i)) == 0

!    Load observation value and observation error into local variables
     tob=data(itob,i)
     obserror = max(cermin(ikx),min(cermax(ikx),data(ier,i)))


! Interpolate log(ps) & log(pres) at mid-layers to obs locations/times
     call tintrp2a(ges_ps,psges,dlat,dlon,dtime,hrdifsig,&
          1,1,mype,nfldsig)
     call tintrp2a(ges_lnprsl,prsltmp,dlat,dlon,dtime,hrdifsig,&
          1,nsig,mype,nfldsig)

     drpx=zero
     if(sfctype) then
        drpx=abs(one-((one/exp(dpres-log(psges))))**rd_over_cp)*t0c
     end if

!    Put obs pressure in correct units to get grid coord. number
     call grdcrd(dpres,1,prsltmp(1),nsig,-1)

! Convert dry (sensible) temperature to virtual temperature
!    tvirt=tob
!    if(.not. iqtflg) then
!       call tintrp3(ges_q,qtges,dlat,dlon,dpres,dtime, &
!            hrdifsig,1,mype,nfldsig)
!       tvirt=tvirt*(one+fv*qtges)
!    end if
!    iqtflg=.true.
     
! Implementation of forward model ----------

     if(sfctype.and.sfcmodel) then
        call tintrp2a(sfct,tgges,dlat,dlon,dtime,hrdifsig,&
             1,1,mype,nfldsig)
        call tintrp2a(sfc_rough,roges,dlat,dlon,dtime,hrdifsig,&
             1,1,mype,nfldsig)
!       call tintrp2a(rsli,msges,dlat,dlon,dtime,hrdifsig,&
!            1,1,mype,nfldsig)
!       msges=min(msges,one)
!       if(msges.lt.one) msges=zero
        msges = zero
        if(itype == 180 .or. itype == 182 .or. itype == 183) then    !sea
           msges=zero
        elseif(itype == 181 .or. itype == 187 .or. itype == 188) then  !land
           msges=one
        endif

        call tintrp2a(ges_tv,tvtmp,dlat,dlon,dtime,hrdifsig,&
             1,nsig,mype,nfldsig)
        call tintrp2a(ges_q,qtmp,dlat,dlon,dtime,hrdifsig,&
             1,nsig,mype,nfldsig)
        call tintrp2a(ges_u,utmp,dlat,dlon,dtime,hrdifsig,&
             1,nsig,mype,nfldsig)
        call tintrp2a(ges_v,vtmp,dlat,dlon,dtime,hrdifsig,&
             1,nsig,mype,nfldsig)
        call tintrp2a(geop_hgtl,hsges,dlat,dlon,dtime,hrdifsig,&
             1,nsig,mype,nfldsig)
  
        psges2  = psges          ! keep in cb
        prsltmp2 = prsltmp       ! keep in cb
        call SFC_WTQ_FWD (psges2, tgges,&
             prsltmp2(1), tvtmp(1), qtmp(1), utmp(1), vtmp(1),&
             prsltmp2(2), tvtmp(2), qtmp(2), &
             hsges(1),roges,msges, &
             f10ges,u10ges,v10ges,t2ges,q2ges,regime,iqtflg)
        tges = t2ges

     else
       if(iqtflg)then
!      Interpolate guess tv to observation location and time
         call tintrp3(ges_tv,tges,dlat,dlon,dpres,dtime, &
              hrdifsig,1,mype,nfldsig)

       else
!        Interpolate guess tsen to observation location and time
         call tintrp3(ges_tsen,tges,dlat,dlon,dpres,dtime, &
              hrdifsig,1,mype,nfldsig)
       end if
     endif

!    Get approximate k value of surface by using surface pressure
     sfcchk=log(psges)
     call grdcrd(sfcchk,1,prsltmp(1),nsig,-1)

!    Check to see if observations is above the top of the model (regional mode)
     if(sfctype)then
        if(abs(dpres)>four) drpx=1.0e10
        pres_diff=prest-r10*psges
        if (twodvar_regional .and. abs(pres_diff)>=r10) drpx=1.0e10
     end if
     rlow=max(sfcchk-dpres,zero)

     rhgh=max(zero,dpres-rsig-r0_001)

     if(sfctype.and.sfcmodel)  dpres = one     ! place sfc T obs at the model sfc

     if(luse(i))then
        awork(1) = awork(1) + one
        if(rlow/=zero) awork(2) = awork(2) + one
        if(rhgh/=zero) awork(3) = awork(3) + one
     end if
     
     ratio_errors=error/((data(ier,i)+drpx+1.0e6*rhgh+r8*rlow)*sqrt(dup(i)))
     error=one/error
     if (dpres > rsig) ratio_errors=zero

!     if(mype ==0 ) then
!        write(6,*) itype,tob,tges
!     endif

! Compute innovation
     ddiff = tob-tges

! If requested, setup for single obs test.
     if (oneobtest) then
        ddiff = maginnov
        error=one/magoberr
        ratio_errors=one
     endif

!    Gross error checks

     obserror = one/max(ratio_errors*error,tiny_r_kind)
     obserrlm = max(cermin(ikx),min(cermax(ikx),obserror))
     residual = abs(ddiff)
     ratio    = residual/obserrlm
     if (ratio > cgross(ikx) .or. ratio_errors < tiny_r_kind) then
        if (luse(i)) awork(4) = awork(4)+one
        error = zero
        ratio_errors = zero

!       Modify for the obs perturbation to adjust the obs err
        if(perturb_obs .and. jiter == jiterstart ) then
           data(ier2,i)= huge_r_kind          ! Do not use this data next outerloop
        endif

     end if
     
     if (ratio_errors*error <=tiny_r_kind) muse(i)=.false.

!    Modify for the obs perturbation to adjust the obs err
     if( muse(i) .and. perturb_obs) then
        if(error >1.0e-2) then
           perturbb=ran01dom()*perturb_fact/error
        else
           perturbb=zero
        endif
        if( jiter /= jiterstart ) then
           ddiff=ddiff+perturbb
        endif
     endif

!    Compute penalty terms
     val      = error*ddiff

!    Turn off rainsonde variational qc over south hemisphere
     cvar_pg1=cvar_pg(ikx)
     if (itype==120 .and. data(ilate,i)<zero) cvar_pg1=zero

     if(luse(i))then
        val2     = val*val
        exp_arg  = -half*val2
        rat_err2 = ratio_errors**2
        if (cvar_pg1 > tiny_r_kind .and. error >tiny_r_kind) then
           arg  = exp(exp_arg)
           wnotgross= one-cvar_pg1
           cg_t=cvar_b(ikx)
           wgross = cg_term*cvar_pg1/(cg_t*wnotgross)
           term =log((arg+wgross)/(one+wgross))
           wgt  = one-wgross/(arg+wgross)
           rwgt = wgt/wgtlim
        else
           term = exp_arg
           wgt  = wgtlim
           rwgt = wgt/wgtlim
        endif
        valqc = -two*rat_err2*term

!       Accumulate statistics for obs belonging to this task
        if(luse(i))then
           if(rwgt < one) awork(21) = awork(21)+one
           jsig = dpres
           jsig=max(1,min(jsig,nsig))
           awork(jsig+3*nsig+100)=awork(jsig+3*nsig+100)+valqc
           awork(jsig+5*nsig+100)=awork(jsig+5*nsig+100)+one
           awork(jsig+6*nsig+100)=awork(jsig+6*nsig+100)+val2*rat_err2
        end if

! Loop over pressure level groupings and obs to accumulate statistics
! as a function of observation type.
        ress   = ddiff*scale
        ressw2 = ress*ress
        nn=1
        if (.not. muse(i)) then
           nn=2
           if(ratio_errors*error >=tiny_r_kind)nn=3
        end if
        do k = 1,npres_print
           if(prest >=ptop(k) .and. prest <= pbot(k))then
              bwork(k,ikx,1,nn)  = bwork(k,ikx,1,nn)+one            ! count
              bwork(k,ikx,2,nn)  = bwork(k,ikx,2,nn)+ress           ! (o-g)
              bwork(k,ikx,3,nn)  = bwork(k,ikx,3,nn)+ressw2         ! (o-g)**2
              bwork(k,ikx,4,nn)  = bwork(k,ikx,4,nn)+val2*rat_err2  ! penalty
              bwork(k,ikx,5,nn)  = bwork(k,ikx,5,nn)+valqc          ! nonlin qc penalty
              
           end if
        end do
     end if

!    If obs is "acceptable", load array with obs info for use
!    in inner loop minimization (int* and stp* routines)
     if ( .not. last .and. muse(i)) then

        if(.not. associated(thead))then
            allocate(thead,stat=istat)
            if(istat /= 0)write(6,*)' failure to write thead '
            ttail => thead
        else
            allocate(ttail%llpoint,stat=istat)
            ttail => ttail%llpoint
            if(istat /= 0)write(6,*)' failure to write ttail%llpoint '
        end if

!       Set (i,j,k) indices of guess gridpoint that bound obs location
        call get_ijk(mm1,dlat,dlon,dpres,ttail%ij(1),ttail%wij(1))
        
        ttail%res     = ddiff
        ttail%err2    = error**2
        ttail%raterr2 = ratio_errors**2      
        if(l_foto)then
          ttail%time  = dtime*r3600
        else
          ttail%time  = zero
        end if
        ttail%b       = cvar_b(ikx)
        ttail%pg      = cvar_pg1
        ttail%use_sfc_model = sfctype.and.sfcmodel
        if(ttail%use_sfc_model) then
           call get_tlm_tsfc(ttail%tlm_tsfc(1), &
                psges2,tgges,prsltmp2(1), &
                tvtmp(1),qtmp(1),utmp(1),vtmp(1),hsges(1),roges,msges, &
                regime,iqtflg)
        else
           ttail%tlm_tsfc = zero
        endif
        ttail%luse    = luse(i)
        ttail%tv_ob   = iqtflg
        if(perturb_obs) then
           ttail%tpertb=perturbb
           if(prest >= ptabl(2))then
              ttail%tk1=1+itype*100
           else if( prest < ptabl(33)) then
              ttail%tk1=33+itype*100
           else
              k_loop: do k=2,32
                if(prest >= ptabl(k+1) .and. prest < ptabl(k)) then
                   ttail%tk1=k+itype*100
                   exit k_loop
                endif
             enddo k_loop
           endif
        else
           ttail%tpertb=zero
           ttail%tk1=izero
        endif
     endif

! Save select output for diagnostic file
     if (conv_diagsave .and. luse(i)) then
        ii=ii+1
        rstation_id     = data(id,i)
        cdiagbuf(ii)    = station_id         ! station id

        rdiagbuf(1,ii)  = ictype(ikx)        ! observation type
        rdiagbuf(2,ii)  = icsubtype(ikx)     ! observation subtype
    
        rdiagbuf(3,ii)  = data(ilate,i)      ! observation latitude (degrees)
        rdiagbuf(4,ii)  = data(ilone,i)      ! observation longitude (degrees)
        rdiagbuf(5,ii)  = data(istnelv,i)    ! station elevation (meters)
        rdiagbuf(6,ii)  = prest              ! observation pressure (hPa)
        rdiagbuf(7,ii)  = data(iobshgt,i)    ! observation height (meters)
        rdiagbuf(8,ii)  = dtime              ! obs time (hours relative to analysis time)

        rdiagbuf(9,ii)  = data(iqc,i)        ! input prepbufr qc or event mark
        rdiagbuf(10,ii) = data(iqt,i)        ! setup qc or event mark (currently qtflg only)
        rdiagbuf(11,ii) = data(iuse,i)       ! read_prepbufr data usage flag
        if(muse(i)) then
           rdiagbuf(12,ii) = one             ! analysis usage flag (1=use, -1=not used)
        else
           rdiagbuf(12,ii) = -one
        endif

        err_input = data(ier2,i)
        err_adjst = data(ier,i)
        if (ratio_errors*error>tiny_r_kind) then
           err_final = one/(ratio_errors*error)
        else
           err_final = huge_single
        endif

        errinv_input = huge_single
        errinv_adjst = huge_single
        errinv_final = huge_single
        if (err_input>tiny_r_kind) errinv_input=one/err_input
        if (err_adjst>tiny_r_kind) errinv_adjst=one/err_adjst
        if (err_final>tiny_r_kind) errinv_final=one/err_final

        rdiagbuf(13,ii) = rwgt               ! nonlinear qc relative weight
        rdiagbuf(14,ii) = errinv_input       ! prepbufr inverse obs error (K**-1)
        rdiagbuf(15,ii) = errinv_adjst       ! read_prepbufr inverse obs error (K**-1)
        rdiagbuf(16,ii) = errinv_final       ! final inverse observation error (K**-1)

        rdiagbuf(17,ii) = data(itob,i)       ! temperature observation (K)
        rdiagbuf(18,ii) = ddiff              ! obs-ges used in analysis (K)
        rdiagbuf(19,ii) = tob-tges           ! obs-ges w/o bias correction (K) (future slot)

     end if

! End of loop over observations
  end do


! Write information to diagnostic file
  if(conv_diagsave)then
     write(7)'  t',nchar,nreal,ii,mype
     write(7)cdiagbuf(1:ii),rdiagbuf(:,1:ii)
     deallocate(cdiagbuf,rdiagbuf)
  end if


! End of routine
end subroutine setupt
  
  


