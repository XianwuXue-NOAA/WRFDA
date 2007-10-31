!
! CRTM_Surface_Define
!
! Module defining the CRTM Surface data structure and containing routines
! to manipulate it.
!
!
! PUBLIC PARAMETERS:
!       1) The type of land surface using in the Surface%Land_Type field:
!
!                  Land type                Parameter Name
!         --------------------------------------------------------
!                   Invalid                 INVALID_LAND            
!                Compacted soil             COMPACTED_SOIL          
!                  Tilled soil              TILLED_SOIL             
!                    Sand                   SAND                      
!                    Rock                   ROCK                      
!           Irrigated low vegetation        IRRIGATED_LOW_VEGETATION
!                 Meadow grass              MEADOW_GRASS            
!                    Scrub                  SCRUB                     
!               Broadleaf forest            BROADLEAF_FOREST        
!                 Pine forest               PINE_FOREST             
!                   Tundra                  TUNDRA                   
!                 Grass soil                GRASS_SOIL              
!             Broadleaf-pine forest         BROADLEAF_PINE_FOREST   
!                 Grass scrub               GRASS_SCRUB             
!                  Oil grass                OIL_GRASS               
!                Urban concrete             URBAN_CONCRETE          
!                  Pine brush               PINE_BRUSH              
!                Broadleaf brush            BROADLEAF_BRUSH         
!                   Wet soil                WET_SOIL                 
!                  Scrub soil               SCRUB_SOIL              
!            Broadleaf(70)-Pine(30)         BROADLEAF70_PINE30
!
!
!
!       2) The type of water surface using in the Surface%Water_Type field:
!
!           Water type        Parameter Name
!         ------------------------------------
!             Invalid         INVALID_WATER 
!            Sea water        SEA_WATER     
!           Fresh water       FRESH_WATER   
!
!
!
!       3) The type of snow surface using in the Surface%Snow_Type field:
!
!               Snow type            Parameter Name
!         -----------------------------------------------
!
!                Invalid             INVALID_SNOW       
!               Wet snow             WET_SNOW           
!            Grass after snow        GRASS_AFTER_SNOW   
!              Powder snow           POWDER_SNOW        
!               RS snow(A)           RS_SNOW_A          
!               RS snow(B)           RS_SNOW_B          
!               RS snow(C)           RS_SNOW_C          
!               RS snow(D)           RS_SNOW_D          
!               RS snow(E)           RS_SNOW_E          
!            Thin Crust snow         THIN_CRUST_SNOW    
!            Thick crust snow        THICK_CRUST_SNOW   
!              Shallow snow          SHALLOW_SNOW       
!               Deep snow            DEEP_SNOW          
!              Crust snow            CRUST_SNOW         
!              Medium snow           MEDIUM_SNOW        
!           Bottom crust snow(A)     BOTTOM_CRUST_SNOW_A
!           Bottom crust snow(B)     BOTTOM_CRUST_SNOW_B
!
!
!
!       4) The type of ice surface using in the Surface%Ice_Type field:
!
!                  Ice type           Parameter Name
!         ------------------------------------------------
!                  Invalid            INVALID_ICE       
!                 Fresh ice           FRESH_ICE         
!             First year sea ice      FIRST_YEAR_SEA_ICE
!           Multiple year sea ice     MULTI_YEAR_SEA_ICE
!                 Ice floe            ICE_FLOE            
!                 Ice ridge           ICE_RIDGE           
!
!
!
! CREATION HISTORY:
!       Written by:  Yong Han,       NOAA/NESDIS;     Yong.Han@noaa.gov
!                    Quanhua Liu,    QSS Group, Inc;  Quanhua.Liu@noaa.gov
!                    Paul van Delst, CIMSS/SSEC;      paul.vandelst@ssec.wisc.edu
!                    07-May-2004
!

MODULE CRTM_Surface_Define

  ! -----------------
  ! Environment setup
  ! -----------------
  ! Module use
  USE Type_Kinds            , ONLY: fp
  USE Message_Handler       , ONLY: SUCCESS, FAILURE, Display_Message
  USE Compare_Float_Numbers , ONLY: Compare_Float
  USE CRTM_Parameters       , ONLY: ZERO, ONE, NO, YES, SET
  USE CRTM_SensorData_Define, ONLY: CRTM_SensorData_type, &
                                    CRTM_Associated_SensorData, &
                                    CRTM_Destroy_SensorData, &
                                    CRTM_Allocate_SensorData, &
                                    CRTM_Assign_SensorData, &
                                    CRTM_Equal_SensorData
  ! Disable implicit typing
  IMPLICIT NONE


  ! ------------
  ! Visibilities
  ! ------------
  ! Everything private by default
  PRIVATE
  ! CRTM_SensorData structure routines inherited
  ! from the CRTM_SensorData_Define module
  PUBLIC :: CRTM_Associated_SensorData
  PUBLIC :: CRTM_Destroy_SensorData
  PUBLIC :: CRTM_Allocate_SensorData
  PUBLIC :: CRTM_Assign_SensorData
  PUBLIC :: CRTM_Equal_SensorData
  !  Goess surface parameters
  PUBLIC :: INVALID_SURFACE
  PUBLIC :: LAND_SURFACE
  PUBLIC :: WATER_SURFACE
  PUBLIC :: SNOW_SURFACE
  PUBLIC :: ICE_SURFACE
  PUBLIC :: N_VALID_SURFACE_TYPES
  PUBLIC :: SURFACE_TYPE_NAME
  ! Land surface parameters
  PUBLIC :: N_VALID_LAND_TYPES
  PUBLIC :: INVALID_LAND
  PUBLIC :: COMPACTED_SOIL
  PUBLIC :: TILLED_SOIL
  PUBLIC :: SAND
  PUBLIC :: ROCK
  PUBLIC :: IRRIGATED_LOW_VEGETATION
  PUBLIC :: MEADOW_GRASS
  PUBLIC :: SCRUB
  PUBLIC :: BROADLEAF_FOREST
  PUBLIC :: PINE_FOREST
  PUBLIC :: TUNDRA
  PUBLIC :: GRASS_SOIL
  PUBLIC :: BROADLEAF_PINE_FOREST
  PUBLIC :: GRASS_SCRUB
  PUBLIC :: OIL_GRASS
  PUBLIC :: URBAN_CONCRETE
  PUBLIC :: PINE_BRUSH
  PUBLIC :: BROADLEAF_BRUSH
  PUBLIC :: WET_SOIL
  PUBLIC :: SCRUB_SOIL
  PUBLIC :: BROADLEAF70_PINE30
  PUBLIC :: LAND_TYPE_NAME
  ! Water surface parameters
  PUBLIC :: N_VALID_WATER_TYPES
  PUBLIC :: INVALID_WATER
  PUBLIC :: SEA_WATER
  PUBLIC :: FRESH_WATER
  PUBLIC :: WATER_TYPE_NAME
  ! Snow surface parameters
  PUBLIC :: N_VALID_SNOW_TYPES
  PUBLIC :: INVALID_SNOW
  PUBLIC :: WET_SNOW
  PUBLIC :: GRASS_AFTER_SNOW
  PUBLIC :: RS_SNOW_A
  PUBLIC :: POWDER_SNOW
  PUBLIC :: RS_SNOW_B
  PUBLIC :: RS_SNOW_C
  PUBLIC :: RS_SNOW_D
  PUBLIC :: THIN_CRUST_SNOW
  PUBLIC :: RS_SNOW_E
  PUBLIC :: BOTTOM_CRUST_SNOW_A
  PUBLIC :: SHALLOW_SNOW
  PUBLIC :: DEEP_SNOW
  PUBLIC :: CRUST_SNOW
  PUBLIC :: MEDIUM_SNOW
  PUBLIC :: BOTTOM_CRUST_SNOW_B
  PUBLIC :: THICK_CRUST_SNOW
  PUBLIC :: NEW_SNOW
  PUBLIC :: OLD_SNOW
  PUBLIC :: SNOW_TYPE_NAME
  ! Ice surface parameters
  PUBLIC :: N_VALID_ICE_TYPES
  PUBLIC :: INVALID_ICE
  PUBLIC :: FRESH_ICE
  PUBLIC :: FIRST_YEAR_SEA_ICE
  PUBLIC :: MULTI_YEAR_SEA_ICE
  PUBLIC :: ICE_FLOE
  PUBLIC :: ICE_RIDGE
  PUBLIC :: ICE_TYPE_NAME
  ! CRTM_Surface structure definition
  PUBLIC :: CRTM_Surface_type
  ! CRTM_Surface routines in this module
  PUBLIC :: CRTM_Destroy_Surface
  PUBLIC :: CRTM_Allocate_Surface
  PUBLIC :: CRTM_Assign_Surface
  PUBLIC :: CRTM_Equal_Surface
  PUBLIC :: CRTM_WeightedSum_Surface
  PUBLIC :: CRTM_Zero_Surface


  ! ---------------------
  ! Procedure overloading
  ! ---------------------
  INTERFACE CRTM_Destroy_Surface
    MODULE PROCEDURE Destroy_Scalar
    MODULE PROCEDURE Destroy_Rank1
    MODULE PROCEDURE Destroy_Rank2
  END INTERFACE CRTM_Destroy_Surface

  INTERFACE CRTM_Allocate_Surface
    MODULE PROCEDURE Allocate_Scalar
    MODULE PROCEDURE Allocate_Rank01
    MODULE PROCEDURE Allocate_Rank11
  END INTERFACE CRTM_Allocate_Surface

  INTERFACE CRTM_Assign_Surface
    MODULE PROCEDURE Assign_Scalar
    MODULE PROCEDURE Assign_Rank1
    MODULE PROCEDURE Assign_Rank2
  END INTERFACE CRTM_Assign_Surface

  INTERFACE CRTM_Equal_Surface
    MODULE PROCEDURE Equal_Scalar
    MODULE PROCEDURE Equal_Rank1
    MODULE PROCEDURE Equal_Rank2
  END INTERFACE CRTM_Equal_Surface

  INTERFACE CRTM_WeightedSum_Surface
    MODULE PROCEDURE WeightedSum_Scalar
    MODULE PROCEDURE WeightedSum_Rank1
    MODULE PROCEDURE WeightedSum_Rank2
  END INTERFACE CRTM_WeightedSum_Surface

  INTERFACE CRTM_Zero_Surface
    MODULE PROCEDURE Zero_Scalar
    MODULE PROCEDURE Zero_Rank1
    MODULE PROCEDURE Zero_Rank2
  END INTERFACE CRTM_Zero_Surface


  ! -----------------
  ! Module parameters
  ! -----------------
  ! The gross surface types. These are used for
  ! cross-checking with the coverage fractions
  ! of each gross surface types.
  INTEGER, PARAMETER :: INVALID_SURFACE = 0
  INTEGER, PARAMETER :: LAND_SURFACE    = 1
  INTEGER, PARAMETER :: WATER_SURFACE   = 2
  INTEGER, PARAMETER :: SNOW_SURFACE    = 4
  INTEGER, PARAMETER :: ICE_SURFACE     = 8
  INTEGER, PARAMETER :: N_VALID_SURFACE_TYPES = LAND_SURFACE  + &
                                                WATER_SURFACE + &
                                                SNOW_SURFACE  + &
                                                ICE_SURFACE
  CHARACTER(*), PARAMETER, DIMENSION( 0:N_VALID_SURFACE_TYPES ) :: &
    SURFACE_TYPE_NAME = (/ 'Invalid surface type     ', &
                           'Land                     ', &
                           'Water                    ', &
                           'Land + water             ', &
                           'Snow                     ', &
                           'Land + snow              ', &
                           'Water + snow             ', &
                           'Land + water + snow      ', &
                           'Ice                      ', &
                           'Land + ice               ', &
                           'Water + ice              ', &
                           'Land + water + ice       ', &
                           'Snow + ice               ', &
                           'Land + snow + ice        ', &
                           'Water + snow + ice       ', &
                           'Land + water + snow + ice' /)


  ! For land, the land types
  INTEGER, PARAMETER :: N_VALID_LAND_TYPES = 20
  INTEGER, PARAMETER :: INVALID_LAND             =  0
  INTEGER, PARAMETER :: COMPACTED_SOIL           =  1
  INTEGER, PARAMETER :: TILLED_SOIL              =  2
  INTEGER, PARAMETER :: SAND                     =  3
  INTEGER, PARAMETER :: ROCK                     =  4
  INTEGER, PARAMETER :: IRRIGATED_LOW_VEGETATION =  5
  INTEGER, PARAMETER :: MEADOW_GRASS             =  6
  INTEGER, PARAMETER :: SCRUB                    =  7
  INTEGER, PARAMETER :: BROADLEAF_FOREST         =  8
  INTEGER, PARAMETER :: PINE_FOREST              =  9
  INTEGER, PARAMETER :: TUNDRA                   = 10
  INTEGER, PARAMETER :: GRASS_SOIL               = 11
  INTEGER, PARAMETER :: BROADLEAF_PINE_FOREST    = 12
  INTEGER, PARAMETER :: GRASS_SCRUB              = 13
  INTEGER, PARAMETER :: OIL_GRASS                = 14
  INTEGER, PARAMETER :: URBAN_CONCRETE           = 15
  INTEGER, PARAMETER :: PINE_BRUSH               = 16
  INTEGER, PARAMETER :: BROADLEAF_BRUSH          = 17
  INTEGER, PARAMETER :: WET_SOIL                 = 18
  INTEGER, PARAMETER :: SCRUB_SOIL               = 19
  INTEGER, PARAMETER :: BROADLEAF70_PINE30       = 20
    CHARACTER(*), PARAMETER, DIMENSION( 0:N_VALID_LAND_TYPES ) :: &
    LAND_TYPE_NAME = (/ 'Invalid land surface type', &
                        'Compacted soil           ', &
                        'Tilled soil              ', &
                        'Sand                     ', &
                        'Rock                     ', &
                        'Irrigated low vegetation ', &
                        'Meadow grass             ', &
                        'Scrub                    ', &
                        'Broadleaf forest         ', &
                        'Pine forest              ', &
                        'Tundra                   ', &
                        'Grass soil               ', &
                        'Broadleaf-pine forest    ', &
                        'Grass scrub              ', &
                        'Oil grass                ', &
                        'Urban concrete           ', &
                        'Pine brush               ', &
                        'Broadleaf brush          ', &
                        'Wet soil                 ', &
                        'Scrub soil               ', &
                        'Broadleaf(70)-Pine(30)   ' /)

  ! For water, the water types
  INTEGER, PARAMETER :: N_VALID_WATER_TYPES = 2
  INTEGER, PARAMETER :: INVALID_WATER  =  0
  INTEGER, PARAMETER :: SEA_WATER      =  1
  INTEGER, PARAMETER :: FRESH_WATER    =  2
    CHARACTER(*), PARAMETER, DIMENSION( 0:N_VALID_WATER_TYPES ) :: &
    WATER_TYPE_NAME = (/ 'Invalid water surface type', &
                         'Sea water                 ', &
                         'Fresh water               ' /)

  ! For snow, the snow types.
  INTEGER, PARAMETER :: N_VALID_SNOW_TYPES = 16
  INTEGER, PARAMETER :: INVALID_SNOW        =  0
  INTEGER, PARAMETER :: WET_SNOW            =  1
  INTEGER, PARAMETER :: GRASS_AFTER_SNOW    =  2
  INTEGER, PARAMETER :: RS_SNOW_A           =  3
  INTEGER, PARAMETER :: POWDER_SNOW         =  4
  INTEGER, PARAMETER :: RS_SNOW_B           =  5
  INTEGER, PARAMETER :: RS_SNOW_C           =  6
  INTEGER, PARAMETER :: RS_SNOW_D           =  7
  INTEGER, PARAMETER :: THIN_CRUST_SNOW     =  8
  INTEGER, PARAMETER :: RS_SNOW_E           =  9
  INTEGER, PARAMETER :: BOTTOM_CRUST_SNOW_A = 10
  INTEGER, PARAMETER :: SHALLOW_SNOW        = 11
  INTEGER, PARAMETER :: DEEP_SNOW           = 12
  INTEGER, PARAMETER :: CRUST_SNOW          = 13
  INTEGER, PARAMETER :: MEDIUM_SNOW         = 14
  INTEGER, PARAMETER :: BOTTOM_CRUST_SNOW_B = 15
  INTEGER, PARAMETER :: THICK_CRUST_SNOW    = 16
  INTEGER, PARAMETER :: NEW_SNOW = POWDER_SNOW
  INTEGER, PARAMETER :: OLD_SNOW = THICK_CRUST_SNOW
  CHARACTER(*), PARAMETER, DIMENSION( 0:N_VALID_SNOW_TYPES ) :: &
    SNOW_TYPE_NAME = (/ 'Invalid snow surface type', &
                        'Wet snow                 ', &
                        'Grass after snow         ', &
                        'RS snow(A)               ', &
                        'Powder snow              ', &
                        'RS snow(B)               ', &
                        'RS snow(C)               ', &
                        'RS snow(D)               ', &
                        'Thin Crust snow          ', &
                        'RS snow(E)               ', &
                        'Bottom crust snow(A)     ', &
                        'Shallow snow             ', &
                        'Deep snow                ', &
                        'Crust snow               ', &
                        'Medium snow              ', &
                        'Bottom crust snow(B)     ', &
                        'Thick crust snow         ' /)

  ! For ice, the ice types.
  INTEGER, PARAMETER :: N_VALID_ICE_TYPES = 5
  INTEGER, PARAMETER :: INVALID_ICE        =  0
  INTEGER, PARAMETER :: FRESH_ICE          =  1
  INTEGER, PARAMETER :: FIRST_YEAR_SEA_ICE =  2
  INTEGER, PARAMETER :: MULTI_YEAR_SEA_ICE =  3
  INTEGER, PARAMETER :: ICE_FLOE           =  4
  INTEGER, PARAMETER :: ICE_RIDGE          =  5
  CHARACTER(*), PARAMETER, DIMENSION( 0:N_VALID_ICE_TYPES ) :: &
     ICE_TYPE_NAME = (/ 'Invalid ice surface type ', &
                        'Fresh ice                ', &
                        'First year sea ice       ', &
                        'Multiple year sea ice    ', &
                        'Ice floe                 ', &
                        'Ice ridge                '/)

  ! RCS Id for the module
  CHARACTER(*), PARAMETER :: MODULE_RCS_ID = &
  '$Id: CRTM_Surface_Define.f90 886 2007-08-23 22:51:40Z paul.vandelst@noaa.gov $'

  ! Surface scalar member invalid values
  INTEGER, PARAMETER ::    INVALID = -1
  INTEGER, PARAMETER :: FP_INVALID = -ONE


  ! ------------------------
  ! Default value parameters
  ! ------------------------
  ! Surface type independent data
  REAL(fp), PARAMETER :: DEFAULT_WIND_SPEED = 5.0_fp  ! m/s
  ! Land surface type data
  INTEGER,  PARAMETER :: DEFAULT_LAND_TYPE             = GRASS_SOIL
  REAL(fp), PARAMETER :: DEFAULT_LAND_TEMPERATURE      = 283.0_fp  ! K
  REAL(fp), PARAMETER :: DEFAULT_SOIL_MOISTURE_CONTENT = 0.05_fp   ! g/cm^3
  REAL(fp), PARAMETER :: DEFAULT_CANOPY_WATER_CONTENT  = 0.05_fp   ! g/cm^3
  REAL(fp), PARAMETER :: DEFAULT_VEGETATION_FRACTION   = 0.3_fp    ! 30%
  REAL(fp), PARAMETER :: DEFAULT_SOIL_TEMPERATURE      = 283.0_fp  ! K
  ! Water type data
  INTEGER,  PARAMETER :: DEFAULT_WATER_TYPE        = SEA_WATER
  REAL(fp), PARAMETER :: DEFAULT_WATER_TEMPERATURE = 283.0_fp   ! K
  REAL(fp), PARAMETER :: DEFAULT_WIND_DIRECTION    = 0.0_fp     ! North
  REAL(fp), PARAMETER :: DEFAULT_SALINITY          = 33.0_fp    ! ppmv
  ! Snow surface type data
  INTEGER,  PARAMETER :: DEFAULT_SNOW_TYPE        = NEW_SNOW
  REAL(fp), PARAMETER :: DEFAULT_SNOW_TEMPERATURE = 263.0_fp   ! K
  REAL(fp), PARAMETER :: DEFAULT_SNOW_DEPTH       = 50.0_fp    ! mm
  REAL(fp), PARAMETER :: DEFAULT_SNOW_DENSITY     = 0.2_fp     ! g/cm^3
  REAL(fp), PARAMETER :: DEFAULT_SNOW_GRAIN_SIZE  = 2.0_fp     ! mm
  ! Ice surface type data
  INTEGER,  PARAMETER :: DEFAULT_ICE_TYPE        = FRESH_ICE
  REAL(fp), PARAMETER :: DEFAULT_ICE_TEMPERATURE = 263.0_fp  ! K
  REAL(fp), PARAMETER :: DEFAULT_ICE_THICKNESS   = 10.0_fp   ! mm
  REAL(fp), PARAMETER :: DEFAULT_ICE_DENSITY     = 0.9_fp    ! g/cm^3
  REAL(fp), PARAMETER :: DEFAULT_ICE_ROUGHNESS   = ZERO


  ! ----------------------------
  ! Surface data type definition
  ! ----------------------------
  TYPE :: CRTM_Surface_type
    INTEGER :: n_Allocates = 0
    ! Dimension values
    INTEGER :: Max_Sensors  = 0  ! N dimension
    INTEGER :: n_Sensors    = 0  ! Nuse dimension
    ! Gross type of surface determined by coverage
    REAL(fp) :: Land_Coverage  = ZERO
    REAL(fp) :: Water_Coverage = ZERO
    REAL(fp) :: Snow_Coverage  = ZERO
    REAL(fp) :: Ice_Coverage   = ZERO
    ! Surface type independent data
    REAL(fp) :: Wind_Speed = DEFAULT_WIND_SPEED
    ! Land surface type data
    INTEGER  :: Land_Type             = DEFAULT_LAND_TYPE
    REAL(fp) :: Land_Temperature      = DEFAULT_LAND_TEMPERATURE
    REAL(fp) :: Soil_Moisture_Content = DEFAULT_SOIL_MOISTURE_CONTENT
    REAL(fp) :: Canopy_Water_Content  = DEFAULT_CANOPY_WATER_CONTENT
    REAL(fp) :: Vegetation_Fraction   = DEFAULT_VEGETATION_FRACTION
    REAL(fp) :: Soil_Temperature      = DEFAULT_SOIL_TEMPERATURE
    ! Water type data
    INTEGER  :: Water_Type        = DEFAULT_WATER_TYPE
    REAL(fp) :: Water_Temperature = DEFAULT_WATER_TEMPERATURE
    REAL(fp) :: Wind_Direction    = DEFAULT_WIND_DIRECTION
    REAL(fp) :: Salinity          = DEFAULT_SALINITY
    ! Snow surface type data
    INTEGER  :: Snow_Type        = DEFAULT_SNOW_TYPE
    REAL(fp) :: Snow_Temperature = DEFAULT_SNOW_TEMPERATURE
    REAL(fp) :: Snow_Depth       = DEFAULT_SNOW_DEPTH
    REAL(fp) :: Snow_Density     = DEFAULT_SNOW_DENSITY
    REAL(fp) :: Snow_Grain_Size  = DEFAULT_SNOW_GRAIN_SIZE
    ! Ice surface type data
    INTEGER  :: Ice_Type        = DEFAULT_ICE_TYPE
    REAL(fp) :: Ice_Temperature = DEFAULT_ICE_TEMPERATURE
    REAL(fp) :: Ice_Thickness   = DEFAULT_ICE_THICKNESS
    REAL(fp) :: Ice_Density     = DEFAULT_ICE_DENSITY
    REAL(fp) :: Ice_Roughness   = DEFAULT_ICE_ROUGHNESS
    ! SensorData containing channel brightness temperatures
    TYPE(CRTM_SensorData_type) :: SensorData  ! N
  END TYPE CRTM_Surface_type


CONTAINS


!##################################################################################
!##################################################################################
!##                                                                              ##
!##                          ## PRIVATE MODULE ROUTINES ##                       ##
!##                                                                              ##
!##################################################################################
!##################################################################################

!----------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Clear_Surface
!
! PURPOSE:
!       Subroutine to clear the scalar members of a CRTM Surface structure to
!       their default values.
!
! CALLING SEQUENCE:
!       CALL CRTM_Clear_Surface( Surface ) ! Output
!
! OUTPUT ARGUMENTS:
!       Surface:     Surface structure for which the scalar members have
!                    been cleared.
!                    UNITS:      N/A
!                    TYPE:       CRTM_Surface_type
!                    DIMENSION:  Scalar
!                    ATTRIBUTES: INTENT(IN OUT)
!
! COMMENTS:
!       Note the INTENT on the output Surface argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!----------------------------------------------------------------------------------

  SUBROUTINE CRTM_Clear_Surface( Surface )
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface
    ! Gross surface type
    Surface%Land_Coverage  = ZERO
    Surface%Water_Coverage = ZERO
    Surface%Snow_Coverage  = ZERO
    Surface%Ice_Coverage   = ZERO
    ! Surface type independent data
    Surface%Wind_Speed = DEFAULT_WIND_SPEED
    ! Land surface type data
    Surface%Land_Type             = DEFAULT_LAND_TYPE
    Surface%Land_Temperature      = DEFAULT_LAND_TEMPERATURE
    Surface%Soil_Moisture_Content = DEFAULT_SOIL_MOISTURE_CONTENT
    Surface%Canopy_Water_Content  = DEFAULT_CANOPY_WATER_CONTENT
    Surface%Vegetation_Fraction   = DEFAULT_VEGETATION_FRACTION
    Surface%Soil_Temperature      = DEFAULT_SOIL_TEMPERATURE
    ! Water surface type data
    Surface%Water_Type        = DEFAULT_WATER_TYPE
    Surface%Water_Temperature = DEFAULT_WATER_TEMPERATURE
    Surface%Wind_Direction    = DEFAULT_WIND_DIRECTION
    Surface%Salinity          = DEFAULT_SALINITY
    ! Snow surface type data
    Surface%Snow_Type        = DEFAULT_SNOW_TYPE
    Surface%Snow_Temperature = DEFAULT_SNOW_TEMPERATURE
    Surface%Snow_Depth       = DEFAULT_SNOW_DEPTH
    Surface%Snow_Density     = DEFAULT_SNOW_DENSITY
    Surface%Snow_Grain_Size  = DEFAULT_SNOW_GRAIN_SIZE
    ! Snow surface type data
    Surface%Ice_Type        = DEFAULT_ICE_TYPE
    Surface%Ice_Temperature = DEFAULT_ICE_TEMPERATURE
    Surface%Ice_Thickness   = DEFAULT_ICE_THICKNESS
    Surface%Ice_Density     = DEFAULT_ICE_DENSITY
    Surface%Ice_Roughness   = DEFAULT_ICE_ROUGHNESS
  END SUBROUTINE CRTM_Clear_Surface





!################################################################################
!################################################################################
!##                                                                            ##
!##                         ## PUBLIC MODULE ROUTINES ##                       ##
!##                                                                            ##
!################################################################################
!################################################################################

!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Destroy_Surface
! 
! PURPOSE:
!       Function to re-initialize the scalar and pointer members of Surface
!       data structures.
!
!       NOTE: This function is mostly a wrapper for the CRTM_SensorData
!             destruction routine to provide the functionality and convenience
!             of allocation of both scalar and rank-1 Surface structures in
!             the same manner as for CRTM_Atmosphere_type structures.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Destroy_Surface( Surface                , &  ! Output
!                                            RCS_Id     =RCS_Id     , &  ! Revision control
!                                            Message_Log=Message_Log  )  ! Error messaging
!
! OUTPUT ARGUMENTS:
!       Surface:      Re-initialized Surface structure. In the context of
!                     the CRTM, rank-1 corresponds to an vector of profiles,
!                     and rank-2 corresponds to an array of channels x profiles.
!                     The latter is used in the K-matrix model.
!                     UNITS:      N/A
!                     TYPE:       CRTM_Surface_type
!                     DIMENSION:  Scalar, Rank-1, or Rank-2 array
!                     ATTRIBUTES: INTENT(IN OUT)
!
! OPTIONAL INPUT ARGUMENTS:
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
!                     ATTRIBUTES: INTENT(OUT), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status: The return value is an integer defining the error status.
!                     The error codes are defined in the Message_Handler module.
!                     If == SUCCESS the structure re-initialisation was successful
!                        == FAILURE - an error occurred, or
!                                   - the structure internal allocation counter
!                                     is not equal to zero (0) upon exiting this
!                                     function. This value is incremented and
!                                     decremented for every structure allocation
!                                     and deallocation respectively.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!
! COMMENTS:
!       Note the INTENT on the output Surface argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!--------------------------------------------------------------------------------

  FUNCTION Destroy_Scalar( Surface    , &  ! Output
                           No_Clear   , &  ! Optional input
                           RCS_Id     , &  ! Revision control
                           Message_Log) &  ! Error messaging
                         RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface
    INTEGER,       OPTIONAL, INTENT(IN)     :: No_Clear
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Destroy_Surface(Scalar)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    LOGICAL :: Clear
    INTEGER :: Allocate_Status

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Default is to clear scalar members...
    Clear = .TRUE.
    ! ....unless the No_Clear argument is set
    IF ( PRESENT( No_Clear ) ) THEN
      IF ( No_Clear == SET ) Clear = .FALSE.
    END IF
    IF ( Clear ) CALL CRTM_Clear_Surface( Surface )


    ! Destroy the SensorData structure component
    ! ------------------------------------------
    Error_Status = CRTM_Destroy_SensorData( Surface%SensorData, &
                                            No_Clear = No_Clear, &
                                            Message_Log=Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      CALL Display_Message( ROUTINE_NAME,    &
                            'Error destroying CRTM_Surface SensorData structure.', &
                            Error_Status,    &
                            Message_Log=Message_Log )
    END IF

  END FUNCTION Destroy_Scalar


  FUNCTION Destroy_Rank1( Surface    , &  ! Output
                          No_Clear   , &  ! Optional input
                          RCS_Id     , &  ! Revision control
                          Message_Log) &  ! Error messaging
                        RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface(:)
    INTEGER,       OPTIONAL, INTENT(IN)     :: No_Clear
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Destroy_Surface(Rank-1)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Reinitialise array
    ! ------------------
    DO n = 1, SIZE( Surface )
      Scalar_Status = Destroy_Scalar( Surface(n), &
                                      No_Clear   =No_Clear, &
                                      Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error destroying element (",i0,")", &
                          &" of Surface structure array." )' ) n
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Destroy_Rank1


  FUNCTION Destroy_Rank2( Surface    , &  ! Output
                          No_Clear   , &  ! Optional input
                          RCS_Id     , &  ! Revision control
                          Message_Log) &  ! Error messaging
                        RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface(:,:)
    INTEGER     ,  OPTIONAL, INTENT(IN)     :: No_Clear
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Destroy_Surface(Rank-2)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: l, m

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Reinitialise array
    ! ------------------
    DO m = 1, SIZE(Surface,2)
      DO l = 1, SIZE(Surface,1)
        Scalar_Status = Destroy_Scalar( Surface(l,m), &
                                        No_Clear   =No_Clear, &
                                        Message_Log=Message_Log )
        IF ( Scalar_Status /= SUCCESS ) THEN
          Error_Status = Scalar_Status
          WRITE( Message, '( "Error destroying element (",i0,",",i0,")", &
                            &" of Surface structure array." )' ) l, m
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM(Message), &
                                Error_Status, &
                                Message_Log=Message_Log )
        END IF
      END DO
    END DO

  END FUNCTION Destroy_Rank2
  

!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Allocate_Surface
! 
! PURPOSE:
!       Function to allocate CRTM_Surface data structures.
!
!       NOTE: This function is a wrapper for the CRTM_SensorData allocation 
!             routine to provide the functionality and convenience for
!             allocation of both scalar and rank-1 Surface structures in
!             the same manner as for CRTM_Atmosphere_type structures.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Allocate_Surface( n_Channels             , &  ! Input
!                                             Surface                , &  ! Output
!                                             RCS_Id     =RCS_Id     , &  ! Revision control
!                                             Message_Log=Message_Log  )  ! Error messaging
!
! INPUT ARGUMENTS:
!       n_Channels:   Number of channels dimension of Surface%SensorData
!                     structure
!                     ** Note: Can be = 0 (i.e. no sensor data). **
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar OR Rank-1
!                                 See output Surface dimensionality table
!                     ATTRIBUTES: INTENT(IN)
!
! OPTIONAL INPUT ARGUMENTS:
!       Message_Log:  Character string specifying a filename in which any
!                     messages will be logged. If not specified, or if an
!                     error occurs opening the log file, the default action
!                     is to output messages to standard output.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER(*)
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(IN), OPTIONAL
!
! OUTPUT ARGUMENTS:
!       Surface:      Surface structure with allocated SensorData pointer
!                     members. The following table shows the allowable dimension
!                     combinations for the calling routine, where M == number of
!                     profiles/surface locations:
!
!                        Input       Output
!                      n_Channels   Surface
!                       dimension   dimension
!                     --------------------------
!                        scalar      scalar
!                        scalar        M
!                          M           M
!
!                     These multiple interfaces are supplied purely for ease of
!                     use depending on what data is available.
!                     
!                     UNITS:      N/A
!                     TYPE:       CRTM_Surface_type
!                     DIMENSION:  Scalar or Rank-1
!                                 See chart above.
!                     ATTRIBUTES: INTENT(IN OUT)
!
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:       Character string containing the Revision Control
!                     System Id field for the module.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER(*)
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(OUT), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status: The return value is an integer defining the error status.
!                     The error codes are defined in the Message_Handler module.
!                     If == SUCCESS the structure re-initialisation was successful
!                        == FAILURE - an error occurred, or
!                                   - the structure internal allocation counter
!                                     is not equal to one (1) upon exiting this
!                                     function. This value is incremented and
!                                     decremented for every structure allocation
!                                     and deallocation respectively.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!
! COMMENTS:
!       Note the INTENT on the output Surface argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!--------------------------------------------------------------------------------

  FUNCTION Allocate_Scalar( n_Channels,   &  ! Input
                            Surface,      &  ! Output
                            RCS_Id,       &  ! Revision control
                            Message_Log ) &  ! Error messaging
                          RESULT( Error_Status )
    ! Arguments
    INTEGER,                 INTENT(IN)     :: n_Channels   
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Surface(Scalar)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    INTEGER :: Allocate_Status


    ! ------
    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! If no channel data, do nothing
    IF ( n_Channels == 0 ) RETURN

    ! Check for invalid channel number
    IF ( n_Channels < 0 ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Channels must be > or = 0.', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! ---------------------------------
    ! Allocate the SensorData structure
    ! ---------------------------------
    Error_Status = CRTM_Allocate_SensorData( n_Channels,         &
                                             Surface%SensorData, &
                                             Message_Log=Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      CALL Display_Message( ROUTINE_NAME,    &
                            'Error allocating CRTM_SensorData structure.', &
                            Error_Status,    &
                            Message_Log=Message_Log )
      RETURN
    END IF

  END FUNCTION Allocate_Scalar

  FUNCTION Allocate_Rank01( n_Channels,   &  ! Input
                            Surface,      &  ! Output
                            RCS_Id,       &  ! Revision control
                            Message_Log ) &  ! Error messaging
                          RESULT( Error_Status )
    ! Arguments
    INTEGER,                               INTENT(IN)     :: n_Channels
    TYPE(CRTM_Surface_type), DIMENSION(:), INTENT(IN OUT) :: Surface
    CHARACTER(*),            OPTIONAL,     INTENT(OUT)    :: RCS_Id
    CHARACTER(*),            OPTIONAL,     INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Surface(Rank-01)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Perform the allocation
    DO i = 1, SIZE( Surface )
      Scalar_Status = Allocate_Scalar( n_Channels, &
                                       Surface(i), &
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i5, &
                          &" of CRTM_Surface structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank01


  FUNCTION Allocate_Rank11( n_Channels,   &  ! Input
                            Surface,      &  ! Output
                            RCS_Id,       &  ! Revision control
                            Message_Log ) &  ! Error messaging
                          RESULT( Error_Status )
    ! Arguments
    INTEGER,                 DIMENSION(:), INTENT(IN)     :: n_Channels
    TYPE(CRTM_Surface_type), DIMENSION(:), INTENT(IN OUT) :: Surface
    CHARACTER(*),            OPTIONAL,     INTENT(OUT)    :: RCS_Id
    CHARACTER(*),            OPTIONAL,     INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Surface(Rank-11)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( n_Channels )
    IF ( SIZE( Surface ) /= n ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Channels and CRTM_Surface arrays have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF

    ! Perform the allocation
    DO i = 1, n
      Scalar_Status = Allocate_Scalar( n_Channels(i), &
                                       Surface(i), &
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i5, &
                          &" of CRTM_Surface structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank11


!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Assign_Surface
!
! PURPOSE:
!       Function to copy valid Surface structures.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Assign_Surface( Surface_in             , &  ! Input
!                                           Surface_out            , &  ! Output
!                                           RCS_Id     =RCS_Id     , &  ! Revision control
!                                           Message_Log=Message_Log  )  ! Error messaging
!
! INPUT ARGUMENTS:
!       Surface_in:   Surface structure which is to be copied. In the context of
!                     the CRTM, rank-1 corresponds to an vector of profiles,
!                     and rank-2 corresponds to an array of channels x profiles.
!                     The latter is used in the K-matrix model.
!                     UNITS:      N/A
!                     TYPE:       CRTM_Surface_type
!                     DIMENSION:  Scalar, Rank-1, or Rank-2 array
!                     ATTRIBUTES: INTENT(IN)
!
! OUTPUT ARGUMENTS:
!       Surface_out:  Copy of the input structure, Surface_in.
!                     UNITS:      N/A
!                     TYPE:       CRTM_Surface_type
!                     DIMENSION:  Same as Surface_in
!                     ATTRIBUTES: INTENT(IN OUT)
!
! OPTIONAL INPUT ARGUMENTS:
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
!                     ATTRIBUTES: INTENT(OUT), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status: The return value is an integer defining the error status.
!                     The error codes are defined in the Message_Handler module.
!                     If == SUCCESS the structure assignment was successful
!                        == FAILURE an error occurred
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!
! COMMENTS:
!       Note the INTENT on the output Surface argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!--------------------------------------------------------------------------------

  FUNCTION Assign_Scalar( Surface_in , &  ! Input
                          Surface_out, &  ! Output
                          RCS_Id     , &  ! Revision control
                          Message_Log) &  ! Error messaging
                        RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN)     :: Surface_in
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface_out
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Assign_Surface(Scalar)'

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID


    ! Assign scalar members
    ! ---------------------
    Surface_out%Land_Coverage         = Surface_in%Land_Coverage
    Surface_out%Water_Coverage        = Surface_in%Water_Coverage
    Surface_out%Snow_Coverage         = Surface_in%Snow_Coverage
    Surface_out%Ice_Coverage          = Surface_in%Ice_Coverage
    Surface_out%Wind_Speed            = Surface_in%Wind_Speed
    Surface_out%Land_Type             = Surface_in%Land_Type
    Surface_out%Land_Temperature      = Surface_in%Land_Temperature
    Surface_out%Soil_Moisture_Content = Surface_in%Soil_Moisture_Content
    Surface_out%Canopy_Water_Content  = Surface_in%Canopy_Water_Content
    Surface_out%Vegetation_Fraction   = Surface_in%Vegetation_Fraction
    Surface_out%Soil_Temperature      = Surface_in%Soil_Temperature
    Surface_out%Water_Type            = Surface_in%Water_Type
    Surface_out%Water_Temperature     = Surface_in%Water_Temperature
    Surface_out%Wind_Direction        = Surface_in%Wind_Direction
    Surface_out%Salinity              = Surface_in%Salinity
    Surface_out%Snow_Type             = Surface_in%Snow_Type
    Surface_out%Snow_Temperature      = Surface_in%Snow_Temperature
    Surface_out%Snow_Depth            = Surface_in%Snow_Depth
    Surface_out%Snow_Density          = Surface_in%Snow_Density
    Surface_out%Snow_Grain_Size       = Surface_in%Snow_Grain_Size
    Surface_out%Ice_Type              = Surface_in%Ice_Type
    Surface_out%Ice_Temperature       = Surface_in%Ice_Temperature
    Surface_out%Ice_Thickness         = Surface_in%Ice_Thickness
    Surface_out%Ice_Density           = Surface_in%Ice_Density
    Surface_out%Ice_Roughness         = Surface_in%Ice_Roughness


    ! Assign the SensorData structure
    ! -------------------------------
    IF ( Surface_In%SensorData%n_Channels > 0 ) THEN

      ! If there is data to copy, then do it....
      Error_Status = CRTM_Assign_SensorData( Surface_In%SensorData, &
                                             Surface_Out%SensorData, &
                                             Message_Log=Message_Log )
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME, &
                              'Error copying Surface SensorData structure.', &
                              Error_Status, &
                              Message_Log=Message_Log )
        RETURN
      END IF
    ELSE

      ! ...otherwise simply clear the structure
      Error_Status = CRTM_Destroy_SensorData( Surface_Out%SensorData, &
                                              Message_Log=Message_Log )
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME, &
                              'Error destroying output Surface SensorData structure.', &
                              Error_Status, &
                              Message_Log=Message_Log )
        RETURN
      END IF
    END IF

  END FUNCTION Assign_Scalar


  FUNCTION Assign_Rank1( Surface_in , &  ! Input
                         Surface_out, &  ! Output
                         RCS_Id     , &  ! Revision control
                         Message_Log) &  ! Error messaging
                       RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN)     :: Surface_in(:)
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface_out(:)
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Assign_Surface(Rank-1)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Surface_in )
    IF ( SIZE( Surface_out ) /= n ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input Surface_in and Surface_out arrays'//&
                            ' have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF

    ! Perform the assignment
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Assign_Scalar( Surface_in(i), &
                                     Surface_out(i), &
                                     Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error copying element (",i0,")", &
                          &" of Surface structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Assign_Rank1


  FUNCTION Assign_Rank2( Surface_in , &  ! Input
                         Surface_out, &  ! Output
                         RCS_Id     , &  ! Revision control
                         Message_Log) &  ! Error messaging
                       RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN)     :: Surface_in(:,:)
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface_out(:,:)
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Assign_Surface(Rank-2)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, j, l, m

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    l = SIZE(Surface_in,1)
    m = SIZE(Surface_in,2)
    IF ( SIZE(Surface_out,1) /= l .OR. &
         SIZE(Surface_out,2) /= m      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input Surface_in and Surface_out arrays'//&
                            ' have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the assignment
    ! ----------------------
    DO j = 1, m
      DO i = 1, l
        Scalar_Status = Assign_Scalar( Surface_in(i,j), &
                                       Surface_out(i,j), &
                                       Message_Log=Message_Log )
        IF ( Scalar_Status /= SUCCESS ) THEN
          Error_Status = Scalar_Status
          WRITE( Message, '( "Error copying element (",i0,",",i0,")",&
                            &" of CRTM_Surface structure array." )' ) i,j
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM(Message), &
                                Error_Status, &
                                Message_Log=Message_Log )
        END IF
      END DO
    END DO

  END FUNCTION Assign_Rank2


!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Equal_Surface
!
! PURPOSE:
!       Function to test if two Surface structures are equal.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Equal_Surface( Surface_LHS                          , &  ! Input
!                                          Surface_RHS                          , &  ! Input
!                                          ULP_Scale         =ULP_Scale         , &  ! Optional input
!                                          Percent_Difference=Percent_Difference, &  ! Optional input
!                                          Check_All         =Check_All         , &  ! Optional input
!                                          RCS_Id            =RCS_Id            , &  ! Optional output
!                                          Message_Log       =Message_Log         )  ! Error messaging
!
!
! INPUT ARGUMENTS:
!       Surface_LHS:        Surface structure to be compared; equivalent to the
!                           left-hand side of a lexical comparison, e.g.
!                             IF ( Surface_LHS == Surface_RHS ).
!                           UNITS:      N/A
!                           TYPE:       CRTM_Surface_type
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN)
!
!       Surface_RHS:        Surface structure to be compared to; equivalent to
!                           right-hand side of a lexical comparison, e.g.
!                             IF ( Surface_LHS == Surface_RHS ).
!                           UNITS:      N/A
!                           TYPE:       CRTM_Surface_type
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN)
!
! OPTIONAL INPUT ARGUMENTS:
!       ULP_Scale:          Unit of data precision used to scale the floating
!                           point comparison. ULP stands for "Unit in the Last Place,"
!                           the smallest possible increment or decrement that can be
!                           made using a machine's floating point arithmetic.
!                           Value must be positive - if a negative value is supplied,
!                           the absolute value is used. If not specified, the default
!                           value is 1.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Percent_Differnece: Percentage difference value to use in comparing
!                           the numbers rather than testing within some numerical
!                           limit. The ULP_Scale argument is ignored if this argument is
!                           specified.
!                           UNITS:      N/A
!                           TYPE:       REAL(fp)
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: OPTIONAL, INTENT(IN)
!
!       Check_All:          Set this argument to check ALL the floating point
!                           channel data of the Surface structures. The default
!                           action is return with a FAILURE status as soon as
!                           any difference is found. This optional argument can
!                           be used to get a listing of ALL the differences
!                           between data in Surface structures.
!                           If == 0, Return with FAILURE status as soon as
!                                    ANY difference is found  *DEFAULT*
!                              == 1, Set FAILURE status if ANY difference is
!                                    found, but continue to check ALL data.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Message_Log:        Character string specifying a filename in which any
!                           messages will be logged. If not specified, or if an
!                           error occurs opening the log file, the default action
!                           is to output messages to standard output.
!                           UNITS:      None
!                           TYPE:       CHARACTER(*)
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(IN), OPTIONAL
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:             Character string containing the Revision Control
!                           System Id field for the module.
!                           UNITS:      None
!                           TYPE:       CHARACTER(*)
!                           DIMENSION:  Scalar
!                           ATTRIBUTES: INTENT(OUT), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status:       The return value is an integer defining the error status.
!                           The error codes are defined in the Message_Handler module.
!                           If == SUCCESS the structures were equal
!                              == FAILURE - an error occurred, or
!                                         - the structures were different.
!                           UNITS:      N/A
!                           TYPE:       INTEGER
!                           DIMENSION:  Scalar
!
!--------------------------------------------------------------------------------

  FUNCTION Equal_Scalar( Surface_LHS       , &  ! Input
                         Surface_RHS       , &  ! Input
                         ULP_Scale         , &  ! Optional input
                         Percent_Difference, &  ! Optional input
                         Check_All         , &  ! Optional input
                         RCS_Id            , &  ! Revision control
                         Message_Log       ) &  ! Error messaging
                       RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN)  :: Surface_LHS
    TYPE(CRTM_Surface_type), INTENT(IN)  :: Surface_RHS
    INTEGER,       OPTIONAL, INTENT(IN)  :: ULP_Scale
    REAL(fp),      OPTIONAL, INTENT(IN)  :: Percent_Difference
    INTEGER,       OPTIONAL, INTENT(IN)  :: Check_All
    CHARACTER(*),  OPTIONAL, INTENT(OUT) :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Equal_Surface(scalar)'
    ! Local variables
    CHARACTER(256) :: Message
    LOGICAL :: Check_Once
    INTEGER :: SensorData_Status
    
    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Default action is to return on ANY difference...
    Check_Once = .TRUE.
    ! ...unless the Check_All argument is set
    IF ( PRESENT( Check_All ) ) THEN
      IF ( Check_All == SET ) Check_Once = .FALSE.
    END IF


    ! Check dimensions
    ! ----------------
    IF ( Surface_LHS%n_Sensors /= Surface_RHS%n_Sensors ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Structure dimensions are different', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Compare the values
    ! ------------------
    ! The coverage components
    IF ( .NOT. Compare_Float( Surface_LHS%Land_Coverage, &
                              Surface_RHS%Land_Coverage, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Land coverage values are different:",3(1x,es13.6))') &
                     Surface_LHS%Land_Coverage, &
                     Surface_RHS%Land_Coverage, &
                     Surface_LHS%Land_Coverage-Surface_RHS%Land_Coverage
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Water_Coverage, &
                              Surface_RHS%Water_Coverage, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Water coverage values are different:",3(1x,es13.6))') &
                     Surface_LHS%Water_Coverage, &
                     Surface_RHS%Water_Coverage, &
                     Surface_LHS%Water_Coverage-Surface_RHS%Water_Coverage
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Snow_Coverage, &
                              Surface_RHS%Snow_Coverage, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Snow coverage values are different:",3(1x,es13.6))') &
                     Surface_LHS%Snow_Coverage, &
                     Surface_RHS%Snow_Coverage, &
                     Surface_LHS%Snow_Coverage-Surface_RHS%Snow_Coverage
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Ice_Coverage, &
                              Surface_RHS%Ice_Coverage, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Ice coverage values are different:",3(1x,es13.6))') &
                     Surface_LHS%Ice_Coverage, &
                     Surface_RHS%Ice_Coverage, &
                     Surface_LHS%Ice_Coverage-Surface_RHS%Ice_Coverage
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Wind_Speed, &
                              Surface_RHS%Wind_Speed, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Wind_Spped values are different:",3(1x,es13.6))') &
                     Surface_LHS%Wind_Speed, &
                     Surface_RHS%Wind_Speed, &
                     Surface_LHS%Wind_Speed-Surface_RHS%Wind_Speed
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF

    ! The land components
    IF ( Surface_LHS%Land_Type /= Surface_RHS%Land_Type ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Land_Type values are different:",2(1x,a,"(",i0,")"))') &
                     TRIM(LAND_TYPE_NAME(Surface_LHS%Land_Type)), Surface_LHS%Land_Type, &
                     TRIM(LAND_TYPE_NAME(Surface_RHS%Land_Type)), Surface_RHS%Land_Type
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Land_Temperature, &
                              Surface_RHS%Land_Temperature, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Land_Temperature values are different:",3(1x,es13.6))') &
                     Surface_LHS%Land_Temperature, &
                     Surface_RHS%Land_Temperature, &
                     Surface_LHS%Land_Temperature-Surface_RHS%Land_Temperature
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Soil_Moisture_Content, &
                              Surface_RHS%Soil_Moisture_Content, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Soil_Moisture_Content values are different:",3(1x,es13.6))') &
                     Surface_LHS%Soil_Moisture_Content, &
                     Surface_RHS%Soil_Moisture_Content, &
                     Surface_LHS%Soil_Moisture_Content-Surface_RHS%Soil_Moisture_Content
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Canopy_Water_Content, &
                              Surface_RHS%Canopy_Water_Content, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Canopy_Water_Content values are different:",3(1x,es13.6))') &
                     Surface_LHS%Canopy_Water_Content, &
                     Surface_RHS%Canopy_Water_Content, &
                     Surface_LHS%Canopy_Water_Content-Surface_RHS%Canopy_Water_Content
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Vegetation_Fraction, &
                              Surface_RHS%Vegetation_Fraction, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Vegetation_Fraction values are different:",3(1x,es13.6))') &
                     Surface_LHS%Vegetation_Fraction, &
                     Surface_RHS%Vegetation_Fraction, &
                     Surface_LHS%Vegetation_Fraction-Surface_RHS%Vegetation_Fraction
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Soil_Temperature, &
                              Surface_RHS%Soil_Temperature, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Soil_Temperature values are different:",3(1x,es13.6))') &
                     Surface_LHS%Soil_Temperature, &
                     Surface_RHS%Soil_Temperature, &
                     Surface_LHS%Soil_Temperature-Surface_RHS%Soil_Temperature
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF

    ! The water components
    IF ( Surface_LHS%Water_Type /= Surface_RHS%Water_Type ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Water_Type values are different:",2(1x,a,"(",i0,")"))') &
                     TRIM(WATER_TYPE_NAME(Surface_LHS%Water_Type)), Surface_LHS%Water_Type, &
                     TRIM(WATER_TYPE_NAME(Surface_RHS%Water_Type)), Surface_RHS%Water_Type
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Water_Temperature, &
                              Surface_RHS%Water_Temperature, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Water_Temperature values are different:",3(1x,es13.6))') &
                     Surface_LHS%Water_Temperature, &
                     Surface_RHS%Water_Temperature, &
                     Surface_LHS%Water_Temperature-Surface_RHS%Water_Temperature
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Wind_Direction, &
                              Surface_RHS%Wind_Direction, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Wind_Direction values are different:",3(1x,es13.6))') &
                     Surface_LHS%Wind_Direction, &
                     Surface_RHS%Wind_Direction, &
                     Surface_LHS%Wind_Direction-Surface_RHS%Wind_Direction
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Salinity, &
                              Surface_RHS%Salinity, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Salinity values are different:",3(1x,es13.6))') &
                     Surface_LHS%Salinity, &
                     Surface_RHS%Salinity, &
                     Surface_LHS%Salinity-Surface_RHS%Salinity
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF

    ! The snow components
    IF ( Surface_LHS%Snow_Type /= Surface_RHS%Snow_Type ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Snow_Type values are different:",2(1x,a,"(",i0,")"))') &
                     TRIM(SNOW_TYPE_NAME(Surface_LHS%Snow_Type)), Surface_LHS%Snow_Type, &
                     TRIM(SNOW_TYPE_NAME(Surface_RHS%Snow_Type)), Surface_RHS%Snow_Type
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Snow_Temperature, &
                              Surface_RHS%Snow_Temperature, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Snow_Temperature values are different:",3(1x,es13.6))') &
                     Surface_LHS%Snow_Temperature, &
                     Surface_RHS%Snow_Temperature, &
                     Surface_LHS%Snow_Temperature-Surface_RHS%Snow_Temperature
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Snow_Depth, &
                              Surface_RHS%Snow_Depth, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Snow_Depth values are different:",3(1x,es13.6))') &
                     Surface_LHS%Snow_Depth, &
                     Surface_RHS%Snow_Depth, &
                     Surface_LHS%Snow_Depth-Surface_RHS%Snow_Depth
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Snow_Density, &
                              Surface_RHS%Snow_Density, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Snow_Density values are different:",3(1x,es13.6))') &
                     Surface_LHS%Snow_Density, &
                     Surface_RHS%Snow_Density, &
                     Surface_LHS%Snow_Density-Surface_RHS%Snow_Density
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Snow_Grain_Size, &
                              Surface_RHS%Snow_Grain_Size, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Snow_Grain_Size values are different:",3(1x,es13.6))') &
                     Surface_LHS%Snow_Grain_Size, &
                     Surface_RHS%Snow_Grain_Size, &
                     Surface_LHS%Snow_Grain_Size-Surface_RHS%Snow_Grain_Size
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF

    ! The ice components
    IF ( Surface_LHS%Ice_Type /= Surface_RHS%Ice_Type ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Ice_Type values are different:",2(1x,a,"(",i0,")"))') &
                     TRIM(ICE_TYPE_NAME(Surface_LHS%Ice_Type)), Surface_LHS%Ice_Type, &
                     TRIM(ICE_TYPE_NAME(Surface_RHS%Ice_Type)), Surface_RHS%Ice_Type
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Ice_Temperature, &
                              Surface_RHS%Ice_Temperature, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Ice_Temperature values are different:",3(1x,es13.6))') &
                     Surface_LHS%Ice_Temperature, &
                     Surface_RHS%Ice_Temperature, &
                     Surface_LHS%Ice_Temperature-Surface_RHS%Ice_Temperature
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Ice_Thickness, &
                              Surface_RHS%Ice_Thickness, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Ice_Thickness values are different:",3(1x,es13.6))') &
                     Surface_LHS%Ice_Thickness, &
                     Surface_RHS%Ice_Thickness, &
                     Surface_LHS%Ice_Thickness-Surface_RHS%Ice_Thickness
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Ice_Density, &
                              Surface_RHS%Ice_Density, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Ice_Density values are different:",3(1x,es13.6))') &
                     Surface_LHS%Ice_Density, &
                     Surface_RHS%Ice_Density, &
                     Surface_LHS%Ice_Density-Surface_RHS%Ice_Density
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    IF ( .NOT. Compare_Float( Surface_LHS%Ice_Roughness, &
                              Surface_RHS%Ice_Roughness, &
                              ULP    =ULP_Scale, &
                              Percent=Percent_Difference ) ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Ice_Roughness values are different:",3(1x,es13.6))') &
                     Surface_LHS%Ice_Roughness, &
                     Surface_RHS%Ice_Roughness, &
                     Surface_LHS%Ice_Roughness-Surface_RHS%Ice_Roughness
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF

    ! The SensorData component
    IF ( Surface_LHS%n_Sensors > 0 ) THEN
      SensorData_Status = CRTM_Equal_SensorData( Surface_LHS%SensorData, &
                                                 Surface_RHS%SensorData, &
                                                 ULP_Scale  =ULP_Scale, &
                                                 Check_All  =Check_All, &
                                                 Message_Log=Message_Log )
      IF ( SensorData_Status /= SUCCESS ) THEN
        Error_Status = FAILURE
        CALL Display_Message( ROUTINE_NAME, &
                              'SensorData structures are different', &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END IF
  END FUNCTION Equal_Scalar


  FUNCTION Equal_Rank1( Surface_LHS       , &  ! Input
                        Surface_RHS       , &  ! Output
                        ULP_Scale         , &  ! Optional input
                        Percent_Difference, &  ! Optional input
                        Check_All         , &  ! Optional input
                        RCS_Id            , &  ! Revision control
                        Message_Log       ) &  ! Error messaging
                      RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN)  :: Surface_LHS(:)
    TYPE(CRTM_Surface_type), INTENT(IN)  :: Surface_RHS(:)
    INTEGER,       OPTIONAL, INTENT(IN)  :: ULP_Scale
    REAL(fp),      OPTIONAL, INTENT(IN)  :: Percent_Difference
    INTEGER,       OPTIONAL, INTENT(IN)  :: Check_All
    CHARACTER(*),  OPTIONAL, INTENT(OUT) :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Equal_Surface(Rank-1)'
    ! Local variables
    CHARACTER(256) :: Message
    LOGICAL :: Check_Once
    INTEGER :: Scalar_Status
    INTEGER :: m, nProfiles

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Default action is to return on ANY difference...
    Check_Once = .TRUE.
    ! ...unless the Check_All argument is set
    IF ( PRESENT( Check_All ) ) THEN
      IF ( Check_All == SET ) Check_Once = .FALSE.
    END IF

    ! Arguments must conform
    nProfiles = SIZE( Surface_LHS )
    IF ( SIZE( Surface_RHS ) /= nProfiles ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input Surface_LHS and Surface_RHS arrays'//&
                            ' have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Test for equality
    ! -----------------
    DO m = 1, nProfiles
      Scalar_Status = Equal_Scalar( Surface_LHS(m), &
                                    Surface_RHS(m), &
                                    ULP_Scale         =ULP_Scale, &
                                    Percent_Difference=Percent_Difference, &
                                    Check_All         =Check_All, &
                                    Message_Log       =Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error comparing element (",i0,")", &
                          &" of rank-1 CRTM_Surface structure array." )' ) m
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END DO
  END FUNCTION Equal_Rank1


  FUNCTION Equal_Rank2( Surface_LHS       , &  ! Input
                        Surface_RHS       , &  ! Output
                        ULP_Scale         , &  ! Optional input
                        Percent_Difference, &  ! Optional input
                        Check_All         , &  ! Optional input
                        RCS_Id            , &  ! Revision control
                        Message_Log       ) &  ! Error messaging
                      RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN)  :: Surface_LHS(:,:)
    TYPE(CRTM_Surface_type), INTENT(IN)  :: Surface_RHS(:,:)
    INTEGER,       OPTIONAL, INTENT(IN)  :: ULP_Scale
    REAL(fp),      OPTIONAL, INTENT(IN)  :: Percent_Difference
    INTEGER,       OPTIONAL, INTENT(IN)  :: Check_All
    CHARACTER(*),  OPTIONAL, INTENT(OUT) :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Equal_Surface(Rank-2)'
    ! Local variables
    CHARACTER(256) :: Message
    LOGICAL :: Check_Once
    INTEGER :: Scalar_Status
    INTEGER :: l, nChannels
    INTEGER :: m, nProfiles

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Default action is to return on ANY difference...
    Check_Once = .TRUE.
    ! ...unless the Check_All argument is set
    IF ( PRESENT( Check_All ) ) THEN
      IF ( Check_All == SET ) Check_Once = .FALSE.
    END IF

    ! Arguments must conform
    nChannels = SIZE(Surface_LHS,1)
    nProfiles = SIZE(Surface_LHS,2)
    IF ( SIZE(Surface_RHS,1) /= nChannels .OR. &
         SIZE(Surface_RHS,2) /= nProfiles      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input Surface_LHS and Surface_RHS arrays'//&
                            ' have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Test for equality
    ! -----------------
    DO m = 1, nProfiles
      DO l = 1, nChannels
        Scalar_Status = Equal_Scalar( Surface_LHS(l,m), &
                                      Surface_RHS(l,m), &
                                      ULP_Scale         =ULP_Scale, &
                                      Percent_Difference=Percent_Difference, &
                                      Check_All         =Check_All, &
                                      Message_Log       =Message_Log )
        IF ( Scalar_Status /= SUCCESS ) THEN
          Error_Status = Scalar_Status
          WRITE( Message, '( "Error comparing element (",i0,",",i0,")", &
                            &" of rank-2 CRTM_Surface structure array." )' ) l,m
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM(Message), &
                                Error_Status, &
                                Message_Log=Message_Log )
          IF ( Check_Once ) RETURN
        END IF
      END DO
    END DO
  END FUNCTION Equal_Rank2
  
  
!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_WeightedSum_Surface
!
! PURPOSE:
!       Function to perform a weighted sum of two valid CRTM_Surface
!       structures. The weighted summation performed is:
!         A = A + w1*B + w2
!       where A and B are the CRTM_Surface structures, and w1 and w2
!       are the weighting factors. Note that w2 is optional.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_WeightedSum_Surface( A,                        &  ! In/Output
!                                                B,                        &  ! Input
!                                                w1,                       &  ! Input
!                                                w2 = w2,                  &  ! Optional input
!                                                RCS_Id = RCS_Id,          &  ! Revision control
!                                                Message_Log=Message_Log )  ! Error messaging
!
! INPUT ARGUMENTS:
!       A:               Surface structure that is to be added to.
!                        UNITS:      N/A
!                        TYPE:       CRTM_Surface_type
!                        DIMENSION:  Scalar OR Rank-1
!                        ATTRIBUTES: INTENT(IN OUT)
!
!       B:               Surface structure that is to be weighted and
!                        added to structure A.
!                        UNITS:      N/A
!                        TYPE:       CRTM_Surface_type
!                        DIMENSION:  Same as A
!                        ATTRIBUTES: INTENT(IN)
!
!       w1:              The first weighting factor used to multiply the
!                        contents of the input structure, B.
!                        UNITS:      N/A
!                        TYPE:       REAL(fp)
!                        DIMENSION:  Scalar
!                        ATTRIBUTES: INTENT(IN)
!
! OPTIONAL INPUT ARGUMENTS:
!       w2:              The second weighting factor used to offset the
!                        weighted sum of the input structures.
!                        UNITS:      N/A
!                        TYPE:       REAL(fp)
!                        DIMENSION:  Scalar
!                        ATTRIBUTES: INTENT(IN)
!
!       Message_Log:     Character string specifying a filename in which any
!                        messages will be logged. If not specified, or if an
!                        error occurs opening the log file, the default action
!                        is to output messages to standard output.
!                        UNITS:      N/A
!                        TYPE:       CHARACTER(*)
!                        DIMENSION:  Scalar
!                        ATTRIBUTES: INTENT(IN), OPTIONAL
!
! OUTPUT ARGUMENTS:
!       A:               Structure containing the weight sum result,
!                          A = A + w1*B + w2
!                        UNITS:      N/A
!                        TYPE:       CRTM_Surface_type
!                        DIMENSION:  Same as B
!                        ATTRIBUTES: INTENT(IN OUT)
!
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:          Character string containing the Revision Control
!                        System Id field for the module.
!                        UNITS:      N/A
!                        TYPE:       CHARACTER(*)
!                        DIMENSION:  Scalar
!                        ATTRIBUTES: INTENT(OUT), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status:    The return value is an integer defining the error status.
!                        The error codes are defined in the Message_Handler module.
!                        If == SUCCESS the structure assignment was successful
!                           == FAILURE an error occurred
!                        UNITS:      N/A
!                        TYPE:       INTEGER
!                        DIMENSION:  Scalar
!
! SIDE EFFECTS:
!       The argument A is INTENT(IN OUT) and is modified upon output.
!
!--------------------------------------------------------------------------------

  FUNCTION WeightedSum_Scalar( A,              &  ! Input/Output
                               B,              &  ! Input
                               w1,             &  ! Input
                               w2,             &  ! optional input
                               RCS_Id,         &  ! Revision control
                               Message_Log )   &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: A
    TYPE(CRTM_Surface_type), INTENT(IN)     :: B
    REAL(fp),           INTENT(IN)     :: w1
    REAL(fp), OPTIONAL, INTENT(IN)     :: w2
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_WeightedSum_Surface(Scalar)'
    ! Local variables
    CHARACTER( 256 ) :: Message
    REAL(fp) :: w2_Local


    ! ------
    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Assign the optional weight
    w2_Local = ZERO
    IF ( PRESENT( w2 ) ) w2_Local = w2


    ! ------------------------
    ! Perform the weighted sum
    ! ------------------------
    A%Wind_Speed = A%Wind_Speed + (w1*B%Wind_Speed) + w2_Local
    
    A%Land_Temperature      = A%Land_Temperature      + (w1*B%Land_Temperature     ) + w2_Local
    A%Soil_Moisture_Content = A%Soil_Moisture_Content + (w1*B%Soil_Moisture_Content) + w2_Local
    A%Canopy_Water_Content  = A%Canopy_Water_Content  + (w1*B%Canopy_Water_Content ) + w2_Local
    A%Vegetation_Fraction   = A%Vegetation_Fraction   + (w1*B%Vegetation_Fraction  ) + w2_Local
    A%Soil_Temperature      = A%Soil_Temperature      + (w1*B%Soil_Temperature     ) + w2_Local
    
    A%Water_Temperature = A%Water_Temperature + (w1*B%Water_Temperature) + w2_Local
    A%Wind_Direction    = A%Wind_Direction    + (w1*B%Wind_Direction   ) + w2_Local
    A%Salinity          = A%Salinity          + (w1*B%Salinity         ) + w2_Local
    
    A%Snow_Temperature = A%Snow_Temperature + (w1*B%Snow_Temperature) + w2_Local
    A%Snow_Depth       = A%Snow_Depth       + (w1*B%Snow_Depth      ) + w2_Local
    A%Snow_Density     = A%Snow_Density     + (w1*B%Snow_Density    ) + w2_Local
    A%Snow_Grain_Size  = A%Snow_Grain_Size  + (w1*B%Snow_Grain_Size ) + w2_Local
    
    A%Ice_Temperature = A%Ice_Temperature + (w1*B%Ice_Temperature) + w2_Local
    A%Ice_Thickness   = A%Ice_Thickness   + (w1*B%Ice_Thickness  ) + w2_Local
    A%Ice_Density     = A%Ice_Density     + (w1*B%Ice_Density    ) + w2_Local
    A%Ice_Roughness   = A%Ice_Roughness   + (w1*B%Ice_Roughness  ) + w2_Local

  END FUNCTION WeightedSum_Scalar


  FUNCTION WeightedSum_Rank1( A          , &  ! Input/Output
                              B          , &  ! Input
                              w1         , &  ! Input
                              w2         , &  ! optional input
                              RCS_Id     , &  ! Revision control
                              Message_Log) &  ! Error messaging
                            RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: A(:)
    TYPE(CRTM_Surface_type), INTENT(IN)     :: B(:)
    REAL(fp)    ,            INTENT(IN)     :: w1
    REAL(fp)    ,  OPTIONAL, INTENT(IN)     :: w2
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_WeightSum_Surface(Rank-1)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: m, nProfiles

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    nProfiles = SIZE(A)
    IF ( SIZE(B) /= nProfiles  ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input structure arguments have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the summation
    ! ---------------------
    DO m = 1, nProfiles
      Scalar_Status = WeightedSum_Scalar( A(m), &
                                          B(m), &
                                          w1, &
                                          w2         =w2, &
                                          Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error computing weighted sum for element (",i0,")", &
                          &" of CRTM_Surface structure arrays." )' ) m
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO
  END FUNCTION WeightedSum_Rank1


  FUNCTION WeightedSum_Rank2( A          , &  ! Input/Output
                              B          , &  ! Input
                              w1         , &  ! Input
                              w2         , &  ! optional input
                              RCS_Id     , &  ! Revision control
                              Message_Log) &  ! Error messaging
                            RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: A(:,:)
    TYPE(CRTM_Surface_type), INTENT(IN)     :: B(:,:)
    REAL(fp)    ,            INTENT(IN)     :: w1
    REAL(fp)    ,  OPTIONAL, INTENT(IN)     :: w2
    CHARACTER(*),  OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),  OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_WeightSum_Surface(Rank-2)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: l, nChannels
    INTEGER :: m, nProfiles

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Arguments must conform
    nChannels = SIZE(A,1)
    nProfiles = SIZE(A,2)
    IF ( SIZE(B,1) /= nChannels .OR. &
         SIZE(B,2) /= nProfiles      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input structure arguments have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the summation
    ! ---------------------
    DO m = 1, nProfiles
      DO l = 1, nChannels
        Scalar_Status = WeightedSum_Scalar( A(l,m), &
                                            B(l,m), &
                                            w1, &
                                            w2         =w2, &
                                            Message_Log=Message_Log )
        IF ( Scalar_Status /= SUCCESS ) THEN
          Error_Status = Scalar_Status
          WRITE( Message, '( "Error computing weighted sum for element (",i0,",",i0,")", &
                            &" of CRTM_Surface structure arrays." )' ) l,m
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM(Message), &
                                Error_Status, &
                                Message_Log=Message_Log )
        END IF
      END DO
    END DO
  END FUNCTION WeightedSum_Rank2


!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Zero_Surface
! 
! PURPOSE:
!       Subroutine to zero-out members of a CRTM_Surface structure.
!
! CALLING SEQUENCE:
!       CALL CRTM_Zero_Surface( Surface )
!
! OUTPUT ARGUMENTS:
!       Surface:      Zeroed out Surface structure.
!                     In the context of the CRTM, rank-1 corresponds to an
!                     vector of profiles, and rank-2 corresponds to an array
!                     of channels x profiles. The latter is used in the
!                     K-matrix model.
!                     UNITS:      N/A
!                     TYPE:       CRTM_Surface_type
!                     DIMENSION:  Scalar, Rank-1, or Rank-2 array
!                     ATTRIBUTES: INTENT(IN OUT)
!
! COMMENTS:
!       - No checking of the input structure is performed.
!
!       - The Surface coverage members are *NOT* set to zero.
!
!       - The Surface type components (land, water, snow, and ice) are *NOT*
!         reset.
!
!       - The SensorData dimension and structure components are *NOT*
!         reset.
!
!       - Note the INTENT on the output Surface argument is IN OUT rather than
!         just OUT. This is necessary because the argument must be defined upon
!         input.
!
!--------------------------------------------------------------------------------

  SUBROUTINE Zero_Scalar( Surface )  ! Output
    TYPE(CRTM_Surface_type),  INTENT(IN OUT) :: Surface
    Surface%Wind_Speed            = ZERO
    Surface%Land_Temperature      = ZERO
    Surface%Soil_Moisture_Content = ZERO
    Surface%Canopy_Water_Content  = ZERO
    Surface%Vegetation_Fraction   = ZERO
    Surface%Soil_Temperature      = ZERO
    Surface%Water_Temperature     = ZERO
    Surface%Wind_Direction        = ZERO
    Surface%Salinity              = ZERO
    Surface%Snow_Temperature      = ZERO
    Surface%Snow_Depth            = ZERO
    Surface%Snow_Density          = ZERO
    Surface%Snow_Grain_Size       = ZERO
    Surface%Ice_Temperature       = ZERO
    Surface%Ice_Thickness         = ZERO
    Surface%Ice_Density           = ZERO
    Surface%Ice_Roughness         = ZERO
  END SUBROUTINE Zero_Scalar


  SUBROUTINE Zero_Rank1( Surface )  ! Output
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface(:)
    INTEGER :: m
    DO m = 1, SIZE( Surface )
      CALL Zero_Scalar( Surface(m) )
    END DO
  END SUBROUTINE Zero_Rank1


  SUBROUTINE Zero_Rank2( Surface )  ! Output
    TYPE(CRTM_Surface_type), INTENT(IN OUT) :: Surface(:,:)
    INTEGER :: l, m
    DO m = 1, SIZE(Surface,2)
      DO l = 1, SIZE(Surface,1)
        CALL Zero_Scalar( Surface(l,m) )
      END DO
    END DO
  END SUBROUTINE Zero_Rank2

END MODULE CRTM_Surface_Define
