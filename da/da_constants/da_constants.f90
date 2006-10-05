module da_constants

   !--------------------------------------------------------------------------
   ! PURPOSE: Common reference point for constants.
   !--------------------------------------------------------------------------

   USE module_driver_constants

   IMPLICIT NONE

#include "namelist_defines.inc"

   !---------------------------------------------------------------------------
   ! [1.0] Physical parameter constants (all NIST standard values):
   !---------------------------------------------------------------------------

   ! Fundamental constants:
   REAL, PARAMETER    :: pi = 3.1415926535897932346
#ifdef MM5_CONSTANT
   REAL, PARAMETER    :: gas_constant = 287.04   ! Value used in MM5.
   REAL, PARAMETER    :: gas_constant_v = 461.51 ! 
   REAL, PARAMETER    :: cp = 1004.0             ! Value used in MM5.
#else
   REAL, PARAMETER    :: gas_constant = 287.     ! Value used in WRF.
   REAL, PARAMETER    :: gas_constant_v = 461.6  ! Value used in WRF.
   REAL, PARAMETER    :: cp = 7.*gas_constant/2. ! Value used in WRF.
#endif
   REAL, PARAMETER    :: t_kelvin = 273.15
   REAL, PARAMETER       :: ps0_inv = 1.0 / 100000.0  ! Base pressure.

   REAL, PARAMETER    :: kappa = gas_constant / cp
   REAL, PARAMETER    :: rd_over_rv = gas_constant / gas_constant_v
   REAL, PARAMETER    :: rd_over_rv1 = 1.0 - rd_over_rv
   REAL, PARAMETER    :: L_over_Rv = 5418.12

   REAL, PARAMETER    :: gamma = 1.4

   ! Earth constants:
   REAL, PARAMETER    :: gravity = 9.81        ! m/s - value used in MM5.
   ! REAL, PARAMETER    :: earth_radius = 6378.15
   REAL, PARAMETER    :: earth_radius = 6370.0		! Be consistant with WRF
   ! REAL, PARAMETER    :: earth_omega  = 2.0*pi/86400.0  ! Omega
   REAL, PARAMETER    :: earth_omega  = 0.000072921     ! Omega 7.2921*10**-5

   ! Saturation Vapour Pressure Constants(Rogers & Yau, 1989) 
   REAL, PARAMETER    :: es_alpha = 611.2
   REAL, PARAMETER    :: es_beta = 17.67
   REAL, PARAMETER    :: es_gamma = 243.5
   REAL, PARAMETER    :: es_gammabeta = es_gamma * es_beta
   REAL, PARAMETER    :: es_gammakelvin = es_gamma - t_kelvin

   ! Explicit moist constants:
   REAL, PARAMETER    :: SVP1=0.6112, SVP2=17.67, SVP3=29.65
   REAL, PARAMETER    :: SVPT0=273.15, TO=273.15
   REAL, PARAMETER    :: N0R=8.E6, N0S=2.E7, RHOS=0.1
   REAL, PARAMETER    :: AVT=841.99667, BVT=0.8, BVT2=2.5+.5*BVT, BVT3=3.+BVT
   REAL, PARAMETER    :: PPI=1./(pi*N0R), PPIS=1./(pi*N0S*RHOS)
   REAL, PARAMETER    :: XLV1=2370., XLF0=.3337E6, XLV0=3.15E6
   REAL, PARAMETER    :: XLS=XLV0-XLV1*273.16+XLF0

   ! Planetary boundary physics (/MM5/physics/pbl_sfc/mrfpbl/mrfpbl.F) constants
   REAL, PARAMETER         :: k_kar = 0.4    ! Von Karman constant

   ! GPS Refractivity constant  
   real, parameter    :: coeff = 3.73e5 / 77.6

#if RWORDSIZE==8
   real, parameter :: da_zero = 0D0
#else
   real, parameter :: da_zero = 0.0
#endif

complex, parameter :: da_zero_complex = (da_zero,da_zero)
   
   !---------------------------------------------------------------------------
   ! [2.0] WRF-Var parameter constants:
   !---------------------------------------------------------------------------

   ! Missing values and the index number of the quality contro

   INTEGER, PARAMETER ::  missing       = -888888
   REAL   , PARAMETER ::  missing_r     = -888888.
   REAL   , PARAMETER ::  Max_StHeight_Diff = 100.

   ! WRFVAR Minimisation:

   INTEGER            :: iter
   INTEGER, PARAMETER :: MP = 6
   INTEGER, PARAMETER :: LP = 6
   INTEGER, PARAMETER :: MAXFEV = 10
   REAL, PARAMETER    :: FTOL = 1.0E-4
   REAL, PARAMETER    :: GTOL = 0.9
   REAL, PARAMETER    :: XTOL = 1.0E-17
   REAL, PARAMETER    :: STPMIN = 1.0E-20
   REAL, PARAMETER    :: STPMAX = 1.0E+20

   ! Background errors:
   REAL, PARAMETER    :: pplow = 1.0e-8       ! Machine lowest number?
   REAL, PARAMETER    :: pp_umin = 1.0e-2     ! Minimum u back. error (m/s).
   REAL, PARAMETER    :: pp_vmin = 1.0e-2     ! Minimum v back. error (m/s).
   REAL, PARAMETER    :: pp_tmin = 1.0e-2     ! Minimum t back. error (K).
   REAL, PARAMETER    :: pp_qmin = 1.0e-6     ! Minimum q back. error (kg/kg)
   REAL, PARAMETER    :: pp_pmin= 1.0e+1      ! Minimum pp back. error (Pa).

   ! FFTs:
   INTEGER, PARAMETER :: Forward_FFT     = -1 ! Grid to spectral
   INTEGER, PARAMETER :: Inverse_FFT     =  1 ! Spectral to grid.
   INTEGER, PARAMETER :: num_fft_factors = 10 ! Max number of factors.
 
   ! Balance:
   INTEGER, PARAMETER :: balance_geo = 1      ! Geostrophic balance.
   INTEGER, PARAMETER :: balance_cyc = 2      ! Cyclostrophic balance.
   INTEGER, PARAMETER :: balance_geocyc = 3   ! Geo/cyclostrophic balance.

   ! Adjoint tests:
   REAL, PARAMETER    :: typical_u_rms = 2.0     ! m/s
   REAL, PARAMETER    :: typical_v_rms = 2.0     ! m/s
   REAL, PARAMETER    :: typical_speed_rms = 2.0 ! m/s
   REAL, PARAMETER    :: typical_tb19v_rms = 1.0 ! K
   REAL, PARAMETER    :: typical_tb19h_rms = 1.0 ! K
   REAL, PARAMETER    :: typical_tb22v_rms = 1.0 ! K
   REAL, PARAMETER    :: typical_tb37v_rms = 1.0 ! K
   REAL, PARAMETER    :: typical_tb37h_rms = 1.0 ! K
   REAL, PARAMETER    :: typical_tb85v_rms = 1.0 ! K
   REAL, PARAMETER    :: typical_tb85h_rms = 1.0 ! K
   REAL, PARAMETER    :: typical_t_rms = 1.0     ! K
   REAL, PARAMETER    :: typical_p_rms = 100.0   ! Pa
   REAL, PARAMETER    :: typical_q_rms = 0.00001 ! g/kg
   REAL, PARAMETER    :: typical_rho_rms = 0.01  ! kg/m^3
   REAL, PARAMETER    :: typical_tpw_rms = 0.2   ! cm
   REAL, PARAMETER    :: typical_ref_rms = 5.0   ! N unit
   REAL, PARAMETER    :: typical_rh_rms = 20.0   ! %
   REAL, PARAMETER    :: typical_thickness_rms = 50.0   ! m
   REAL, PARAMETER    :: typical_qrn_rms = 0.00001 ! g/kg
   REAL, PARAMETER    :: typical_qcw_rms = 0.00001 ! g/kg
   REAL, PARAMETER    :: typical_w_rms = 0.1     ! m/s
   REAL, PARAMETER    :: typical_rv_rms = 1.0    ! m/s
   REAL, PARAMETER    :: typical_rf_rms = 1.0    ! dBZ

   ! The following typical mean squared values depend on control variable. They   
   ! are calculated in da_setup_background_errors and used in the VvToVp adjoint 
   ! test:

   REAL, PARAMETER    :: inv_typ_vp1_sumsq = 0.00001 ! 1/SUM(psi**2)
   REAL, PARAMETER    :: inv_typ_vp2_sumsq = 0.00001 ! 1/SUM(chi**2)
   REAL, PARAMETER    :: inv_typ_vp3_sumsq = 0.00001 ! 1/SUM(phi_u**2)
   REAL, PARAMETER    :: inv_typ_vp4_sumsq = 10000.0 ! 1/SUM(q**2)
   REAL, PARAMETER    :: inv_typ_vp5_sumsq = 0.00001 ! 1/SUM(?**2)
   REAL, PARAMETER    :: inv_typ_vpalpha_sumsq = 1.0 ! 1/SUM(?**2)

   CHARACTER(LEN=*),PARAMETER :: wrfvar_version = "WRFVAR V2.2"
   CHARACTER(LEN=*),PARAMETER :: wrf_version    = "WRF V2.2"

   ! Fortran unit  parameters:

   ! stdout, stderr, trace_unit all controlled from namelist

   ! Units 9,10 are used for reading and writing namelist.input/output in WRF

   INTEGER, PARAMETER :: jpout = 11           ! Unit number for x output.
   INTEGER, PARAMETER :: stats_unit = 12      ! Unit number for stats output.
   INTEGER, PARAMETER :: innov_vector_unit = 14 ! Innovation vector diagnostics

   INTEGER, PARAMETER :: cov_unit = 25 ! Covariances unit
   INTEGER, PARAMETER :: be_unit = 34    ! Unit number for be input.
   INTEGER, PARAMETER :: gen_be_iunit = 30
   INTEGER, PARAMETER :: gen_be_ounit = 31

   INTEGER, PARAMETER :: sound_diag_unit1 = 36 ! For da_sound/da_obs_diagnostics
   INTEGER, PARAMETER :: sound_diag_unit2 = 37
   INTEGER, PARAMETER :: sound_diag_unit3 = 38
   INTEGER, PARAMETER :: sound_diag_unit4 = 39

   INTEGER, PARAMETER :: terrain_unit = 40    ! Unit number for terrain input.
   INTEGER, PARAMETER :: jpin = 41            ! Unit number for xb input.

   integer, parameter :: rand_unit = 45       ! Output of noise.
   integer, parameter :: yp_unit = 46         ! Output of H(x'(yo+noise)).
   integer, parameter :: y_unit = 47          ! Output of H(x'(yo)).
   integer, parameter :: jo_unit = 48         ! Output of components of Jo, ErrFac.
   INTEGER, PARAMETER :: anl_inc_unit = 141   ! Analysis increment unit     
   integer, parameter :: fac_unit = 49        ! Input components of ErrFac.
   integer, parameter :: omb_unit = 50        ! Output for O-B values.

    INTEGER, PARAMETER :: bufrtovs_unit = 55  ! Input BUFR/TOVS data

   INTEGER, PARAMETER :: check_max_iv_unit=60 ! Unit number for O-B check.

   INTEGER, PARAMETER :: num_alpha_corr_types = 3

   INTEGER, PARAMETER :: alpha_corr_unit1(num_alpha_corr_types) = (/61,62,63/)
   INTEGER, PARAMETER :: alpha_corr_unit2(num_alpha_corr_types) = (/71,72,73/)

   integer, parameter :: cost_unit = 81       ! Output of cost-function value
   integer, parameter :: grad_unit = 82       ! Output of gradient norm

   INTEGER, PARAMETER :: bufr_iunit = 91      ! Unit number for bufr obs input.
   INTEGER, PARAMETER :: gts_iunit  = 92      ! Unit number for GTS obs input.
   INTEGER, PARAMETER :: ssmi_iunit = 93      ! Unit number for SSMI obs input.
   INTEGER, PARAMETER :: Radar_iunit = 94     ! Unit number for Radar input.
   INTEGER, PARAMETER :: airs_table_unit = 95 ! AIRS bufr table input
   INTEGER, PARAMETER :: wrf_done_unit = 98   ! wrf coupling
   INTEGER, PARAMETER :: rtm_error_unit = 99  ! RTTOV error unit
   ! Tracing to unit 100
   INTEGER, PARAMETER :: rtm_info_unit = 109  ! Radiance info file
   INTEGER, PARAMETER :: rtm_bias_unit = 110  ! Radiance bias file
   INTEGER, PARAMETER :: unit_factor_rad = 111
   INTEGER, PARAMETER :: filtered_obs_iunit  = 192  ! Unit number for writing filtered obs
   INTEGER, PARAMETER :: filtered_rad_unit   = 193  ! Unit number for writing filtered radiance
   INTEGER, PARAMETER :: innov_rad_unit      = 194  ! Unit number for writing innovation radiance
   INTEGER, PARAMETER :: oma_rad_unit        = 195  ! Unit number for writing oma radiance
   INTEGER, PARAMETER :: error_factor_rad_unit = 196  ! Unit number for radiance error factor
   INTEGER, PARAMETER :: unit_983            = 983 ! TBD
   integer, parameter  :: iunit = 70
   integer, parameter  :: ounit = iunit + 1
   integer, parameter  :: namelist_unit = 72
   integer, parameter  :: spec_unit = 73      ! Unit for spectral diag. output.
   integer, parameter  :: ep_unit = 74        ! Ensemble perturbation input.
   INTEGER, PARAMETER :: max_num_of_var = 200 ! Maximum # of stored fields.

   !---------------------------------------------------------------------------
   ! [3.0] Variables used in MM5 part of code:
   !---------------------------------------------------------------------------

   INTEGER            :: map_projection       ! 1=LamConf/2=PolarSte/3=Mercator
   REAL               :: ycntr
   INTEGER            :: coarse_ix            ! COARSE DOMAIN DIM IN I DIRECTION.
   INTEGER            :: coarse_jy            ! COARSE DOMAIN DIM IN Y DIRECTION.
   REAL               :: coarse_ds            ! Coarse domain gridlength (km)
   REAL               :: start_x              ! i posn. of (1,1) in coarse domain.
   REAL               :: start_y              ! j posn. of (1,1) in coarse domain.
   REAL               :: start_lat            ! Latitude coresponds to start_(x,y)
   REAL               :: start_lon            ! Longitude coresponds to start_(x,y)
   REAL               :: delt_lat             ! Latitude increments for global grids
   REAL               :: delt_lon             ! Longitude increments for global grids

   REAL               :: phic                 ! COARSE DOMAIN CENTRAL LAT(DEGREE)
   REAL               :: xlonc                ! COARSE DOMAIN CENTRAL LON(DEGREE)
   REAL               :: cone_factor          ! Cone Factor
   REAL               :: truelat1_3dv         ! True latitude 1 (degrees)
   REAL               :: truelat2_3dv         ! True latitude 2 (degrees)
   REAL               :: pole                 ! Pole latitude (degrees)
   REAL               :: dsm                  ! Current domain gridlength (km)
   REAL               :: psi1                 ! ?
   REAL               :: c2                   ! earth_radius * COS(psi1)

   REAL               :: ptop
   REAL               :: ps0
   REAL               :: ts0 = 300.0          ! Base potential temperture
                                              ! mm5 code may try to change value
   REAL               :: tlp
   REAL               :: tis0

   !------------------------------------------------------------------------------
   ! 4.0 vertical interpolation options
   !------------------------------------------------------------------------------

   INTEGER, PARAMETER :: v_interp_not_specified = missing, &
                         v_interp_p             = 1, &
                         v_interp_h             = 2
   INTEGER            :: p_below = 0, p_above = 0, h_below = 0, h_above = 0

   !------------------------------------------------------------------------------
   ! WRFVAR scalar constants:
   !------------------------------------------------------------------------------

   integer                :: Anal_Space  ! Space of analysis
                                         ! ( 1 = Full model,
                                         !   2 = Transformed grid,
                                         !   3 = Ob space (PSAS) )

   integer                :: mix         ! 1st dimension of analysis grid.
   integer                :: mjy         ! 2nd dimension of analysis grid.
   integer                :: mkz         ! 3rd dimension of analysis grid.

  !Recursive filter:

   REAL, ALLOCATABLE      :: rf_turnconds(:) ! RF turning conditions.

   INTEGER, PARAMETER     :: max_ob_levels = 1001 ! Maximum levels for single ob
   INTEGER, PARAMETER     :: max_fgat_time = 100  ! Maximum levels for FGAT.

   integer                :: current_ob_time

   integer                :: num_gpspw_tot, num_synop_tot, num_metar_tot, &
                             num_pilot_tot, num_ssmi_rv_tot, num_ssmi_tb_tot, &
                             num_ssmi_tot,  num_ssmt1_tot, num_ssmt2_tot, &
                             num_satem_tot, num_geoamv_tot,num_polaramv_tot, &
                             num_ships_tot, &
                             num_sound_tot, num_airep_tot, num_qscat_tot, &
                             num_profiler_tot, num_buoy_tot, num_gpsref_tot, &
                             num_Radar_tot, num_bogus_tot,num_airsr_tot, &
                             num_radiance_tot

   logical       :: gaussian_lats  


   integer       :: cv_size_domain_jb    ! Total jb cv size.
   integer       :: cv_size_domain_je    ! Total je cv size.
   integer       :: cv_size_domain       ! Total cv size.    



   ! Namelist variables in future?:
   REAL, PARAMETER :: maximum_rh = 100.0
   REAL, PARAMETER :: minimum_rh =  10.0

   ! other

   CHARACTER*80  CHEADL1
   CHARACTER*80  CHEADL2
   CHARACTER*160 CHEADL3


   INTEGER, PARAMETER :: jperr = 6

   ! NCEP ERRORS (U in m/s, V in m/s, T in K, H in %, P in Pa)
   ! RH HAS BEEN DIVIDED BY 2

   REAL, PARAMETER :: err_k(0:jperr+1) = &
                      (/200000., 100100.,70000.,50000.,30000.,10000.,5000., 1./)
   REAL, PARAMETER :: err_u(0:jperr+1) = &
                      (/ 1.4, 1.4,   2.4,   2.8,   3.4,   2.5,  2.7,  2.7/)
   REAL, PARAMETER :: err_v(0:jperr+1) = &
                      (/ 1.4, 1.4,   2.4,   2.8,   3.4,   2.5,  2.7 , 2.7 /)
   REAL, PARAMETER :: err_t(0:jperr+1) = &
                      (/ 1.8, 1.8,   1.3,   1.3,   2.0,   3.1,  4.0 , 4.0 /)
   REAL, PARAMETER :: err_rh(0:jperr+1) = &
                      (/ 10.0, 10.0,  10.0,  10.0,  10.0,  10.0, 10.0,  10.0/)
   REAL, PARAMETER :: err_p(0:jperr+1) = &
                      (/ 100.0,100.0, 100.0, 100.0, 100.0, 100.0,100.0,100.0 /)

   ! Maximum error check factors:  INV > (Obs_error*factor) --> fails_error_max

   LOGICAL, PARAMETER :: check_max_iv_print = .TRUE.

   REAL, PARAMETER :: max_error_t              = 5, &
                      max_error_uv             = 5, &
                      max_error_pw             = 5, &
                      max_error_ref            = 5, &
                      max_error_rh             = 5, &
                      max_error_q              = 5, &
                      max_error_p              = 5, &
                      max_error_tb             = 5, &
                      max_error_thickness      = 5, &
                      max_error_rv             = 5, &
                      max_error_rf             = 5, &
                      max_error_buv            = 500, &
                      max_error_bt             = 500, &
                      max_error_bq             = 500, &
                      max_error_slp            = 500

   ! Define various ways for bad data to be flagged.  

   INTEGER, PARAMETER ::  &

   missing_data            = -88, &     ! Data is missing with the value of 
                                        ! missing_r
   outside_of_domain       = -77, &     ! Data outside horizontal domain 
                                        ! or time window, data set to missing_r
   wrong_direction         = -15, &     ! Wind vector direction <0 or> 360 
                                        ! => direction set to missing_r
   negative_spd            = -14, &     ! Wind vector norm is negative 
                                        ! => norm set to missing_r
   zero_spd                = -13, &     ! Wind vector norm is zero 
                                        ! => norm set to missing_r
   wrong_wind_data         = -12, &     ! Spike in wind profile 
                                        ! =>direction and norm set to missing_r 
   zero_t_td               = -11, &     ! t or td = 0 => t or td, rh and qv 
                                        ! are set to missing_r, 
   t_fail_supa_inver       = -10, &     ! superadiabatic temperature
                                        ! 
   wrong_t_sign            = - 9, &     ! Spike in Temperature profile 
                                        ! 
   above_model_lid         = - 8, &     ! heigh above model lid
                                        ! => no action
   far_below_model_surface = - 7, &     ! heigh far below model surface
                                        ! => no action
   below_model_surface     = - 6, &     ! height below model surface
                                        ! => no action
   standard_atmosphere     = - 5, &     ! Missing h, p or t
                                        ! =>Datum interpolated from standard atm
   from_background         = - 4, &     ! Missing h, p or t
                                        ! =>Datum interpolated from model
   fails_error_max         = - 3, &     ! Datum Fails error max check
                                        ! => no action
   fails_buddy_check       = - 2, &     ! Datum Fails buddy check
                                        ! => no action
   no_buddies              = - 1, &     ! Datum has no buddies
                                        ! => no action
   good_quality            =   0, &     ! OBS datum has good quality
                                        !
   convective_adjustment   =   1, &     ! convective adjustement check
                                        ! =>apply correction on t, td, rh and qv
   surface_correction      =   2, &     ! Surface datum
                                        ! => apply correction on datum
   Hydrostatic_recover     =   3, &     ! Height from hydrostaic assumption with
                                        ! the OBS data calibration
   Reference_OBS_recover   =   4, &     ! Height from reference state with OBS
                                        ! data calibration
   Other_check             =  88        ! passed other quality check

   ! Observations:

   INTEGER, PARAMETER     :: max_Radar = 10000    ! Maximum Number of Radar obs.

   integer                :: num_procs, &         ! Number of total processors.
                             numb_procs, &         ! Alternative name
                             myproc                ! My processor ID.
   logical                :: rootproc             ! Am I the root processor

   INTEGER, PARAMETER :: var4d_coupling_disk_linear = 1
   INTEGER, PARAMETER :: var4d_coupling_disk_simul  = 2

   ! RTM_INIT setup parameter

   integer, parameter            :: maxsensor = 30

   ! type( rttov_coef ), pointer :: coefs(:)         ! RTTOV coefficients

   ! Tracing

   INTEGER :: trace_start_points=0   ! Number of routines to initiate trace

   INTEGER, PARAMETER :: num_ob_indexes = 23

   INTEGER, PARAMETER :: sound_index          = 1
   INTEGER, PARAMETER :: synop_index          = 2
   INTEGER, PARAMETER :: pilot_index          = 3
   INTEGER, PARAMETER :: satem_index          = 4
   INTEGER, PARAMETER :: geoamv_index         = 5
   INTEGER, PARAMETER :: polaramv_index       = 6
   INTEGER, PARAMETER :: airep_index          = 7
   INTEGER, PARAMETER :: gpspw_index          = 8
   INTEGER, PARAMETER :: gpsref_index         = 9
   INTEGER, PARAMETER :: metar_index          = 10
   INTEGER, PARAMETER :: ships_index          = 11
   INTEGER, PARAMETER :: ssmi_retrieval_index = 12
   INTEGER, PARAMETER :: ssmi_tb_index        = 13
   INTEGER, PARAMETER :: ssmt1_index          = 14
   INTEGER, PARAMETER :: ssmt2_index          = 15
   INTEGER, PARAMETER :: qscat_index          = 16
   INTEGER, PARAMETER :: profiler_index       = 17
   INTEGER, PARAMETER :: buoy_index           = 18
   INTEGER, PARAMETER :: bogus_index          = 19
   INTEGER, PARAMETER :: pseudo_index         = 20
   INTEGER, PARAMETER :: radar_index          = 21
   INTEGER, PARAMETER :: radiance_index       = 22
   INTEGER, PARAMETER :: airsr_index          = 23

   CHARACTER(LEN=14), PARAMETER :: obs_names(num_ob_indexes) = (/ &
      "SOUND         ", &
      "SYNOP         ", &
      "PILOT         ", &
      "SATEM         ", &
      "Geo AMV       ", &
      "Polar AMV     ", &
      "AIREP         ", &
      "GPSPW         ", &
      "GPSRF         ", &
      "METAR         ", &
      "SHIP          ", &
      "SSMI_RETRIEVAL", &
      "SSMI_TB       ", &
      "SSMT1         ", &
      "SSMT2         ", &
      "QSCAT         ", &
      "Profiler      ", &
      "Buoy          ", &
      "Bogus         ", &
      "Pseudo        ", &
      "Radar         ", &
      "Radiance      ", &
      "AIRS retrieval"  &
   /)

   INTEGER, PARAMETER :: max_no_fm = 290

   INTEGER, PARAMETER :: num_ob_vars=9

   LOGICAL, PARAMETER :: in_report(num_ob_vars,2) = RESHAPE((/&
     .FALSE.,.FALSE.,.FALSE.,.FALSE.,.FALSE.,.FALSE.,.FALSE.,.FALSE.,.FALSE., & ! sound
     .TRUE.,.TRUE.,.TRUE.,.TRUE.,.TRUE.,.TRUE.,.FALSE.,.FALSE.,.FALSE./), &
     (/num_ob_vars,2/))

   INTEGER, PARAMETER :: report_h   = 1
   INTEGER, PARAMETER :: report_u   = 2
   INTEGER, PARAMETER :: report_v   = 3
   INTEGER, PARAMETER :: report_t   = 4
   INTEGER, PARAMETER :: report_q   = 5
   INTEGER, PARAMETER :: report_p   = 6
   INTEGER, PARAMETER :: report_rh  = 7
   INTEGER, PARAMETER :: report_slp = 8
   INTEGER, PARAMETER :: report_zk  = 9

   LOGICAL :: obs_use(num_ob_indexes) = .FALSE.



   ! Special cases

   INTEGER, PARAMETER :: fm_satem = 86
   INTEGER, PARAMETER :: fm_amv   = 88

   INTEGER, PARAMETER :: fm_index(max_no_fm) = (/ &
      0,0,0,0,0,0,0,0,0,0,                                & ! 1-10
      0,Synop_index,Ships_index,0,Metar_index,            & ! 11-15
      Metar_index,Ships_index,buoy_index,buoy_index,0,    & ! 16-20
      0,0,0,0,0,0,0,0,0,0,                                & ! 21-30
      0,pilot_index,pilot_index,pilot_index,sound_index,  & ! 31-35
      sound_index,sound_index,sound_index,0,0,            & ! 36-40
      0,airep_index,0,0,0,0,0,0,0,0,                      & ! 41-50
      0,0,0,0,0,0,0,0,0,0,                                & ! 51-60
      0,0,0,0,0,0,0,0,0,0,                                & ! 61-70
      0,0,0,0,0,0,0,0,0,0,                                & ! 71-80
      0,0,0,0,0,satem_index,0,geoamv_index,0,0,           & ! 81-90
      0,0,0,0,0,airep_index,airep_index,0,0,0,            & ! 91-100
      0,0,0,0,0,0,0,0,0,0,                                & ! 101-110
      gpspw_index,0,0,gpspw_index,0,gpsref_index,0,0,0,0, & ! 111-120
      ssmt1_index,ssmt2_index,0,0,0,0,0,0,0,0,            & ! 121-130
      0,profiler_index,airsr_index,0,bogus_index,0,0,0,0,0, & ! 131-140
      0,0,0,0,0,0,0,0,0,0,                                & ! 141-150
      0,0,0,0,0,0,0,0,0,0,                                & ! 151-160
      0,0,0,0,0,0,0,0,0,0,                                & ! 161-170
      0,0,0,0,0,0,0,0,0,0,                                & ! 171-180
      0,0,0,0,0,0,0,0,0,0,                                & ! 181-190
      0,0,0,0,0,0,0,0,0,0,                                & ! 191-200
      0,0,0,0,0,0,0,0,0,0,                                & ! 201-210
      0,0,0,0,0,0,0,0,0,0,                                & ! 211-220
      0,0,0,0,0,0,0,0,0,0,                                & ! 231-230
      0,0,0,0,0,0,0,0,0,0,                                & ! 231-240
      0,0,0,0,0,0,0,0,0,0,                                & ! 241-250
      0,0,0,0,0,0,0,0,0,0,                                & ! 251-260
      0,0,0,0,0,0,0,0,0,0,                                & ! 261-270
      0,0,0,0,0,0,0,0,0,0,                                & ! 271-280
      qscat_index,0,0,0,0,0,0,0,0,0 /)                      ! 281-290

   CHARACTER*120  :: fmt_info ='(a12,1x,a19,1x,a40,1x,i6,3(f12.3,11x),6x,a5)'
   CHARACTER*120  :: fmt_srfc = '(7(:,f12.3,i4,f7.2))'
   CHARACTER*120  :: fmt_each = &
      '(3(f12.3,i4,f7.2),11x,3(f12.3,i4,f7.2),11x,1(f12.3,i4,f7.2))'

CONTAINS

#include "da_advance_cymdh.inc"
#include "da_array_print.inc"
#include "da_change_date.inc"
#include "da_find_fft_factors.inc"
#include "da_find_fft_trig_funcs.inc"
#include "da_gamma.inc"

end module da_constants