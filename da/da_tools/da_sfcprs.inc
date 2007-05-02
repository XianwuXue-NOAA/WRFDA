subroutine da_sfcprs (kts, kte, p, t, q, height, psfc, pslv, h_obs, t_obs)
   
   ! Purpose: to compute the pressure at obs height (psfc) from the sea
   !          level pressure (pslv), obs height (h_obs), temperature
   !          (t_obs, optional), and the model profile (p,t,q).
    
   implicit none

   integer,            intent(in)  :: kts, kte
   real, dimension(kts:kte), intent(in)  :: HEIGHT, P, T, Q
   real,               intent(in)  :: H_OBS, PSLV    
   real,               intent(out) :: PSFC    
   real, optional     ,intent(in)  :: T_OBS    

   real,          parameter :: G = gravity
   real,          parameter :: R =  gas_constant
   real,          parameter :: ROV2 = R / 2.
   real,          parameter :: gamma  = 6.5E-3, &   ! temperature Lapse rate
                      gammarg= gamma*gas_constant/g

   real,       dimension(3)    :: PLMB                   

   integer                     :: K
   integer                     :: K500
   integer                     :: K700
   integer                     :: K850

   logical                     :: L1
   logical                     :: L2
   logical                     :: L3

   real                        :: GAMMA78, GAMMA57  
   real                        :: HT    
   real                        :: P1 
   real                        :: T1       
   real                        :: T500       
   real                        :: T700    
   real                        :: T850    
   real                        :: TC
   real                        :: TFIXED 
   real                        :: TSLV, TSFC  

   TC   = t_kelvin + 17.5
   PLMB = (/85000., 70000., 50000./)

   !  Find the locations of the 850, 700 and 500 mb levels.

101 continue
   K850 = 0                              ! FinD K AT: P=850
   K700 = 0                              !            P=700
   K500 = 0                              !            P=500

   do K = kte-1, kts, -1
      if      (p(k) > PLMB(1) .and. K850==0) then
         K850 = K + 1
      else if (p(k) > PLMB(2) .and. K700==0) then
         K700 = K + 1
      else if (p(k) > PLMB(3) .and. K500==0) then
         K500 = K + 1
      end if
  
   end do

   if ((K850 .EQ. 0) .OR. (K700 .EQ. 0) .OR. (K500 .EQ. 0)) then
      ! write(unit=message(1),fmt='(A,3f8.0,A)') &
      !    'Error in finding p level for ',PLMB(1), PLMB(2), PLMB(3),' Pa.'
      ! do K = 1, KX
      !    write(unit=message(k+1),fmt='(A,I3,A,F10.2)') 'K = ',K,'  PRESSURE = ',P(K)
      ! end do
      ! write(unit=message(kx+2),fmt='(A,2f8.0,A,f8.0,A)) ','Expected ',    &
      !    PLMB(1), PLMB(2),' and ',PLMB(3),' Pa. values, at least.'
      ! message(kx+3)="not enough levels"
      ! message(kx+4)="Change the pressure levels by -25mb"
      ! call da_error(__FILE__,__LINE__,message(1:kx+4))
      PLMB(1) = PLMB(1) - 2500.
      PLMB(2) = PLMB(2) - 2500.
      PLMB(3) = PLMB(3) - 2500.
      goto 101
   end if

   !  The 850 hPa level is called something special, and interpolated
   !  to cross points.  And then, we fill those last rows and columns.

   ht = height(k850)

   !  The variable ht is now -h_obs/ht(850 hPa).  The plot thickens.

   ht = -h_obs / ht

   !  Make an isothermal assumption to get a first guess at the surface
   !  pressure.  This is to tell us which levels to use for the lapse
   !  rates in a bit.

   psfc = pslv * (pslv / p(k850)) ** ht

   !  Get a pressure more than 100 hPa above the surface - P1.  The
   !  P1 is the top of the level that we will use for our lapse rate
   !  computations.

   if      ((PSFC - p(k850) - 10000.) >= 0.) then
      P1 = p(k850)
   else if ((PSFC - p(k700)) >= 0.) then
      P1 = PSFC - 10000.
   else
      P1 = p(k500)
   end if

   !  Compute virtual temperatures for k850, k700, and k500 layers.  Now
   !  you see why we wanted Q on pressure levels, it all is beginning   
   !  to make sense.

   t850 = t(k850) * (1.0 + 0.608 * q(k850))
   t700 = t(k700) * (1.0 + 0.608 * q(k700))
   t500 = t(k500) * (1.0 + 0.608 * q(k500))

   !  Compute two lapse rates between these three levels.  These are
   !  environmental values for each (i,j).

   gamma78 = LOG(t850 / t700)  / LOG (p(k850) / p(k700))
   gamma57 = LOG(t700 / t500)  / LOG (p(k700) / p(k500))

   if ((psfc - p(k850) - 10000.) >= 0.0) then
      t1 = t850
   else if ((psfc - p(k850)) >= 0.0) then
      t1 = t700 * (p1 / p(k700)) ** gamma78
   else if ((psfc - p(k700)) >= 0.0) then 
      t1 = t500 * (p1 / p(k500)) ** gamma57
   else
      t1 = t500
   end if

   !  From our temperature way up in the air, we extrapolate down to
   !  the sea level to get a guess at the sea level temperature.

   tslv = t1 * (pslv / p1) ** (gammarg)

   !  The new surface temperature is computed from the with new sea level 
   !  temperature, just using the elevation and a lapse rate.  This lapse 
   !  rate is -6.5 K/km.

   if (present (t_obs)) then
     tsfc = t_obs
   else
     tsfc = tslv - gamma * h_obs
   end if

   !  A correction to the sea-level temperature, in case it is too warm.

   TFIXED = TC - 0.005 * (TSFC - TC) ** 2

   L1 = tslv .LT. tc
   L2 = tsfc .LE. tc
   L3 = .NOT. L1
   if (L2 .AND. L3) then
      tslv = tc
   else if ((.NOT. L2) .AND. L3) then
      tslv = tfixed
   end if

   !  Finally, we can get to the surface pressure.

   p1 = -h_obs * g / (rov2 * (tsfc + tslv))
   psfc = pslv * EXP(p1)

   !  Surface pressure and sea-level pressure are the same at sea level.

   if (ABS (h_obs) < 0.1) psfc = pslv

end subroutine da_sfcprs

