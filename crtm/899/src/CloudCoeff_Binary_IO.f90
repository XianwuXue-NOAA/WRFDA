!
! CloudCoeff_Binary_IO
!
! Module containing routines to read and write Binary format
! CloudCoeff files.
!
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 24-Jun-2004
!                       paul.vandelst@ssec.wisc.edu
!

MODULE CloudCoeff_Binary_IO

  ! ------------------
  ! Environment set up
  ! ------------------
  ! Module use
  USE Type_Kinds,          ONLY: Long
  USE Message_Handler,     ONLY: SUCCESS, FAILURE, WARNING, INFORMATION, &
                                 Display_Message
  USE Binary_File_Utility, ONLY: Open_Binary_File
  USE CloudCoeff_Define,   ONLY: CloudCoeff_Type, &
                                 Associated_CloudCoeff, &
                                 Allocate_CloudCoeff, &
                                 Destroy_CloudCoeff, &
                                 Check_CloudCoeff_Release, &
                                 Info_CloudCoeff
  ! Disable implicit typing
  IMPLICIT NONE


  ! ------------
  ! Visibilities
  ! ------------
  PRIVATE
  PUBLIC :: Inquire_CloudCoeff_Binary
  PUBLIC :: Read_CloudCoeff_Binary
  PUBLIC :: Write_CloudCoeff_Binary


  ! -----------------
  ! Module parameters
  ! -----------------
  CHARACTER(*), PRIVATE, PARAMETER :: MODULE_RCS_ID = &
    '$Id: CloudCoeff_Binary_IO.f90 510 2007-05-01 03:22:04Z paul.vandelst@noaa.gov $'
  ! Keyword set value
  INTEGER, PARAMETER :: SET = 1


CONTAINS


!------------------------------------------------------------------------------
!
! NAME:
!       Inquire_CloudCoeff_Binary
!
! PURPOSE:
!       Function to inquire a Binary format CloudCoeff file.
!
! CALLING SEQUENCE:
!       Error_Status = Inquire_CloudCoeff_Binary( Filename                           , &  ! Input
!                                                 n_MW_Frequencies = n_MW_Frequencies, &  ! Optional Output
!                                                 n_MW_Radii       = n_MW_Radii      , &  ! Optional Output
!                                                 n_IR_Frequencies = n_IR_Frequencies, &  ! Optional Output
!                                                 n_IR_Radii       = n_IR_Radii      , &  ! Optional Output
!                                                 n_Temperatures   = n_Temperatures  , &  ! Optional Output
!                                                 n_Densities      = n_Densities     , &  ! Optional Output
!                                                 n_Legendre_Terms = n_Legendre_Terms, &  ! Optional Output
!                                                 n_Phase_Elements = n_Phase_Elements, &  ! Optional Output
!                                                 Release          = Release         , &  ! Optional Output
!                                                 Version          = Version         , &  ! Optional Output
!                                                 RCS_Id           = RCS_Id          , &  ! Revision control
!                                                 Message_Log      = Message_Log       )  ! Error messaging
!
! INPUT ARGUMENTS:
!       Filename:          Character string specifying the name of a
!                          CloudCoeff format data file.
!                          UNITS:      N/A
!                          TYPE:       CHARACTER(*)
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(IN)
!
! OPTIONAL INPUT ARGUMENTS:
!       Message_Log:       Character string specifying a filename in which any
!                          messages will be logged. If not specified, or if an
!                          error occurs opening the log file, the default action
!                          is to output messages to standard output.
!                          UNITS:      N/A
!                          TYPE:       CHARACTER(*)
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(IN), OPTIONAL
!
! OPTIONAL OUTPUT ARGUMENTS:
!       n_MW_Frequencies:  The number of microwave frequencies in
!                          the look-up table (LUT)
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       n_MW_Radii:        The number of discrete effective radii 
!                          for MW scatterers in the LUT.
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       n_IR_Frequencies:  The number of infrared frequencies in
!                          the LUT 
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       n_IR_Radii:        The number of discrete effective radii 
!                          for IR scatterers in the LUT.
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       n_Temperatures:    The number of discrete layer temperatures
!                          in the LUT. 
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       n_Densities:       The number of fixed densities for snow, graupel,
!                          and hail/ice in the LUT. 
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       n_Legendre_Terms:  The maximum number of Legendre polynomial
!                          terms in the LUT.
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       n_Phase_Elements:  The maximum number of phase elements in the LUT.
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       Release:           The coefficient file release number.
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       Version:           The coefficient file version number.
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
!       RCS_Id:            Character string containing the Revision Control
!                          System Id field for the module.
!                          UNITS:      N/A
!                          TYPE:       CHARACTER(*)
!                          DIMENSION:  Scalar
!                          ATTRIBUTES: INTENT(OUT), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status:      The return value is an integer defining the error status.
!                          The error codes are defined in the Message_Handler module.
!                          If == SUCCESS the Binary file inquiry was successful
!                             == FAILURE an error occurred.
!                          UNITS:      N/A
!                          TYPE:       INTEGER
!                          DIMENSION:  Scalar
!
!------------------------------------------------------------------------------

  FUNCTION Inquire_CloudCoeff_Binary( Filename        , &  ! Input
                                      n_MW_Frequencies, &  ! Optional Output
                                      n_MW_Radii      , &  ! Optional Output
                                      n_IR_Frequencies, &  ! Optional Output
                                      n_IR_Radii      , &  ! Optional Output
                                      n_Temperatures  , &  ! Optional Output
                                      n_Densities     , &  ! Optional Output
                                      n_Legendre_Terms, &  ! Optional Output
                                      n_Phase_Elements, &  ! Optional Output
                                      Release         , &  ! Optional Output
                                      Version         , &  ! Optional Output
                                      RCS_Id          , &  ! Revision control
                                      Message_Log     ) &  ! Error messaging
                                    RESULT ( Error_Status )
    ! Arguments
    CHARACTER(*),           INTENT(IN)  :: Filename
    INTEGER,      OPTIONAL, INTENT(OUT) :: n_MW_Frequencies
    INTEGER,      OPTIONAL, INTENT(OUT) :: n_MW_Radii
    INTEGER,      OPTIONAL, INTENT(OUT) :: n_IR_Frequencies
    INTEGER,      OPTIONAL, INTENT(OUT) :: n_IR_Radii
    INTEGER,      OPTIONAL, INTENT(OUT) :: n_Temperatures
    INTEGER,      OPTIONAL, INTENT(OUT) :: n_Densities
    INTEGER,      OPTIONAL, INTENT(OUT) :: n_Legendre_Terms
    INTEGER,      OPTIONAL, INTENT(OUT) :: n_Phase_Elements
    INTEGER,      OPTIONAL, INTENT(OUT) :: Release
    INTEGER,      OPTIONAL, INTENT(OUT) :: Version
    CHARACTER(*), OPTIONAL, INTENT(OUT) :: RCS_Id
    CHARACTER(*), OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Function parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'Inquire_CloudCoeff_Binary'
    ! Function variables
    CHARACTER(256) :: Message
    INTEGER :: IO_Status
    INTEGER :: FileID
    INTEGER(Long) :: File_n_MW_Frequencies
    INTEGER(Long) :: File_n_MW_Radii
    INTEGER(Long) :: File_n_IR_Frequencies
    INTEGER(Long) :: File_n_IR_Radii
    INTEGER(Long) :: File_n_Temperatures
    INTEGER(Long) :: File_n_Densities
    INTEGER(Long) :: File_n_Legendre_Terms
    INTEGER(Long) :: File_n_Phase_Elements
    INTEGER(Long) :: File_Release
    INTEGER(Long) :: File_Version
 
    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID


    ! Open the Binary format CloudCoeff file
    ! --------------------------------------
    Error_Status = Open_Binary_File( TRIM( Filename ), &
                                     FileID, &
                                     Message_Log = Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      CALL Display_Message( ROUTINE_NAME, &
                            'Error opening CloudCoeff file '//TRIM( Filename ), &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF


    ! Read the Release/Version information
    ! ------------------------------------
    READ( FileID, IOSTAT = IO_Status ) File_Release, &
                                       File_Version
    IF ( IO_Status /= 0 ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Error reading CloudCoeff file Release/Version values from ", a, &
                        &". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM( Message ), &
                            Error_Status, &
                            Message_Log = Message_Log )
      CLOSE( FileID )
      RETURN
    END IF


    ! Read the dimensions
    ! -------------------
    READ( FileID, IOSTAT=IO_Status ) File_n_MW_Frequencies, File_n_MW_Radii, &
                                     File_n_IR_Frequencies, File_n_IR_Radii, &
                                     File_n_Temperatures,   File_n_Densities, &
                                     File_n_Legendre_Terms, File_n_Phase_Elements 
    IF ( IO_Status /= 0 ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Error reading dimensions from ", a, &
                        &". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM( Message ), &
                            Error_Status, &
                            Message_Log = Message_Log )
      CLOSE( FileID )
      RETURN
    END IF


    ! Close the file
    ! --------------
    CLOSE( FileID, STATUS='KEEP', &
                   IOSTAT=IO_Status )
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message, '( "Error closing ", a, ". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM( Message ), &
                            WARNING, &
                            Message_Log = Message_Log )
    END IF


    ! Assign the return arguments
    ! ---------------------------
    IF ( PRESENT( n_MW_Frequencies ) ) n_MW_Frequencies = File_n_MW_Frequencies
    IF ( PRESENT( n_MW_Radii       ) ) n_MW_Radii       = File_n_MW_Radii
    IF ( PRESENT( n_IR_Frequencies ) ) n_IR_Frequencies = File_n_IR_Frequencies
    IF ( PRESENT( n_IR_Radii       ) ) n_IR_Radii       = File_n_IR_Radii
    IF ( PRESENT( n_Temperatures   ) ) n_Temperatures   = File_n_Temperatures
    IF ( PRESENT( n_Densities      ) ) n_Densities      = File_n_Densities
    IF ( PRESENT( n_Legendre_Terms ) ) n_Legendre_Terms = File_n_Legendre_Terms
    IF ( PRESENT( n_Phase_Elements ) ) n_Phase_Elements = File_n_Phase_Elements
    IF ( PRESENT( Release          ) ) Release          = File_Release
    IF ( PRESENT( Version          ) ) Version          = File_Version

  END FUNCTION Inquire_CloudCoeff_Binary


!------------------------------------------------------------------------------
!
! NAME:
!       Read_CloudCoeff_Binary
!
! PURPOSE:
!       Function to read Binary format CloudCoeff files.
!
! CALLING SEQUENCE:
!       Error_Status = Read_CloudCoeff_Binary( Filename                           , &  ! Input
!                                              CloudCoeff                         , &  ! Output
!                                              Quiet            =Quiet            , &  ! Optional input
!                                              Process_ID       =Process_ID       , &  ! Optional input
!                                              Output_Process_ID=Output_Process_ID, &  ! Optional input
!                                              RCS_Id           =RCS_Id           , &  ! Revision control
!                                              Message_Log      =Message_Log        )  ! Error messaging
!
! INPUT ARGUMENTS:
!       Filename:           Character string specifying the name of the
!                           input binary format CloudCoeff data file.
!                           UNITS:      N/A
!                           TYPE:       CHARACTER(*)
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN)
!
! OPTIONAL INPUT ARGUMENTS:
!       Quiet:              Set this argument to suppress Information messages
!                           being printed to standard output (or the Message
!                           log file if the Message_Log optional argument is
!                           used.) By default, Information messages are printed.
!                           If QUIET = 0, Information messages are OUTPUT.
!                              QUIET = 1, Information messages are SUPPRESSED.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Process_ID:         Set this argument to the MPI process ID that this
!                           function call is running under. This value is used
!                           solely for controlling INFORMATIOn Message output.
!                           If MPI is not being used, ignore this argument.
!                           This argument is ignored if the Quiet argument is set.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Output_Process_ID:  Set this argument to the MPI process ID in which
!                           all Information messages are to be output. If
!                           the passed Process_ID value agrees with this value
!                           the Information messages are output. 
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
! OUTPUT ARGUMENTS:
!       CloudCoeff:         Structure to contain the cloud optical property
!                           data read from the file.
!                           UNITS:      N/A
!                           TYPE:       CloudCoeff_type
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN OUT)
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:             Character string containing the Revision Control
!                           System Id field for the module.
!                           UNITS:      N/A
!                           TYPE:       CHARACTER(*)
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: OPTIONAL, INTENT(OUT)
!
! FUNCTION RESULT:
!       Error_Status:       The return value is an integer defining the error status.
!                           The error codes are defined in the Message_Handler module.
!                           If == SUCCESS the Binary file read was successful
!                              == FAILURE a read error occurred.
!                              == WARNING an error occurred closing the Binary file.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!
! SIDE EFFECTS:
!       If the CloudCoeff argument is defined upon input, it is redefined (or
!       reinitialised) at output.
!
! COMMENTS:
!       Note the INTENT on the output CloudCoeff argument is IN OUT rather
!       than just OUT. This is necessary because the argument may be defined on
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!------------------------------------------------------------------------------

  FUNCTION Read_CloudCoeff_Binary( Filename         , &  ! Input
                                   CloudCoeff       , &  ! Output
                                   Quiet            , &  ! Optional input
                                   Process_ID       , &  ! Optional input
                                   Output_Process_ID, &  ! Optional input
                                   RCS_Id           , &  ! Revision control
                                   Message_Log      ) &  ! Error messaging
                                 RESULT ( Error_Status )
    ! Arguments
    CHARACTER(*),           INTENT(IN)     :: Filename
    TYPE(CloudCoeff_type),  INTENT(IN OUT) :: CloudCoeff
    INTEGER,      OPTIONAL, INTENT(IN)     :: Quiet
    INTEGER,      OPTIONAL, INTENT(IN)     :: Process_ID
    INTEGER,      OPTIONAL, INTENT(IN)     :: Output_Process_ID
    CHARACTER(*), OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*), OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Function parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'Read_CloudCoeff_Binary'
    ! Function variables
    CHARACTER(1000) :: Message
    CHARACTER(128) :: Process_ID_Tag
    LOGICAL :: Noisy
    INTEGER :: IO_Status
    INTEGER :: Destroy_Status
    INTEGER :: FileID
    INTEGER(Long) :: n_MW_Frequencies, n_IR_Frequencies
    INTEGER(Long) :: n_MW_Radii      , n_IR_Radii
    INTEGER(Long) :: n_Temperatures  , n_Densities
    INTEGER(Long) :: n_Legendre_Terms, n_Phase_Elements 
    INTEGER(Long) :: i, j, k, l, m
 
    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Output informational messages....
    Noisy = .TRUE.
    ! ....unless....
    IF ( PRESENT( Quiet ) ) THEN
      ! ....the QUIET keyword is set.
      IF ( Quiet == 1 ) Noisy = .FALSE.
    ELSE
      ! ....the Process_ID is not selected for output
      IF ( PRESENT( Process_ID ) .AND. PRESENT( Output_Process_ID ) ) THEN
        IF ( Process_ID /= Output_Process_ID ) Noisy = .FALSE.
      END IF
    END IF

    ! Create a process ID message tag for
    ! WARNING and FAILURE messages
    IF ( PRESENT( Process_ID ) ) THEN
      WRITE( Process_ID_Tag, '( ";  MPI Prcess ID: ", i5 )' ) Process_ID
    ELSE
      Process_ID_Tag = ' '
    END IF


    ! Open the CloudCoeff file
    ! ------------------------
    Error_Status = Open_Binary_File( TRIM( Filename ), &
                                     FileID,   &
                                     Message_Log = Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      CALL Display_Message( ROUTINE_NAME, &
                            'Error opening '//TRIM( Filename )//TRIM( Process_ID_Tag ), &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF


    ! Read the Release/Version information
    ! ------------------------------------
    READ( FileID, IOSTAT=IO_Status ) CloudCoeff%Release, &
                                     CloudCoeff%Version
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message, '( "Error reading CloudCoeff file Release/Version values from ", a, &
                        &". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      GOTO 2000
    END IF

    ! Check the release
    Error_Status = Check_CloudCoeff_Release( CloudCoeff, &
                                             Message_Log = Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      Message = 'CloudCoeff Release check failed for '//TRIM( Filename )
      GOTO 2000
    END IF


    ! Read the dimensions
    ! -------------------
    READ( FileID, IOSTAT=IO_Status ) n_MW_Frequencies, n_MW_Radii, &
                                     n_IR_Frequencies, n_IR_Radii, &
                                     n_Temperatures  , n_Densities, &
                                     n_Legendre_Terms, n_Phase_Elements 
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message, '( "Error reading data dimensions from ", a, &
                        &". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      GOTO 2000
    END IF


    ! Allocate the CloudCoeff structure for reading
    ! ---------------------------------------------
    Error_Status = Allocate_CloudCoeff( n_MW_Frequencies, &
                                        n_MW_Radii      , &
                                        n_IR_Frequencies, &
                                        n_IR_Radii      , &
                                        n_Temperatures  , &
                                        n_Densities     , &
                                        n_Legendre_Terms, &
                                        n_Phase_Elements, &
                                        CloudCoeff      , &
                                        Message_Log=Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      Message = 'Error occurred allocating CloudCoeff structure.'//TRIM(Process_ID_Tag)
      GOTO 2000
    END IF


    ! Read the lookup table dimension vectors
    ! ---------------------------------------
    READ( FileID, IOSTAT=IO_Status ) CloudCoeff%Frequency_MW, &
                                     CloudCoeff%Frequency_IR, &
                                     CloudCoeff%Reff_MW     , &
                                     CloudCoeff%Reff_IR     , &
                                     CloudCoeff%Temperature , &
                                     CloudCoeff%Density
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message,'( "Error reading LUT dimension vectors from ", a, &
                       &". IOSTAT = ", i5 )' ) &
                     TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Read the microwave liquid phase data
    ! ------------------------------------
    READ( FileID, IOSTAT=IO_Status ) CloudCoeff%ke_L_MW    , &
                                     CloudCoeff%w_L_MW     , &
                                     CloudCoeff%g_L_MW     , &
                                     CloudCoeff%pcoeff_L_MW
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message,'("Error reading microwave liquid phase data from ",a,&
                      &". IOSTAT = ", i5 )' ) &
                     TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Read the microwave solid phase data
    ! -----------------------------------
    READ( FileID, IOSTAT=IO_Status ) CloudCoeff%ke_S_MW    , &
                                     CloudCoeff%w_S_MW     , &
                                     CloudCoeff%g_S_MW     , &
                                     CloudCoeff%pcoeff_S_MW
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message,'("Error reading microwave solid phase data from ",a,&
                      &". IOSTAT = ", i5 )' ) &
                     TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Read the infrared data
    ! ----------------------
    READ( FileID, IOSTAT=IO_Status ) CloudCoeff%ke_IR    , &
                                     CloudCoeff%w_IR     , &
                                     CloudCoeff%g_IR     , &
                                     CloudCoeff%pcoeff_IR
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message,'("Error reading infrared data from ",a,&
                      &". IOSTAT = ", i5 )' ) &
                     TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Close the file
    ! --------------
    CLOSE( FileID, STATUS = 'KEEP', &
                   IOSTAT=IO_Status )
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message, '( "Error closing ", a, ". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM( Message )//TRIM( Process_ID_Tag ), &
                            WARNING, &
                            Message_Log = Message_Log )
    END IF


    ! Output an info message
    ! ----------------------
    IF ( Noisy ) THEN
      CALL Info_CloudCoeff( CloudCoeff, Message )
      CALL Display_Message( ROUTINE_NAME, &
                            'FILE: '//TRIM( Filename )//'; '//TRIM( Message ), &
                            INFORMATION, &
                            Message_Log = Message_Log )
    END IF

    !=====
    RETURN
    !=====

    ! Clean up after an error
    ! -----------------------
    1000 CONTINUE
    Destroy_Status = Destroy_CloudCoeff( CloudCoeff, &
                                         Message_Log=Message_Log)
    IF ( Destroy_Status /= SUCCESS ) &
      Message = TRIM(Message)//'; Error destroying CloudCoeff during error cleanup.'

    2000 CONTINUE
    CLOSE(FileID)
    Error_Status = FAILURE
    CALL Display_Message( ROUTINE_NAME, &
                          TRIM( Message ), &
                          Error_Status, &
                          Message_Log=Message_Log )

  END FUNCTION Read_CloudCoeff_Binary


!------------------------------------------------------------------------------
!
! NAME:
!       Write_CloudCoeff_Binary
!
! PURPOSE:
!       Function to write Binary format CloudCoeff files.
!
! CALLING SEQUENCE:
!       Error_Status = Write_CloudCoeff_Binary( Filename               , &  ! Input
!                                               CloudCoeff             , &  ! Input
!                                               Quiet      =Quiet      , &  ! Optional input
!                                               RCS_Id     =RCS_Id     , &  ! Revision control
!                                               Message_Log=Message_Log  )  ! Error messaging
!
! INPUT ARGUMENTS:
!       Filename:     Character string specifying the name of an output
!                     CloudCoeff format data file.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER(*)
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(IN)
!
!       CloudCoeff:   Structure containing the cloud optical property
!                     data to write to file.
!                     UNITS:      N/A
!                     TYPE:       CloudCoeff_type
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(IN)
!
! OPTIONAL INPUT ARGUMENTS:
!       Quiet:        Set this keyword to suppress information messages being
!                     printed to standard output (or the Message log file if 
!                     the Message_Log optional argument is used.) By default,
!                     information messages are printed.
!                     If QUIET = 0, information messages are OUTPUT.
!                        QUIET = 1, information messages are SUPPRESSED.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Message_Log:  Character string specifying a filename in which any
!                     messages will be logged. If not specified, or if an
!                     error occurs opening the log file, the default action
!                     is to output messages to standard output.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER(*)
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(IN), OPTIONAL
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:       Character string containing the Revision Control
!                     System Id field for the module.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER(*)
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: OPTIONAL, INTENT(OUT)
!
! FUNCTION RESULT:
!       Error_Status: The return value is an integer defining the error status.
!                     The error codes are defined in the Message_Handler module.
!                     If == SUCCESS the Binary file write was successful
!                        == FAILURE a write error occurred.
!                        == WARNING an error occurred closing the Binary file.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!
! SIDE EFFECTS:
!       - If the output file already exists, it is overwritten.
!       - If an error occurs *during* the write phase, the output file is deleted
!         before returning to the calling routine.
!
!------------------------------------------------------------------------------

  FUNCTION Write_CloudCoeff_Binary( Filename    , &  ! Input
                                    CloudCoeff  , &  ! Input
                                    Quiet       , &  ! Optional input
                                    RCS_Id      , &  ! Revision control
                                    Message_Log ) &  ! Error messaging
                                  RESULT ( Error_Status )
    ! Arguments
    CHARACTER(*),           INTENT(IN)  :: Filename
    TYPE(CloudCoeff_type),  INTENT(IN)  :: CloudCoeff
    INTEGER,      OPTIONAL, INTENT(IN)  :: Quiet
    CHARACTER(*), OPTIONAL, INTENT(OUT) :: RCS_Id
    CHARACTER(*), OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Function parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'Write_CloudCoeff_Binary'
    CHARACTER(*), PARAMETER :: FILE_STATUS_ON_ERROR = 'DELETE'
    ! Function variables
    CHARACTER(256) :: Message
    LOGICAL :: Noisy
    INTEGER :: IO_Status
    INTEGER :: FileID
    INTEGER :: i, j, k, l 
 
    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Output informational Messages....
    Noisy = .TRUE.
    ! ....unless the QUIET keyword is set.
    IF ( PRESENT( Quiet ) ) THEN
      IF ( Quiet == 1 ) Noisy = .FALSE.
    END IF

    ! Check structure
    IF ( .NOT. Associated_CloudCoeff( CloudCoeff ) ) THEN
      Message = 'Some or all INPUT CloudCoeff pointer members are NOT associated.'
      GOTO 2000
    END IF

    ! Check the CloudCoeff structure Release
    Error_Status = Check_CloudCoeff_Release( CloudCoeff, &
                                             Message_Log = Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      Message = 'CloudCoeff Release check failed.'
      GOTO 2000
    END IF

    ! Check the CloudCoeff structure dimensions
    IF ( CloudCoeff%n_MW_Frequencies < 1 .OR. &
         CloudCoeff%n_MW_Radii       < 1 .OR. &
         CloudCoeff%n_IR_Frequencies < 1 .OR. &
         CloudCoeff%n_IR_Radii       < 1 .OR. &
         CloudCoeff%n_Temperatures   < 1 .OR. &
         CloudCoeff%n_Densities      < 1 .OR. &
         CloudCoeff%n_Legendre_Terms < 0 .OR. &
         CloudCoeff%n_Phase_Elements < 1      ) THEN
      Message = 'One or more dimensions of CloudCoeff structure are < or = 0.'
      GOTO 2000
    END IF


    ! Open the CloudCoeff data file
    ! -----------------------------
    Error_Status = Open_Binary_File( TRIM( Filename ), &
                                     FileID, &
                                     For_Output  = SET, &
                                     Message_Log = Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      Message = 'Error opening '//TRIM( Filename )
      GOTO 2000
    END IF


    ! Write the Release/Version information
    ! -------------------------------------
    WRITE( FileID, IOSTAT=IO_Status ) CloudCoeff%Release, &
                                      CloudCoeff%Version
    IF ( IO_Status /= 0 ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Error writing CloudCoeff file Release/Version values to ", a, &
                        &". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Write the dimensions
    ! --------------------
    WRITE( FileID, IOSTAT=IO_Status ) CloudCoeff%n_MW_Frequencies, CloudCoeff%n_MW_Radii, &
                                      CloudCoeff%n_IR_Frequencies, CloudCoeff%n_IR_Radii, &
                                      CloudCoeff%n_Temperatures  , CloudCoeff%n_Densities, &
                                      CloudCoeff%n_Legendre_Terms, CloudCoeff%n_Phase_Elements 
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message, '( "Error writing data dimensions to ", a, &
                        &". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Write the lookup table dimension vectors
    ! ---------------------------------------
    WRITE( FileID, IOSTAT=IO_Status ) CloudCoeff%Frequency_MW, &
                                      CloudCoeff%Frequency_IR, &
                                      CloudCoeff%Reff_MW     , &
                                      CloudCoeff%Reff_IR     , &
                                      CloudCoeff%Temperature , &
                                      CloudCoeff%Density
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message,'( "Error writing LUT dimension vectors to ", a, &
                       &". IOSTAT = ", i5 )' ) &
                     TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Write the microwave liquid phase data
    ! ------------------------------------
    WRITE( FileID, IOSTAT=IO_Status ) CloudCoeff%ke_L_MW    , &
                                      CloudCoeff%w_L_MW     , &
                                      CloudCoeff%g_L_MW     , &
                                      CloudCoeff%pcoeff_L_MW
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message,'("Error writing microwave liquid phase data to ",a,&
                      &". IOSTAT = ", i5 )' ) &
                     TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Write the microwave solid phase data
    ! -----------------------------------
    WRITE( FileID, IOSTAT=IO_Status ) CloudCoeff%ke_S_MW    , &
                                      CloudCoeff%w_S_MW     , &
                                      CloudCoeff%g_S_MW     , &
                                      CloudCoeff%pcoeff_S_MW
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message,'("Error writing microwave solid phase data to ",a,&
                      &". IOSTAT = ", i5 )' ) &
                     TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Write the infrared data
    ! ----------------------
    WRITE( FileID, IOSTAT=IO_Status ) CloudCoeff%ke_IR    , &
                                      CloudCoeff%w_IR     , &
                                      CloudCoeff%g_IR     , &
                                      CloudCoeff%pcoeff_IR
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message,'("Error writing infrared data to ",a,&
                      &". IOSTAT = ", i5 )' ) &
                     TRIM( Filename ), IO_Status
      GOTO 1000
    END IF


    ! Close the file
    ! --------------
    CLOSE( FileID, STATUS = 'KEEP',   &
                   IOSTAT = IO_Status )
    IF ( IO_Status /= 0 ) THEN
      WRITE( Message, '( "Error closing ", a, ". IOSTAT = ", i5 )' ) &
                      TRIM( Filename ), IO_Status
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM( Message ), &
                            WARNING, &
                            Message_Log = Message_Log )
    END IF


    ! Output an info message
    ! ----------------------
    IF ( Noisy ) THEN
      CALL Info_CloudCoeff( CloudCoeff, Message )
      CALL Display_Message( ROUTINE_NAME, &
                            'FILE: '//TRIM( Filename )//'; '//TRIM( Message ), &
                            INFORMATION, &
                            Message_Log = Message_Log )
    END IF

    !=====
    RETURN
    !=====

    ! Clean up after an error
    ! -----------------------
    1000 CONTINUE
    CLOSE(FileID,STATUS=FILE_STATUS_ON_ERROR)

    2000 CONTINUE
    Error_Status = FAILURE
    CALL Display_Message( ROUTINE_NAME, &
                          TRIM( Message ), &
                          Error_Status, &
                          Message_Log = Message_Log )

  END FUNCTION Write_CloudCoeff_Binary

END MODULE CloudCoeff_Binary_IO
