subroutine da_proc_sum_count_obs ( count_obs )

   !---------------------------------------------------------------------------
   !  PURPOSE: Do MPI sum operation across processors to get the global sum of
   !           count_obs. The sum is returned only on the root processor,
   !           i.e., processor 0. (In this way, we do not have to do all-to-all 
   !           communication.)
   !
   !  IMPORTANT!!!
   !           The length of sumval and procval arrays are currently 100. 
   !           This number will work till the obs types does not exceed 25  
   !           which is currently 16. This length should be changed accordingly 
   !           if more observation types are added.
   !----------------------------------------------------------------------------

#ifdef DM_PARALLEL
   INCLUDE 'mpif.h'
#endif
   
   integer, parameter:: numvals = 100

   TYPE (count_obs_type), INTENT(INOUT)     :: count_obs

   INTEGER           :: sumval(1:numvals)     ! Sum across processors.
   INTEGER           :: procval(1:numvals)    ! Partial values on processor to sum.
   INTEGER           :: ierr                  ! Error code from MPI routines.
   INTEGER           :: root                  ! Monitor processor.
   INTEGER           :: offset                ! Index into procval and sumval arrays.

#ifdef DM_PARALLEL

   IF (rootproc) root = myproc
   call wrf_dm_bcast_integer ( root, 1 )

   offset = 1
   call da_pack_count_obs( count_obs % num_synop, offset, procval )
   call da_pack_count_obs( count_obs % num_sound, offset, procval )
   call da_pack_count_obs( count_obs % num_sound, offset, procval )
   call da_pack_count_obs( count_obs % num_satem, offset, procval )
   call da_pack_count_obs( count_obs % num_geoamv, offset, procval )
   call da_pack_count_obs( count_obs % num_polaramv, offset, procval )
   call da_pack_count_obs( count_obs % num_metar, offset, procval )
   call da_pack_count_obs( count_obs % num_airep, offset, procval )
   call da_pack_count_obs( count_obs % num_ships, offset, procval )
   call da_pack_count_obs( count_obs % num_pilot, offset, procval )
   call da_pack_count_obs( count_obs % num_gpspw, offset, procval )
   call da_pack_count_obs( count_obs % num_ssmi_retrieval, offset, procval )
   call da_pack_count_obs( count_obs % num_ssmi_tb, offset, procval )
   call da_pack_count_obs( count_obs % num_ssmt1, offset, procval )
   call da_pack_count_obs( count_obs % num_ssmt2, offset, procval )
   call da_pack_count_obs( count_obs % num_qscat, offset, procval )
   call da_pack_count_obs( count_obs % num_profiler, offset, procval )
   call da_pack_count_obs( count_obs % num_bogus, offset, procval )
   call da_pack_count_obs( count_obs % num_buoy, offset, procval )

   call MPI_REDUCE(procval, sumval, numvals, MPI_INTEGER, MPI_SUM, root, MPI_COMM_WORLD, IERR )
   
   IF ( myproc .eq. root ) then
      offset = 1
      call da_unpack_count_obs( count_obs % num_synop, offset, sumval )
      call da_unpack_count_obs( count_obs % num_sound, offset, sumval )
      call da_unpack_count_obs( count_obs % num_sound, offset, sumval )
      call da_unpack_count_obs( count_obs % num_satem, offset, sumval )
      call da_unpack_count_obs( count_obs % num_geoamv, offset, sumval )
      call da_unpack_count_obs( count_obs % num_polaramv, offset, sumval )
      call da_unpack_count_obs( count_obs % num_metar, offset, sumval )
      call da_unpack_count_obs( count_obs % num_airep, offset, sumval )
      call da_unpack_count_obs( count_obs % num_ships, offset, sumval )
      call da_unpack_count_obs( count_obs % num_pilot, offset, sumval )
      call da_unpack_count_obs( count_obs % num_gpspw, offset, sumval )
      call da_unpack_count_obs( count_obs % num_ssmi_retrieval, offset, procval )
      call da_unpack_count_obs( count_obs % num_ssmi_tb, offset, procval )
      call da_unpack_count_obs( count_obs % num_ssmt1, offset, sumval )
      call da_unpack_count_obs( count_obs % num_ssmt2, offset, sumval )
      call da_unpack_count_obs( count_obs % num_qscat, offset, sumval )
      call da_unpack_count_obs( count_obs % num_profiler, offset, sumval )
      call da_unpack_count_obs( count_obs % num_bogus, offset, sumval )
      call da_unpack_count_obs( count_obs % num_buoy, offset, sumval )
   END IF
#endif

end subroutine da_proc_sum_count_obs
