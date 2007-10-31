!
! CRTM_Forward_Module
!
! Module containing the CRTM forward model function.
!
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 29-Jun-2004
!                       paul.vandelst@ssec.wisc.edu
!

MODULE CRTM_Forward_Module


  ! ------------
  ! Module usage
  ! ------------
  USE Type_Kinds,               ONLY: fp=>fp_kind
  USE Message_Handler,          ONLY: SUCCESS, FAILURE, WARNING, Display_Message
  USE CRTM_Parameters,          ONLY: SET, NOT_SET, ONE, &
                                      MAX_N_PROFILES, &
                                      MAX_N_ABSORBERS, &
                                      MAX_N_PREDICTORS, &
                                      MAX_N_PHASE_ELEMENTS, &
                                      MAX_N_LEGENDRE_TERMS, &
                                      MAX_N_STOKES, &
                                      MAX_N_ANGLES
  USE CRTM_Atmosphere_Define
  USE CRTM_Surface_Define
  USE CRTM_GeometryInfo_Define
  USE CRTM_ChannelInfo_Define
  USE CRTM_Options_Define
  USE CRTM_AtmAbsorption
  USE CRTM_AerosolScatter
  USE CRTM_CloudScatter
  USE CRTM_SfcOptics
  USE CRTM_AtmOptics
  USE CRTM_RTSolution


  ! -----------------------
  ! Disable implicit typing
  ! -----------------------
  IMPLICIT NONE


  ! ------------
  ! Visibilities
  ! ------------
  ! Everything private by default
  PRIVATE
  ! Public procedures
  PUBLIC :: CRTM_Forward


  ! --------------------
  ! Function overloading
  ! --------------------
  INTERFACE CRTM_Forward
    MODULE PROCEDURE CRTM_Forward_scalar
    MODULE PROCEDURE CRTM_Forward_rank1
  END INTERFACE CRTM_Forward


  ! -----------------
  ! Module parameters
  ! -----------------
  ! RCS Id for the module
  CHARACTER( * ), PARAMETER :: MODULE_RCS_ID = &
  '$Id: CRTM_Forward_Module.f90,v 1.17 2006/05/25 18:35:34 wd20pd Exp $'


CONTAINS


!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Forward
!
! PURPOSE:
!       Function that calculates top-of-atmosphere (TOA) radiances
!       and brightness temperatures for an input atmospheric profile or
!       profile set and user specified satellites/channels.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Forward( Atmosphere,                &  ! Input    
!                                    Surface,                   &  ! Input    
!                                    GeometryInfo,              &  ! Input    
!                                    ChannelInfo,               &  ! Input    
!                                    RTSolution,                &  ! Output   
!                                    Options      = Options,    &  ! Optional input
!                                    RCS_Id       = RCS_Id,     &  ! Revision control
!                                    Message_Log  = Message_Log )  ! Error messaging
!
! INPUT ARGUMENTS:
!       Atmosphere:     Structure containing the Atmosphere data.
!                       UNITS:      N/A
!                       TYPE:       CRTM_Atmosphere_type
!                       DIMENSION:  Scalar
!                                     or
!                                   Rank-1 (M)
!                                   See dimensionality table in COMMENTS below.
!                       ATTRIBUTES: INTENT( IN )
!
!       Surface:        Structure containing the Surface data.
!                       UNITS:      N/A
!                       TYPE:       CRTM_Surface_type
!                       DIMENSION:  Same as input Atmosphere structure
!                                   See dimensionality table in COMMENTS below.
!                       ATTRIBUTES: INTENT( IN )
!
!       GeometryInfo:   Structure containing the view geometry
!                       information.
!                       UNITS:      N/A
!                       TYPE:       TYPE( CRTM_GeometryInfo_type )
!                       DIMENSION:  Same as input Atmosphere structure
!                                   See dimensionality table in COMMENTS below.
!                       ATTRIBUTES: INTENT( IN )
!
!       ChannelInfo:    Structure returned from the CRTM_Init() function
!                       that contains the satellite/sesnor channel index
!                       information.
!                       UNITS:      N/A
!                       TYPE:       TYPE( CRTM_ChannelInfo_type )
!                       DIMENSION:  Scalar
!                       ATTRIBUTES: INTENT( IN )
!
! OPTIONAL INPUT ARGUMENTS:
!       Options:        Options structure containing the optional arguments
!                       for the CRTM.
!                       UNITS:      N/A
!                       TYPE:       CRTM_Options_type
!                       DIMENSION:  Same as input Atmosphere structure
!                                   See dimensionality table in COMMENTS below.
!                       ATTRIBUTES: INTENT( IN ), OPTIONAL
!
!       Message_Log:    Character string specifying a filename in which any
!                       messages will be logged. If not specified, or if an
!                       error occurs opening the log file, the default action
!                       is to output messages to the screen.
!                       UNITS:      N/A
!                       TYPE:       CHARACTER( * )
!                       DIMENSION:  Scalar
!                       ATTRIBUTES: INTENT( IN ), OPTIONAL
!
! OUTPUT ARGUMENTS:
!       RTSolution:     Structure containing the soluition to the RT equation
!                       for the given inputs.
!                       UNITS:      N/A
!                       TYPE:       CRTM_RTSolution_type
!                       DIMENSION:  Rank-1 (L)
!                                     or
!                                   Rank-2 (L x M)
!                                   See dimensionality table in COMMENTS below.
!                       ATTRIBUTES: INTENT( IN OUT )
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:         Character string containing the Revision Control
!                       System Id field for the module.
!                       UNITS:      N/A
!                       TYPE:       CHARACTER(*)
!                       DIMENSION:  Scalar
!                       ATTRIBUTES: INTENT( OUT ), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status:   The return value is an integer defining the error status.
!                       The error codes are defined in the ERROR_HANDLER module.
!                       If == SUCCESS the computation was sucessful
!                          == FAILURE an unrecoverable error occurred
!                       UNITS:      N/A
!                       TYPE:       INTEGER
!                       DIMENSION:  Scalar
!
! SIDE EFFECTS:
!      None.
!
! RESTRICTIONS:
!      None.
!
! COMMENTS:
!       - The folowing tables details the input/output argument dimensionality
!         association, where L == n_Channels, M == n_Profiles:
!
!                                           |   OPTIONAL  |
!                  INPUTS                   |    INPUT    |   OUTPUTS
!                                           |             |
!     Atmosphere   Surface   GeometryInfo   |   Options   |  RTSolution
!  -----------------------------------------+-------------+----------------
!       Scalar      Scalar      Scalar      |    Scalar   |      L
!                                           |             |
!         M           M           M         |      M      |    L x M
!
!         Thus one can process either a single profile or multiple profiles.
!         The routines for each specific case above have been overloaded to
!         the generic interface described in the header above.
!
!       - Note that the Options optional input structure argument contains
!         spectral information (e.g. emissivity) that must have the same
!         spectral dimensionality (the "L" dimension) as the output
!         RTSolution structure.
!
!       - Note the INTENT on the output RTSolution argument is IN OUT rather
!         than just OUT. This is necessary because the argument may be defined
!         upon input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!
!--------------------------------------------------------------------------------

  !#----------------------------------------------------------------------------#
  !#----------------------------------------------------------------------------#
  !#                -- RANK-1 (N_PROFILES) SPECIFIC FUNCTION --                 #
  !#----------------------------------------------------------------------------#
  !#----------------------------------------------------------------------------#

  FUNCTION CRTM_Forward_rank1( Atmosphere,   &  ! Input, M
                               Surface,      &  ! Input, M    
                               GeometryInfo, &  ! Input, M    
                               ChannelInfo,  &  ! Input, Scalar    
                               RTSolution,   &  ! Output, L x M   
                               Options,      &  ! Optional input, M    
                               RCS_Id,       &  ! Revision control
                               Message_Log ) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    TYPE( CRTM_Atmosphere_type ),        DIMENSION( : ),    INTENT( IN OUT ) :: Atmosphere    ! M
    TYPE( CRTM_Surface_type ),           DIMENSION( : ),    INTENT( IN )     :: Surface       ! M
    TYPE( CRTM_GeometryInfo_type ),      DIMENSION( : ),    INTENT( IN OUT ) :: GeometryInfo  ! M
    TYPE( CRTM_ChannelInfo_type ),                          INTENT( IN )     :: ChannelInfo   ! Scalar 
    TYPE( CRTM_RTSolution_type ),        DIMENSION( :, : ), INTENT( IN OUT ) :: RTSolution    ! L x M
    TYPE( CRTM_Options_type ), OPTIONAL, DIMENSION( : ),    INTENT( IN )     :: Options       ! M
    CHARACTER( * ),            OPTIONAL,                    INTENT( OUT )    :: RCS_Id
    CHARACTER( * ),            OPTIONAL,                    INTENT( IN )     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER( * ), PARAMETER :: ROUTINE_NAME = 'CRTM_Forward(Rank-1)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    CHARACTER( 10 )  :: Value_Input, Value_Allowed
    LOGICAL :: Options_Present
    INTEGER :: m, n_Profiles


    ! ------
    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID


    ! ----------------------------
    ! Check the number of profiles
    ! ----------------------------

    ! Number of atmospheric profiles.
    n_Profiles = SIZE( Atmosphere )

    ! Check that the number of profiles is not greater than
    ! MAX_N_PROFILES. This is simply a limit to restrict the
    ! size of the input arrays so they're not TOO big.
    IF ( n_Profiles > MAX_N_PROFILES ) THEN
      Error_Status = FAILURE
      WRITE( Value_Input,   '( i5 )' ) n_Profiles
      WRITE( Value_Allowed, '( i5 )' ) MAX_N_PROFILES
      CALL Display_Message( ROUTINE_NAME, &
                            'Number of passed profiles ('// &
                            TRIM( ADJUSTL( Value_Input ) )// &
                            ') > maximum number of profiles allowed ('// &
                            TRIM( ADJUSTL( Value_Allowed ) )//').', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF

    ! Check the profile dimensionality
    ! of the other arguments
    IF ( SIZE( Surface ) /= n_Profiles ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Inconsistent profile dimensionality for '//&
                            'Surface input argument.', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF
    
    IF ( SIZE( GeometryInfo ) /= n_Profiles ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Inconsistent profile dimensionality for '//&
                            'GeomtryInfo input argument.', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF

    IF ( SIZE( RTSolution, 2 ) /= n_Profiles ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Inconsistent profile dimensionality for '//&
                            'RTSolution output argument.', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF

    Options_Present = .FALSE.
    IF ( PRESENT( Options ) ) THEN
      Options_Present = .TRUE.
      IF ( SIZE( Options ) /= n_Profiles ) THEN
        Error_Status = FAILURE
        CALL Display_Message( ROUTINE_NAME, &
                              'Inconsistent profile dimensionality for '//&
                              'Options optional input argument.', &
                              Error_Status, &
                              Message_Log = Message_Log )
        RETURN
      END IF
    END IF
    



    !#--------------------------------------------------------------------------#
    !#                           -- PROFILE LOOP --                             #
    !#                                                                          #
    !#  Note that there are two loops, one with the Options argument, and       #
    !#  one without. This is done so that, in the former case, the Options      #
    !#  argument can be indexed with the profile index variable, m, without     #
    !#  an IF(PRESENT(Options)) test inside the profile loop.                   #
    !#--------------------------------------------------------------------------#

    ! -------------------------
    ! Loop for Options argument
    ! -------------------------

    Options_Check: IF ( Options_Present ) THEN

      DO m = 1, n_Profiles
        Error_Status = CRTM_Forward_scalar( Atmosphere(m),            &  ! Input, Scalar
                                            Surface(m),               &  ! Input, Scalar
                                            GeometryInfo(m),          &  ! Input, Scalar
                                            ChannelInfo,              &  ! Input, Scalar
                                            RTSolution(:,m),          &  ! Output, L   
                                            Options = Options(m),     &  ! Optional input, Scalar
                                            Message_Log = Message_Log )  ! Error messaging
        IF ( Error_Status == FAILURE ) THEN
          WRITE( Message, '( "Error occured in CRTM_Forward(Scalar), ", &
                            &"with Options, for profile #", i5 )' ) m
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM( Message ), &
                                Error_Status, &
                                Message_Log = Message_Log )
          RETURN
        END IF
      END DO


    ! ----------------------------
    ! Loop for no Options argument
    ! ----------------------------

    ELSE

      DO m = 1, n_Profiles
        Error_Status = CRTM_Forward_scalar( Atmosphere(m),            &  ! Input, Scalar
                                            Surface(m),               &  ! Input, Scalar
                                            GeometryInfo(m),          &  ! Input, Scalar
                                            ChannelInfo,              &  ! Input, Scalar
                                            RTSolution(:,m),          &  ! Output, L   
                                            Message_Log = Message_Log )  ! Error messaging
        IF ( Error_Status == FAILURE ) THEN
          WRITE( Message, '( "Error occured in CRTM_Forward(Scalar), ", &
                            &"for profile #", i5 )' ) m
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM( Message ), &
                                Error_Status, &
                                Message_Log = Message_Log )
          RETURN
        END IF
      END DO

    END IF Options_Check

  END FUNCTION CRTM_Forward_rank1



  !#----------------------------------------------------------------------------#
  !#----------------------------------------------------------------------------#
  !#              -- SCALAR (SINGLE PROFILE) SPECIFIC FUNCTION --               #
  !#----------------------------------------------------------------------------#
  !#----------------------------------------------------------------------------#

  FUNCTION CRTM_Forward_scalar( Atmosphere,   &  ! Input, Scalar
                                Surface,      &  ! Input, Scalar
                                GeometryInfo, &  ! Input, Scalar
                                ChannelInfo,  &  ! Input, Scalar    
                                RTSolution,   &  ! Output, L   
                                Options,      &  ! Optional input, Scalar    
                                RCS_Id,       &  ! Revision control
                                Message_Log ) &  ! Error messaging
                              RESULT( Error_Status )
    ! Arguments
    TYPE( CRTM_Atmosphere_type ),                 INTENT( IN OUT ) :: Atmosphere    ! Scalar
    TYPE( CRTM_Surface_type ),                    INTENT( IN )     :: Surface       ! Scalar
    TYPE( CRTM_GeometryInfo_type ),               INTENT( IN OUT ) :: GeometryInfo  ! Scalar
    TYPE( CRTM_ChannelInfo_type ),                INTENT( IN )     :: ChannelInfo   ! Scalar
    TYPE( CRTM_RTSolution_type ), DIMENSION( : ), INTENT( IN OUT ) :: RTSolution    ! L
    TYPE( CRTM_Options_type ),    OPTIONAL,       INTENT( IN )     :: Options       ! Scalar
    CHARACTER( * ),               OPTIONAL,       INTENT( OUT )    :: RCS_Id
    CHARACTER( * ),               OPTIONAL,       INTENT( IN )     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER( * ), PARAMETER :: ROUTINE_NAME = 'CRTM_Forward(Scalar)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    LOGICAL :: User_Emissivity
    LOGICAL :: User_Direct_Reflectivity
    INTEGER :: Status
    INTEGER :: l, n_Full_Streams, n_Layers
    TYPE( CRTM_AtmAbsorption_type ) :: AtmAbsorption
    TYPE( CRTM_AtmScatter_type )    :: AerosolScatter
    TYPE( CRTM_AtmScatter_type )    :: CloudScatter
    TYPE( CRTM_AtmScatter_type )    :: AtmOptics 
    TYPE( CRTM_SfcOptics_type )     :: SfcOptics
    ! Internal variable output
    TYPE( CRTM_CSVariables_type ),save :: CSV  ! CloudScatter
    TYPE( CRTM_AOVariables_type ),save :: AOV  ! AtmOptics
    TYPE( CRTM_RTVariables_type ),save :: RTV  ! RTSolution


    ! ------
    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID


    ! ----------------------------
    ! Check the number of channels
    ! ----------------------------
    ! If no channels, simply return
    IF ( ChannelInfo%n_Channels == 0 ) RETURN
    ! Output array too small
    IF ( SIZE( RTSolution ) < ChannelInfo%n_Channels ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Output RTSolution structure array too small (", i5, &
                        &") to hold results for the number of requested channels (", i5, ")" )' ) &
                      SIZE( RTSolution ), ChannelInfo%n_Channels
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM( Message ), &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF



    !#--------------------------------------------------------------------------#
    !#            -- CHECK THE OPTIONAL Options STRUCTURE ARGUMENT --           #
    !#                                                                          #
    !# Note the use of the "User_Emissivity" logical flag in this seciton is    #
    !# not intended as the generic "user options are present" flag. It is       #
    !# anticipated that future additions to the Options structure argument will #
    !# necessitate additional flag variables.                                   #
    !#--------------------------------------------------------------------------#

    ! ---------------------------------------------------
    ! Default action is NOT to use user specified Options
    ! ---------------------------------------------------

    User_Emissivity = .FALSE.


    ! --------------------------
    ! Check the Options argument
    ! --------------------------

    Options_Present: IF ( PRESENT( Options ) ) THEN

      ! Check if the supplied emissivity should be used
      Check_Emissivity: IF ( Options%Emissivity_Switch == SET ) THEN

        ! Are the channel dimensions consistent
        IF ( Options%n_Channels < ChannelInfo%n_Channels ) THEN
          Error_Status = FAILURE
          WRITE( Message, '( "Input Options channel dimension (", i5, ") is less ", &
                            &"than the number of requested channels (",i5, ")" )' ) &
                          Options%n_Channels, ChannelInfo%n_Channels
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM( Message ), &
                                Error_Status, &
                                Message_Log = Message_Log )
          RETURN
        END IF

        ! Set to use the supplied emissivity
        User_Emissivity = .TRUE.

        ! Check if the supplied direct reflectivity should be used
        User_Direct_Reflectivity = .FALSE.
        IF ( Options%Direct_Reflectivity_Switch == SET ) User_Direct_Reflectivity = .TRUE.

      END IF Check_Emissivity

    END IF Options_Present



    !#--------------------------------------------------------------------------#
    !#         -- COMPUTE THE DERIVED GEOMETRY FROM THE USER SPECIFIED --       #
    !#         -- COMPONENTS OF THE CRTM_GeometryInfo STRUCTURE        --       #
    !#--------------------------------------------------------------------------#

    Error_Status = CRTM_Compute_GeometryInfo( GeometryInfo, &
                                              Message_Log = Message_Log )


    IF ( Error_Status /= SUCCESS ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Error computing derived GeometryInfo components', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF



    !#--------------------------------------------------------------------------#
    !#                     -- ALLOCATE ALL LOCAL STRUCTURES --                  #
    !#--------------------------------------------------------------------------#

    ! ---------------------------
    ! The AtmAbsorption structure
    ! ---------------------------

    Error_Status = CRTM_Allocate_AtmAbsorption( Atmosphere%n_Layers,      &  ! Input
                                                MAX_N_PREDICTORS,         &  ! Input
                                                MAX_N_ABSORBERS,          &  ! Input
                                                AtmAbsorption,            &  ! Output
                                                Message_Log = Message_Log )  ! Error messaging

    IF ( Error_Status /= SUCCESS ) THEN
      Error_Status = FAILURE
      CALL DIsplay_Message( ROUTINE_NAME, &
                            'Error allocating AtmAbsorption structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF


    ! --------------------------
    ! The CloudScatter structure
    ! --------------------------

    Error_Status = CRTM_Allocate_AtmScatter( Atmosphere%n_Layers,      &  ! Input
                                             MAX_N_LEGENDRE_TERMS,     &  ! Input
                                             MAX_N_PHASE_ELEMENTS,     &  ! Input
                                             CloudScatter,             &  ! Output
                                             Message_Log = Message_Log )  ! Error messaging

    IF ( Error_Status /= SUCCESS ) THEN
      Error_Status = FAILURE
      CALL DIsplay_Message( ROUTINE_NAME, &
                            'Error allocating CloudScatter structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF


    ! ----------------------------
    ! The AerosolScatter structure
    ! ----------------------------

    Error_Status = CRTM_Allocate_AtmScatter( Atmosphere%n_Layers,      &  ! Input
                                             MAX_N_LEGENDRE_TERMS,     &  ! Input
                                             MAX_N_PHASE_ELEMENTS,     &  ! Input
                                             AerosolScatter,           &  ! Output
                                             Message_Log = Message_Log )  ! Error messaging

    IF ( Error_Status /= SUCCESS ) THEN
      Error_Status = FAILURE
      CALL DIsplay_Message( ROUTINE_NAME, &
                            'Error allocating AerosolScatter structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF



    ! -----------------------
    ! The AtmOptics structure
    ! -----------------------

    Error_Status = CRTM_Allocate_AtmScatter( Atmosphere%n_Layers,      &  ! Input
                                             MAX_N_LEGENDRE_TERMS,     &  ! Input
                                             MAX_N_PHASE_ELEMENTS,     &  ! Input
                                             AtmOptics,                &  ! Output
                                             Message_Log = Message_Log )  ! Error messaging

 
    IF ( Error_Status /= SUCCESS ) THEN
      Error_Status = FAILURE
      CALL DIsplay_Message( ROUTINE_NAME, &
                            'Error allocating CloudScatter structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF


    ! -----------------------
    ! The SfcOptics structure
    ! -----------------------

    Error_Status = CRTM_Allocate_SfcOptics( MAX_N_ANGLES,             &  ! Input
                                            MAX_N_STOKES,             &  ! Input
                                            SfcOptics,                &  ! Output
                                            Message_Log = Message_Log )  ! Error messaging

    IF ( Error_Status /= SUCCESS ) THEN
      CALL DIsplay_Message( ROUTINE_NAME, &
                            'Error allocating SfcOptics structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF



    !#--------------------------------------------------------------------------#
    !#                     -- PREPROCESS SOME INPUT DATA --                     #
    !#--------------------------------------------------------------------------#

    ! --------------------------------------------------------
    ! Average surface skin temperature for multi-surface types
    ! --------------------------------------------------------

    CALL CRTM_Compute_SurfaceT( Surface, SfcOptics )



    !#--------------------------------------------------------------------------#
    !#                -- SET UP FOR GASEOUS ABSORPTION CALCS --                 #
    !#--------------------------------------------------------------------------#

    Error_Status = CRTM_SetUp_AtmAbsorption( Atmosphere,               &  ! Input
                                             GeometryInfo,             &  ! Input
                                             AtmAbsorption,            &  ! Output
                                             Message_Log = Message_Log )  ! Error messaging

    IF ( Error_Status /= SUCCESS ) THEN
      CALL DIsplay_Message( ROUTINE_NAME, &
                            'Error setting up AtmAbsorption structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF



    !#--------------------------------------------------------------------------#
    !#                           -- CHANNEL LOOP --                             #
    !#--------------------------------------------------------------------------#

    Channel_Loop: DO l = 1, ChannelInfo%n_Channels


      ! --------------------------------
      ! Compute the layer optical depths
      ! due to gaseous absorption
      ! --------------------------------

      Error_Status = CRTM_Compute_AtmAbsorption( ChannelInfo%Channel_Index(l), & ! Input
                                                 AtmAbsorption,                & ! In/Output
                                                 Message_Log = Message_Log     ) ! Error messaging

      IF ( Error_Status /= SUCCESS ) THEN
        WRITE( Message, '( "Error computing AtmAbsorption for ", a, ", channel ", i4 )' ) &
                        TRIM( ChannelInfo%Sensor_Descriptor(l) ), &
                        ChannelInfo%Sensor_Channel(l)
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM( Message ), &
                              Error_Status, &
                              Message_Log = Message_Log )
        RETURN
!          OR
!        CYCLE Channel_Loop
      END IF


      ! ---------------------------------------------------------------
      ! Determine the number of streams (n_Full_Streams) in up+downward
      ! directions. Currently, n_Full_Streams is determined from the
      ! cloud parameters only. It will also use the aerosol parameters 
      ! when aerosol scattering is included.
      ! ---------------------------------------------------------------

      CALL CRTM_Compute_n_Streams( Atmosphere, &
                                   ChannelInfo%Channel_Index(l), &
                                   n_Full_Streams, &
                                   RTSolution(l) )

      ! Transfer the number of streams
      ! to all the scattering structures
      AtmOptics%n_Legendre_Terms = n_Full_Streams


      ! -----------------------------------------------------------
      ! Compute the cloud particle absorption/scattering properties
      ! -----------------------------------------------------------

      IF( Atmosphere%n_Clouds > 0 ) THEN

        CloudScatter%n_Legendre_Terms   = n_Full_Streams
        Error_Status = CRTM_Compute_CloudScatter( Atmosphere,                   &  ! Input
                                                  ChannelInfo%Channel_Index(l), &  ! Input
                                                  CloudScatter,                 &  ! Output
                                                  CSV,                          &  ! Internal variable output
                                                  Message_Log = Message_Log     )  ! Error messaging
        IF ( Error_Status /= SUCCESS ) THEN
          WRITE( Message, '( "Error computing CloudScatter for ", a, &
                            &", channel ", i4 )' ) &
                          TRIM( ChannelInfo%Sensor_Descriptor(l) ), &
                          ChannelInfo%Sensor_Channel(l)
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM( Message ), &
                                Error_Status, &
                                Message_Log = Message_Log )
          RETURN
        END IF

      END IF


      ! ----------------------------------------------------
      ! Compute the aerosol absorption/scattering properties
      ! ----------------------------------------------------

      IF ( Atmosphere%n_Aerosols > 0 ) THEN

        AerosolScatter%n_Legendre_Terms = n_Full_Streams
        Error_Status = CRTM_Compute_AerosolScatter( Atmosphere,                   & ! Input
                                                    GeometryInfo,                 & ! Input
                                                    ChannelInfo%Channel_Index(l), & ! Input
                                                    AerosolScatter,               & ! In/Output
                                                    Message_Log = Message_Log     ) ! Error messaging

        IF ( Error_Status /= SUCCESS ) THEN
          WRITE( Message, '( "Error computing AerosolScatter for ", a, ", channel ", i4 )' ) &
                          TRIM( ChannelInfo%Sensor_Descriptor(l) ), &
                          ChannelInfo%Sensor_Channel(l)
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM( Message ), &
                                Error_Status, &
                                Message_Log = Message_Log )
          RETURN
        END IF

      END IF


      ! ---------------------------------------------------
      ! Compute the combined atmospheric optical properties
      ! ---------------------------------------------------

      CALL CRTM_Combine_AtmOptics( AtmAbsorption,  & ! Input
                                   CloudScatter,   & ! Input
                                   AerosolScatter, & ! Input
                                   AtmOptics,      & ! Output
                                   AOV             ) ! Internal variable output


      ! ------------------------------------
      ! Fill the SfcOptics structure for the
      ! optional emissivity input case.
      ! ------------------------------------

      ! Indicate SfcOptics ARE to be computed
      SfcOptics%Compute_Switch = SET

      ! Change SfcOptics emissivity/reflectivity
      ! contents/computation status
      IF ( User_Emissivity ) THEN
        SfcOptics%Compute_Switch  = NOT_SET

        SfcOptics%Emissivity(1,1)       = Options%Emissivity(l)
        SfcOptics%Reflectivity(1,1,1,1) = ONE - Options%Emissivity(l)

        IF ( User_Direct_Reflectivity ) THEN
          SfcOptics%Direct_Reflectivity(1,1) = Options%Direct_Reflectivity(l)
        ELSE
          SfcOptics%Direct_Reflectivity(1,1) = SfcOptics%Reflectivity(1,1,1,1)
        END IF

      END IF


      ! ------------------------------------
      ! Solve the radiative transfer problem
      ! ------------------------------------

      Error_Status = CRTM_Compute_RTSolution( Atmosphere,                   &  ! Input
                                              Surface,                      &  ! Input
                                              AtmOptics,                    &  ! Input
                                              SfcOptics,                    &  ! Input
                                              GeometryInfo,                 &  ! Input
                                              ChannelInfo%Channel_Index(l), &  ! Input
                                              RTSolution(l),                &  ! Output
                                              RTV,                          &  ! Internal variable output
                                              Message_Log = Message_Log     )  ! Error messaging

      IF ( Error_Status /= SUCCESS ) THEN
        WRITE( Message, '( "Error computing RTSolution for ", a, &
                          &", channel ", i4 )' ) &
                        TRIM( ChannelInfo%Sensor_Descriptor(l) ), &
                        ChannelInfo%Sensor_Channel(l)
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM( Message ), &
                              Error_Status, &
                              Message_Log = Message_Log )
        RETURN
!          OR
!        CYCLE Channel_Loop
      END IF

    END DO Channel_Loop



    !#--------------------------------------------------------------------------#
    !#                    -- DEALLOCATE LOCAL STRUCTURES --                     #
    !#--------------------------------------------------------------------------#

    ! -----------------------
    ! The SfcOptics structure
    ! -----------------------

    Status = CRTM_Destroy_SfcOptics( SfcOptics )

    IF ( Status /= SUCCESS ) THEN
      Error_Status = WARNING
      CALL Display_Message( ROUTINE_NAME, &
                            'Error deallocating SfcOptics structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
    END IF


    ! -----------------------
    ! The AtmOptics structure
    ! -----------------------

    Status = CRTM_Destroy_AtmScatter( AtmOptics )

    IF ( Status /= SUCCESS ) THEN
      Error_Status = WARNING
      CALL Display_Message( ROUTINE_NAME, &
                            'Error deallocating AtmOptics structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
    END IF


    ! ----------------------------
    ! The AerosolScatter structure
    ! ----------------------------

    Status = CRTM_Destroy_AtmScatter( AerosolScatter )

    IF ( Status /= SUCCESS ) THEN
      Error_Status = WARNING
      CALL Display_Message( ROUTINE_NAME, &
                            'Error deallocating AerosolScatter structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
    END IF


    ! --------------------------
    ! The CloudScatter structure
    ! --------------------------

    Status = CRTM_Destroy_AtmScatter( CloudScatter )

    IF ( Status /= SUCCESS ) THEN
      Error_Status = WARNING
      CALL Display_Message( ROUTINE_NAME, &
                            'Error deallocating CloudScatter structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
    END IF


    ! ---------------------------
    ! The AtmAbsorption structure
    ! ---------------------------

    Status = CRTM_Destroy_AtmAbsorption( AtmAbsorption )

    IF ( Status /= SUCCESS ) THEN
      Error_Status = WARNING
      CALL Display_Message( ROUTINE_NAME, &
                            'Error deallocating AtmAbsorption structure', &
                            Error_Status, &
                            Message_Log = Message_Log )
    END IF

  END FUNCTION CRTM_Forward_scalar

END MODULE CRTM_Forward_Module
