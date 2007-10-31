!
! CRTM_Atmosphere_Define
!
! Module defining the CRTM Atmosphere structure and containing routines to 
! manipulate it.
!
!
! PUBLIC PARAMETERS:
!
!       CLIMATOLOGY
!       -----------
!
!         1) The valid climatology values used in the Atmosphere%Climatology field:
!
!                 Climatology Type        Parameter Name
!           ------------------------------------------------------
!                     Invalid             INVALID_MODEL         
!                     Tropical            TROPICAL              
!                Midlatitude summer       MIDLATITUDE_SUMMER    
!                Midlatitude winter       MIDLATITUDE_WINTER    
!                 Subarctic summer        SUBARCTIC_SUMMER      
!                 Subarctic winter        SUBARCTIC_WINTER      
!             U.S. Standard Atmosphere    US_STANDARD_ATMOSPHERE
!
!         2) The number of valid climatology models is specified by the 
!              N_VALID_CLIMATOLOGY_MODELS
!            parameter.
!
!         3) The valid climatology names are specified by the 
!             CLIMATOLOGY_MODEL_NAME
!            parameter. It used the above climatology type definitions to provide a
!            string identifying the climatology type. For example,
!              CLIMATOLOGY_MODEL_NAME( MIDLATITUDE_SUMMER )
!            contains the string
!              'Midlatitude summer'
!
!
!       ABSORBER IDENTIFICATION
!       -----------------------
!
!         1) The valid absorber ID values used in the Atmosphere%Absorber_ID field:
!
!             Molecular species        Parameter Name
!           ------------------------------------------------
!                 Invalid              INVALID_ABSORBER_ID
!                   H2O                H2O_ID
!                   CO2                CO2_ID
!                   O3                 O3_ID
!                   N2O                N2O_ID
!                   CO                 CO_ID
!                   CH4                CH4_ID
!                   O2                 O2_ID
!                   NO                 NO_ID
!                   SO2                SO2_ID
!                   NO2                NO2_ID
!                   NH3                NH3_ID
!                  HNO3                HNO3_ID
!                   OH                 OH_ID
!                   HF                 HF_ID
!                   HCl                HCl_ID
!                   HBr                HBr_ID
!                   HI                 HI_ID
!                   ClO                CLO_ID
!                   OCS                OCS_ID
!                  H2CO                H2CO_ID
!                  HOCl                HOCL_ID
!                   N2                 N2_ID
!                   HCN                HCN_ID
!                  CH3l                CH3L_ID
!                  H2O2                H2O2_ID
!                  C2H2                C2H2_ID
!                  C2H6                C2H6_ID
!                   PH3                PH3_ID
!                  COF2                COF2_ID
!                   SF6                SF6_ID
!                   H2S                H2S_ID
!                  HCOOH               HCOOH_ID
!
!         2) The number of valid absorber units is specified by the 
!              N_VALID_ABSORBER_UNITS
!            parameter.
!
!         3) The character string array parameter
!              ABSORBER_ID_NAME
!            uses the above absorber ID definitions to provide a string value for
!            the absorber. For example,
!              ABSORBER_ID_NAME( N2O_ID )
!            contains the string
!              'N2O'
!
!
!       ABSORBER UNITS IDENTIFICATION
!       -----------------------------
!
!         1) The valid absorber units flag values used in the Atmosphere%Absorber_Units field:
!
!             Absorber Units                         Parameter Name
!           -----------------------------------------------------------------------
!             Invalid                                INVALID_ABSORBER_UNITS
!             Volume mixing ratio, ppmv              VOLUME_MIXING_RATIO_UNITS
!             Number density, cm^-3                  NUMBER_DENSITY_UNITS
!             Mass mixing ratio, g/kg                MASS_MIXING_RATIO_UNITS
!             Mass density, g.m^-3                   MASS_DENSITY_UNITS
!             Partial pressure, hPa                  PARTIAL_PRESSURE_UNITS
!             Dewpoint temperature, K  (H2O ONLY)    DEWPOINT_TEMPERATURE_K_UNITS
!             Dewpoint temperature, C  (H2O ONLY)    DEWPOINT_TEMPERATURE_C_UNITS
!             Relative humidity, %     (H2O ONLY)    RELATIVE_HUMIDITY_UNITS
!             Specific amount, g/g                   SPECIFIC_AMOUNT_UNITS
!             Integrated path, mm                    INTEGRATED_PATH_UNITS
!
!         2) The number of valid absorber IDs is specified by the 
!              N_VALID_ABSORBER_IDS
!            parameter.
!
!         3) The character string array parameter
!              ABSORBER_UNITS_NAME
!            uses the above absorber units definitions to provide a string value for
!            the absorber units. For example,
!              ABSORBER_UNITS_NAME( MASS_MIXING_RATIO_UNITS )
!            contains the string
!              'Mass mixing ratio, g/kg'
!
!         4) The parameter array
!              H2O_ONLY_UNITS_FLAG
!            contains a list of flags for each absorber units type that idenitifies
!            it as being valid for *all* absorbers (0) or valid for water vapour
!            only (1). For example the values of
!              H2O_ONLY_UNITS_FLAG( RELATIVE_HUMIDITY_UNITS )
!            and
!              H2O_ONLY_UNITS_FLAG( SPECIFIC_AMOUNT_UNITS )
!            are 1 and 0 respectively indicating that the former is a valid unit for
!            water vapour ONLY but the latter can be used for any absorber.
!
!
! USE ASSOCIATED PUBLIC PARAMETERS:
!
!       CRTM_Cloud_Define MODULE
!       ------------------------
!
!         1) The valid cloud type values used in the Cloud%Type field:
!
!             Cloud Type      Parameter Name
!           ----------------------------------
!               None          NO_CLOUD
!               Water         WATER_CLOUD
!               Ice           ICE_CLOUD
!               Rain          RAIN_CLOUD
!               Snow          SNOW_CLOUD
!               Graupel       GRAUPEL_CLOUD
!               Hail          HAIL_CLOUD
!
!         2) The number of valid cloud types is specified by the 
!              N_VALID_CLOUD_TYPES
!            parameter.
!
!         3) The character string array parameter
!              CLOUD_TYPE_NAME
!            uses the above cloud type definitions to provide a string value for
!            the type of cloud. For example,
!              CLOUD_TYPE_NAME( GRAUPEL_CLOUD )
!            contains the string
!              'Graupel'
!
!
!       CRTM_Aerosol_Define MODULE
!       --------------------------
!
!         1) The valid aerosol type values used in the Aerosol%Type field:
!
!                Aerosol Type      Parameter Name
!           --------------------------------------------------
!                   None           NO_AEROSOL   
!                   Dust           DUST_AEROSOL   
!               Sea salt SSAM(*)   SEASALT_SSAM_AEROSOL 
!               Sea salt SSCM(+)   SEASALT_SSCM_AEROSOL 
!             Dry organic carbon   DRY_ORGANIC_CARBON_AEROSOL
!             Wet organic carbon   WET_ORGANIC_CARBON_AEROSOL
!              Dry black carbon    DRY_BLACK_CARBON_AEROSOL
!              Wet black carbon    WET_BLACK_CARBON_AEROSOL
!                  Sulfate         SULFATE_AEROSOL  
!
!            (*) SSAM == sea salt accumulation mode, Reff ~ 0.5 - 5.0 um
!            (+) SSCM == sea salt coarse mode,       Reff ~ 5.0 - 30 um
!
!         2) The number of valid aerosol types is specified by the 
!              N_VALID_AEROSOL_TYPES
!            parameter.
!
!         3) The character string array parameter
!              AEROSOL_TYPE_NAME
!            uses the above aerosol type definitions to provide a string value for
!            the type of aerosol. For example,
!              AEROSOL_TYPE_NAME( DRY_BLACK_CARBON_AEROSOL )
!            contains the string
!              'Dry black carbon'
!
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 23-Feb-2004
!                       paul.vandelst@ssec.wisc.edu
!

MODULE CRTM_Atmosphere_Define

  ! -----------------
  ! Environment setup
  ! -----------------
  ! Module use
  USE Type_Kinds           , ONLY: fp
  USE Message_Handler      , ONLY: SUCCESS, FAILURE, Display_Message
  USE Compare_Float_Numbers, ONLY: Compare_Float
  USE CRTM_Parameters      , ONLY: ZERO, NO, YES, SET
  USE CRTM_Cloud_Define    , ONLY: N_VALID_CLOUD_TYPES, &
                                   NO_CLOUD, &
                                   WATER_CLOUD, &
                                   ICE_CLOUD, &
                                   RAIN_CLOUD, &
                                   SNOW_CLOUD, &
                                   GRAUPEL_CLOUD, &
                                   HAIL_CLOUD, &
                                   CLOUD_TYPE_NAME, &
                                   CRTM_Cloud_type, &
                                   CRTM_Associated_Cloud, &
                                   CRTM_Destroy_Cloud, &
                                   CRTM_Allocate_Cloud, &
                                   CRTM_Assign_Cloud, &
                                   CRTM_Equal_Cloud, &
                                   CRTM_WeightedSum_Cloud, &
                                   CRTM_Zero_Cloud
  USE CRTM_Aerosol_Define  , ONLY: N_VALID_AEROSOL_TYPES, &
                                   NO_AEROSOL, &
                                   DUST_AEROSOL, &
                                   SEASALT_SSAM_AEROSOL, &
                                   SEASALT_SSCM_AEROSOL, &
                                   DRY_ORGANIC_CARBON_AEROSOL, &
                                   WET_ORGANIC_CARBON_AEROSOL, &
                                   DRY_BLACK_CARBON_AEROSOL, &
                                   WET_BLACK_CARBON_AEROSOL, &
                                   SULFATE_AEROSOL  , &
                                   AEROSOL_TYPE_NAME, &
                                   CRTM_Aerosol_type, &
                                   CRTM_Associated_Aerosol, &
                                   CRTM_Destroy_Aerosol, &
                                   CRTM_Allocate_Aerosol, &
                                   CRTM_Assign_Aerosol, &
                                   CRTM_Equal_Aerosol, &
                                   CRTM_WeightedSum_Aerosol, &
                                   CRTM_Zero_Aerosol
  ! Disable implicit typing
  IMPLICIT NONE


  ! ------------
  ! Visibilities
  ! ------------
  ! Everything private by default
  PRIVATE
  ! CRTM_Cloud parameters
  PUBLIC :: N_VALID_CLOUD_TYPES
  PUBLIC :: NO_CLOUD
  PUBLIC :: WATER_CLOUD
  PUBLIC :: ICE_CLOUD
  PUBLIC :: RAIN_CLOUD
  PUBLIC :: SNOW_CLOUD
  PUBLIC :: GRAUPEL_CLOUD
  PUBLIC :: HAIL_CLOUD
  PUBLIC :: CLOUD_TYPE_NAME
  ! CRTM_Cloud structure data type
  ! in the CRTM_Cloud_Define module
  PUBLIC :: CRTM_Cloud_type
  ! CRTM_Cloud structure routines inherited
  ! from the CRTM_Cloud_Define module
  PUBLIC :: CRTM_Associated_Cloud
  PUBLIC :: CRTM_Destroy_Cloud
  PUBLIC :: CRTM_Allocate_Cloud
  PUBLIC :: CRTM_Assign_Cloud
  PUBLIC :: CRTM_Equal_Cloud
  ! CRTM_Aerosol parameters
  PUBLIC :: N_VALID_AEROSOL_TYPES
  PUBLIC :: NO_AEROSOL
  PUBLIC :: DUST_AEROSOL
  PUBLIC :: SEASALT_SSAM_AEROSOL
  PUBLIC :: SEASALT_SSCM_AEROSOL
  PUBLIC :: DRY_ORGANIC_CARBON_AEROSOL
  PUBLIC :: WET_ORGANIC_CARBON_AEROSOL
  PUBLIC :: DRY_BLACK_CARBON_AEROSOL
  PUBLIC :: WET_BLACK_CARBON_AEROSOL
  PUBLIC :: SULFATE_AEROSOL  
  PUBLIC :: AEROSOL_TYPE_NAME
  ! CRTM_Aerosol structure data type
  ! in the CRTM_Aerosol_Define module
  PUBLIC :: CRTM_Aerosol_type
  ! CRTM_Aerosol structure routines inherited
  ! from the CRTM_Aerosol_Define module
  PUBLIC :: CRTM_Associated_Aerosol
  PUBLIC :: CRTM_Destroy_Aerosol
  PUBLIC :: CRTM_Allocate_Aerosol
  PUBLIC :: CRTM_Assign_Aerosol
  PUBLIC :: CRTM_Equal_Aerosol
  ! CRTM_Atmosphere parameters
  PUBLIC :: N_VALID_ABSORBER_IDS
  PUBLIC :: INVALID_ABSORBER_ID
  PUBLIC ::   H2O_ID
  PUBLIC ::   CO2_ID
  PUBLIC ::    O3_ID
  PUBLIC ::   N2O_ID
  PUBLIC ::    CO_ID
  PUBLIC ::   CH4_ID
  PUBLIC ::    O2_ID
  PUBLIC ::    NO_ID
  PUBLIC ::   SO2_ID
  PUBLIC ::   NO2_ID
  PUBLIC ::   NH3_ID
  PUBLIC ::  HNO3_ID
  PUBLIC ::    OH_ID
  PUBLIC ::    HF_ID
  PUBLIC ::   HCL_ID
  PUBLIC ::   HBR_ID
  PUBLIC ::    HI_ID
  PUBLIC ::   CLO_ID
  PUBLIC ::   OCS_ID
  PUBLIC ::  H2CO_ID
  PUBLIC ::  HOCL_ID
  PUBLIC ::    N2_ID
  PUBLIC ::   HCN_ID
  PUBLIC ::  CH3L_ID
  PUBLIC ::  H2O2_ID
  PUBLIC ::  C2H2_ID
  PUBLIC ::  C2H6_ID
  PUBLIC ::   PH3_ID
  PUBLIC ::  COF2_ID
  PUBLIC ::   SF6_ID
  PUBLIC ::   H2S_ID
  PUBLIC :: HCOOH_ID 
  PUBLIC :: ABSORBER_ID_NAME
  PUBLIC :: N_VALID_ABSORBER_UNITS
  PUBLIC ::       INVALID_ABSORBER_UNITS
  PUBLIC ::    VOLUME_MIXING_RATIO_UNITS
  PUBLIC ::         NUMBER_DENSITY_UNITS
  PUBLIC ::      MASS_MIXING_RATIO_UNITS
  PUBLIC ::           MASS_DENSITY_UNITS
  PUBLIC ::       PARTIAL_PRESSURE_UNITS
  PUBLIC :: DEWPOINT_TEMPERATURE_K_UNITS ! H2O only
  PUBLIC :: DEWPOINT_TEMPERATURE_C_UNITS ! H2O only
  PUBLIC ::      RELATIVE_HUMIDITY_UNITS ! H2O only
  PUBLIC ::        SPECIFIC_AMOUNT_UNITS
  PUBLIC ::        INTEGRATED_PATH_UNITS
  PUBLIC :: ABSORBER_UNITS_NAME
  PUBLIC :: H2O_ONLY_UNITS_FLAG
  PUBLIC :: N_VALID_CLIMATOLOGY_MODELS
  PUBLIC :: INVALID_MODEL
  PUBLIC :: TROPICAL
  PUBLIC :: MIDLATITUDE_SUMMER
  PUBLIC :: MIDLATITUDE_WINTER
  PUBLIC :: SUBARCTIC_SUMMER
  PUBLIC :: SUBARCTIC_WINTER
  PUBLIC :: US_STANDARD_ATMOSPHERE
  PUBLIC :: CLIMATOLOGY_MODEL_NAME
  ! CRTM_Atmosphere structure data type
  PUBLIC :: CRTM_Atmosphere_type
  ! CRTM_Atmosphere routines in this module
  PUBLIC :: CRTM_Associated_Atmosphere
  PUBLIC :: CRTM_Destroy_Atmosphere
  PUBLIC :: CRTM_Allocate_Atmosphere
  PUBLIC :: CRTM_Assign_Atmosphere
  PUBLIC :: CRTM_Equal_Atmosphere
  PUBLIC :: CRTM_WeightedSum_Atmosphere
  PUBLIC :: CRTM_Zero_Atmosphere
  ! Utility routines in this module
  PUBLIC :: CRTM_Get_AbsorberIdx

  ! -------------------
  ! Procedure overloads
  ! -------------------
  INTERFACE CRTM_Destroy_Atmosphere
    MODULE PROCEDURE Destroy_Scalar
    MODULE PROCEDURE Destroy_Rank1
    MODULE PROCEDURE Destroy_Rank2
  END INTERFACE CRTM_Destroy_Atmosphere

  INTERFACE CRTM_Allocate_Atmosphere
    MODULE PROCEDURE Allocate_Scalar
    MODULE PROCEDURE Allocate_Rank00001
    MODULE PROCEDURE Allocate_Rank00011
    MODULE PROCEDURE Allocate_Rank00101
    MODULE PROCEDURE Allocate_Rank00111
    MODULE PROCEDURE Allocate_Rank10001
    MODULE PROCEDURE Allocate_Rank10101
    MODULE PROCEDURE Allocate_Rank10111
  END INTERFACE CRTM_Allocate_Atmosphere

  INTERFACE CRTM_Assign_Atmosphere
    MODULE PROCEDURE Assign_Scalar
    MODULE PROCEDURE Assign_Rank1
    MODULE PROCEDURE Assign_Rank2
  END INTERFACE CRTM_Assign_Atmosphere

  INTERFACE CRTM_Equal_Atmosphere
    MODULE PROCEDURE Equal_Scalar
    MODULE PROCEDURE Equal_Rank1
    MODULE PROCEDURE Equal_Rank2
  END INTERFACE CRTM_Equal_Atmosphere

  INTERFACE CRTM_WeightedSum_Atmosphere
    MODULE PROCEDURE WeightedSum_Scalar
    MODULE PROCEDURE WeightedSum_Rank1
    MODULE PROCEDURE WeightedSum_Rank2
  END INTERFACE CRTM_WeightedSum_Atmosphere

  INTERFACE CRTM_Zero_Atmosphere
    MODULE PROCEDURE Zero_Scalar
    MODULE PROCEDURE Zero_Rank1
    MODULE PROCEDURE Zero_Rank2
  END INTERFACE CRTM_Zero_Atmosphere


  ! -----------------
  ! Module parameters
  ! -----------------
  ! The absorber IDs. Use HITRAN definitions
  INTEGER, PARAMETER :: N_VALID_ABSORBER_IDS = 32
  INTEGER, PARAMETER :: INVALID_ABSORBER_ID =  0
  INTEGER, PARAMETER ::   H2O_ID =  1
  INTEGER, PARAMETER ::   CO2_ID =  2
  INTEGER, PARAMETER ::    O3_ID =  3
  INTEGER, PARAMETER ::   N2O_ID =  4
  INTEGER, PARAMETER ::    CO_ID =  5
  INTEGER, PARAMETER ::   CH4_ID =  6
  INTEGER, PARAMETER ::    O2_ID =  7
  INTEGER, PARAMETER ::    NO_ID =  8
  INTEGER, PARAMETER ::   SO2_ID =  9
  INTEGER, PARAMETER ::   NO2_ID = 10
  INTEGER, PARAMETER ::   NH3_ID = 11
  INTEGER, PARAMETER ::  HNO3_ID = 12
  INTEGER, PARAMETER ::    OH_ID = 13
  INTEGER, PARAMETER ::    HF_ID = 14
  INTEGER, PARAMETER ::   HCl_ID = 15
  INTEGER, PARAMETER ::   HBr_ID = 16
  INTEGER, PARAMETER ::    HI_ID = 17
  INTEGER, PARAMETER ::   ClO_ID = 18
  INTEGER, PARAMETER ::   OCS_ID = 19
  INTEGER, PARAMETER ::  H2CO_ID = 20
  INTEGER, PARAMETER ::  HOCl_ID = 21
  INTEGER, PARAMETER ::    N2_ID = 22
  INTEGER, PARAMETER ::   HCN_ID = 23
  INTEGER, PARAMETER ::  CH3l_ID = 24
  INTEGER, PARAMETER ::  H2O2_ID = 25
  INTEGER, PARAMETER ::  C2H2_ID = 26
  INTEGER, PARAMETER ::  C2H6_ID = 27
  INTEGER, PARAMETER ::   PH3_ID = 28
  INTEGER, PARAMETER ::  COF2_ID = 29
  INTEGER, PARAMETER ::   SF6_ID = 30
  INTEGER, PARAMETER ::   H2S_ID = 31
  INTEGER, PARAMETER :: HCOOH_ID = 32
  CHARACTER(*), PARAMETER, DIMENSION( 0:N_VALID_ABSORBER_IDS ) :: &
    ABSORBER_ID_NAME = (/ 'Invalid', &
                          'H2O    ', 'CO2    ', 'O3     ', 'N2O    ', &
                          'CO     ', 'CH4    ', 'O2     ', 'NO     ', &
                          'SO2    ', 'NO2    ', 'NH3    ', 'HNO3   ', &
                          'OH     ', 'HF     ', 'HCl    ', 'HBr    ', &
                          'HI     ', 'ClO    ', 'OCS    ', 'H2CO   ', &
                          'HOCl   ', 'N2     ', 'HCN    ', 'CH3Cl  ', &
                          'H2O2   ', 'C2H2   ', 'C2H6   ', 'PH3    ', &
                          'COF2   ', 'SF6    ', 'H2S    ', 'HCOOH  ' /)

  ! The absorber units. Use LBLRTM definitions and then some.
  INTEGER, PARAMETER :: N_VALID_ABSORBER_UNITS = 10
  INTEGER, PARAMETER ::       INVALID_ABSORBER_UNITS =  0
  INTEGER, PARAMETER ::    VOLUME_MIXING_RATIO_UNITS =  1
  INTEGER, PARAMETER ::         NUMBER_DENSITY_UNITS =  2
  INTEGER, PARAMETER ::      MASS_MIXING_RATIO_UNITS =  3
  INTEGER, PARAMETER ::           MASS_DENSITY_UNITS =  4
  INTEGER, PARAMETER ::       PARTIAL_PRESSURE_UNITS =  5
  INTEGER, PARAMETER :: DEWPOINT_TEMPERATURE_K_UNITS =  6 ! H2O only
  INTEGER, PARAMETER :: DEWPOINT_TEMPERATURE_C_UNITS =  7 ! H2O only
  INTEGER, PARAMETER ::      RELATIVE_HUMIDITY_UNITS =  8 ! H2O only
  INTEGER, PARAMETER ::        SPECIFIC_AMOUNT_UNITS =  9
  INTEGER, PARAMETER ::        INTEGRATED_PATH_UNITS = 10
  CHARACTER(*), PARAMETER, DIMENSION( 0:N_VALID_ABSORBER_UNITS ) :: &
    ABSORBER_UNITS_NAME = (/ 'Invalid units                      ', &
                             'Volume mixing ratio, ppmv          ', &
                             'Number density, cm^-3              ', &
                             'Mass mixing ratio, g/kg            ', &
                             'Mass density, g.m^-3               ', &
                             'Partial pressure, hPa              ', &
                             'Dewpoint temperature, K  (H2O ONLY)', &
                             'Dewpoint temperature, C  (H2O ONLY)', &
                             'Relative humidity, %     (H2O ONLY)', &
                             'Specific amount, g/g               ', &
                             'Integrated path, mm                ' /)
  INTEGER, PARAMETER, DIMENSION( 0:N_VALID_ABSORBER_UNITS ) :: &
    H2O_ONLY_UNITS_FLAG = (/ 0, &  ! None
                             0, &  ! Volume mixing ratio, ppmv
                             0, &  ! Number density, cm^-3
                             0, &  ! Mass mixing ratio, g/kg
                             0, &  ! Mass density, g.m^-3
                             0, &  ! Partial pressure, hPa
                             1, &  ! Dewpoint temperature, K  (H2O ONLY)
                             1, &  ! Dewpoint temperature, C  (H2O ONLY)
                             1, &  ! Relative humidity, %     (H2O ONLY)
                             0, &  ! Specific amount, g/g
                             0 /)  ! Integrated path, mm

  ! The climatology models
  INTEGER, PARAMETER :: N_VALID_CLIMATOLOGY_MODELS = 6
  INTEGER, PARAMETER :: INVALID_MODEL          = 0
  INTEGER, PARAMETER :: TROPICAL               = 1
  INTEGER, PARAMETER :: MIDLATITUDE_SUMMER     = 2
  INTEGER, PARAMETER :: MIDLATITUDE_WINTER     = 3
  INTEGER, PARAMETER :: SUBARCTIC_SUMMER       = 4
  INTEGER, PARAMETER :: SUBARCTIC_WINTER       = 5
  INTEGER, PARAMETER :: US_STANDARD_ATMOSPHERE = 6 
  CHARACTER(*), PARAMETER, DIMENSION( 0:N_VALID_CLIMATOLOGY_MODELS ) :: &
    CLIMATOLOGY_MODEL_NAME = (/ 'Invalid                 ', &
                                'Tropical                ', &
                                'Midlatitude summer      ', &
                                'Midlatitude winter      ', &
                                'Subarctic summer        ', &
                                'Subarctic winter        ', &
                                'U.S. Standard Atmosphere' /)

  ! RCS Id for the module
  CHARACTER(*), PARAMETER :: MODULE_RCS_ID = &
  '$Id: CRTM_Atmosphere_Define.f90 886 2007-08-23 22:51:40Z paul.vandelst@noaa.gov $'


  ! ------------------------------------
  ! CRTM_Atmosphere structure definition
  ! ------------------------------------
  TYPE :: CRTM_Atmosphere_type
    INTEGER :: n_Allocates = 0
    ! Dimension values
    INTEGER :: Max_Layers   = 0  ! K dimension
    INTEGER :: n_Layers     = 0  ! Kuse dimension
    INTEGER :: n_Absorbers  = 0  ! J dimension
    INTEGER :: Max_Clouds   = 0  ! Nc dimension
    INTEGER :: n_Clouds     = 0  ! NcUse dimension
    INTEGER :: Max_Aerosols = 0  ! Na dimension
    INTEGER :: n_Aerosols   = 0  ! NaUse dimension
    ! Climatology model associated with the profile
    INTEGER :: Climatology = INVALID_MODEL
    ! Absorber ID and units
    INTEGER, DIMENSION(:), POINTER :: Absorber_ID    => NULL() ! J
    INTEGER, DIMENSION(:), POINTER :: Absorber_Units => NULL() ! J
    ! Profile LEVEL and LAYER quantities
    REAL(fp), DIMENSION(:),   POINTER :: Level_Pressure => NULL()  ! 0:K
    REAL(fp), DIMENSION(:),   POINTER :: Pressure       => NULL()  ! K
    REAL(fp), DIMENSION(:),   POINTER :: Temperature    => NULL()  ! K
    REAL(fp), DIMENSION(:,:), POINTER :: Absorber       => NULL()  ! K x J
    ! Clouds associated with each profile
    TYPE(CRTM_Cloud_type),   DIMENSION(:), POINTER :: Cloud   => NULL()  ! Nc
    ! Aerosols associated with each profile
    TYPE(CRTM_Aerosol_type), DIMENSION(:), POINTER :: Aerosol => NULL()  ! Na
  END TYPE CRTM_Atmosphere_type


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
!       CRTM_Clear_Atmosphere
!
! PURPOSE:
!       Subroutine to clear the scalar members of a CRTM_Atmosphere structure.
!
! CALLING SEQUENCE:
!       CALL CRTM_Clear_Atmosphere( Atmosphere ) ! Output
!
! OUTPUT ARGUMENTS:
!       Atmosphere:  Atmosphere structure for which the scalar members have
!                    been cleared.
!                    UNITS:      N/A
!                    TYPE:       CRTM_Atmosphere_type
!                    DIMENSION:  Scalar
!                    ATTRIBUTES: INTENT(IN OUT)
!
! COMMENTS:
!       Note the INTENT on the output Atmosphere argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!----------------------------------------------------------------------------------

  SUBROUTINE CRTM_Clear_Atmosphere( Atmosphere )
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere
    Atmosphere%Climatology = INVALID_MODEL
  END SUBROUTINE CRTM_Clear_Atmosphere



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
!       CRTM_Associated_Atmosphere
!
! PURPOSE:
!       Function to test the association status of the components of a
!       CRTM_Atmosphere structure.
!
! CALLING SEQUENCE:
!       Association_Status = CRTM_Associated_Atmosphere( Atmosphere,                 &  ! Input
!                                                        ANY_Test     = Any_Test,    &  ! Optional input
!                                                        Skip_Cloud   = Skip_Cloud,  &  ! Optional input
!                                                        Skip_Aerosol = Skip_Aerosol )  ! Optional input
!
! INPUT ARGUMENTS:
!       Atmosphere:          Structure which is to have its pointer
!                            member's association status tested.
!                            UNITS:      N/A
!                            TYPE:       CRTM_Atmosphere_type
!                            DIMENSION:  Scalar
!                            ATTRIBUTES: INTENT(IN)
!
! OPTIONAL INPUT ARGUMENTS:
!       ANY_Test:            Set this argument to test if ANY of the
!                            Atmosphere structure components are associated.
!                            The default is to test if ALL the components
!                            are associated.
!                            If ANY_Test = 0, test if ALL the components
!                                             are associated.  (DEFAULT)
!                               ANY_Test = 1, test if ANY of the components
!                                             are associated.
!                            UNITS:      N/A
!                            TYPE:       INTEGER
!                            DIMENSION:  Scalar
!                            ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Skip_Cloud:          Set this argument to not include the Cloud
!                            member in the association test. This is required
!                            because a valid Atmosphere structure can be
!                            cloud-free.
!                            If Skip_Cloud = 0, the Cloud member association
!                                               status is tested.  (DEFAULT)
!                               Skip_Cloud = 1, the Cloud member association
!                                               status is NOT tested.
!                            UNITS:      N/A
!                            TYPE:       INTEGER
!                            DIMENSION:  Scalar
!                            ATTRIBUTES: INTENT(IN), OPTIONAL
!
!       Skip_Aerosol:        Set this argument to not include the Aerosol
!                            member in the association test. This is required
!                            because a valid Atmosphere structure can be
!                            aerosol-free.
!                            If Skip_Aerosol = 0, the Aerosol member association
!                                                 status is tested.  (DEFAULT)
!                               Skip_Aerosol = 1, the Aerosol member association
!                                                 status is NOT tested.
!                            UNITS:      N/A
!                            TYPE:       INTEGER
!                            DIMENSION:  Scalar
!                            ATTRIBUTES: INTENT(IN), OPTIONAL
!
! FUNCTION RESULT:
!       Association_Status:  The return value is a logical value indicating the
!                            association status of the Atmosphere components.
!                            .TRUE.  - if ALL the Atmosphere components are
!                                      associated, or if the ANY_Test argument
!                                      is set and ANY of the Atmosphere pointer
!                                      members are associated.
!                            .FALSE. - some or all of the Atmosphere pointer
!                                      members are NOT associated.
!                            UNITS:      N/A
!                            TYPE:       LOGICAL
!                            DIMENSION:  Scalar
!
!--------------------------------------------------------------------------------

  FUNCTION CRTM_Associated_Atmosphere( Atmosphere  , & ! Input
                                       ANY_Test    , & ! Optional input
                                       Skip_Cloud  , & ! Optional input
                                       Skip_Aerosol) & ! Optional input
                                     RESULT( Association_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN) :: Atmosphere
    INTEGER,          OPTIONAL, INTENT(IN) :: ANY_Test
    INTEGER,          OPTIONAL, INTENT(IN) :: Skip_Cloud
    INTEGER,          OPTIONAL, INTENT(IN) :: Skip_Aerosol
    ! Function result
    LOGICAL :: Association_Status
    ! Local variables
    LOGICAL :: ALL_Test
    LOGICAL :: Include_Cloud
    LOGICAL :: Include_Aerosol

    ! Set up
    ! ------
    ! Default is to test ALL the components
    ! for a true association status....
    ALL_Test = .TRUE.
    ! ...unless the ANY_Test argument is set.
    IF ( PRESENT( ANY_Test ) ) THEN
      IF ( ANY_Test == SET ) ALL_Test = .FALSE.
    END IF

    ! Default is to include the Cloud member
    ! in the association test....
    Include_Cloud = .TRUE.
    ! ...unless the Skip_Cloud argument is set.
    IF ( PRESENT( Skip_Cloud ) ) THEN
      IF ( Skip_Cloud == SET ) Include_Cloud = .FALSE.
    END IF

    ! Default is to include the Aerosol member
    ! in the association test....
    Include_Aerosol = .TRUE.
    ! ...unless the Skip_Aerosol argument is set.
    IF ( PRESENT( Skip_Aerosol ) ) THEN
      IF ( Skip_Aerosol == SET ) Include_Aerosol = .FALSE.
    END IF

    ! Initialise a result
    Association_Status = .FALSE.


    ! Test the members that MUST be associated
    ! ----------------------------------------
    IF ( ALL_Test ) THEN
      IF ( ASSOCIATED( Atmosphere%Absorber_ID       ) .AND. &
           ASSOCIATED( Atmosphere%Absorber_Units    ) .AND. &
           ASSOCIATED( Atmosphere%Level_Pressure    ) .AND. &
           ASSOCIATED( Atmosphere%Pressure          ) .AND. &
           ASSOCIATED( Atmosphere%Temperature       ) .AND. &
           ASSOCIATED( Atmosphere%Absorber          ) ) THEN
        Association_Status = .TRUE.
      END IF
    ELSE
      IF ( ASSOCIATED( Atmosphere%Absorber_ID       ) .OR. &
           ASSOCIATED( Atmosphere%Absorber_Units    ) .OR. &
           ASSOCIATED( Atmosphere%Level_Pressure    ) .OR. &
           ASSOCIATED( Atmosphere%Pressure          ) .OR. &
           ASSOCIATED( Atmosphere%Temperature       ) .OR. &
           ASSOCIATED( Atmosphere%Absorber          ) ) THEN
        Association_Status = .TRUE.
      END IF
    END IF


    ! Test the members that MAY be associated
    ! ---------------------------------------
    ! Clouds
    IF ( Include_Cloud ) THEN
      IF ( ALL_Test ) THEN
        IF ( Association_Status             .AND. &
             ASSOCIATED( Atmosphere%Cloud ) ) THEN
          Association_Status = .TRUE.
        END IF
      ELSE
        IF ( Association_Status             .OR. &
             ASSOCIATED( Atmosphere%Cloud ) ) THEN
          Association_Status = .TRUE.
        END IF
      END IF
    END IF

    ! Aerosols
    IF ( Include_Aerosol ) THEN
      IF ( ALL_Test ) THEN
        IF ( Association_Status               .AND. &
             ASSOCIATED( Atmosphere%Aerosol ) ) THEN
          Association_Status = .TRUE.
        END IF
      ELSE
        IF ( Association_Status               .OR. &
             ASSOCIATED( Atmosphere%Aerosol ) ) THEN
          Association_Status = .TRUE.
        END IF
      END IF
    END IF

  END FUNCTION CRTM_Associated_Atmosphere


!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Destroy_Atmosphere
! 
! PURPOSE:
!       Function to re-initialize CRTM_Atmosphere data structures.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Destroy_Atmosphere( Atmosphere             , &  ! Output
!                                               RCS_Id     =RCS_Id     , &  ! Revision control
!                                               Message_Log=Message_Log  )  ! Error messaging
!
! OUTPUT ARGUMENTS:
!       Atmosphere:   Re-initialized Atmosphere structure. In the context of
!                     the CRTM, rank-1 corresponds to an vector of profiles,
!                     and rank-2 corresponds to an array of channels x profiles.
!                     The latter is used in the K-matrix model.
!                     UNITS:      N/A
!                     TYPE:       CRTM_Atmosphere_type
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
!       Note the INTENT on the output Atmosphere argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!--------------------------------------------------------------------------------

  FUNCTION Destroy_Scalar( Atmosphere , &  ! Output
                           No_Clear   , &  ! Optional input
                           RCS_Id     , &  ! Revision control
                           Message_Log) &  ! Error messaging
                         RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere
    INTEGER     ,     OPTIONAL, INTENT(IN)     :: No_Clear
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Destroy_Atmosphere(Scalar)'
    ! Local variables
    CHARACTER(256) :: Message
    LOGICAL :: Clear
    INTEGER :: Allocate_Status

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Re-initialise the dimensions
    Atmosphere%Max_Layers   = 0
    Atmosphere%n_Layers     = 0
    Atmosphere%n_Absorbers  = 0
    Atmosphere%Max_Clouds   = 0
    Atmosphere%n_Clouds     = 0
    Atmosphere%Max_Aerosols = 0
    Atmosphere%n_Aerosols   = 0

    ! Default is to clear scalar members...
    Clear = .TRUE.
    ! ....unless the No_Clear argument is set
    IF ( PRESENT( No_Clear ) ) THEN
      IF ( No_Clear == SET ) Clear = .FALSE.
    END IF
    IF ( Clear ) CALL CRTM_Clear_Atmosphere( Atmosphere )

    ! If ALL components are NOT associated, do nothing
    IF ( .NOT. CRTM_Associated_Atmosphere( Atmosphere ) ) RETURN


    ! Deallocate the array components
    ! -------------------------------
    DEALLOCATE( Atmosphere%Absorber_ID   , &
                Atmosphere%Absorber_Units, &
                Atmosphere%Level_Pressure, &
                Atmosphere%Pressure      , &
                Atmosphere%Temperature   , &
                Atmosphere%Absorber      , &
                STAT = Allocate_Status )
    IF ( Allocate_Status /= 0 ) THEN
      Error_Status = FAILURE
      WRITE(Message,'("Error deallocating Atmosphere components. STAT = ",i0)') &
                    Allocate_Status
      CALL Display_Message( ROUTINE_NAME,    &
                            TRIM(Message), &
                            Error_Status,    &
                            Message_Log=Message_Log )
    END IF


    ! Deallocate the Cloud structure array component
    ! ----------------------------------------------
    IF ( ASSOCIATED( Atmosphere%Cloud ) ) THEN

      ! Destroy the cloud structure(s)
      Error_Status = CRTM_Destroy_Cloud( Atmosphere%Cloud, &
                                         No_Clear = No_Clear, &
                                         Message_Log=Message_Log )
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME,    &
                              'Error destroying Atmosphere Cloud structure(s).', &
                              Error_Status,    &
                              Message_Log=Message_Log )
      END IF

      ! Deallocate the array
      DEALLOCATE( Atmosphere%Cloud, STAT = Allocate_Status )
      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error deallocating Atmosphere cloud ", &
                          &"component. STAT = ", i0 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME,    &
                              TRIM(Message), &
                              Error_Status,    &
                              Message_Log=Message_Log )
      END IF
    END IF


    ! Deallocate the Aerosol structure array component
    ! ------------------------------------------------
    IF ( ASSOCIATED( Atmosphere%Aerosol ) ) THEN
    
      ! Destroy the aerosol structure(s)
      Error_Status = CRTM_Destroy_Aerosol( Atmosphere%Aerosol, &
                                           No_Clear = No_Clear, &
                                           Message_Log=Message_Log )
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME,    &
                              'Error destroying CRTM_Atmosphere Aerosol structure(s).', &
                              Error_Status,    &
                              Message_Log=Message_Log )
      END IF

      ! Deallocate the array
      DEALLOCATE( Atmosphere%Aerosol, STAT = Allocate_Status )
      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error deallocating CRTM_Atmosphere cloud ", &
                          &"member. STAT = ", i0 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME,    &
                              TRIM(Message), &
                              Error_Status,    &
                              Message_Log=Message_Log )
      END IF
    END IF


    ! Decrement and test allocation counter
    ! -------------------------------------
    Atmosphere%n_Allocates = Atmosphere%n_Allocates - 1
    IF ( Atmosphere%n_Allocates /= 0 ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Allocation counter /= 0, Value = ", i0 )' ) &
                      Atmosphere%n_Allocates
      CALL Display_Message( ROUTINE_NAME,    &
                            TRIM(Message), &
                            Error_Status,    &
                            Message_Log=Message_Log )
    END IF

  END FUNCTION Destroy_Scalar


  FUNCTION Destroy_Rank1( Atmosphere , &  ! Output
                          No_Clear   , &  ! Optional input
                          RCS_Id     , &  ! Revision control
                          Message_Log) &  ! Error messaging
                        RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    INTEGER     ,     OPTIONAL, INTENT(IN)     :: No_Clear
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Destroy_Atmosphere(Rank-1)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Reinitialise array
    ! ------------------
    DO n = 1, SIZE( Atmosphere )
      Scalar_Status = Destroy_Scalar( Atmosphere(n), &
                                      No_Clear   =No_Clear, &
                                      Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error destroying element (",i0,")", &
                          &" of Atmosphere structure array." )' ) n
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Destroy_Rank1


  FUNCTION Destroy_Rank2( Atmosphere , &  ! Output
                          No_Clear   , &  ! Optional input
                          RCS_Id     , &  ! Revision control
                          Message_Log) &  ! Error messaging
                        RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:,:)
    INTEGER     ,     OPTIONAL, INTENT(IN)     :: No_Clear
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Destroy_Atmosphere(Rank-2)'
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
    DO m = 1, SIZE(Atmosphere,2)
      DO l = 1, SIZE(Atmosphere,1)
        Scalar_Status = Destroy_Scalar( Atmosphere(l,m), &
                                        No_Clear = No_Clear, &
                                        Message_Log=Message_Log )
        IF ( Scalar_Status /= SUCCESS ) THEN
          Error_Status = Scalar_Status
          WRITE( Message, '( "Error destroying element (",i0,",",i0,")", &
                            &" of Atmosphere structure array." )' ) l, m
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
!       CRTM_Allocate_Atmosphere
! 
! PURPOSE:
!       Function to allocate CRTM_Atmosphere data structures.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Allocate_Atmosphere( n_Layers               , &  ! Input
!                                                n_Absorbers            , &  ! Input
!                                                n_Clouds               , &  ! Input
!                                                n_Aerosols             , &  ! Input
!                                                Atmosphere             , &  ! Output
!                                                RCS_Id     =RCS_Id     , &  ! Revision control
!                                                Message_Log=Message_Log  )  ! Error messaging
!
! INPUT ARGUMENTS:
!       n_Layers:     Number of layers dimension.
!                     Must be > 0.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar OR Rank-1
!                                 See output Atmosphere dimensionality chart
!                     ATTRIBUTES: INTENT(IN)
!
!       n_Absorbers:  Number of absorbers dimension. This will be the same for
!                     all elements if the Atmosphere argument is an array.
!                     Must be > 0.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(IN)
!
!       n_Clouds:     Number of clouds dimension of Atmosphere data.
!                     ** Note: Can be = 0 (i.e. clear sky). **
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar OR Rank-1
!                                 See output Atmosphere dimensionality chart
!                     ATTRIBUTES: INTENT(IN)
!
!       n_Aerosols:   Number of aerosol types dimension of Atmosphere data.
!                     ** Note: Can be = 0 (i.e. no aerosols). **
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar OR Rank-1
!                                 See output Atmosphere dimensionality chart
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
!       Atmosphere:   Atmosphere structure with allocated components. The
!                     following table shows the allowable dimension combinations
!                     for the calling routine, where M == number of profiles:
!
!                        Input       Input       Input      Input        Output
!                       n_Layers   n_Absorbers  n_Clouds  n_Aerosols    Atmosphere
!                       dimension   dimension   dimension  dimension    dimension
!                     --------------------------------------------------------------
!                        scalar      scalar      scalar     scalar       scalar
!                        scalar      scalar      scalar     scalar         M
!                        scalar      scalar      scalar       M            M
!                        scalar      scalar        M        scalar         M
!                        scalar      scalar        M          M            M
!                          M         scalar      scalar     scalar         M
!                          M         scalar      scalar       M            M
!                          M         scalar        M        scalar         M
!                          M         scalar        M          M            M
!
!                     Note the number of absorbers cannot vary with the profile.
!
!                     These multiple interfaces are supplied purely for ease of
!                     use depending on what data is available.
!                     
!                     UNITS:      N/A
!                     TYPE:       CRTM_Atmosphere_type
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
!       Note the INTENT on the output Atmosphere argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!--------------------------------------------------------------------------------

  FUNCTION Allocate_Scalar( n_Layers   , &  ! Input
                            n_Absorbers, &  ! Input
                            n_Clouds   , &  ! Input
                            n_Aerosols , &  ! Input
                            Atmosphere , &  ! Output
                            RCS_Id     , &  ! Revision control
                            Message_Log) &  ! Error messaging
                          RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers    
    INTEGER                   , INTENT(IN)     :: n_Absorbers 
    INTEGER                   , INTENT(IN)     :: n_Clouds    
    INTEGER                   , INTENT(IN)     :: n_Aerosols    
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Scalar)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Allocate_Status
    INTEGER :: i

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID
    
    ! Check dimensions
    IF ( n_Layers    < 1 .OR. &
         n_Absorbers < 1 ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Layers and n_Absorbers must be > 0.', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF
    IF ( n_Clouds   < 0 .OR. &
         n_Aerosols < 0 ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Clouds and n_Aerosols must be > or = 0.', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF
    
    ! Check if ANY pointers are already associated
    ! If they are, deallocate them but leave scalars.
    IF ( CRTM_Associated_Atmosphere( Atmosphere, ANY_Test = SET ) ) THEN
      Error_Status = CRTM_Destroy_Atmosphere( Atmosphere, &
                                              No_Clear = SET, &
                                              Message_Log=Message_Log )
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME,    &
                              'Error deallocating Atmosphere components.', &
                              Error_Status,    &
                              Message_Log=Message_Log )
        RETURN
      END IF
    END IF


    ! Allocate the intrinsic type arrays
    ! ----------------------------------
    ALLOCATE( Atmosphere%Absorber_ID( n_Absorbers ), &
              Atmosphere%Absorber_Units( n_Absorbers ), &
              Atmosphere%Level_Pressure( 0:n_Layers ), &
              Atmosphere%Pressure( n_Layers ), &
              Atmosphere%Temperature( n_Layers ), &
              Atmosphere%Absorber( n_Layers, n_Absorbers ), &
              STAT = Allocate_Status )
    IF ( Allocate_Status /= 0 ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Error allocating Atmosphere data arrays. STAT = ", i0 )' ) &
                      Allocate_Status
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Allocate the cloud structure array
    ! ----------------------------------
    IF ( n_Clouds > 0 ) THEN
    
      ! Allocate the structure array
      ALLOCATE( Atmosphere%Cloud( n_Clouds ), &
                STAT = Allocate_Status )
      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error allocating Atmosphere Cloud structure array. STAT = ", i0 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        RETURN
      END IF
      
      ! Allocate the individual structures
      DO i = 1, n_Clouds
        Error_Status = CRTM_Allocate_Cloud( n_Layers,&
                                            Atmosphere%Cloud(i), &
                                            Message_Log=Message_Log )
        IF ( Error_Status /= SUCCESS ) THEN
          CALL Display_Message( ROUTINE_NAME, &
                                'Error allocating Cloud structure(s).', &
                                Error_Status, &
                                Message_Log=Message_Log )
          RETURN
        END IF
      END DO
    END IF


    ! Allocate the aerosol structure array
    ! ------------------------------------
    IF ( n_Aerosols > 0 ) THEN
    
      ! Allocate the structure array
      ALLOCATE( Atmosphere%Aerosol( n_Aerosols ), &
                STAT = Allocate_Status )
      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error allocating Atmosphere Aerosol structure array. STAT = ", i0 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        RETURN
      END IF
      
      ! Allocate the individual structures
      DO i = 1, n_Aerosols
        Error_Status = CRTM_Allocate_Aerosol( n_Layers, &
                                              Atmosphere%Aerosol(i), &
                                              Message_Log=Message_Log )
        IF ( Error_Status /= SUCCESS ) THEN
          CALL Display_Message( ROUTINE_NAME, &
                                'Error allocating Aerosol structure(s).', &
                                Error_Status, &
                                Message_Log=Message_Log )
          RETURN
        END IF
      END DO
    END IF


    ! Assign the dimensions and initalise arrays
    ! ------------------------------------------
    Atmosphere%Max_Layers   = n_Layers
    Atmosphere%n_Layers     = n_Layers
    Atmosphere%n_Absorbers  = n_Absorbers
    Atmosphere%Max_Clouds   = n_Clouds
    Atmosphere%n_Clouds     = n_Clouds
    Atmosphere%Max_Aerosols = n_Aerosols
    Atmosphere%n_Aerosols   = n_Aerosols
    
    Atmosphere%Absorber_ID    = INVALID_ABSORBER_ID
    Atmosphere%Absorber_Units = INVALID_ABSORBER_UNITS
    
    Atmosphere%Level_Pressure = ZERO
    Atmosphere%Pressure       = ZERO
    Atmosphere%Temperature    = ZERO
    Atmosphere%Absorber       = ZERO


    ! Increment and test allocation counter
    ! -------------------------------------
    Atmosphere%n_Allocates = Atmosphere%n_Allocates + 1
    IF ( Atmosphere%n_Allocates /= 1 ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Allocation counter /= 1, Value = ", i0 )' ) &
                      Atmosphere%n_Allocates
      CALL Display_Message( ROUTINE_NAME,    &
                            TRIM(Message), &
                            Error_Status,    &
                            Message_Log=Message_Log )
    END IF

  END FUNCTION Allocate_Scalar


  FUNCTION Allocate_Rank00001( n_Layers   , &  ! Input, scalar
                               n_Absorbers, &  ! Input, scalar
                               n_Clouds   , &  ! Input, scalar
                               n_Aerosols , &  ! Input, scalar
                               Atmosphere , &  ! Output, M
                               RCS_Id     , &  ! Revision control
                               Message_Log) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers
    INTEGER                   , INTENT(IN)     :: n_Absorbers
    INTEGER                   , INTENT(IN)     :: n_Clouds
    INTEGER                   , INTENT(IN)     :: n_Aerosols
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Rank-00001)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID


    ! Perform the allocation
    ! ----------------------
    DO i = 1, SIZE( Atmosphere )
      Scalar_Status = Allocate_Scalar( n_Layers     , & ! Input
                                       n_Absorbers  , & ! Input
                                       n_Clouds     , & ! Input
                                       n_Aerosols   , & ! Input
                                       Atmosphere(i), & ! Output
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i0, &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank00001


  FUNCTION Allocate_Rank00011( n_Layers   , &  ! Input, scalar
                               n_Absorbers, &  ! Input, scalar
                               n_Clouds   , &  ! Input, scalar
                               n_Aerosols , &  ! Input,  M
                               Atmosphere , &  ! Output, M
                               RCS_Id     , &  ! Revision control
                               Message_Log) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers
    INTEGER                   , INTENT(IN)     :: n_Absorbers
    INTEGER                   , INTENT(IN)     :: n_Clouds
    INTEGER                   , INTENT(IN)     :: n_Aerosols(:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Rank-00011)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------                
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Atmosphere )
    IF ( SIZE( n_Aerosols ) /= n ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Aerosols and Atmosphere arrays'//&
                            ' do not conform', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the allocation
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Allocate_Scalar( n_Layers     , & ! Input
                                       n_Absorbers  , & ! Input
                                       n_Clouds     , & ! Input
                                       n_Aerosols(i), & ! Input
                                       Atmosphere(i), & ! Output
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i0, &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank00011


  FUNCTION Allocate_Rank00101( n_Layers   , &  ! Input, scalar
                               n_Absorbers, &  ! Input, scalar
                               n_Clouds   , &  ! Input,  M
                               n_Aerosols , &  ! Input, scalar
                               Atmosphere , &  ! Output, M
                               RCS_Id     , &  ! Revision control
                               Message_Log) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers
    INTEGER                   , INTENT(IN)     :: n_Absorbers
    INTEGER                   , INTENT(IN)     :: n_Clouds(:)
    INTEGER                   , INTENT(IN)     :: n_Aerosols
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Rank-00101)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------                
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Atmosphere )
    IF ( SIZE( n_Clouds ) /= n ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Clouds and Atmosphere arrays'//&
                            ' do not conform', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the allocation
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Allocate_Scalar( n_Layers     , & ! Input
                                       n_Absorbers  , & ! Input
                                       n_Clouds(i)  , & ! Input
                                       n_Aerosols   , & ! Input
                                       Atmosphere(i), & ! Output
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i0, &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank00101


  FUNCTION Allocate_Rank00111( n_Layers   , &  ! Input, scalar
                               n_Absorbers, &  ! Input, scalar
                               n_Clouds   , &  ! Input,  M
                               n_Aerosols , &  ! Input,  M
                               Atmosphere , &  ! Output, M
                               RCS_Id     , &  ! Revision control
                               Message_Log) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers
    INTEGER                   , INTENT(IN)     :: n_Absorbers
    INTEGER                   , INTENT(IN)     :: n_Clouds(:)
    INTEGER                   , INTENT(IN)     :: n_Aerosols(:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Rank-00111)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Atmosphere )
    IF ( SIZE( n_Clouds   ) /= n .OR. &
         SIZE( n_Aerosols ) /= n      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Clouds, n_Aerosols and Atmosphere arrays'//&
                            ' do not conform', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF

    ! Perform the allocation
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Allocate_Scalar( n_Layers     , & ! Input
                                       n_Absorbers  , & ! Input
                                       n_Clouds(i)  , & ! Input
                                       n_Aerosols(i), & ! Input
                                       Atmosphere(i), & ! Output
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i0, &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank00111


  FUNCTION Allocate_Rank10001( n_Layers   , &  ! Input,  M
                               n_Absorbers, &  ! Input, scalar
                               n_Clouds   , &  ! Input, scalar
                               n_Aerosols , &  ! Input, scalar
                               Atmosphere , &  ! Output, M
                               RCS_Id     , &  ! Revision control
                               Message_Log) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers(:)
    INTEGER                   , INTENT(IN)     :: n_Absorbers
    INTEGER                   , INTENT(IN)     :: n_Clouds
    INTEGER                   , INTENT(IN)     :: n_Aerosols
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Rank-10001)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Atmosphere )
    IF ( SIZE( n_Layers ) /= n ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Layers and Atmosphere arrays'//&
                            ' do not conform', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the allocation
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Allocate_Scalar( n_Layers(i)  , & ! Input
                                       n_Absorbers  , & ! Input
                                       n_Clouds     , & ! Input
                                       n_Aerosols   , & ! Input
                                       Atmosphere(i), & ! Output
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i0, &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank10001


  FUNCTION Allocate_Rank10011( n_Layers   , &  ! Input,  M
                               n_Absorbers, &  ! Input, scalar
                               n_Clouds   , &  ! Input, scalar
                               n_Aerosols , &  ! Input,  M
                               Atmosphere , &  ! Output, M
                               RCS_Id     , &  ! Revision control
                               Message_Log) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers(:)
    INTEGER                   , INTENT(IN)     :: n_Absorbers   
    INTEGER                   , INTENT(IN)     :: n_Clouds      
    INTEGER                   , INTENT(IN)     :: n_Aerosols(:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Rank-10011)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Atmosphere )
    IF ( SIZE( n_Layers   ) /= n .OR. &
         SIZE( n_Aerosols ) /= n      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Layers, n_Aerosols and Atmosphere arrays'//&
                            ' do not conform', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the allocation
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Allocate_Scalar( n_Layers(i)  , & ! Input
                                       n_Absorbers  , & ! Input
                                       n_Clouds     , & ! Input
                                       n_Aerosols(i), & ! Input
                                       Atmosphere(i), & ! Output
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i0, &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank10011


  FUNCTION Allocate_Rank10101( n_Layers   , &  ! Input,  M
                               n_Absorbers, &  ! Input, scalar
                               n_Clouds   , &  ! Input,  M
                               n_Aerosols , &  ! Input, scalar
                               Atmosphere , &  ! Output, M
                               RCS_Id     , &  ! Revision control
                               Message_Log) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers(:)
    INTEGER                   , INTENT(IN)     :: n_Absorbers   
    INTEGER                   , INTENT(IN)     :: n_Clouds(:)
    INTEGER                   , INTENT(IN)     :: n_Aerosols    
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Rank-10101)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Atmosphere )
    IF ( SIZE( n_Layers ) /= n .OR. &
         SIZE( n_Clouds ) /= n      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Layers, n_Clouds and Atmosphere arrays'//&
                            ' do not conform', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the allocation
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Allocate_Scalar( n_Layers(i)  , & ! Input
                                       n_Absorbers  , & ! Input
                                       n_Clouds(i)  , & ! Input
                                       n_Aerosols   , & ! Input
                                       Atmosphere(i), & ! Output
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i0, &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank10101


  FUNCTION Allocate_Rank10111( n_Layers   , &  ! Input,  M
                               n_Absorbers, &  ! Input, scalar
                               n_Clouds   , &  ! Input,  M
                               n_Aerosols , &  ! Input,  M
                               Atmosphere , &  ! Output, M
                               RCS_Id     , &  ! Revision control
                               Message_Log) &  ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    INTEGER                   , INTENT(IN)     :: n_Layers(:)
    INTEGER                   , INTENT(IN)     :: n_Absorbers   
    INTEGER                   , INTENT(IN)     :: n_Clouds(:)
    INTEGER                   , INTENT(IN)     :: n_Aerosols(:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_Atmosphere(Rank-10111)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Atmosphere )
    IF ( SIZE( n_Layers   ) /= n .OR. &
         SIZE( n_Clouds   ) /= n .OR. &
         SIZE( n_Aerosols ) /= n      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Layers, n_Clouds, n_Aerosols and Atmosphere arrays'//&
                            ' do not conform', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the allocation
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Allocate_Scalar( n_Layers(i)  , & ! Input
                                       n_Absorbers  , & ! Input
                                       n_Clouds(i)  , & ! Input
                                       n_Aerosols(i), & ! Input
                                       Atmosphere(i), & ! Output
                                       Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error allocating element #", i0, &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Allocate_Rank10111


!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Assign_Atmosphere
!
! PURPOSE:
!       Function to copy valid CRTM_Atmosphere structures.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Assign_Atmosphere( Atmosphere_in          , &  ! Input
!                                              Atmosphere_out         , &  ! Output
!                                              RCS_Id     =RCS_Id     , &  ! Revision control
!                                              Message_Log=Message_Log  )  ! Error messaging
!
! INPUT ARGUMENTS:
!       Atmosphere_in:   Atmosphere structure which is to be copied. In the
!                        context of the CRTM, rank-1 corresponds to an vector
!                        of profiles, and rank-2 corresponds to an array of
!                        channels x profiles. The latter is used in the K-matrix
!                        model.
!                        UNITS:      N/A
!                        TYPE:       CRTM_Atmosphere_type
!                        DIMENSION:  Scalar, Rank-1, or Rank-2 array
!                        ATTRIBUTES: INTENT(IN)
!
! OUTPUT ARGUMENTS:
!       Atmosphere_out:  Copy of the input structure, Atmosphere_in.
!                        UNITS:      N/A
!                        TYPE:       CRTM_Atmosphere_type
!                        DIMENSION:  Same as Atmosphere_in
!                        ATTRIBUTES: INTENT(IN OUT)
!
! OPTIONAL INPUT ARGUMENTS:
!       Message_Log:     Character string specifying a filename in which any
!                        messages will be logged. If not specified, or if an
!                        error occurs opening the log file, the default action
!                        is to output messages to standard output.
!                        UNITS:      N/A
!                        TYPE:       CHARACTER(*)
!                        DIMENSION:  Scalar
!                        ATTRIBUTES: INTENT(IN), OPTIONAL
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
! COMMENTS:
!       Note the INTENT on the output Atmosphere argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
!--------------------------------------------------------------------------------

  FUNCTION Assign_Scalar( Atmosphere_in , &  ! Input
                          Atmosphere_out, &  ! Output
                          RCS_Id        , &  ! Revision control
                          Message_Log   ) &  ! Error messaging
                        RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN)     :: Atmosphere_in
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere_out
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Assign_Atmosphere(Scalar)'

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID
    
    ! ALL *input* pointers must be associated
    ! BUT the Cloud and/or Aerosol components
    ! may not be.
    IF ( .NOT. CRTM_Associated_Atmosphere( Atmosphere_In, &
                                           Skip_Cloud   = SET, &
                                           Skip_Aerosol = SET  ) ) THEN
      Error_Status = CRTM_Destroy_Atmosphere( Atmosphere_Out, &
                                              Message_Log=Message_Log )
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME,    &
                              'Error deallocating output CRTM_Atmosphere components.', &
                              Error_Status,    &
                              Message_Log=Message_Log )
      END IF
      RETURN
    END IF


    ! Allocate the structure
    ! ----------------------
    Error_Status = CRTM_Allocate_Atmosphere( Atmosphere_in%Max_Layers, &
                                             Atmosphere_in%n_Absorbers, &
                                             Atmosphere_in%Max_Clouds, &
                                             Atmosphere_in%Max_Aerosols, &
                                             Atmosphere_out, &
                                             Message_Log=Message_Log )
    IF ( Error_Status /= SUCCESS ) THEN
      CALL Display_Message( ROUTINE_NAME, &
                            'Error allocating output CRTM_Atmosphere arrays.', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Assign intrinsic data types
    ! ---------------------------
    Atmosphere_out%n_Layers   = Atmosphere_in%n_Layers
    Atmosphere_out%n_Clouds   = Atmosphere_in%n_Clouds
    Atmosphere_out%n_Aerosols = Atmosphere_in%n_Aerosols

    Atmosphere_out%Climatology = Atmosphere_in%Climatology

    Atmosphere_out%Absorber_ID    = Atmosphere_in%Absorber_ID
    Atmosphere_out%Absorber_Units = Atmosphere_in%Absorber_Units
    Atmosphere_out%Level_Pressure = Atmosphere_in%Level_Pressure
    Atmosphere_out%Pressure       = Atmosphere_in%Pressure
    Atmosphere_out%Temperature    = Atmosphere_in%Temperature
    Atmosphere_out%Absorber       = Atmosphere_in%Absorber


    ! Assign Cloud structure
    ! ----------------------
    IF ( Atmosphere_in%Max_Clouds > 0 ) THEN
      Error_Status = CRTM_Assign_Cloud( Atmosphere_in%Cloud, &
                                        Atmosphere_out%Cloud, &
                                        Message_Log=Message_Log)
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME, &
                              'Error copying Cloud structure.', &
                              Error_Status, &
                              Message_Log=Message_Log )
        RETURN
      END IF
    END IF


    ! Assign Aerosol structure
    ! ------------------------
    IF ( Atmosphere_in%Max_Aerosols > 0 ) THEN
      Error_Status = CRTM_Assign_Aerosol( Atmosphere_in%Aerosol, &
                                          Atmosphere_out%Aerosol, &
                                          Message_Log=Message_Log)
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME, &
                              'Error copying Aerosol structure.', &
                              Error_Status, &
                              Message_Log=Message_Log )
        RETURN
      END IF
    END IF

  END FUNCTION Assign_Scalar


  FUNCTION Assign_Rank1( Atmosphere_in , &  ! Input
                         Atmosphere_out, &  ! Output
                         RCS_Id        , &  ! Revision control
                         Message_Log   ) &  ! Error messaging
                       RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN)     :: Atmosphere_in(:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere_out(:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Assign_Atmosphere(Rank-1)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, n

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    n = SIZE( Atmosphere_in )
    IF ( SIZE( Atmosphere_out ) /= n ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input Atmosphere_in and Atmosphere_out arrays'//&
                            ' have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the assignment
    ! ----------------------
    DO i = 1, n
      Scalar_Status = Assign_Scalar( Atmosphere_in(i), &
                                     Atmosphere_out(i), &
                                     Message_Log=Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error copying element (",i0,")", &
                          &" of CRTM_Atmosphere structure array." )' ) i
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
      END IF
    END DO

  END FUNCTION Assign_Rank1


  FUNCTION Assign_Rank2( Atmosphere_in , &  ! Input
                         Atmosphere_out, &  ! Output
                         RCS_Id        , &  ! Revision control
                         Message_Log   ) &  ! Error messaging
                       RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN)     :: Atmosphere_in(:,:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere_out(:,:)
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Assign_Atmosphere(Rank-2)'
    ! Local variables
    CHARACTER(256) :: Message
    INTEGER :: Scalar_Status
    INTEGER :: i, j, l, m

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID

    ! Array arguments must conform
    l = SIZE(Atmosphere_in,1)
    m = SIZE(Atmosphere_in,2)
    IF ( SIZE(Atmosphere_out,1) /= l .OR. &
         SIZE(Atmosphere_out,2) /= m      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input Atmosphere_in and Atmosphere_out arrays'//&
                            ' have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Perform the assignment
    ! ----------------------
    DO j = 1, m
      DO i = 1, l
        Scalar_Status = Assign_Scalar( Atmosphere_in(i,j), &
                                       Atmosphere_out(i,j), &
                                       Message_Log=Message_Log )
        IF ( Scalar_Status /= SUCCESS ) THEN
          Error_Status = Scalar_Status
          WRITE( Message, '( "Error copying element (",i0,",",i0,")",&
                            &" of CRTM_Atmosphere structure array." )' ) i,j
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
!       CRTM_Equal_Atmosphere
!
! PURPOSE:
!       Function to test if two Atmosphere structures are equal.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Equal_Atmosphere( Atmosphere_LHS                       , &  ! Input
!                                             Atmosphere_RHS                       , &  ! Input
!                                             ULP_Scale         =ULP_Scale         , &  ! Optional input
!                                             Percent_Difference=Percent_Difference, &  ! Optional input
!                                             Check_All         =Check_All         , &  ! Optional input
!                                             RCS_Id            =RCS_Id            , &  ! Optional output
!                                             Message_Log       =Message_Log         )  ! Error messaging
!
!
! INPUT ARGUMENTS:
!       Atmosphere_LHS:     Atmosphere structure to be compared; equivalent to the
!                           left-hand side of a lexical comparison, e.g.
!                             IF ( Atmosphere_LHS == Atmosphere_RHS ).
!                           In the context of the CRTM, rank-1 corresponds to an
!                           vector of profiles, and rank-2 corresponds to an array
!                           of channels x profiles. The latter is used in the
!                           K-matrix model.
!                           UNITS:      N/A
!                           TYPE:       CRTM_Atmosphere_type
!                           DIMENSION:  Scalar, Rank-1, or Rank-2 array
!                           ATTRIBUTES: INTENT(IN)
!
!       Atmosphere_RHS:     Atmosphere structure to be compared to; equivalent to
!                           right-hand side of a lexical comparison, e.g.
!                             IF ( Atmosphere_LHS == Atmosphere_RHS ).
!                           UNITS:      N/A
!                           TYPE:       CRTM_Atmosphere_type
!                           DIMENSION:  Same as Atmosphere_LHS
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
!                           channel data of the Atmosphere structures. The default
!                           action is return with a FAILURE status as soon as
!                           any difference is found. This optional argument can
!                           be used to get a listing of ALL the differences
!                           between data in Atmosphere structures.
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

  FUNCTION Equal_Scalar( Atmosphere_LHS    , &  ! Input
                         Atmosphere_RHS    , &  ! Input
                         ULP_Scale         , &  ! Optional input
                         Percent_Difference, &  ! Optional input
                         Check_All         , &  ! Optional input
                         RCS_Id            , &  ! Revision control
                         Message_Log       ) &  ! Error messaging
                       RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN)  :: Atmosphere_LHS
    TYPE(CRTM_Atmosphere_type), INTENT(IN)  :: Atmosphere_RHS
    INTEGER,          OPTIONAL, INTENT(IN)  :: ULP_Scale
    REAL(fp),         OPTIONAL, INTENT(IN)  :: Percent_Difference
    INTEGER,          OPTIONAL, INTENT(IN)  :: Check_All
    CHARACTER(*),     OPTIONAL, INTENT(OUT) :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Equal_Atmosphere(scalar)'
    ! Local variables
    CHARACTER(256) :: Message
    LOGICAL :: Check_Once
    INTEGER :: j, k
    INTEGER :: Cloud_Status, Aerosol_Status

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

    ! Check the structure association status
    IF ( .NOT. CRTM_Associated_Atmosphere( Atmosphere_LHS ) ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Some or all INPUT Atmosphere_LHS pointer '//&
                            'members are NOT associated.', &
                            Error_Status,    &
                            Message_Log=Message_Log )
      RETURN
    END IF
    IF ( .NOT. CRTM_Associated_Atmosphere( Atmosphere_RHS ) ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME,    &
                            'Some or all INPUT Atmosphere_RHS pointer '//&
                            'members are NOT associated.', &
                            Error_Status,    &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Check dimensions
    ! ----------------
    IF ( Atmosphere_LHS%n_Layers    /= Atmosphere_RHS%n_Layers    .AND. &
         Atmosphere_LHS%n_Absorbers /= Atmosphere_RHS%n_Absorbers .AND. &
         Atmosphere_LHS%n_Clouds    /= Atmosphere_RHS%n_Clouds    .AND. &
         Atmosphere_LHS%n_Aerosols  /= Atmosphere_RHS%n_Aerosols        ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Structure dimensions are different', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Compare the values
    ! ------------------
    IF ( Atmosphere_LHS%Climatology /= Atmosphere_RHS%Climatology ) THEN
      Error_Status = FAILURE
      WRITE( Message,'("Climatology values are different:",2(1x,i0))') &
                     Atmosphere_LHS%Climatology, Atmosphere_RHS%Climatology
      CALL Display_Message( ROUTINE_NAME, &
                            TRIM(Message), &
                            Error_Status, &
                            Message_Log=Message_Log )
      IF ( Check_Once ) RETURN
    END IF
    DO j = 1, Atmosphere_LHS%n_Absorbers
      IF ( Atmosphere_LHS%Absorber_ID(j) /= Atmosphere_RHS%Absorber_ID(j) ) THEN
        Error_Status = FAILURE
        WRITE( Message,'("Absorber_Id(",i0,") values are different:",2(1x,i0))') &
                       j, Atmosphere_LHS%Absorber_ID(j), Atmosphere_RHS%Absorber_ID(j)
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END DO
    DO j = 1, Atmosphere_LHS%n_Absorbers
      IF ( Atmosphere_LHS%Absorber_Units(j) /= Atmosphere_RHS%Absorber_Units(j) ) THEN
        Error_Status = FAILURE
        WRITE( Message,'("Absorber_Units(",i0,") values are different:",2(1x,i0))') &
                       j, Atmosphere_LHS%Absorber_Units(j), Atmosphere_RHS%Absorber_Units(j)
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END DO
    DO k = 0, Atmosphere_LHS%n_Layers
      IF ( .NOT. Compare_Float( Atmosphere_LHS%Level_Pressure(k), &
                                Atmosphere_RHS%Level_Pressure(k), &
                                ULP    =ULP_Scale, &
                                Percent=Percent_Difference ) ) THEN
        Error_Status = FAILURE
        WRITE( Message,'("Level_Pressure values are different at level ",i0,&
                        &":",3(1x,es13.6))') &
                       k, Atmosphere_LHS%Level_Pressure(k), &
                          Atmosphere_RHS%Level_Pressure(k), &
                          Atmosphere_LHS%Level_Pressure(k)-Atmosphere_RHS%Level_Pressure(k)
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END DO
    DO k = 1, Atmosphere_LHS%n_Layers
      IF ( .NOT. Compare_Float( Atmosphere_LHS%Pressure(k), &
                                Atmosphere_RHS%Pressure(k), &
                                ULP    =ULP_Scale, &
                                Percent=Percent_Difference ) ) THEN
        Error_Status = FAILURE
        WRITE( Message,'("Pressure values are different at level ",i0,&
                        &":",3(1x,es13.6))') &
                       k, Atmosphere_LHS%Pressure(k), &
                          Atmosphere_RHS%Pressure(k), &
                          Atmosphere_LHS%Pressure(k)-Atmosphere_RHS%Pressure(k)
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END DO
    
    DO k = 1, Atmosphere_LHS%n_Layers
      IF ( .NOT. Compare_Float( Atmosphere_LHS%Temperature(k), &
                                Atmosphere_RHS%Temperature(k), &
                                ULP    =ULP_Scale, &
                                Percent=Percent_Difference ) ) THEN
        Error_Status = FAILURE
        WRITE( Message,'("Temperature values are different at level ",i0,&
                        &":",3(1x,es13.6))') &
                       k, Atmosphere_LHS%Temperature(k), &
                          Atmosphere_RHS%Temperature(k), &
                          Atmosphere_LHS%Temperature(k)-Atmosphere_RHS%Temperature(k)
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END DO
    DO j = 1, Atmosphere_LHS%n_Absorbers
      DO k = 1, Atmosphere_LHS%n_Layers
        IF ( .NOT. Compare_Float( Atmosphere_LHS%Absorber(k,j), &
                                  Atmosphere_RHS%Absorber(k,j), &
                                  ULP    =ULP_Scale, &
                                  Percent=Percent_Difference ) ) THEN
          Error_Status = FAILURE
          WRITE( Message,'("Absorber values are different at level ",i0,&
                          &" for absorber ",i0,":",3(1x,es13.6))') &
                         k, j, Atmosphere_LHS%Absorber(k,j), &
                               Atmosphere_RHS%Absorber(k,j), &
                               Atmosphere_LHS%Absorber(k,j)-Atmosphere_RHS%Absorber(k,j)
          CALL Display_Message( ROUTINE_NAME, &
                                TRIM(Message), &
                                Error_Status, &
                                Message_Log=Message_Log )
          IF ( Check_Once ) RETURN
        END IF
      END DO
    END DO
    
    IF ( Atmosphere_LHS%n_Clouds > 0 ) THEN
      Cloud_Status = CRTM_Equal_Cloud( Atmosphere_LHS%Cloud, &
                                       Atmosphere_RHS%Cloud, &
                                       ULP_Scale  =ULP_Scale, &
                                       Check_All  =Check_All, &
                                       Message_Log=Message_Log )
      IF ( Cloud_Status /= SUCCESS ) THEN
        Error_Status = FAILURE
        CALL Display_Message( ROUTINE_NAME, &
                              'Cloud structures are different', &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END IF
    
    IF ( Atmosphere_LHS%n_Aerosols > 0 ) THEN
      Aerosol_Status = CRTM_Equal_Aerosol( Atmosphere_LHS%Aerosol, &
                                           Atmosphere_RHS%Aerosol, &
                                           ULP_Scale  =ULP_Scale, &
                                           Check_All  =Check_All, &
                                           Message_Log=Message_Log )
      IF ( Aerosol_Status /= SUCCESS ) THEN
        Error_Status = FAILURE
        CALL Display_Message( ROUTINE_NAME, &
                              'Aerosol structures are different', &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END IF
  END FUNCTION Equal_Scalar


  FUNCTION Equal_Rank1( Atmosphere_LHS    , &  ! Input
                        Atmosphere_RHS    , &  ! Output
                        ULP_Scale         , &  ! Optional input
                        Percent_Difference, &  ! Optional input
                        Check_All         , &  ! Optional input
                        RCS_Id            , &  ! Revision control
                        Message_Log       ) &  ! Error messaging
                      RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN)  :: Atmosphere_LHS(:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN)  :: Atmosphere_RHS(:)
    INTEGER,          OPTIONAL, INTENT(IN)  :: ULP_Scale
    REAL(fp),         OPTIONAL, INTENT(IN)  :: Percent_Difference
    INTEGER,          OPTIONAL, INTENT(IN)  :: Check_All
    CHARACTER(*),     OPTIONAL, INTENT(OUT) :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Equal_Atmosphere(Rank-1)'
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
    nProfiles = SIZE( Atmosphere_LHS )
    IF ( SIZE( Atmosphere_RHS ) /= nProfiles ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input Atmosphere_LHS and Atmosphere_RHS arrays'//&
                            ' have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Test for equality
    ! -----------------
    DO m = 1, nProfiles
      Scalar_Status = Equal_Scalar( Atmosphere_LHS(m), &
                                    Atmosphere_RHS(m), &
                                    ULP_Scale         =ULP_Scale, &
                                    Percent_Difference=Percent_Difference, &
                                    Check_All         =Check_All, &
                                    Message_Log       =Message_Log )
      IF ( Scalar_Status /= SUCCESS ) THEN
        Error_Status = Scalar_Status
        WRITE( Message, '( "Error comparing element (",i0,")", &
                          &" of rank-1 CRTM_Atmosphere structure array." )' ) m
        CALL Display_Message( ROUTINE_NAME, &
                              TRIM(Message), &
                              Error_Status, &
                              Message_Log=Message_Log )
        IF ( Check_Once ) RETURN
      END IF
    END DO
  END FUNCTION Equal_Rank1


  FUNCTION Equal_Rank2( Atmosphere_LHS    , &  ! Input
                        Atmosphere_RHS    , &  ! Output
                        ULP_Scale         , &  ! Optional input
                        Percent_Difference, &  ! Optional input
                        Check_All         , &  ! Optional input
                        RCS_Id            , &  ! Revision control
                        Message_Log       ) &  ! Error messaging
                      RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN)  :: Atmosphere_LHS(:,:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN)  :: Atmosphere_RHS(:,:)
    INTEGER,          OPTIONAL, INTENT(IN)  :: ULP_Scale
    REAL(fp),         OPTIONAL, INTENT(IN)  :: Percent_Difference
    INTEGER,          OPTIONAL, INTENT(IN)  :: Check_All
    CHARACTER(*),     OPTIONAL, INTENT(OUT) :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)  :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_Equal_Atmosphere(Rank-2)'
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
    nChannels = SIZE(Atmosphere_LHS,1)
    nProfiles = SIZE(Atmosphere_LHS,2)
    IF ( SIZE(Atmosphere_RHS,1) /= nChannels .OR. &
         SIZE(Atmosphere_RHS,2) /= nProfiles      ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input Atmosphere_LHS and Atmosphere_RHS arrays'//&
                            ' have different dimensions', &
                            Error_Status, &
                            Message_Log=Message_Log )
      RETURN
    END IF


    ! Test for equality
    ! -----------------
    DO m = 1, nProfiles
      DO l = 1, nChannels
        Scalar_Status = Equal_Scalar( Atmosphere_LHS(l,m), &
                                      Atmosphere_RHS(l,m), &
                                      ULP_Scale         =ULP_Scale, &
                                      Percent_Difference=Percent_Difference, &
                                      Check_All         =Check_All, &
                                      Message_Log       =Message_Log )
        IF ( Scalar_Status /= SUCCESS ) THEN
          Error_Status = Scalar_Status
          WRITE( Message, '( "Error comparing element (",i0,",",i0,")", &
                            &" of rank-2 CRTM_Atmosphere structure array." )' ) l,m
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
!       CRTM_WeightedSum_Atmosphere
!
! PURPOSE:
!       Function to perform a weighted sum of two valid CRTM_Atmosphere
!       structures. The weighted summation performed is:
!         A = A + w1*B + w2
!       where A and B are the CRTM_Atmosphere structures, and w1 and w2
!       are the weighting factors. Note that w2 is optional.
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_WeightedSum_Atmosphere( A                      , &  ! In/Output
!                                                   B                      , &  ! Input
!                                                   w1                     , &  ! Input
!                                                   w2         =w2         , &  ! Optional input
!                                                   RCS_Id     =RCS_Id     , &  ! Revision control
!                                                   Message_Log=Message_Log  )  ! Error messaging
!
! INPUT ARGUMENTS:
!       A:               Atmosphere structure that is to be added to.
!                        In the context of the CRTM, rank-1 corresponds to an
!                        vector of profiles, and rank-2 corresponds to an array
!                        of channels x profiles. The latter is used in the
!                        K-matrix model.
!                        UNITS:      N/A
!                        TYPE:       CRTM_Atmosphere_type
!                        DIMENSION:  Scalar, Rank-1, or Rank-2 array
!                        ATTRIBUTES: INTENT(IN OUT)
!
!       B:               Atmosphere structure that is to be weighted and
!                        added to structure A.
!                        UNITS:      N/A
!                        TYPE:       CRTM_Atmosphere_type
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
!                        TYPE:       CRTM_Atmosphere_type
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

  FUNCTION WeightedSum_Scalar( A          , & ! Input/Output
                               B          , & ! Input
                               w1         , & ! Input
                               w2         , & ! optional input
                               RCS_Id     , & ! Revision control
                               Message_Log) & ! Error messaging
                             RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: A
    TYPE(CRTM_Atmosphere_type), INTENT(IN)     :: B
    REAL(fp)    ,               INTENT(IN)     :: w1
    REAL(fp)    ,     OPTIONAL, INTENT(IN)     :: w2
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_WeightedSum_Atmosphere(Scalar)'
    ! Local variables
    REAL(fp) :: w2_Local
    INTEGER :: j, k

    ! Set up
    ! ------
    Error_Status = SUCCESS
    IF ( PRESENT( RCS_Id ) ) RCS_Id = MODULE_RCS_ID
    
    ! Array arguments must conform
    IF ( A%n_Layers    /= B%n_Layers    .OR. &
         A%n_Absorbers /= B%n_Absorbers .OR. &
         A%n_Clouds    /= B%n_Clouds    .OR. &
         A%n_Aerosols  /= B%n_Aerosols       ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME,    &
                            'A and B structure dimensions are different.', &
                            Error_Status,    &
                            Message_Log=Message_Log )
      RETURN
    END IF
         
    ! Assign the optional weight
    w2_Local = ZERO
    IF ( PRESENT( w2 ) ) w2_Local = w2


    ! Weight the array components
    ! ---------------------------
    k = A%n_Layers
    A%Temperature(:k) = A%Temperature(:k) + (w1*B%Temperature(:k)) + w2_Local
    DO j = 1, A%n_Absorbers
      A%Absorber(:k,j) = A%Absorber(:k,j) + (w1*B%Absorber(:k,j)) + w2_Local
    END DO


    ! Weight the Cloud structure
    ! --------------------------
    IF ( A%n_Clouds > 0 ) THEN
      Error_Status = CRTM_WeightedSum_Cloud( A%Cloud, &
                                             B%Cloud, &
                                             w1, &
                                             w2 = w2, &
                                             Message_Log=Message_Log )
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME,    &
                              'Weighted sum of Cloud structure components failed.', &
                              Error_Status,    &
                              Message_Log=Message_Log )
        RETURN
      END IF
    END IF


    ! Weight the Aerosol structure
    ! ----------------------------
    IF ( A%n_Aerosols > 0 ) THEN
      Error_Status = CRTM_WeightedSum_Aerosol( A%Aerosol, &
                                               B%Aerosol, &
                                               w1, &
                                               w2 = w2, &
                                               Message_Log=Message_Log )
      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME,    &
                              'Weighted sum of Aerosol structure components failed.', &
                              Error_Status,    &
                              Message_Log=Message_Log )
        RETURN
      END IF
    END IF

  END FUNCTION WeightedSum_Scalar


  FUNCTION WeightedSum_Rank1( A          , &  ! Input/Output
                              B          , &  ! Input
                              w1         , &  ! Input
                              w2         , &  ! optional input
                              RCS_Id     , &  ! Revision control
                              Message_Log) &  ! Error messaging
                            RESULT( Error_Status )
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: A(:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN)     :: B(:)
    REAL(fp)    ,               INTENT(IN)     :: w1
    REAL(fp)    ,     OPTIONAL, INTENT(IN)     :: w2
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_WeightSum_Atmosphere(Rank-1)'
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
                          &" of CRTM_Atmosphere structure arrays." )' ) m
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
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: A(:,:)
    TYPE(CRTM_Atmosphere_type), INTENT(IN)     :: B(:,:)
    REAL(fp)    ,               INTENT(IN)     :: w1
    REAL(fp)    ,     OPTIONAL, INTENT(IN)     :: w2
    CHARACTER(*),     OPTIONAL, INTENT(OUT)    :: RCS_Id
    CHARACTER(*),     OPTIONAL, INTENT(IN)     :: Message_Log
    ! Function result
    INTEGER :: Error_Status
    ! Local parameters
    CHARACTER(*), PARAMETER :: ROUTINE_NAME = 'CRTM_WeightSum_Atmosphere(Rank-2)'
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
                            &" of CRTM_Atmosphere structure arrays." )' ) l,m
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
!       CRTM_Zero_Atmosphere
! 
! PURPOSE:
!       Subroutine to zero-out all members of a CRTM_Atmosphere structure - both
!       scalar and pointer.
!
! CALLING SEQUENCE:
!       CALL CRTM_Zero_Atmosphere( Atmosphere )
!
! OUTPUT ARGUMENTS:
!       Atmosphere:   Zeroed out Atmosphere structure.
!                     In the context of the CRTM, rank-1 corresponds to an
!                     vector of profiles, and rank-2 corresponds to an array
!                     of channels x profiles. The latter is used in the
!                     K-matrix model.
!                     UNITS:      N/A
!                     TYPE:       CRTM_Atmosphere_type
!                     DIMENSION:  Scalar, Rank-1, or Rank-2 array
!                     ATTRIBUTES: INTENT(IN OUT)
!
! COMMENTS:
!       - No checking of the input structure is performed, so there are no
!         tests for component association status. This means the Atmosphere
!         structure must have allocated components upon entry to this
!         routine.
!
!       - The Absorber_ID and Absorber_Units components are *NOT* zeroed out
!         in this routine.
!
!       - The n_Layers, n_Clouds, and n_Aerosols components are set to the value
!         of the Max_Layers, Max_Clouds, and Max_Aerosols components respectively.
!
!       - Note the INTENT on the output Atmosphere argument is IN OUT rather than
!         just OUT. This is necessary because the argument must be defined upon
!         input.
!
!--------------------------------------------------------------------------------

  SUBROUTINE Zero_Scalar( Atmosphere )  ! Output
    TYPE(CRTM_Atmosphere_type),  INTENT(IN OUT) :: Atmosphere

    ! Reset the structure components
    IF ( Atmosphere%Max_Clouds   > 0 ) CALL CRTM_Zero_Cloud(   Atmosphere%Cloud   )
    IF ( Atmosphere%Max_Aerosols > 0 ) CALL CRTM_Zero_Aerosol( Atmosphere%Aerosol )

    ! Reset the array components
    Atmosphere%Level_Pressure    = ZERO
    Atmosphere%Pressure          = ZERO
    Atmosphere%Temperature       = ZERO
    Atmosphere%Absorber          = ZERO
  END SUBROUTINE Zero_Scalar


  SUBROUTINE Zero_Rank1( Atmosphere )  ! Output
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:)
    INTEGER :: m
    DO m = 1, SIZE( Atmosphere )
      CALL Zero_Scalar( Atmosphere(m) )
    END DO
  END SUBROUTINE Zero_Rank1


  SUBROUTINE Zero_Rank2( Atmosphere )  ! Output
    TYPE(CRTM_Atmosphere_type), INTENT(IN OUT) :: Atmosphere(:,:)
    INTEGER :: l, m
    DO m = 1, SIZE(Atmosphere,2)
      DO l = 1, SIZE(Atmosphere,1)
        CALL Zero_Scalar( Atmosphere(l,m) )
      END DO
    END DO
  END SUBROUTINE Zero_Rank2



!--------------------------------------------------------------------------------
!
! NAME:
!       CRTM_Get_AbsorberIdx
! 
! PURPOSE:
!       Function to determine the index of the requested absorber in the
!       CRTM_Atmosphere structure absorber component.
!
! CALLING SEQUENCE:
!       Idx = CRTM_Get_AbsorberIdx(Atmosphere, AbsorberId)
!
! INPUT ARGUMENTS:
!       Atmosphere:   CRTM Atmosphere structure.
!                     UNITS:      N/A
!                     TYPE:       CRTM_Atmosphere_type
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(IN)
!
!       AbsorberId:   Integer value used to identify absorbing molecular
!                     species. The accepted absorber Ids are defined in
!                     this module.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT(IN)
!
! FUNCTION RESULT:
!       Idx:          Index of the requested absorber in the 
!                     Atmosphere%Absorber array component.
!                     If the requested absorber cannot be found, 
!                     a value of -1 is returned.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!
!--------------------------------------------------------------------------------

  FUNCTION CRTM_Get_AbsorberIdx(Atm, AbsorberId) RESULT(AbsorberIdx)
    ! Arguments
    TYPE(CRTM_Atmosphere_type), INTENT(IN) :: Atm
    INTEGER                   , INTENT(IN) :: AbsorberId
    ! Function result
    INTEGER :: AbsorberIdx
    ! Local variables
    INTEGER :: j, Idx(1)
    
    ! Initialise result to "not found"
    AbsorberIdx = -1
    ! Return if absorber not present
    IF ( COUNT(Atm%Absorber_ID == AbsorberId) /= 1 ) RETURN
    ! Find the location
    Idx = PACK( (/(j,j=1,Atm%n_Absorbers)/), &
                Atm%Absorber_ID==AbsorberId  )
    AbsorberIdx=Idx(1)
    
  END FUNCTION CRTM_Get_AbsorberIdx

END MODULE CRTM_Atmosphere_Define
