!--------------------------------------------------------------------------------
!M+
! NAME:
!       CRTM_SensorData_Define
!
! PURPOSE:
!       Module defining the CRTM SensorData SensorData structure and containing
!       routines to manipulate it.
!       
! CATEGORY:
!       CRTM : Surface : Sensor Data
!
! LANGUAGE:
!       Fortran-95
!
! CALLING SEQUENCE:
!       USE SensorData_Define
!
! MODULES:
!       Type_Kinds:          Module containing definitions for kinds
!                            of variable types.
!
!       Message_Handler:     Module to define simple error codes and
!                            handle error conditions
!                            USEs: FILE_UTILITY module
!
!       CRTM_Parameters:     Module of parameter definitions for the CRTM.
!                            USEs: TYPE_KINDS module
!
! CONTAINS:
!       CRTM_Associated_SensorData:  Function to test the association status
!                                    of the pointer members of a SensorData
!                                    structure.
!
!       CRTM_Destroy_SensorData:     Function to re-initialize an SensorData
!                                    structure.
!
!       CRTM_Allocate_SensorData:    Function to allocate the pointer members
!                                    of a SensorData structure.
!
!       CRTM_Assign_SensorData:      Function to copy an SensorData structure.
!
!
! DERIVED TYPES:
!       CRTM_SensorData_type
!       --------------------
!         Definition of the CRTM SensorData data structure.
!         Fields are...
!
!         n_Channels:              Number of channels dimension.
!                                  This is the "L" dimension.
!                                  Note: Can be = 0 (i.e. no sensor data)
!                                  UNITS:      N/A
!                                  TYPE:       INTEGER
!                                  DIMENSION:  Scalar
!
!         Sensor_ID:               The WMO code for identifying a satelite
!                                  sensor. Taken from the WMO common
!                                  code tables at:
!                                    http://www.wmo.ch/web/ddbs/Code-tables.html
!                                  The Sensor ID is from Common Code
!                                  table C-8, or code table 0 02 019 in BUFR
!                                  UNITS:      N/A
!                                  TYPE:       INTEGER
!                                  DIMENSION:  Scalar
!
!         Tb:                      The brightness temperature observation for
!                                  the specified channel.
!                                  UNITS:      Kelvin (K)
!                                  TYPE:       REAL( Double )
!                                  DIMENSION:  Rank-1, n_Channels
!
!             
!
!         NCEP_Sensor_ID:          An "in-house" value used at NOAA/NCEP/EMC 
!                                  to identify a satellite/sensor combination.
!                                  UNITS:      N/A
!                                  TYPE:       INTEGER
!                                  DIMENSION:  Rank-1, n_Channels
!                                  ATTRIBUTES: POINTER
!
!         WMO_Satellite_ID:        The WMO code for identifying satellite
!                                  platforms. Taken from the WMO common
!                                  code tables at:
!                                    http://www.wmo.ch/web/ddbs/Code-tables.html
!                                  The Satellite ID is from Common Code
!                                  table C-5, or code table 0 01 007 in BUFR
!                                  UNITS:      N/A
!                                  TYPE:       INTEGER
!                                  DIMENSION:  Rank-1, n_Channels
!                                  ATTRIBUTES: POINTER
!
!         WMO_Sensor_ID:           The WMO code for identifying a satelite
!                                  sensor. Taken from the WMO common
!                                  code tables at:
!                                    http://www.wmo.ch/web/ddbs/Code-tables.html
!                                  The Sensor ID is from Common Code
!                                  table C-8, or code table 0 02 019 in BUFR
!                                  UNITS:      N/A
!                                  TYPE:       INTEGER
!                                  DIMENSION:  Rank-1, n_Channels
!                                  ATTRIBUTES: POINTER
!
!         Sensor_Channel:          This is the sensor channel number associated
!                                  with the data in the coefficient file. Helps
!                                  in identifying channels where the numbers are
!                                  not contiguous (e.g. AIRS).
!                                  UNITS:      N/A
!                                  TYPE:       INTEGER
!                                  DIMENSION:  Rank-1, n_Channels
!                                  ATTRIBUTES: POINTER
!
!
!       *!IMPORTANT!*
!       -------------
!       Note that the CRTM_SensorData_type is PUBLIC and its members are
!       not encapsulated; that is, they can be fully accessed outside the
!       scope of this module. This makes it possible to manipulate
!       the structure and its data directly rather than, for e.g., via
!       get() and set() functions. This was done to eliminate the
!       overhead of the get/set type of structure access in using the
!       structure. *But*, it is recommended that the user destroy,
!       allocate, and assign the structure using only the routines
!       in this module where possible to eliminate -- or at least
!       minimise -- the possibility of memory leakage since most
!       of the structure members are pointers.
!
! INCLUDE FILES:
!       None.
!
! EXTERNALS:
!       None.
!
! COMMON BLOCKS:
!       None.
!
! FILES ACCESSED:
!       None.
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 23-Jul-2004
!                       paul.vandelst@ssec.wisc.edu
!
!  Copyright (C) 2004 Paul van Delst
!
!  This program is free software; you can redistribute it and/or
!  modify it under the terms of the GNU General Public License
!  as published by the Free Software Foundation; either version 2
!  of the License, or (at your option) any later version.
!
!  This program is distributed in the hope that it will be useful,
!  but WITHOUT ANY WARRANTY; without even the implied warranty of
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!  GNU General Public License for more details.
!
!  You should have received a copy of the GNU General Public License
!  along with this program; if not, write to the Free Software
!  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
!M-
!--------------------------------------------------------------------------------

MODULE CRTM_SensorData_Define


  ! ----------
  ! Module use
  ! ----------

  USE Type_Kinds
  USE Message_Handler

  USE CRTM_Parameters, ONLY: INVALID_NCEP_SENSOR_ID, &
                             INVALID_WMO_SATELLITE_ID, &
                             INVALID_WMO_SENSOR_ID   


  ! -----------------------
  ! Disable implicit typing
  ! -----------------------

  IMPLICIT NONE


  ! ------------
  ! Visibilities
  ! ------------

  PRIVATE

  PUBLIC :: CRTM_Associated_SensorData
  PUBLIC :: CRTM_Destroy_SensorData
  PUBLIC :: CRTM_Allocate_SensorData
  PUBLIC :: CRTM_Assign_SensorData


  ! -------------------------
  ! PRIVATE Module parameters
  ! -------------------------

  ! -- RCS Id for the module
  CHARACTER( * ), PRIVATE, PARAMETER :: MODULE_RCS_ID = &
  '$Id: CRTM_SensorData_Define.f90,v 1.7 2006/05/02 14:58:35 dgroff Exp $'

  ! -- SensorData scalar member invalid value
  INTEGER,         PRIVATE, PARAMETER :: INVALID = -1
  REAL( fp_kind ), PRIVATE, PARAMETER :: ZERO    = 0.0_fp_kind

  ! -- Keyword set value
  INTEGER, PRIVATE, PARAMETER :: SET = 1



  ! -------------------------------
  ! SensorData data type definition
  ! -------------------------------

  TYPE, PUBLIC :: CRTM_SensorData_type
    INTEGER :: n_Allocates = 0

    ! -- Dimension values
    INTEGER :: n_Channels = 0 ! L dimension

    ! -- WMO sensor ID for the sensor providing the following measurements
    INTEGER :: Sensor_ID = INVALID

    ! -- The sensor brightness temperatures
    REAL( fp_kind ), DIMENSION( : ), POINTER :: Tb => NULL() ! L


    ! -- The sensor ID and channels
    INTEGER, DIMENSION( : ), POINTER :: NCEP_Sensor_ID   => NULL() ! L
    INTEGER, DIMENSION( : ), POINTER :: WMO_Satellite_ID => NULL() ! L
    INTEGER, DIMENSION( : ), POINTER :: WMO_Sensor_ID    => NULL() ! L
    INTEGER, DIMENSION( : ), POINTER :: Sensor_Channel   => NULL() ! L


  END TYPE CRTM_SensorData_type


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
!       CRTM_Clear_SensorData
!
! PURPOSE:
!       Subroutine to clear the scalar members of a CRTM SensorData structure.
!
! CATEGORY:
!       CRTM : Surface : SensorData
!
! LANGUAGE:
!       Fortran-95
!
! CALLING SEQUENCE:
!       CALL CRTM_Clear_SensorData( SensorData) ! Output
!
! INPUT ARGUMENTS:
!       None.
!
! OPTIONAL INPUT ARGUMENTS:
!       None.
!
! OUTPUT ARGUMENTS:
!       SensorData:  SensorData structure for which the scalar members have
!                    been cleared.
!                    UNITS:      N/A
!                    TYPE:       CRTM_SensorData_type
!                    DIMENSION:  Scalar
!                    ATTRIBUTES: INTENT( IN OUT )
!
! OPTIONAL OUTPUT ARGUMENTS:
!       None.
!
! CALLS:
!       None.
!
! SIDE EFFECTS:
!       None.
!
! RESTRICTIONS:
!       None.
!       
! COMMENTS:
!       Note the INTENT on the output SensorData argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 23-Jul-2004
!                       paul.vandelst@ssec.wisc.edu
!
!----------------------------------------------------------------------------------

  SUBROUTINE CRTM_Clear_SensorData( SensorData )

    TYPE( CRTM_SensorData_type ), INTENT( IN OUT ) :: SensorData

    SensorData%n_Channels = 0

  END SUBROUTINE CRTM_Clear_SensorData





!################################################################################
!################################################################################
!##                                                                            ##
!##                         ## PUBLIC MODULE ROUTINES ##                       ##
!##                                                                            ##
!################################################################################
!################################################################################

!--------------------------------------------------------------------------------
!S+
! NAME:
!       CRTM_Associated_SensorData
!
! PURPOSE:
!       Function to test the association status of the pointer members of a
!       CRTM_SensorData structure.
!
! CATEGORY:
!       CRTM : Surface : SensorData
!
! LANGUAGE:
!       Fortran-95
!
! CALLING SEQUENCE:
!       Association_Status = CRTM_Associated_SensorData( SensorData,         &  ! Input
!                                                        ANY_Test = Any_Test )  ! Optional input
!
! INPUT ARGUMENTS:
!       SensorData:  SensorData structure which is to have its pointer
!                    member's association status tested.
!                    UNITS:      N/A
!                    TYPE:       CRTM_SensorData_type
!                    DIMENSION:  Scalar
!                    ATTRIBUTES: INTENT( IN )
!
! OPTIONAL INPUT ARGUMENTS:
!       ANY_Test:    Set this argument to test if ANY of the
!                    SensorData structure pointer members are associated.
!                    The default is to test if ALL the pointer members
!                    are associated.
!                    If ANY_Test = 0, test if ALL the pointer members
!                                     are associated.  (DEFAULT)
!                       ANY_Test = 1, test if ANY of the pointer members
!                                     are associated.
!
! OUTPUT ARGUMENTS:
!       None.
!
! OPTIONAL OUTPUT ARGUMENTS:
!       None.
!
! FUNCTION RESULT:
!       Association_Status:  The return value is a logical value indicating the
!                            association status of the SensorData pointer
!                            members.
!                            .TRUE.  - if ALL the SensorData pointer members
!                                      are associated, or if the ANY_Test argument
!                                      is set and ANY of the SensorData
!                                      pointer members are associated.
!                            .FALSE. - some or all of the SensorData pointer
!                                      members are NOT associated.
!                            UNITS:      N/A
!                            TYPE:       LOGICAL
!                            DIMENSION:  Scalar
!
! CALLS:
!       None.
!
! SIDE EFFECTS:
!       None.
!
! RESTRICTIONS:
!       None.
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 13-May-2004
!                       paul.vandelst@ssec.wisc.edu
!S-
!--------------------------------------------------------------------------------

  FUNCTION CRTM_Associated_SensorData( SensorData, & ! Input
                                       ANY_Test )  & ! Optional input
                                     RESULT( Association_Status )



    !#--------------------------------------------------------------------------#
    !#                        -- TYPE DECLARATIONS --                           #
    !#--------------------------------------------------------------------------#

    ! ---------
    ! Arguments
    ! ---------

    ! -- Input
    TYPE( CRTM_SensorData_type ), INTENT( IN ) :: SensorData

    ! -- Optional input
    INTEGER,            OPTIONAL, INTENT( IN ) :: ANY_Test


    ! ---------------
    ! Function result
    ! ---------------

    LOGICAL :: Association_Status


    ! ---------------
    ! Local variables
    ! ---------------

    LOGICAL :: ALL_Test



    !#--------------------------------------------------------------------------#
    !#                           -- CHECK INPUT --                              #
    !#--------------------------------------------------------------------------#

    ! -- Default is to test ALL the pointer members
    ! -- for a true association status....
    ALL_Test = .TRUE.

    ! ...unless the ANY_Test argument is set.
    IF ( PRESENT( ANY_Test ) ) THEN
      IF ( ANY_Test == SET ) ALL_Test = .FALSE.
    END IF



    !#--------------------------------------------------------------------------#
    !#           -- TEST THE STRUCTURE POINTER MEMBER ASSOCIATION --            #
    !#--------------------------------------------------------------------------#

    Association_Status = .FALSE.

    IF ( ALL_Test ) THEN

      IF ( ASSOCIATED( SensorData%NCEP_Sensor_ID   ) .AND. &
           ASSOCIATED( SensorData%WMO_Satellite_ID ) .AND. &
           ASSOCIATED( SensorData%WMO_Sensor_ID    ) .AND. &
           ASSOCIATED( SensorData%Sensor_Channel   ) .AND. &
           ASSOCIATED( SensorData%Tb               )       ) THEN
        Association_Status = .TRUE.
      END IF

    ELSE

      IF ( ASSOCIATED( SensorData%NCEP_Sensor_ID   ) .OR. &
           ASSOCIATED( SensorData%WMO_Satellite_ID ) .OR. &
           ASSOCIATED( SensorData%WMO_Sensor_ID    ) .OR. &
           ASSOCIATED( SensorData%Sensor_Channel   ) .OR. &
           ASSOCIATED( SensorData%Tb               )      ) THEN
        Association_Status = .TRUE.
      END IF

    END IF

  END FUNCTION CRTM_Associated_SensorData




!--------------------------------------------------------------------------------
!S+
! NAME:
!       CRTM_Destroy_SensorData
! 
! PURPOSE:
!       Function to re-initialize the scalar and pointer members of SensorData
!       data structures.
!
! CATEGORY:
!       CRTM : Surface : SensorData
!
! LANGUAGE:
!       Fortran-95
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Destroy_SensorData( SensorData,               &  ! Output
!                                               RCS_Id      = RCS_Id,     &  ! Revision control
!                                               Message_Log = Message_Log )  ! Error messaging
!
! INPUT ARGUMENTS:
!       None.
!
! OPTIONAL INPUT ARGUMENTS:
!       Message_Log:  Character string specifying a filename in which any
!                     messages will be logged. If not specified, or if an
!                     error occurs opening the log file, the default action
!                     is to output messages to standard output.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER(*)
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT( IN ), OPTIONAL
!
! OUTPUT ARGUMENTS:
!       SensorData:   Re-initialized SensorData structure.
!                     UNITS:      N/A
!                     TYPE:       CRTM_SensorData_type
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT( IN OUT )
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:       Character string containing the Revision Control
!                     System Id field for the module.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER(*)
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT( OUT ), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status: The return value is an integer defining the error status.
!                     The error codes are defined in the ERROR_HANDLER module.
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
! CALLS:
!       CRTM_Clear_SensorData:       Subroutine to clear the scalar members of a
!                                    CRTM SensorData structure.
!
!       CRTM_Associated_SensorData:  Function to test the association status of
!                                    the pointer members of a CRTM_SensorData
!                                    structure.
!
!       Display_Message:             Subroutine to output messages
!                                    SOURCE: ERROR_HANDLER module
!
! SIDE EFFECTS:
!       None.
!
! RESTRICTIONS:
!       None.
!       
! COMMENTS:
!       Note the INTENT on the output SensorData argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 23-Jul-2004
!                       paul.vandelst@ssec.wisc.edu
!S-
!--------------------------------------------------------------------------------

  FUNCTION CRTM_Destroy_SensorData( SensorData,   &  ! Output
                                    No_Clear,     &  ! Optional input
                                    RCS_Id,       &  ! Revision control
                                    Message_Log ) &  ! Error messaging
                                  RESULT( Error_Status )



    !#--------------------------------------------------------------------------#
    !#                        -- TYPE DECLARATIONS --                           #
    !#--------------------------------------------------------------------------#

    ! ---------
    ! Arguments
    ! ---------

    ! -- Output
    TYPE( CRTM_SensorData_type ), INTENT( IN OUT ) :: SensorData

    ! -- Optional input
    INTEGER,            OPTIONAL, INTENT( IN )     :: No_Clear

    ! -- Revision control
    CHARACTER( * ),     OPTIONAL, INTENT( OUT )    :: RCS_Id

    ! - Error messaging
    CHARACTER( * ),     OPTIONAL, INTENT( IN )     :: Message_Log


    ! ---------------
    ! Function result
    ! ---------------

    INTEGER :: Error_Status


    ! ----------------
    ! Local parameters
    ! ----------------

    CHARACTER( * ), PARAMETER :: ROUTINE_NAME = 'CRTM_Destroy_SensorData'


    ! ---------------
    ! Local variables
    ! ---------------

    CHARACTER( 256 ) :: Message
    LOGICAL :: Clear
    INTEGER :: Allocate_Status


    !#--------------------------------------------------------------------------#
    !#                    -- SET SUCCESSFUL RETURN STATUS --                    #
    !#--------------------------------------------------------------------------#

    Error_Status = SUCCESS



    !#--------------------------------------------------------------------------#
    !#                -- SET THE RCS ID ARGUMENT IF SUPPLIED --                 #
    !#--------------------------------------------------------------------------#

    IF ( PRESENT( RCS_Id ) ) THEN
      RCS_Id = ' '
      RCS_Id = MODULE_RCS_ID
    END IF



    !#--------------------------------------------------------------------------#
    !#                      -- CHECK OPTIONAL ARGUMENTS --                      #
    !#--------------------------------------------------------------------------#

    ! -- Default is to clear scalar members...
    Clear = .TRUE.
    ! -- ....unless the No_Clear argument is set
    IF ( PRESENT( No_Clear ) ) THEN
      IF ( No_Clear == SET ) Clear = .FALSE.
    END IF


    
    !#--------------------------------------------------------------------------#
    !#                       -- PERFORM REINITIALISATION --                     #
    !#--------------------------------------------------------------------------#

    ! -----------------------------
    ! Initialise the scalar members
    ! -----------------------------

    IF ( Clear ) CALL CRTM_Clear_SensorData( SensorData )


    ! -----------------------------------------------------
    ! If ALL pointer members are NOT associated, do nothing
    ! -----------------------------------------------------

    IF ( .NOT. CRTM_Associated_SensorData( SensorData ) ) RETURN


    ! ------------------------------
    ! Deallocate the pointer members
    ! ------------------------------

    ! -- Deallocate the SensorData NCEP_Sensor_ID member
    IF ( ASSOCIATED( SensorData%NCEP_Sensor_ID ) ) THEN

      DEALLOCATE( SensorData%NCEP_Sensor_ID, STAT = Allocate_Status )

      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error deallocating CRTM_SensorData NCEP_Sensor_ID ", &
                          &"member. STAT = ", i5 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME,    &
                              TRIM( Message ), &
                              Error_Status,    &
                              Message_Log = Message_Log )
      END IF
    END IF


    ! -- Deallocate the SensorData WMO_Satellite_ID member
    IF ( ASSOCIATED( SensorData%WMO_Satellite_ID ) ) THEN

      DEALLOCATE( SensorData%WMO_Satellite_ID, STAT = Allocate_Status )

      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error deallocating CRTM_SensorData WMO_Satellite_ID ", &
                          &"member. STAT = ", i5 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME,    &
                              TRIM( Message ), &
                              Error_Status,    &
                              Message_Log = Message_Log )
      END IF
    END IF


    ! -- Deallocate the SensorData WMO_Sensor_ID member
    IF ( ASSOCIATED( SensorData%WMO_Sensor_ID ) ) THEN

      DEALLOCATE( SensorData%WMO_Sensor_ID, STAT = Allocate_Status )

      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error deallocating CRTM_SensorData WMO_Sensor_ID ", &
                          &"member. STAT = ", i5 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME,    &
                              TRIM( Message ), &
                              Error_Status,    &
                              Message_Log = Message_Log )
      END IF
    END IF


    ! -- Deallocate the SensorData Sensor_Channel member
    IF ( ASSOCIATED( SensorData%Sensor_Channel ) ) THEN

      DEALLOCATE( SensorData%Sensor_Channel, STAT = Allocate_Status )

      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error deallocating CRTM_SensorData Sensor_Channel ", &
                          &"member. STAT = ", i5 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME,    &
                              TRIM( Message ), &
                              Error_Status,    &
                              Message_Log = Message_Log )
      END IF
    END IF


    ! -- Deallocate the SensorData Tb member
    IF ( ASSOCIATED( SensorData%Tb ) ) THEN

      DEALLOCATE( SensorData%Tb, STAT = Allocate_Status )

      IF ( Allocate_Status /= 0 ) THEN
        Error_Status = FAILURE
        WRITE( Message, '( "Error deallocating CRTM_SensorData Tb ", &
                          &"member. STAT = ", i5 )' ) &
                        Allocate_Status
        CALL Display_Message( ROUTINE_NAME,    &
                              TRIM( Message ), &
                              Error_Status,    &
                              Message_Log = Message_Log )
      END IF
    END IF



    !#--------------------------------------------------------------------------#
    !#               -- DECREMENT AND TEST ALLOCATION COUNTER --                #
    !#--------------------------------------------------------------------------#

    SensorData%n_Allocates = SensorData%n_Allocates - 1

    IF ( SensorData%n_Allocates /= 0 ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Allocation counter /= 0, Value = ", i5 )' ) &
                      SensorData%n_Allocates
      CALL Display_Message( ROUTINE_NAME,    &
                            TRIM( message ), &
                            Error_Status,    &
                            Message_Log = Message_Log )
    END IF

  END FUNCTION CRTM_Destroy_SensorData





!------------------------------------------------------------------------------
!S+
! NAME:
!       CRTM_Allocate_SensorData
! 
! PURPOSE:
!       Function to allocate the pointer members of a CRTM SensorData
!       data structure.
!
! CATEGORY:
!       CRTM : SensorData
!
! LANGUAGE:
!       Fortran-95
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Allocate_SensorData( n_Channels,               &  ! Input
!                                                SensorData,               &  ! Output
!                                                RCS_Id = RCS_Id,          &  ! Revision control
!                                                Message_Log = Message_Log )  ! Error messaging
!
! INPUT ARGUMENTS:
!       n_Channels:   The number of channels in the SensorData structure.
!                     Must be > 0.
!                     UNITS:      N/A
!                     TYPE:       INTEGER
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT( IN )
!
! OPTIONAL INPUT ARGUMENTS:
!       Message_Log:  Character string specifying a filename in which any
!                     Messages will be logged. If not specified, or if an
!                     error occurs opening the log file, the default action
!                     is to output Messages to standard output.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER( * )
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT( IN ), OPTIONAL
!
! OUTPUT ARGUMENTS:
!       SensorData:   SensorData structure with allocated pointer members
!                     UNITS:      N/A
!                     TYPE:       CRTM_SensorData_type
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT( IN OUT )
!
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:       Character string containing the Revision Control
!                     System Id field for the module.
!                     UNITS:      N/A
!                     TYPE:       CHARACTER(*)
!                     DIMENSION:  Scalar
!                     ATTRIBUTES: INTENT( OUT ), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status: The return value is an integer defining the error status.
!                     The error codes are defined in the ERROR_HANDLER module.
!                     If == SUCCESS the structure pointer allocations were
!                                   successful
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
! CALLS:
!       CRTM_Associated_SensorData:  Function to test the association status
!                                     of the pointer members of a CRTM
!                                     SensorData structure.
!
!       CRTM_Destroy_SensorData:     Function to re-initialize a SensorData
!                                     structure.
!
!       Display_Message:              Subroutine to output messages
!                                     SOURCE: ERROR_HANDLER module
!
! SIDE EFFECTS:
!       None.
!
! RESTRICTIONS:
!       None.
!       
! COMMENTS:
!       Note the INTENT on the output SensorData argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 13-May-2004
!                       paul.vandelst@ssec.wisc.edu
!S-
!------------------------------------------------------------------------------

  FUNCTION CRTM_Allocate_SensorData( n_Channels,   &  ! Input
                                     SensorData,   &  ! Output
                                     RCS_Id,       &  ! Revision control
                                     Message_Log ) &  ! Error messaging
                                   RESULT( Error_Status )



    !#--------------------------------------------------------------------------#
    !#                        -- TYPE DECLARATIONS --                           #
    !#--------------------------------------------------------------------------#

    ! ---------
    ! Arguments
    ! ---------

    ! -- Input
    INTEGER,                      INTENT( IN )     :: n_Channels

    ! -- Output
    TYPE( CRTM_SensorData_type ), INTENT( IN OUT ) :: SensorData

    ! -- Revision control
    CHARACTER( * ),     OPTIONAL, INTENT( OUT )    :: RCS_Id

    ! - Error messaging
    CHARACTER( * ),     OPTIONAL, INTENT( IN )     :: Message_Log


    ! ---------------
    ! Function result
    ! ---------------

    INTEGER :: Error_Status


    ! ----------------
    ! Local parameters
    ! ----------------

    CHARACTER( * ), PARAMETER :: ROUTINE_NAME = 'CRTM_Allocate_SensorData'


    ! ---------------
    ! Local variables
    ! ---------------

    CHARACTER( 256 ) :: Message

    INTEGER :: Allocate_Status



    !#--------------------------------------------------------------------------#
    !#                    -- SET SUCCESSFUL RETURN STATUS --                    #
    !#--------------------------------------------------------------------------#

    Error_Status = SUCCESS



    !#--------------------------------------------------------------------------#
    !#                -- SET THE RCS ID ARGUMENT IF SUPPLIED --                 #
    !#--------------------------------------------------------------------------#

    IF ( PRESENT( RCS_Id ) ) THEN
      RCS_Id = ' '
      RCS_Id = MODULE_RCS_ID
    END IF



    !#--------------------------------------------------------------------------#
    !#                            -- CHECK INPUT --                             #
    !#--------------------------------------------------------------------------#

    ! ----------------------
    ! The number of channels
    ! ----------------------

    IF ( n_Channels < 0 ) THEN
      Error_Status = FAILURE
      CALL Display_Message( ROUTINE_NAME, &
                            'Input n_Channels must be > or = 0.', &
                            Error_Status, &
                            Message_Log = Message_Log )
      RETURN
    END IF



    ! --------------------------------------------
    ! Check if ANY pointers are already associated
    ! --------------------------------------------

    IF ( CRTM_Associated_SensorData( SensorData, ANY_Test = SET ) ) THEN

      Error_Status = CRTM_Destroy_SensorData( SensorData, &
                                              Message_Log = Message_Log )

      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME,    &
                              'Error deallocating CRTM_SensorData pointer members.', &
                              Error_Status,    &
                              Message_Log = Message_Log )
        RETURN
      END IF

    END IF


    ! -----------------------------------------------
    ! If the number of channels is 0, then we're done
    ! -----------------------------------------------

    IF ( n_Channels == 0 ) RETURN



    !#--------------------------------------------------------------------------#
    !#                       -- PERFORM THE ALLOCATION --                       #
    !#--------------------------------------------------------------------------#

    ALLOCATE( SensorData%NCEP_Sensor_ID( n_Channels ), &
              SensorData%WMO_Satellite_ID( n_Channels ), &
              SensorData%WMO_Sensor_ID( n_Channels ), &
              SensorData%Sensor_Channel( n_Channels ), &
              SensorData%Tb( n_Channels ), &
              STAT = Allocate_Status )

    IF ( Allocate_Status /= 0 ) THEN
      Error_Status = FAILURE
      WRITE( Message, '( "Error allocating CRTM_SensorData data arrays. STAT = ", i5 )' ) &
                      Allocate_Status
      CALL Display_Message( ROUTINE_NAME,    &
                            TRIM( Message ), &
                            Error_Status,    &
                            Message_Log = Message_Log )
      RETURN
    END IF



    !#--------------------------------------------------------------------------#
    !#        -- ASSIGN THE n_Channels DIMENSION AND INITALISE ARRAYS --        #
    !#--------------------------------------------------------------------------#

    SensorData%n_Channels = n_Channels

    SensorData%NCEP_Sensor_ID    = INVALID_NCEP_SENSOR_ID
    SensorData%WMO_Satellite_ID  = INVALID_WMO_SATELLITE_ID
    SensorData%WMO_Sensor_ID     = INVALID_WMO_SENSOR_ID
    SensorData%Sensor_Channel    = INVALID
    SensorData%Tb                = ZERO



    !#--------------------------------------------------------------------------#
    !#                -- INCREMENT AND TEST ALLOCATION COUNTER --               #
    !#--------------------------------------------------------------------------#

    SensorData%n_Allocates = SensorData%n_Allocates + 1

    IF ( SensorData%n_Allocates /= 1 ) THEN
      Error_Status = WARNING
      WRITE( Message, '( "Allocation counter /= 1, Value = ", i5 )' ) &
                      SensorData%n_Allocates
      CALL Display_Message( ROUTINE_NAME,    &
                            TRIM( message ), &
                            Error_Status,    &
                            Message_Log = Message_Log )
    END IF

  END FUNCTION CRTM_Allocate_SensorData





!--------------------------------------------------------------------------------
!S+
! NAME:
!       CRTM_Assign_SensorData
!
! PURPOSE:
!       Function to copy valid SensorData structures.
!
! CATEGORY:
!       CRTM : Surface : SensorData
!
! LANGUAGE:
!       Fortran-95
!
! CALLING SEQUENCE:
!       Error_Status = CRTM_Assign_SensorData( SensorData_in,  &  ! Input
!                                              SensorData_out, &  ! Output
!                                              RCS_Id = RCS_Id,          &  ! Revision control
!                                              Message_Log = Message_Log )  ! Error messaging
!
! INPUT ARGUMENTS:
!       SensorData_in:   SensorData structure which is to be copied.
!                        UNITS:      N/A
!                        TYPE:       CRTM_SensorData_type
!                        DIMENSION:  Scalar OR Rank-1
!                        ATTRIBUTES: INTENT( IN )
!
! OPTIONAL INPUT ARGUMENTS:
!       Message_Log:     Character string specifying a filename in which any
!                        messages will be logged. If not specified, or if an
!                        error occurs opening the log file, the default action
!                        is to output messages to standard output.
!                        UNITS:      N/A
!                        TYPE:       CHARACTER(*)
!                        DIMENSION:  Scalar
!                        ATTRIBUTES: INTENT( IN ), OPTIONAL
!
! OUTPUT ARGUMENTS:
!       SensorData_out:  Copy of the input structure, SensorData_in.
!                        UNITS:      N/A
!                        TYPE:       CRTM_SensorData_type
!                        DIMENSION:  Same as SensorData_in
!                        ATTRIBUTES: INTENT( IN OUT )
!
!
! OPTIONAL OUTPUT ARGUMENTS:
!       RCS_Id:          Character string containing the Revision Control
!                        System Id field for the module.
!                        UNITS:      N/A
!                        TYPE:       CHARACTER(*)
!                        DIMENSION:  Scalar
!                        ATTRIBUTES: INTENT( OUT ), OPTIONAL
!
! FUNCTION RESULT:
!       Error_Status:    The return value is an integer defining the error status.
!                        The error codes are defined in the ERROR_HANDLER module.
!                        If == SUCCESS the structure assignment was successful
!                           == FAILURE an error occurred
!                        UNITS:      N/A
!                        TYPE:       INTEGER
!                        DIMENSION:  Scalar
!
! CALLS:
!       CRTM_Associated_SensorData:  Function to test the association status
!                                    of the pointer members of a CRTM
!                                    SensorData structure.
!
!
!       CRTM_Allocate_SensorData:    Function to allocate the pointer members
!                                    of a CRTM SensorData structure.
!
!       Display_Message:             Subroutine to output messages
!                                    SOURCE: ERROR_HANDLER module
!
! SIDE EFFECTS:
!       None.
!
! RESTRICTIONS:
!       None.
!       
! COMMENTS:
!       Note the INTENT on the output SensorData argument is IN OUT rather than
!       just OUT. This is necessary because the argument may be defined upon
!       input. To prevent memory leaks, the IN OUT INTENT is a must.
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 23-Jul-2004
!                       paul.vandelst@ssec.wisc.edu
!S-
!--------------------------------------------------------------------------------

  FUNCTION CRTM_Assign_SensorData( SensorData_in,  &  ! Input
                                   SensorData_out, &  ! Output
                                   RCS_Id,         &  ! Revision control
                                   Message_Log )   &  ! Error messaging
                                 RESULT( Error_Status )



    !#--------------------------------------------------------------------------#
    !#                        -- TYPE DECLARATIONS --                           #
    !#--------------------------------------------------------------------------#

    ! ---------
    ! Arguments
    ! ---------

    ! -- Input
    TYPE( CRTM_SensorData_type ), INTENT( IN )     :: SensorData_in

    ! -- Output
    TYPE( CRTM_SensorData_type ), INTENT( IN OUT ) :: SensorData_out

    ! -- Revision control
    CHARACTER( * ),     OPTIONAL, INTENT( OUT )    :: RCS_Id

    ! - Error messaging
    CHARACTER( * ),     OPTIONAL, INTENT( IN )     :: Message_Log


    ! ---------------
    ! Function result
    ! ---------------

    INTEGER :: Error_Status


    ! ----------------
    ! Local parameters
    ! ----------------

    CHARACTER( * ), PARAMETER :: ROUTINE_NAME = 'CRTM_Assign_SensorData'



    !#--------------------------------------------------------------------------#
    !#                -- SET THE RCS ID ARGUMENT IF SUPPLIED --                 #
    !#--------------------------------------------------------------------------#

    IF ( PRESENT( RCS_Id ) ) THEN
      RCS_Id = ' '
      RCS_Id = MODULE_RCS_ID
    END IF



    !#--------------------------------------------------------------------------#
    !#           -- TEST THE STRUCTURE ARGUMENT POINTER ASSOCIATION --          #
    !#--------------------------------------------------------------------------#

    ! ----------------------------------------------
    ! ALL *input* pointers must be associated.
    !
    ! If this test succeeds, then some or all of the
    ! input pointers are NOT associated, so destroy
    ! the output structure and return.
    ! ----------------------------------------------

    IF ( .NOT. CRTM_Associated_SensorData( SensorData_In ) ) THEN

      Error_Status = CRTM_Destroy_SensorData( SensorData_Out, &
                                              Message_Log = Message_Log )

      IF ( Error_Status /= SUCCESS ) THEN
        CALL Display_Message( ROUTINE_NAME,    &
                              'Error deallocating output CRTM_SensorData pointer members.', &
                              Error_Status,    &
                              Message_Log = Message_Log )
      END IF

      RETURN

    END IF



    !#--------------------------------------------------------------------------#
    !#                       -- PERFORM THE ASSIGNMENT --                       #
    !#--------------------------------------------------------------------------#

    ! ----------------------
    ! Allocate the structure
    ! ----------------------

    Error_Status = CRTM_Allocate_SensorData( SensorData_in%n_Channels, &
                                             SensorData_out, &
                                             Message_Log = Message_Log )

    IF ( Error_Status /= SUCCESS ) THEN
      CALL Display_Message( ROUTINE_NAME,    &
                            'Error allocating output CRTM_SensorData arrays.', &
                            Error_Status,    &
                            Message_Log = Message_Log )
      RETURN
    END IF


    ! -----------------
    ! Assign array data
    ! -----------------

    SensorData_out%NCEP_Sensor_ID    = SensorData_in%NCEP_Sensor_ID
    SensorData_out%WMO_Sensor_ID     = SensorData_in%WMO_Sensor_ID
    SensorData_out%WMO_Satellite_ID  = SensorData_in%WMO_Satellite_ID
    SensorData_out%Sensor_Channel    = SensorData_in%Sensor_Channel
    SensorData_out%Tb                = SensorData_in%Tb

  END FUNCTION CRTM_Assign_SensorData

END MODULE CRTM_SensorData_Define


!---------------------------------------------------------------------------------
!                          -- MODIFICATION HISTORY --
!---------------------------------------------------------------------------------
!
! $Id: CRTM_SensorData_Define.f90,v 1.7 2006/05/02 14:58:35 dgroff Exp $
!
! $Date: 2006/05/02 14:58:35 $
!
! $Revision: 1.7 $
!
! $Name:  $
!
! $State: Exp $
!
! $Log: CRTM_SensorData_Define.f90,v $
! Revision 1.7  2006/05/02 14:58:35  dgroff
! - Replaced all references of Error_Handler with Message_Handler
!
! Revision 1.6  2005/10/19 14:11:35  paulv
! - Shortened non-standard, too-long comment line in modification history.
!   It was causing compiler warning messages.
!
! Revision 1.5  2005/08/22 13:37:49  yhan
! - Add a scalar variable Sensor_ID to CRTM_SensorData_Type to hold a
!   WMO_Sensor_ID set by the user.  It is used in CRTM to identify the
!   the surface emissivity routine for the sensor channels.
!
! Revision 1.4  2005/02/16 15:42:14  paulv
! - Initialization of arrays after allocation changed from an "invalid" value
!   to zero.
!
! Revision 1.3  2004/11/05 15:47:27  paulv
! - Upgraded to Fortran-95
! - Structure initialisation is now performed in the structure type
!   declaration. Removed Init() subroutine.
! - Made Associated() function PUBLIC.
! - Intent of output structures in the Clear(), Allocate(), and Assign()
!   routines changed from (OUT) to (IN OUT) to prevent memory leaks.
! - Allocate() function now destroys the output structure if any pointer
!   members are defined upon input.
! - Updated documentation.
! - Now USEing CRTM_Parameters module for invalid sensor ID values.
! - Altered the way the Assign() function handles unassociated input. Previously
!   an error was issued:
!     IF ( .NOT. CRTM_Associated_SensorData( SensorData_In ) ) THEN
!       Error_Status = FAILURE
!       RETURN
!     END IF
!   Now, rather than returning an error, the output structure is destroyed
!   (in case it is defined upon input), and a successful status is returned,
!     IF ( .NOT. CRTM_Associated_SensorData( SensorData_In ) ) THEN
!       Error_Status = CRTM_Destroy_SensorData( SensorData_Out, &
!                                               Message_Log = Message_Log )
!       RETURN
!     END IF
!
! Revision 1.2  2004/07/27 14:30:33  paulv
! - Changed structure components from pointers to arrays to simple scalars.
!   Now each structure is associated with a single channel rather than
!   grouping all the channel data together.
!
! Revision 1.1  2004/07/23 21:20:08  paulv
! Initial checkin.
!
!
!
!
!