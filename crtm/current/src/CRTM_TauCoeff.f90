!
! CRTM_TauCoeff
!
! Module containing the shared CRTM absorption coefficients (TauCoeff)
! and their load/destruction routines. 
!
! SIDE EFFECTS:
!       Routines in this module modify the contents of the public
!       data structures.
!
! RESTRICTIONS:
!       Routines in this module should only be called during the
!       CRTM initialisation.
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 12-Jun-2000
!                       paul.vandelst@ssec.wisc.edu
!

MODULE CRTM_TauCoeff

  ! -----------------
  ! Environment setup
  ! -----------------
  ! CRTM Modules
  USE Message_Handler   , ONLY: SUCCESS, FAILURE, WARNING, Display_Message
  USE TauCoeff_Define   , ONLY: TauCoeff_type, Destroy_TauCoeff
  USE TauCoeff_Binary_IO, ONLY: Read_TauCoeff_Binary
  USE CRTM_Parameters   , ONLY: MAX_N_SENSORS           , &
                                CRTM_Set_Max_nChannels  , &
                                CRTM_Reset_Max_nChannels, &
                                CRTM_Get_Max_nChannels  , &
                                CRTM_IsSet_Max_nChannels
  ! Disable all implicit typing
  IMPLICIT NONE


  ! ------------
  ! Visibilities
  ! ------------
  PRIVATE
  PUBLIC :: CRTM_Load_TauCoeff
  PUBLIC :: CRTM_Destroy_TauCoeff


  ! -----------------
  ! Module parameters
  ! -----------------
  CHARACTER(*),  PARAMETER, PRIVATE :: MODULE_RCS_ID = &
  '$Id: CRTM_TauCoeff.f90 243 2006-12-28 18:10:54Z paul.vandelst@noaa.gov $'

  ! --------------------------------------
  ! The shared data for the gas absorption
  ! (AtmAbsorption) model
  ! --------------------------------------
  TYPE(TauCoeff_type), SAVE, PUBLIC, DIMENSION(:), ALLOCATABLE :: TC


CONTAINS


!------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Load_TauCoeff
!
! PURPOSE:
!       Function to load the TauCoeff transmittance coefficient data into
!       the shared data structure.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Load_TauCoeff( SensorID         =SensorID,          &  ! Optional input
!                                          File_Path        =File_Path,         &  ! Optional input
!                                          Quiet            =Quiet,             &  ! Optional input
!                                          Process_ID       =Process_ID,        &  ! Optional input
!                                          Output_Process_ID=Output_Process_ID, &  ! Optional input
!                                          Message_Log      =Message_Log        )  ! Error messaging
!
! OPTIONAL INPUT ARGUMENTS:
!       SensorID:           List of the sensor IDs (e.g. hirs3_n17, amsua_n18,
!                           ssmis_f16, etc) with which the CRTM is to be
!                           initialised. These Sensor ID are used to construct
!                           the sensor specific TauCoeff filenames containing
!                           the necessary coefficient data, i.e.
!                             <SensorID>.TauCoeff.bin
!                           If this argument is not specified, the default
!                           TauCoeff filename is
!                             TauCoeff.bin
!                           UNITS:      N/A
!                           TYPE:       CHARACTER(*)
!                           DIMENSION:  Rank-1
!                           ATTRIBUTES: INTENT(IN)
!
!       File_Path:          Character string specifying a file path for the
!                           input data files. If not specified, the current
!                           directory is the default.
!                           UNITS:      N/A
!                           TYPE:       CHARACTER(*)
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Quiet:              Set this argument to suppress INFORMATION messages
!                           being printed to standard output (or the message
!                           log file if the Message_Log optional argument is
!                           used.) By default, INFORMATION messages are printed.
!                           If QUIET = 0, INFORMATION messages are OUTPUT.
!                              QUIET = 1, INFORMATION messages are SUPPRESSED.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Process_ID:         Set this argument to the MPI process ID that this
!                           function call is running under. This value is used
!                           solely for controlling INFORMATIOn message output.
!                           If MPI is not being used, ignore this argument.
!                           This argument is ignored if the Quiet argument is set.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Output_Process_ID:  Set this argument to the MPI process ID in which
!                           all INFORMATION messages are to be output. If
!                           the passed Process_ID value agrees with this value
!                           the INFORMATION messages are output. 
!                           This argument is ignored if the Quiet argument
!                           is set.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Message_Log:        Character string specifying a filename in which
!                           any messages will be logged. If not specified,
!                           or if an error occurs opening the log file, the
!                           default action is to output messages to standard
!                           output.
!                           UNITS:      N/A
!                           TYPE:       CHARACTER(*)
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status:       The return value is an integer defining the error
!                           status. The error codes are defined in the
!                           Message_Handler module.
!                           If == SUCCESS the TauCoeff data load was successful
!                              == FAILURE an unrecoverable error occurred.
!                              == WARNING the number of channels read in differs
!                                         from that stored in the CRTM_Parameters
!                                         module.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!
! SIDE EFFECTS:
!       This function modifies the contents of the public data structures
!       in this module.
!
!------------------------------------------------------------------------------

  FUNCTION CRTM_Load_TauCoeff( SensorID         , &  ! Input
                               File_Path        , &  ! Optional input
                               Quiet            , &  ! Optional input
                               Process_ID       , &  ! Optional input
                               Output_Process_ID, &  ! Optional input
                               Message_Log      ) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    CHARACTER(*), DIMENSION(:), OPTIONAL, INTENT(IN) :: SensorID
    CHARACTER(*),               OPTIONAL, INTENT(IN) :: File_Path
    INTEGER,                    OPTIONAL, INTENT(IN) :: Quiet
    INTEGER,                    OPTIONAL, INTENT(IN) :: Process_ID
    INTEGER,                    OPTIONAL, INTENT(IN) :: Output_Process_ID
    CHARACTER(*),               OPTIONAL, INTENT(IN) :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Load_TauCoeff'
    ! Local variables
    CHARACTER(256) :: Message
    CHARACTER(256) :: Process_ID_Tag
    CHARACTER(256), DIMENSION(MAX_N_SENSORS) :: TauCoeff_File
    INTEGER :: Allocate_Status
    INTEGER :: n, nSensors, nChannels
    INTEGER :: Max_n_Channels  ! Maximum channels protected variable
    LOGICAL :: Is_Set

    ! Set up
    Error_Status = SUCCESS
    ! Create a process ID message tag for
    ! WARNING and FAILURE messages
    IF ( PRESENT( Process_ID ) ) THEN
      WRITE( Process_ID_Tag, '( ";  MPI Process ID: ", i0 )' ) Process_ID
    ELSE
      Process_ID_Tag = ' '
    END IF

    ! Determine the number of sensors and construct their filenames
    IF ( PRESENT( SensorID ) ) THEN
      ! Construct filenames for specified sensors
      nSensors = SIZE(SensorID)
      IF ( nSensors > MAX_N_SENSORS ) THEN
        Error_Status = FAILURE
        WRITE(Message,'("Too many sensors, ",i0," specified. Maximum of ",i0," sensors allowed.")') &
                      nSensors, MAX_N_SENSORS
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message)//TRIM(Process_ID_Tag), &
                              Error_Status, &
                              Message_Log=Message_Log)
        RETURN
      END IF
      DO n=1,nSensors
        TauCoeff_File(n) = TRIM(ADJUSTL(SensorID(n)))//'.TauCoeff.bin'
      END DO
    ELSE
      ! No sensors specified. Use default filename.
      nSensors=1
      TauCoeff_File(1) = 'TauCoeff.bin'
    END IF
    
    ! Add the file path
    IF ( PRESENT(File_Path) ) THEN
      DO n=1,nSensors
        TauCoeff_File(n) = TRIM(ADJUSTL(File_Path))//TRIM(TauCoeff_File(n))
      END DO
    END IF
    
    ! Allocate the TauCoeff shared data structure array
    ALLOCATE(TC(nSensors), STAT=Allocate_Status)
    IF( Allocate_Status /= 0 )THEN
      WRITE(Message,'("TauCoeff structure array allocation failed. STAT=",i0)') Allocate_Status
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message)//TRIM(Process_ID_Tag), & 
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF
    
    ! Read the TauCoeff data files
    DO n = 1, nSensors
      Error_Status = Read_TauCoeff_Binary( TRIM(TauCoeff_File(n))             , &  ! Input
                                           TC(n)                              , &  ! Output
                                           Quiet            =Quiet            , &
                                           Process_ID       =Process_ID       , &
                                           Output_Process_ID=Output_Process_ID, &
                                           Message_Log      =Message_Log        )
      IF ( Error_Status /= SUCCESS ) THEN
        WRITE(Message,'("Error reading TauCoeff file #",i0,", ",a)') &
                      n, TRIM(TauCoeff_File(n))
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message)//TRIM(Process_ID_Tag), &
                              Error_Status, &
                              Message_Log=Message_Log )
        RETURN
      END IF
    END DO

    ! Determine the total number of channels
    nChannels = SUM(TC%n_Channels)
    
    ! Set the protect Max_n_Channels variable
    !
    ! Get the current value, if any
    Max_n_Channels = CRTM_Get_Max_nChannels()
    ! Has the number of channels been set?
    IF ( CRTM_IsSet_Max_nChannels() ) THEN
      ! Yes. Check the value      
      IF ( Max_n_Channels /= nChannels ) THEN
        Error_Status = WARNING
        WRITE( Message, '( "MAX_N_CHANNELS already set to different value, ", i0, ", ", &
                          &"than defined by TauCoeff file(s), ", i0, &
                          &". Overwriting" )' ) &
                        Max_n_Channels, nChannels
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message)//TRIM(Process_ID_Tag), &
                              Error_Status, &
                              Message_Log=Message_Log )
        CALL CRTM_Set_Max_nChannels(nChannels)
      END IF
    ELSE
      ! No. Set the value
      CALL CRTM_Set_Max_nChannels(nChannels)
    END IF

  END FUNCTION CRTM_Load_TauCoeff 


!------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Destroy_TauCoeff
!
! PURPOSE:
!       Function to deallocate the public shared data structure containing
!       the CRTM TauCoeff transmittance coefficient data.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Destroy_TauCoeff( Process_ID  = Process_ID, &  ! Optional input
!                                             Message_Log = Message_Log )  ! Error messaging
!
! OPTIONAL INPUT ARGUMENTS:
!       Process_ID:       Set this argument to the MPI process ID that this
!                         function call is running under. This value is used
!                         solely for controlling message output. If MPI is not
!                         being used, ignore this argument.
!                         UNITS:      N/A
!                         TYPE:       INTEGER
!                         DIMENSION:  Scalar
!                         ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Message_Log:      Character string specifying a filename in which any
!                         messages will be logged. If not specified, or if an
!                         error occurs opening the log file, the default action
!                         is to output messages to the screen.
!                         UNITS:      N/A
!                         TYPE:       CHARACTER(*)
!                         DIMENSION:  Scalar
!                         ATTRIBUTES: INTENT(IN), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status:     The return value is an integer defining the error
!                         status. The error codes are defined in the
!                         Message_Handler module.
!                         If == SUCCESS the deallocation of the public TC data
!                                       structure was successful
!                            == FAILURE an unrecoverable error occurred.
!                         UNITS:      N/A
!                         TYPE:       INTEGER
!                         DIMENSION:  Scalar
!
!
! SIDE EFFECTS:
!       This function modifies the contents of the public data structures
!       in this module.
!
!------------------------------------------------------------------------------

  FUNCTION CRTM_Destroy_TauCoeff( Process_ID,   &  ! Optional input
                                  Message_Log ) &  ! Error messaging
                                RESULT ( Error_Status )
    ! Arguments
    INTEGER,      OPTIONAL, INTENT(IN)  :: Process_ID
    CHARACTER(*), OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Destroy_TauCoeff'
    ! Local variables
    CHARACTER(256) :: Message
    CHARACTER(256) :: Process_ID_Tag
    INTEGER :: n, Destroy_Status, Allocate_Status
    
    ! Set up
    Error_Status = SUCCESS
    ! Create a process ID message tag for
    ! WARNING and FAILURE messages
    IF ( PRESENT( Process_ID ) ) THEN
      WRITE( Process_ID_Tag, '( ";  MPI Process ID: ", i0 )' ) Process_ID
    ELSE
      Process_ID_Tag = ' '
    END IF

    ! Destroy the structure array elements
    DO n = 1, SIZE(TC)
      Destroy_Status = Destroy_TauCoeff( TC(n), &
                                         Message_Log=Message_Log )
      IF ( Destroy_Status /= SUCCESS ) THEN
        Error_Status = FAILURE
        WRITE(Message,'("Error destroying TauCoeff structure array element #",i0)') n
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message)//TRIM(Process_ID_Tag), &
                              Error_Status, &
                              Message_Log=Message_Log )
        ! No return here. Continue deallocating
      END IF
    END DO

    ! Deallocate the structure array
    DEALLOCATE(TC, STAT=Allocate_Status)
    IF( Allocate_Status /= 0 )THEN
      WRITE(Message,'("RTTOV TC structure deallocation failed. STAT=",i0)') Allocate_Status
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message)//TRIM(Process_ID_Tag), &
                            Error_Status, &
                            Message_Log=Message_Log)
      
      ! Again, no return.
    END IF

    ! Reset the protected variable Max_n_Channels
    CALL CRTM_Reset_Max_nChannels()

  END FUNCTION CRTM_Destroy_TauCoeff

END MODULE CRTM_TauCoeff
