subroutine da_scan_ssmi (iunit, ob, xp, filename)

   !---------------------------------------------------------------------------
   ! Read the header of a MM5 3D-VAR 2.0 GTS observation file
   !---------------------------------------------------------------------------

   implicit none

   INTEGER,          INTENT(in)    :: iunit
   TYPE(xpose_type), INTENT(IN)    :: xp    ! Domain decomposition vars.
   TYPE(ob_type),    INTENT(inout) :: ob
   CHARACTER(*), INTENT(in)        :: filename

   CHARACTER (LEN =  10)        :: fmt_name

   CHARACTER (LEN = 160)        :: fmt_info,    &
                                   fmt_loc
   CHARACTER (LEN = 40)         :: obs_platform
   CHARACTER (LEN = 120)        :: char_ned

   INTEGER                      :: i, j, k, i1, j1, k1, iost, fm
   REAL                         :: dx, dxm, dy, dym, dz, dzm

   TYPE (model_loc_type)        :: loc
   TYPE (info_type)             :: info
   TYPE (field_type)            :: speed, tpw

   TYPE (field_type)            :: tb19v, tb19h, tb22v
   TYPE (field_type)            :: tb37v, tb37h, tb85v, tb85h

   LOGICAL                      :: isfilter,ipass 
   LOGICAL                      :: outside, inside_halo
   INTEGER                      :: irain, iprecip

   isfilter = .true. ! filter out rain points
   irain = 0

   ob%ob_numb(ob%current_ob_time)%ssmi_retrieval = ob%num_ssmi_retrieval
   ob%ob_numb(ob%current_ob_time)%ssmi_tb        = ob%num_ssmi_tb

   ! OPEN FILE

   OPEN(UNIT   = iunit,     &
        FILE   = trim(filename), &
        FORM   = 'FORMATTED',  &
        ACCESS = 'SEQUENTIAL', &
        IOSTAT =  iost,     &
        STATUS = 'OLD')

   IF (iost /= 0) THEN
      write(UNIT=stdout, fmt='(/A,I3,3(2X,A)/)') &
           'ERROR IN SSMI INPUT FILE UNIT ',iunit, &
           'SSMI FILENAME:', trim(filename), &
           'FOR SSMI CANNOT BE FOUND OR CANNOT BE OPENED'
      RETURN
   ENDIF

   REWIND (UNIT = iunit)

   ! 2.  READ HEADER
   ! ===============

   ! 2.1 READ FIRST LINE
   !     ---------------

   READ (UNIT = iunit, FMT = '(A)', IOSTAT = iost) char_ned

   ! 2.2 PROCESS ERROR
   !     -------------

   IF (iost /= 0) THEN
      write(unit=stderr, fmt='(/a,i3/)') &
           'ERROR READING FILE UNIT:', iunit, &
           'ERROR CODE:', iost

      return
   else
      write(UNIT=stdout, fmt='(/2a/)') &
           'in da_scan_ssmi.inc, char_ned=', trim(char_ned)
   ENDIF

   ! 2.3 READ NUMBER OF REPORTS
   !     ---------------------

   DO
      READ (UNIT = iunit, FMT = '(A)', IOSTAT = iost) char_ned

      IF (iost /= 0) THEN
         write(unit=stderr, fmt='(/a,i3/)') &
              'ERROR READING FILE UNIT:', iunit, &
              'ERROR CODE:', iost

         return
      ENDIF

      if (char_ned(1:6) == 'NESTIX') EXIT
   ENDDO

   DO
      READ (UNIT = iunit, FMT = '(A)', IOSTAT = iost) char_ned
      if (char_ned(1:6) == 'INFO  ') EXIT
   ENDDO

   READ (UNIT = iunit, FMT = '(A)', IOSTAT = iost) char_ned

   ! READ FORMATS
   ! ------------

   READ (UNIT=iunit, FMT = '(A,1X,A)') &
        fmt_name, fmt_info, &
        fmt_name, fmt_loc

   ! SKIP 1 line
   ! -----------

   READ (UNIT=iunit, FMT = '(A)') fmt_name

   !  WRITE (UNIT = stdout, FMT = '(/,2(A,F3.0,/))')  &
   !     'Error max test ratio for SWS = ',max_error_uv,  &
   !     'Error max test ratio for PW  = ',max_error_pw,  &
   !     'Error max test ratio for PW  = ',max_error_tb


   ! LOOP OVER RECORDS
   ! -----------------

   reports: DO

      ! READ STATION GENERAL INFO
      ! =========================

      READ (UNIT=iunit, FMT = fmt_info, IOSTAT = iost) &
                   info % platform,    &
                   info % date_char,   &
                   info % name,        &
                   info % levels,      &
                   info % lat,         &
                   info % lon,         &
                   info % elv,         &
                   info % id

      read(UNIT=info % platform (4:6),FMT='(I3)') fm

      IF (iost /= 0) THEN
         EXIT reports
      ENDIF

      ob % total_obs = ob % total_obs + 1

      SELECT CASE(fm)
         CASE (125)    ;
            ! READ SURFACE WIND SPEED AND PRECIPITABLE WATER
            READ (UNIT=iunit, FMT = fmt_loc) speed, tpw
         CASE (126)    ;
            READ (UNIT=iunit, FMT = fmt_loc) &
               tb19v, tb19h, tb22v, tb37v, tb37h, tb85v, tb85h
         CASE DEFAULT;
            write(UNIT=stdout, fmt='(/a/)') &
                 'WARNING   WARNING   WARNING   WARNING   WARNING :'
            write(UNIT=stdout, fmt='(a, i6)') 'unsaved ssmi obs found, fm=', fm
            write(UNIT=stdout, fmt='(a, 2f12.6)') &
                 'info%(lon,lat)=', info%lon, info%lat
      END SELECT

      ! CHECK IF OBS IS IN HORIZONTAL DOMAIN
      ! ====================================

      ! Compute the model horizontal coordinate x, y
      ! Check if obs is wihin horizontal domain

      call da_ll_to_xy (info, loc, xp, outside, inside_halo)

      IF ( outside ) CYCLE reports

      SELECT CASE(fm)
         CASE (125) ;
            if ( .not. Use_SsmiRetrievalObs ) CYCLE reports

            ! Check if at least one field is present
            IF ((tpw % qc == missing) .AND. (speed % qc == missing)) THEN
               CYCLE reports
            ENDIF

            ob % num_ssmi_retrieval = ob % num_ssmi_retrieval + 1

         CASE (126) ;
            if ( .not. Use_SsmiTbObs ) CYCLE reports

            ! Check if at least one field is present

            IF ((tb19v % qc == missing) .AND. (tb19h % qc == missing)  .AND. &
                (tb22v % qc == missing)                                .AND. &
                (tb37v % qc == missing) .AND. (tb37h % qc == missing)  .AND. &
                (tb85v % qc == missing) .AND. (tb85h % qc == missing)) THEN
                 CYCLE reports
            ENDIF

           ! FILTER RAIN PIXELS
           ! ====================================

             IF (isfilter) then

               ipass = .false.
               iprecip = 0
                call filter(tb19v%inv, tb19h%inv, tb22v%inv, tb37v%inv, &
                            tb37h%inv, tb85v%inv, tb85h%inv, ipass, iprecip, &
                            info%lat)
               if (iprecip == 1) then
                   irain = irain + 1
                   CYCLE reports
                endif
             ENDIF

            ob % num_ssmi_tb = ob % num_ssmi_tb + 1

         CASE DEFAULT;
            !---------Do nothing.
      END SELECT

   ENDDO reports

   close(UNIT=iunit)
   
   ! PRINT OUT
   ! =========
 
   write(UNIT=stdout, fmt='(5x,a,i6,a)') &
        'Read:  ', ob % num_ssmi_retrieval , ' SSMI_RETRIEVAL reports,', &
        'Read:  ', ob % num_ssmi_tb ,        ' SSMI_Tb reports,', &
        'Read:  ', ob % total_obs, ' Total Observations.'

   write(UNIT=stdout, fmt='(/,5x,a,i6/)') &
      '** Rain contaminated SSMI_Tb =', irain

   ob%ob_numb(ob%current_ob_time)%ssmi_retrieval = ob%num_ssmi_retrieval
   ob%ob_numb(ob%current_ob_time)%ssmi_tb        = ob%num_ssmi_tb

end subroutine da_scan_ssmi
