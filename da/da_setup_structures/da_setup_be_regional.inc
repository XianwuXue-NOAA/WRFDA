subroutine da_setup_be_regional(xb, be, xbx, xp)

   !---------------------------------------------------------------------------
   ! PURPOSE: Define and allocate components of background errors
   !---------------------------------------------------------------------------

   IMPLICIT NONE

   TYPE (xb_type), INTENT(IN)  :: xb                    ! First guess structure.
   TYPE (be_type), INTENT(OUT) :: be                    ! Back. errors structure.
   TYPE (xbx_type),INTENT(IN)  :: xbx                   ! Header non-grid info 
   type (xpose_type), intent(in) :: xp   ! Dimensions and xpose buffers.

   INTEGER                     :: nrec, max_wavenumber  ! Scalar.
   INTEGER                     :: i, j, k, m, ic, jc       ! Loop counters.
   INTEGER                     :: ier                   ! error index
   real, allocatable   :: height(:,:,:)      ! Height field.
   integer, allocatable:: bin(:,:,:)         ! Bin assigned to each 3D point
   integer, allocatable:: bin2d(:,:)         ! Bin assigned to each 2D point
   integer             :: bin_type           ! Type of bin to average over.
   integer             :: num_bins           ! Number of bins (3D fields).
   integer             :: num_bins2d         ! Number of bins (3D fields).
   real    :: lat_min, lat_max, binwidth_lat ! Used if bin_type = 2 (degrees)..
   real    :: hgt_min, hgt_max, binwidth_hgt ! Used if bin_type = 2 (m). .
   integer :: num_bins_lat, num_bins_hgt     ! Used if bin_type = 2.

   logical  :: use_global_eofs               ! True if projected data uses global EOFs
   REAL, ALLOCATABLE           :: be1_eval_loc(:,:)     ! Temp arrays.
   REAL, ALLOCATABLE           :: be2_eval_loc(:,:)     ! Temp arrays.
   REAL, ALLOCATABLE           :: be3_eval_loc(:,:)     ! Temp arrays.
   REAL, ALLOCATABLE           :: be4_eval_loc(:,:)     ! Temp arrays.
   REAL, ALLOCATABLE           :: be5_eval_loc(:,:)     ! Temp arrays.

   REAL, ALLOCATABLE           :: be1_eval_glo(:)       ! Global Eigenvalues.
   REAL, ALLOCATABLE           :: be2_eval_glo(:)       ! Global Eigenvalues.
   REAL, ALLOCATABLE           :: be3_eval_glo(:)       ! Global Eigenvalues.
   REAL, ALLOCATABLE           :: be4_eval_glo(:)       ! Global Eigenvalues.
   REAL, ALLOCATABLE           :: be5_eval_glo(:)       ! Global Eigenvalues.

   REAL, ALLOCATABLE           :: be1_evec_loc(:,:,:)   ! Local Eigenvectors.
   REAL, ALLOCATABLE           :: be2_evec_loc(:,:,:)   ! Local Eigenvectors.
   REAL, ALLOCATABLE           :: be3_evec_loc(:,:,:)   ! Local Eigenvectors.
   REAL, ALLOCATABLE           :: be4_evec_loc(:,:,:)   ! Local Eigenvectors.
   REAL, ALLOCATABLE           :: be5_evec_loc(:,:,:)   ! Local Eigenvectors.

   REAL, ALLOCATABLE           :: be1_evec_glo(:,:)     ! Global Eigenvectors.
   REAL, ALLOCATABLE           :: be2_evec_glo(:,:)     ! Global Eigenvectors.
   REAL, ALLOCATABLE           :: be3_evec_glo(:,:)     ! Global Eigenvectors.
   REAL, ALLOCATABLE           :: be4_evec_glo(:,:)     ! Global Eigenvectors.
   REAL, ALLOCATABLE           :: be5_evec_glo(:,:)     ! Global Eigenvectors.

   REAL, ALLOCATABLE           :: be1_rf_lengthscale(:) ! RF lengthscale.
   REAL, ALLOCATABLE           :: be2_rf_lengthscale(:) ! RF lengthscale.
   REAL, ALLOCATABLE           :: be3_rf_lengthscale(:) ! RF lengthscale.
   REAL, ALLOCATABLE           :: be4_rf_lengthscale(:) ! RF lengthscale.
   REAL, ALLOCATABLE           :: be5_rf_lengthscale(:)
   REAL, ALLOCATABLE           :: alpha_rf_lengthscale(:)

   real, allocatable           :: evec_loc(:,:,:)        ! Latitudinally varying eigenvectors.
   real, allocatable           :: eval_loc(:,:)          ! Latitudinally varying eigenvalues.

   character*10                :: variable
   integer                     :: ni, nj, nk, nk_2d, b, nlev           
   integer                     :: ix, jy, kz
   real, allocatable           :: regcoeff1(:)
   real, allocatable           :: regcoeff2(:,:)
   real, allocatable           :: regcoeff3(:,:,:)
   real                        :: avg,avg2,avg3

   IF (trace_use) call da_trace_entry("da_setup_be_regional")

   write (UNIT=stdout,FMT='(A)') &
      ' -------------------------------------------------------'
   write (UNIT=stdout,FMT='(A)') &
      ' [3.0] Set up background errors for regional application'
   write (UNIT=stdout,FMT='(A)') &
      ' -------------------------------------------------------'
   write (UNIT=stdout,FMT=*) ' '

   be % v1 % name = 'psi  '           ! Streamfunction
   be % v2 % name = 'chi_u'           ! Uncorrelated velocity potential.
   be % v3 % name = 't_u'             ! Unbalanced temperature.
   be % v4 % name = 'q/qsg'
   be % v5 % name = 'psfc'            ! surface pressure

   write(UNIT=stdout,FMT='(3x,A)')' da_setup_be_regional: WRF-Var dry control variables are:'
   write(UNIT=stdout,FMT='(4x,7A)') &
      TRIM(be % v1 % name), ', ', TRIM(be % v2 % name), ', ', &
      TRIM(be % v3 % name), ' and ', TRIM(be % v5 % name)

   write(UNIT=stdout,FMT='(3x,A,A)') &
      ' da_setup_be_regional: humidity control variable is ',&
      TRIM(be % v4 % name)

   write(UNIT=stdout,FMT=*) ' '

   ix = xb % mix
   jy = xb % mjy
   kz = xb % mkz

   rewind (be_unit)
   read(be_unit) ni, nj, nk

   allocate( bin(1:ni,1:nj,1:nk) )
   allocate( bin2d(1:ni,1:nj) )

   read(be_unit)bin_type
   read(be_unit)lat_min, lat_max, binwidth_lat
   read(be_unit)hgt_min, hgt_max, binwidth_hgt
   read(be_unit)num_bins, num_bins2d
   read(be_unit)bin(1:ni,1:nj,1:nk)
   read(be_unit)bin2d(1:ni,1:nj)

   ! 1.1 Read in regression coefficients

   allocate (regcoeff1(1:num_bins))
   allocate (regcoeff2(1:nk,1:num_bins2d))
   allocate (regcoeff3(1:nk,1:nk,1:num_bins2d))

   read(be_unit) regcoeff1  
   read(be_unit) regcoeff2 
   read(be_unit) regcoeff3  

   ! 1.2 Fill regression coeff. array

   allocate (be%reg_chi(1:nj,1:nk))
   allocate (be%reg_ps (1:nj,1:nk))
   allocate (be%reg_t  (1:nj,1:nk,1:nk))

   do k=1,nk
      do j =1, nj
         b = bin(1,j,k)
         be%reg_chi(j,k) = regcoeff1(b)
      end do
   end do

   do j=1,nj
      b = bin2d(1,j)
      do k=1,nk
       be%reg_ps(j,k) = regcoeff2(k,b)
      end do
   end do

   do j=1,nj
      b = bin2d(1,j)
      do i=1,nk
      do k=1,nk
       be%reg_t(j,i,k) = regcoeff3(i,k,b)
      end do
      end do
   end do

   ! write(901,'(10e13.5)') ((be%reg_chi (j,k),j=1,num_bins2d),k=1,nk)
   ! write(902,'(10e13.5)') ((be%reg_ps (j,k),j=1,num_bins2d),k=1,nk)
   ! write(903,'(10e13.5)') ((be%reg_t (j,k,k),j=1,num_bins2d),k=1,nk)

   ! 1.3 Domain_averaged regression coefficients

   if (.not.lat_stats_option) then
      write(UNIT=stdout, fmt='(/5x, a/)') &
         '*** Using the averaged regression coefficients for unbalanced part ***'

      do k=1,nk
         avg= 0.0
         avg2=0.0
         do j=1,num_bins2d
            avg= avg + be%reg_ps (j,k)/float(num_bins2d) 
            avg2= avg2 + be%reg_chi (j,k)/float(num_bins2d) 
         enddo

         do j=1,num_bins2d
            be%reg_ps(j,k)=avg
            be%reg_chi (j,k)=avg2
         enddo
      enddo

      do m=1,nk
         do k=1,nk
            avg3= 0.0

            do j=1,num_bins2d
               avg3= avg3 + be%reg_t (j,k,m)/float(num_bins2d)
            enddo

            do j=1,num_bins2d
               be%reg_t(j,k,m)=avg3
            enddo
         enddo
      enddo
   else
      write(UNIT=stdout, fmt='(/5x, a/)') &
         '*** Using the latitude-dependent regression coefficients for unbalanced part ***'
   endif
    
   ! 2.0 Load the eigenvector and eigenvalue

   ALLOCATE ( be1_eval_loc (1:jy,1:kz) )
   ALLOCATE ( be2_eval_loc (1:jy,1:kz) )
   ALLOCATE ( be3_eval_loc (1:jy,1:kz) )
   ALLOCATE ( be4_eval_loc (1:jy,1:kz) )
   ALLOCATE ( be5_eval_loc (1:jy,1:1 ) )

   IF (vert_corr == 2) THEN

      ALLOCATE ( be1_eval_glo(1:kz) )
      ALLOCATE ( be2_eval_glo(1:kz) )
      ALLOCATE ( be3_eval_glo(1:kz) )
      ALLOCATE ( be4_eval_glo(1:kz) )
      ALLOCATE ( be5_eval_glo(1:1) )

      ALLOCATE ( be1_evec_loc(1:jy,1:kz,1:kz))
      ALLOCATE ( be2_evec_loc(1:jy,1:kz,1:kz))
      ALLOCATE ( be3_evec_loc(1:jy,1:kz,1:kz))
      ALLOCATE ( be4_evec_loc(1:jy,1:kz,1:kz))
      ALLOCATE ( be5_evec_loc(1:jy,1: 1,1: 1))

      ALLOCATE ( be1_evec_glo(1:kz,1:kz) )
      ALLOCATE ( be2_evec_glo(1:kz,1:kz) )
      ALLOCATE ( be3_evec_glo(1:kz,1:kz) )
      ALLOCATE ( be4_evec_glo(1:kz,1:kz) )
      ALLOCATE ( be5_evec_glo(1:1,1:1) )
   END IF

   ! 2.2 Read in the eigenvector and eigenvalue 

   ! 2.2.1 Control variable 1 (psi)

   read(be_unit) variable
   read(be_unit) nk, num_bins2d
   read(be_unit)  be1_evec_glo
   read(be_unit)  be1_eval_glo
   allocate( evec_loc(1:nk,1:nk,1:num_bins2d) )
   allocate( eval_loc(1:nk,     1:num_bins2d) )
   read(be_unit)  evec_loc
   read(be_unit)  eval_loc
   if (variable(1:3) /= 'psi') then
      errmsg(1)=' Variable mismatch while transfering eigen values from BE file '
      write(unit=errmsg(2),FMT='(A,A)') ' Expected psi but got ',variable
      call da_error(__FILE__,__LINE__,errmsg(1:2))
   endif
   be % v1 % name = variable
   do j=1,nj
      b = bin2d(1,j)
      be1_evec_loc(j,1:nk,1:nk) = evec_loc(1:nk,1:nk,b)
      be1_eval_loc(j,1:nk     ) = eval_loc(1:nk,b)
   enddo

   ! 2.2.2 Control variable 2 (chi_u)

   read(be_unit) variable
   read(be_unit) nk, num_bins2d
   read(be_unit)  be2_evec_glo
   read(be_unit)  be2_eval_glo
   read(be_unit)  evec_loc
   read(be_unit)  eval_loc
   if (variable(1:5) /= 'chi_u') then
      errmsg(1)=' Variable mismatch while transfering eigen values from BE file '
      write(unit=errmsg(2),FMT='(A,A)') ' Expected chi_u but got ',variable
      call da_error(__FILE__,__LINE__,errmsg(1:2))
   endif
   be % v2 % name = variable
   do j=1,nj
      b = bin2d(1,j)
      be2_evec_loc(j,1:nk,1:nk) = evec_loc(1:nk,1:nk,b)
      be2_eval_loc(j,1:nk     ) = eval_loc(1:nk,b)
   enddo

   ! 2.2.3 Control variable 3 (t_u)
   read(be_unit) variable
   read(be_unit) nk, num_bins2d
   read(be_unit)  be3_evec_glo
   read(be_unit)  be3_eval_glo
   read(be_unit)  evec_loc
   read(be_unit)  eval_loc
   if (variable(1:3) /= 't_u') then
      errmsg(1)=' Variable mismatch while transfering eigen values from BE file '
      write(unit=errmsg(2),FMT='(A,A)') ' Expected t_u but got ',variable
      call da_error(__FILE__,__LINE__,errmsg(1:2))
   endif
   be % v3 % name = variable
   do j=1,nj
      b = bin2d(1,j)
      be3_evec_loc(j,1:nk,1:nk) = evec_loc(1:nk,1:nk,b)
      be3_eval_loc(j,1:nk     ) = eval_loc(1:nk,b)
   enddo

   ! 2.2.4 Control variable 4 (q/qsg)

   read(be_unit) variable
   read(be_unit) nk, num_bins2d
   read(be_unit)  be4_evec_glo
   read(be_unit)  be4_eval_glo
   read(be_unit)  evec_loc
   read(be_unit)  eval_loc
   if (variable(1:3) /= 'rh') then
      errmsg(1)=' Variable mismatch while transfering eigen values from BE file '
      write(unit=errmsg(2),FMT='(A,A)') ' Expected rh but got ',variable
      call da_error(__FILE__,__LINE__,errmsg(1:2))
   endif
   be % v4 % name = variable
   do j=1,nj
      b = bin2d(1,j)
      be4_evec_loc(j,1:nk,1:nk) = evec_loc(1:nk,1:nk,b)
      be4_eval_loc(j,1:nk     ) = eval_loc(1:nk,b)
   enddo

   deallocate ( evec_loc )
   deallocate ( eval_loc )

   ! 2.2.5 Control variable ps_u

   read(be_unit) variable
   read(be_unit) nk_2d, num_bins2d
   allocate( evec_loc(1:nk_2d,1:nk_2d,1:num_bins2d) )
   allocate( eval_loc(1:nk_2d,        1:num_bins2d) )
   read(be_unit)  be5_evec_glo
   read(be_unit)  be5_eval_glo
   read(be_unit)  evec_loc
   read(be_unit)  eval_loc
   if (variable(1:4) /= 'ps_u') then
      errmsg(1)=' Variable mismatch while transfering eigen values from BE file '
      write(unit=errmsg(2),FMT='(A,A)') ' Expected ps_u but got ',variable
      call da_error(__FILE__,__LINE__,errmsg(1:2))
   endif
   be % v5 % name = variable
   do j=1,nj
      b = bin2d(1,j)
      be5_evec_loc(j,1:1,1:1) = evec_loc(1:1,1:1,b)
      be5_eval_loc(j,1:1    ) = eval_loc(1:1,b)
   enddo

   deallocate ( evec_loc )
   deallocate ( eval_loc )

   ! 3.0 Check and get the truncated number of the vertical modes
   ! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   IF ( vert_corr == 2 ) THEN

      ! 3.1 Perform checks on eigenvectors:

      IF ( test_statistics ) THEN
         call da_check_eof_decomposition( be1_eval_glo(:), be1_evec_glo(:,:), be % v1 % name)
         call da_check_eof_decomposition( be2_eval_glo(:), be2_evec_glo(:,:), be % v2 % name)
         call da_check_eof_decomposition( be3_eval_glo(:), be3_evec_glo(:,:), be % v3 % name)
         call da_check_eof_decomposition( be4_eval_glo(:), be4_evec_glo(:,:), be % v4 % name)
      END IF

      ! 3.2 Truncate in vertical:

      call da_get_vertical_truncation( max_vert_var1, be1_eval_glo(:), be % v1 )
      call da_get_vertical_truncation( max_vert_var2, be2_eval_glo(:), be % v2 )
      call da_get_vertical_truncation( max_vert_var3, be3_eval_glo(:), be % v3 )
      call da_get_vertical_truncation( max_vert_var4, be4_eval_glo(:), be % v4 )

      be % v5 % mz = 1

      write(UNIT=stdout,FMT=*) ' '

   ELSE

      ! 3.3 no truncated

      be % v1 % mz = xb % mkz
      be % v2 % mz = xb % mkz
      be % v3 % mz = xb % mkz
      be % v4 % mz = xb % mkz
      be % v5 % mz = xb % mkz

   END IF

   ! 4.0 Initialise control variable space components of header:
   ! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   ! 4.1 Compute the size of the control variables

   be % mix = ix
   be % mjy = jy

   ! 4.2 Transfer errors to error structure:

   call da_allocate_background_errors( jy, kz, be1_eval_glo, be1_evec_glo, be1_eval_loc, &
                                       be1_evec_loc, be % v1 )
   call da_allocate_background_errors( jy, kz, be2_eval_glo, be2_evec_glo, be2_eval_loc, &
                                       be2_evec_loc, be % v2 )
   call da_allocate_background_errors( jy, kz, be3_eval_glo, be3_evec_glo, be3_eval_loc, &
                                       be3_evec_loc, be % v3 )
   call da_allocate_background_errors( jy, kz, be4_eval_glo, be4_evec_glo, be4_eval_loc, &
                                       be4_evec_loc, be % v4 )

   ! 4.2.1 transfer the ps_u variance to be % v5:

   call da_allocate_background_errors( jy,  1, be5_eval_glo, be5_evec_glo, be5_eval_loc, &
                                       be5_evec_loc, be % v5 )

   IF (print_detail_be) THEN
      WRITE(UNIT=stdout,FMT='(2x,a,i10)') "b) Finished eigenvector processing!"
   END IF

   ! 5.0 Load the scale lengths
   ! ~~~~~~~~~~~~~~~~~~~~~~~~~~

   ! 5.1 Allocate the array for scale lengths

   allocate ( be1_rf_lengthscale(1:nk) )
   allocate ( be2_rf_lengthscale(1:nk) )
   allocate ( be3_rf_lengthscale(1:nk) )
   allocate ( be4_rf_lengthscale(1:nk) )
   allocate ( be5_rf_lengthscale(1:nk) )

   ! 5.2 read in the scale lengths

   read(be_unit) variable
   read(be_unit) be1_rf_lengthscale

   read(be_unit) variable
   read(be_unit) be2_rf_lengthscale

   read(be_unit) variable
   read(be_unit) be3_rf_lengthscale

   read(be_unit) variable
   read(be_unit) be4_rf_lengthscale

   read(be_unit) variable
   read(be_unit) be5_rf_lengthscale(1:1)
   be%v5%name = variable

   ! 5.3 Convert the scale lengths in the real distance (meter)

   be1_rf_lengthscale(1:nk) = be1_rf_lengthscale(1:nk) * xb%ds
   be2_rf_lengthscale(1:nk) = be2_rf_lengthscale(1:nk) * xb%ds
   be3_rf_lengthscale(1:nk) = be3_rf_lengthscale(1:nk) * xb%ds
   be4_rf_lengthscale(1:nk) = be4_rf_lengthscale(1:nk) * xb%ds
   be5_rf_lengthscale(1:1)  = be5_rf_lengthscale(1:1)  * xb%ds

   ! 6.0 Perform checks on eigenvectors with be data structure:
   ! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   IF ( test_statistics ) THEN
      call da_check_eof_decomposition( be%v1%val_g(:), be%v1%evec_g(:,:),&
                                     be%v1%name)
      call da_check_eof_decomposition( be%v2%val_g(:), be%v2%evec_g(:,:),&
                                     be%v2%name)
      call da_check_eof_decomposition( be%v3%val_g(:), be%v3%evec_g(:,:),&
                                     be%v3%name)
      call da_check_eof_decomposition( be%v4%val_g(:), be%v4%evec_g(:,:),&
                                     be%v4%name)
   END IF

   ! 6.2 Close the be unit

   close(be_unit)

   ! 7.0 Apply empirical and recursive filter rescaling factor:
   ! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   call da_rescale_background_errors( ix, jy, var_scaling1, len_scaling1, &
                                      xb % ds, be1_rf_lengthscale, be % v1 )
   call da_rescale_background_errors( ix, jy, var_scaling2, len_scaling2, &
                                      xb % ds, be2_rf_lengthscale, be % v2 )
call da_oi(__FILE__,__LINE__)
   call da_rescale_background_errors( ix, jy, var_scaling3, len_scaling3, &
                                      xb % ds, be3_rf_lengthscale, be % v3 )
call da_oi(__FILE__,__LINE__)
   call da_rescale_background_errors( ix, jy, var_scaling4, len_scaling4, &
                                      xb % ds, be4_rf_lengthscale, be % v4 )
   call da_rescale_background_errors( ix, jy, var_scaling5, len_scaling5, &
                                      xb % ds, be5_rf_lengthscale, be % v5 )

   ! 8.0 Deallocate input model state:
   ! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   DEALLOCATE ( be1_eval_loc )
   DEALLOCATE ( be2_eval_loc )
   DEALLOCATE ( be3_eval_loc )
   DEALLOCATE ( be4_eval_loc )
   DEALLOCATE ( be5_eval_loc )

   IF ( vert_corr == 2 ) THEN
      DEALLOCATE ( be1_eval_glo )
      DEALLOCATE ( be2_eval_glo )
      DEALLOCATE ( be3_eval_glo )
      DEALLOCATE ( be4_eval_glo )
      DEALLOCATE ( be5_eval_glo )

      DEALLOCATE ( be1_evec_loc )
      DEALLOCATE ( be2_evec_loc )
      DEALLOCATE ( be3_evec_loc )
      DEALLOCATE ( be4_evec_loc )
      DEALLOCATE ( be5_evec_loc )

      DEALLOCATE ( be1_evec_glo )
      DEALLOCATE ( be2_evec_glo )
      DEALLOCATE ( be3_evec_glo )
      DEALLOCATE ( be4_evec_glo )
      DEALLOCATE ( be5_evec_glo )

   END IF

   deallocate( bin )
   deallocate( bin2d )

   if ( be % ne > 0 ) then
      be % alpha % mz = be % ne
      be % alpha % name = 'alpha'

      ALLOCATE ( be5_eval_loc (1:1,1:num_bins2d) )
      ALLOCATE ( be5_eval_glo(1:1) )
      ALLOCATE ( be5_evec_loc(1:1,1:1,1:num_bins2d) )
      ALLOCATE ( be5_evec_glo(1:1,1:1) )

      ! Transfer the alpha standard deviation to be % alpha:
      allocate( be % alpha % val(1:jy,1:be % ne) )
      allocate( be % alpha % evec(1:jy,1:kz,1:be % ne) )
      allocate( be % alpha % rf_alpha(1:be % ne) )

      be % alpha % val(1:jy,1:be % ne) = alpha_std_dev
      be % alpha % evec(1:jy,1:kz,1:be % ne) = 1.0
      be % alpha % rf_alpha(1:be % ne) = 1.0 

      ! Include alpha lengthscale info:
      allocate ( alpha_rf_lengthscale(1:be % ne) )
      alpha_rf_lengthscale(:) = 1000.0 * alpha_corr_scale ! Convert km to m.

      call da_rescale_background_errors( ix, jy, 1.0, 1.0, &
         xb % ds, alpha_rf_lengthscale, be % alpha )
   else
      be % alpha % mz = 0
   end if

   IF (trace_use) call da_trace_exit("da_setup_be_regional")

end subroutine da_setup_be_regional

