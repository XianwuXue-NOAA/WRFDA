!MEDIATION_LAYER:SOLVE_DA

SUBROUTINE da_solve ( grid , config_flags , &
#include "em_dummy_new_args.inc"
                 )

   ! Driver layer modules
   USE module_domain
   USE module_configure
   USE module_driver_constants
   USE module_machine
   USE module_tiles
   USE module_dm
   ! Mediation layer modules
   ! Model layer modules
   USE module_model_constants

   use da_constants
   use da_define_structures
   use da_setup_structures
   use da_test
   use da_tools
   use da_minimisation
   use da_par_util
   use da_tracing
   use da_reporting
   use module_get_file_names ! for system interface on cray

   ! Registry generated module
   USE module_state_description

   IMPLICIT NONE

   TYPE(domain),                intent(inout) :: grid
   TYPE (grid_config_rec_type), intent(inout) :: config_flags

   ! Definitions of dummy arguments to solve
#include "em_dummy_new_decl.inc"

   TYPE (xbx_type)              :: xbx         ! For header & non-grid arrays.
   TYPE (be_type)               :: be          ! Background error structure.
   real, allocatable            :: cvt(:)      ! Control variable structure.
   real, allocatable            :: xhat(:)     ! Control variable structure.
   TYPE (y_type)                :: ob          ! Observation structure.
   TYPE (ob_type)               :: iv          ! Obs. increment structure.
   TYPE (y_type)                :: re          ! Residual (o-a) structure.
   TYPE (y_type)                :: y           ! y = H(x_inc) structure.
   INTEGER                      :: it          ! External loop counter.
   type (j_type)                :: j           ! Cost function.

   INTEGER                      :: ids , ide , jds , jde , kds , kde , &
                                   ims , ime , jms , jme , kms , kme , &
                                   its , ite , jts , jte , kts , kte

   integer                      :: cv_size
   real                         :: j_grad_norm_target ! TArget j norm.
#ifdef DM_PARALLEL
   integer                      :: ierr,comm
#endif

   IF (trace_use) call da_trace_entry("da_solve")

   !---------------------------------------------------------------------------
   ! If it is verification run set check_max_iv as .false.
   !---------------------------------------------------------------------------

   if ((analysis_type(1:6)=="VERIFY" .or. analysis_type(1:6) == "verify")) then
      check_max_iv = .false.
   endif

   IF ( cv_options_hum < 1 .OR. cv_options_hum > 3 ) THEN
      WRITE(UNIT=errmsg(1),FMT='(A,I3)') &
         'Invalid cv_options_hum = ', cv_options_hum
      call wrf_error_fatal(errmsg(1))
   END IF

   IF ( vert_corr == 2 ) THEN
      IF ( vertical_ip < 0 .OR. vertical_ip > 2 ) THEN
         WRITE (UNIT=errmsg(1),FMT='(A,I3)') &
           'Invalid vertical_ip = ', &
           vertical_ip
         call da_warning(__FILE__,__LINE__,errmsg(1:1))
      END IF
   END IF

   IF ( 0.5 * REAL(rf_passes) /= REAL(rf_passes / 2) ) THEN
      WRITE(UNIT=stdout,FMT='(A,I4,A)')'rf_passes = ', &
                         rf_passes, ' .Should be even.'
      rf_passes = INT( REAL( rf_passes / 2 ) )
      WRITE(UNIT=stdout,FMT='(A,I4)') 'Resetting rf_passes = ', rf_passes
   END IF

   if ( analysis_type == 'randomcv' ) then
      ntmax = 0
      write(UNIT=stdout)' Resetting ntmax = 0 for analysis_type = randomcv' 
   end if

   !---------------------------------------------------------------------------
   ! [2.0] Initialise wrfvar parameters:
   !---------------------------------------------------------------------------

   call da_solve_init( grid, grid%xp, grid%xb, &
                       ids, ide, jds, jde, kds, kde, &
                       ims, ime, jms, jme, kms, kme, &
                       its, ite, jts, jte, kts, kte )

   !---------------------------------------------------------------------------
   ! [3.0] Set up first guess field (grid%xb):
   !---------------------------------------------------------------------------

   call da_setup_firstguess( xbx, grid, &
#include "em_dummy_new_args.inc"
                           )

   !---------------------------------------------------------------------------
   ! [4.0] Set up observations (ob):
   !---------------------------------------------------------------------------

   call da_setup_obs_structures( grid%xp, ob, iv )

   !---------------------------------------------------------------------------
   ! [5.0] Set up background errors (be):
   !---------------------------------------------------------------------------

   call da_setup_background_errors( grid%xb, xbx, be, grid%xp, &
                                    its, ite, jts, jte, kts, kte, &
                                    ids, ide, jds, jde, kds, kde )
   cv_size = be % cv % size

   !---------------------------------------------------------------------------
   ! [6.0] Set up ensemble perturbation input:
   !---------------------------------------------------------------------------

   grid%ep % ne = be % ne
   if (be % ne > 0) THEN
      call da_setup_flow_predictors( ide, jde, kde, be % ne, grid%ep )
   end if

   !---------------------------------------------------------------------------
   ! [7.0] Setup control variable (cv):
   !---------------------------------------------------------------------------

   allocate( cvt(1:cv_size) )
   allocate( xhat(1:cv_size) )
   call da_initialize_cv( cv_size, cvt )
   call da_initialize_cv( cv_size, xhat )
      
   call da_zero_vp_type( grid%vv )
   call da_zero_vp_type( grid%vp )

   if ( test_transforms .or. Testing_WRFVAR ) then
      call da_get_innov_vector( it, ob, iv, &
                                grid , config_flags , &
#include "em_dummy_new_args.inc"
                 )

      call da_allocate_y( iv, re )
      call da_allocate_y( iv, y )

      allocate( cvt(1:cv_size) )
      allocate( xhat(1:cv_size) )
      call da_initialize_cv( cv_size, cvt )
      call da_initialize_cv( cv_size, xhat )

      call da_check( cv_size, grid%xb, xbx, be, grid%ep, iv, &
                     grid%xa, grid%vv, grid%vp, grid%xp, ob, y, &
                     ids, ide, jds, jde, kds, kde, &
                     ims, ime, jms, jme, kms, kme, &
                     its, ite, jts, jte, kts, kte )
      call da_zero_vp_type( grid%vv )
      call da_zero_vp_type( grid%vp )
   endif

   !---------------------------------------------------------------------------
   ! [8] Outerloop
   !---------------------------------------------------------------------------

   j_grad_norm_target = 1.0

   DO it = 1, max_ext_its

      ! [8.1] Calculate nonlinear model trajectory 

      if (var4d) then
         call da_trace("da_solve","Starting da_run_wrf_nl.ksh")
#ifdef DM_PARALLEL
         if (var4d_coupling == var4d_coupling_disk_simul) then
            call da_system_4dvar("da_run_wrf_nl.ksh pre ")
            ! call system("./wrf.exe -rmpool 1")
            IF (rootproc) THEN
               call system("rm -rf nl/wrf_done")
               call system("touch nl/wrf_go_ahead")
               DO WHILE ( .true. )
                  OPEN(wrf_done_unit,file="wrf_done",status="old",err=303)
                  CLOSE(wrf_done_unit)
                  EXIT
303                  CONTINUE
                  CALL system("sync")
                  CALL system("slegrid%ep 1")
               ENDDO
            ENDIF
            CALL wrf_get_dm_communicator ( comm )
            CALL mpi_barrier( comm, ierr )

            call da_system_4dvar("da_run_wrf_nl.ksh post ")
         else
            call system("da_run_wrf_nl.ksh")
         end if
#else
         call system("da_run_wrf_nl.ksh")
#endif
         call da_trace("da_solve","Finished da_run_wrf_nl.ksh")
      endif

      ! [8.2] Calculate innovation vector (O-B):

      call da_get_innov_vector( it, ob, iv, &
                                grid , config_flags , &
#include "em_dummy_new_args.inc"
                 )

      if (test_transforms) then
         call da_check( cv_size, grid%xb, xbx, be, grid%ep, iv, &
                        grid%xa, grid%vv, grid%vp, grid%xp, ob, y, &
                        ids, ide, jds, jde, kds, kde, &
                        ims, ime, jms, jme, kms, kme, &
                        its, ite, jts, jte, kts, kte )
      end if

      if (testing_wrfvar) then
         call da_check( cv_size, grid%xb, xbx, be, grid%ep, iv, &
                        grid%xa, grid%vv, grid%vp, grid%xp, ob, y, &
                        ids, ide, jds, jde, kds, kde, &
                        ims, ime, jms, jme, kms, kme, &
                        its, ite, jts, jte, kts, kte )
      end if

      ! Write "clean" QCed observations if requested:
      if ((analysis_type(1:6) == "QC-OBS" .or. &
           analysis_type(1:6) == "qc-obs")) then
         if (it == 1) then
            CALL da_write_filtered_obs(ob, iv, grid%xb, grid%xp, &
                          grid%moad_cen_lat, grid%stand_lon,&
                          grid%truelat1, grid%truelat2 )
         end if     
      endif

      if (lmonitoring) call wrf_shutdown

      ! [8.3] Interpolate x_g to low resolution grid

      ! [8.4] Minimize cost function:

      call da_allocate_y( iv, re )
      call da_allocate_y( iv, y )

      call da_minimise_cg( grid, config_flags,                  &
                           it, be % cv % size, & 
                           grid%xb, xbx, be, grid%ep, iv, &
                           j_grad_norm_target, xhat, cvt, &
                           grid%xa, grid%vv, grid%vp, grid%xp, re, y, j,    &
                           ids, ide, jds, jde, kds, kde,        &
                           ims, ime, jms, jme, kms, kme,        &
                           its, ite, jts, jte, kts, kte         )

      !------------------------------------------------------------------------

      ! [8.5] Update latest analysis solution:

      call da_transform_vtox( cv_size, grid%xb, xbx, be, grid%ep, xhat, grid%vv, grid%vp, grid%xp, grid%xa,  &
                              ids, ide, jds, jde, kds, kde,             &
                              ims, ime, jms, jme, kms, kme,             &
                              its, ite, jts, jte, kts, kte )

      ! [8.6] Only when use_RadarObs = .false. and W_INCREMENTS =.true.,
      !       the W_increment need to be diagnosed:

      if (W_INCREMENTS .and. .not. use_RadarObs) then
         call da_uvprho_to_w_lin( grid%xb, grid%xa, grid%xp,                 &
                                  ids,ide, jds,jde, kds,kde,  &
                                  ims,ime, jms,jme, kms,kme,  &
                                  its,ite, jts,jte, kts, kte )

         call wrf_dm_halo(grid%xp%domdesc,grid%xp%comms,grid%xp%halo_id13)
      endif

      ! [8.7] Write out diagnostics

      call da_write_diagnostics( ob, iv, re, y, grid%xp, grid%xa, j )

      ! [8.8] Write Ascii radiance OMB and OMA file

      if ( lwrite_oa_rad_ascii ) then
        write(UNIT=stdout,FMT=*)  ' writing radiance OMB and OMA ascii file'
        CALL da_write_oa_rad_ascii(grid%xp,ob,iv,re)
      end if

      !------------------------------------------------------------------------
      ! [8.0] Output WRFVAR analysis and analysis increments:
      !------------------------------------------------------------------------

      call da_transfer_xatoanalysis( it, xbx, grid, config_flags ,&
#include "em_dummy_new_args.inc"
         )
   END DO

   !---------------------------------------------------------------------------
   ! [9.0] Tidy up:
   !---------------------------------------------------------------------------

   deallocate ( cvt )
   deallocate ( xhat )
   call da_deallocate_obs(iv)
   call da_deallocate_y( re )
   call da_deallocate_y( y )

   call wrf_message("*** WRF-Var completed successfully ***")

   IF (trace_use) call da_trace_exit("da_solve")

CONTAINS

#include "da_solve_init.inc"

end subroutine da_solve
