!
! Compare_Float_Numbers
!
! Module containing routines to perform equality and relational
! comparisons on floating point numbers.
!
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 01-Apr-2003
!                       paul.vandelst@ssec.wisc.edu
!

MODULE Compare_Float_Numbers


  ! -----------------
  ! Environment setup
  ! -----------------
  ! Module usage
  USE Type_Kinds, ONLY: Single, Double
  ! Disable all implicit typing
  IMPLICIT NONE


  ! ------------
  ! Visibilities
  ! ------------
  PRIVATE
  PUBLIC :: Compare_Float
  PUBLIC :: OPERATOR (.EqualTo.)
  PUBLIC :: OPERATOR (.GreaterThan.)
  PUBLIC :: OPERATOR (.LessThan.)


  ! ---------------------
  ! Procedure overloading
  ! ---------------------

  INTERFACE Compare_Float
    MODULE PROCEDURE Compare_Real_Single
    MODULE PROCEDURE Compare_Real_Double
    MODULE PROCEDURE Compare_Complex_Single
    MODULE PROCEDURE Compare_Complex_Double
  END INTERFACE Compare_Float

  INTERFACE OPERATOR (.EqualTo.)
    MODULE PROCEDURE Is_Equal_To_Single
    MODULE PROCEDURE Is_Equal_To_Double
  END INTERFACE OPERATOR (.EqualTo.)

  INTERFACE OPERATOR (.GreaterThan.)
    MODULE PROCEDURE Is_Greater_Than_Single
    MODULE PROCEDURE Is_Greater_Than_Double
  END INTERFACE OPERATOR (.GreaterThan.)

  INTERFACE OPERATOR (.LessThan.)
    MODULE PROCEDURE Is_Less_Than_Single
    MODULE PROCEDURE Is_Less_Than_Double
  END INTERFACE OPERATOR (.LessThan.)


  ! -----------------
  ! Module parameters
  ! -----------------
  ! Module RCS Id string
  CHARACTER(*), PARAMETER :: MODULE_RCS_ID = &
    '$Id: Compare_Float_Numbers.f90 886 2007-08-23 22:51:40Z paul.vandelst@noaa.gov $'
  ! Numeric literals
  REAL(Single), PARAMETER :: SP_ZERO = 0.0_Single
  REAL(Double), PARAMETER :: DP_ZERO = 0.0_Double
  REAL(Single), PARAMETER :: SP_ONE = 1.0_Single
  REAL(Double), PARAMETER :: DP_ONE = 1.0_Double
  REAL(Single), PARAMETER :: SP_HUNDRED = 100.0_Single
  REAL(Double), PARAMETER :: DP_HUNDRED = 100.0_Double

CONTAINS


!----------------------------------------------------------------------------------
! NAME:
!       .EqualTo.
!
! PURPOSE:
!       Relational operator to test the equality of REAL operands.
!
! CALLING SEQUENCE:
!       IF ( x .EqualTo. y ) THEN
!         .....
!       END IF
!
! OPERANDS:
!       x, y:        Two congruent floating point data objects to compare.
!                    UNITS:      N/A
!                    TYPE:       REAL(Single)   [ == default real]
!                                  OR
!                                REAL(Double)
!                    DIMENSION:  Scalar, or any allowed rank array.
!
! OPERATOR RESULT:
!       (x .EqualTo. y)    The result is a logical value indicating whether
!                          the operands are equal to within numerical precision
!                          UNITS:      N/A
!                          TYPE:       LOGICAL
!                          DIMENSION:  Same as operands.
!
! PROCEDURE:
!       The test performed is
!
!         ABS( x - y ) < SPACING( MAX(ABS(x),ABS(y)) )
!
!       If the result is .TRUE., the numbers are considered equal.
!
!----------------------------------------------------------------------------------

  ELEMENTAL FUNCTION Is_Equal_To_Single( x, y ) RESULT( Equal_To )
    REAL(Single), INTENT(IN)  :: x, y
    LOGICAL :: Equal_To
    Equal_To = ABS(x-y) < SPACING( MAX(ABS(x),ABS(y)) )
  END FUNCTION Is_Equal_To_Single

  ELEMENTAL FUNCTION Is_Equal_To_Double( x, y ) RESULT( Equal_To )
    REAL(Double), INTENT(IN)  :: x, y
    LOGICAL :: Equal_To
    Equal_To = ABS(x-y) < SPACING( MAX(ABS(x),ABS(y)) )
  END FUNCTION Is_Equal_To_Double


!----------------------------------------------------------------------------------
! NAME:
!       .GreaterThan.
!
! PURPOSE:
!       Relational operator to test if one REAL operand is greater than another.
!
! CALLING SEQUENCE:
!       IF ( x .GreaterThan. y ) THEN
!         .....
!       END IF
!
! OPERANDS:
!       x, y:        Two congruent floating point data objects to compare.
!                    UNITS:      N/A
!                    TYPE:       REAL(Single)   [ == default real]
!                                  OR
!                                REAL(Double)
!                    DIMENSION:  Scalar, or any allowed rank array.
!
! OPERATOR RESULT:
!       (x .GreaterThan. y)    The result is a logical value indicating whether
!                              the operand x is greater than y by more than
!                              the spacing between representable floating point
!                              numbers.
!                              UNITS:      N/A
!                              TYPE:       LOGICAL
!                              DIMENSION:  Same as operands.
!
! PROCEDURE:
!       The test performed is
!
!         ( x - y ) >= SPACING( MAX(ABS(x),ABS(y)) )
!
!       If the result is .TRUE., x is considered greater than y.
!
!----------------------------------------------------------------------------------

  ELEMENTAL FUNCTION Is_Greater_Than_Single( x, y ) RESULT ( Greater_Than )
    REAL(Single), INTENT(IN) :: x, y
    LOGICAL :: Greater_Than
    IF ( (x-y) >= SPACING( MAX( ABS(x), ABS(y) ) ) ) THEN
      Greater_Than = .TRUE.
    ELSE
      Greater_Than = .FALSE.
    END IF
  END FUNCTION Is_Greater_Than_Single


  ELEMENTAL FUNCTION Is_Greater_Than_Double( x, y ) RESULT ( Greater_Than )
    REAL(Double), INTENT(IN) :: x, y
    LOGICAL :: Greater_Than
    IF ( (x-y) >= SPACING( MAX( ABS(x), ABS(y) ) ) ) THEN
      Greater_Than = .TRUE.
    ELSE
      Greater_Than = .FALSE.
    END IF
  END FUNCTION Is_Greater_Than_Double


!----------------------------------------------------------------------------------
! NAME:
!       .LessThan.
!
! PURPOSE:
!       Relational operator to test if one REAL operand is less than another.
!
! CALLING SEQUENCE:
!       IF ( x .LessThan. y ) THEN
!         .....
!       END IF
!
! OPERANDS:
!       x, y:        Two congruent floating point data objects to compare.
!                    UNITS:      N/A
!                    TYPE:       REAL(Single)   [ == default real]
!                                  OR
!                                REAL(Double)
!                    DIMENSION:  Scalar, or any allowed rank array.
!
! OPERATOR RESULT:
!       (x .LessThan. y)    The result is a logical value indicating whether
!                           the operand x is less than y by more than the
!                           spacing between representable floating point
!                           numbers.
!                           UNITS:      N/A
!                           TYPE:       LOGICAL
!                           DIMENSION:  Same as operands.
!
! PROCEDURE:
!       The test performed is
!
!         ( y - x ) >= SPACING( MAX(ABS(x),ABS(y)) )
!
!       If the result is .TRUE., x is considered less than y.
!
!----------------------------------------------------------------------------------

  ELEMENTAL FUNCTION Is_Less_Than_Single( x, y ) RESULT ( Less_Than )
    REAL(Single), INTENT(IN) :: x, y
    LOGICAL :: Less_Than
    IF ( (y-x) >= SPACING( MAX( ABS(x), ABS(y) ) ) ) THEN
      Less_Than = .TRUE.
    ELSE
      Less_Than = .FALSE.
    END IF
  END FUNCTION Is_Less_Than_Single


  ELEMENTAL FUNCTION Is_Less_Than_Double( x, y ) RESULT ( Less_Than )
    REAL(Double), INTENT(IN) :: x, y
    LOGICAL :: Less_Than
    IF ( (y-x) >= SPACING( MAX( ABS(x), ABS(y) ) ) ) THEN
      Less_Than = .TRUE.
    ELSE
      Less_Than = .FALSE.
    END IF
  END FUNCTION Is_Less_Than_Double


!----------------------------------------------------------------------------------
! NAME:
!       Compare_Float
!
! PURPOSE:
!       Function to compare floating point scalars and arrays with adjustible
!       precision tolerance.
!
! CALLING SEQUENCE:
!       Result = Compare_Float( x, y,            &  ! Input
!                               ULP    =ULP    , &  ! Optional input
!                               Percent=Percent  )  ! Optional input
!
! INPUT ARGUMENTS:
!       x, y:        Two congruent floating point data objects to compare.
!                    UNITS:      N/A
!                    TYPE:       REAL(Single)   [ == default real]
!                                  OR
!                                REAL(Double)
!                                  OR
!                                COMPLEX(Single)
!                                  OR
!                                COMPLEX(Double)
!                    DIMENSION:  Scalar, or any allowed rank array.
!                    ATTRIBUTES: INTENT(IN)
!
! OPTIONAL INPUT ARGUMENTS:
!       ULP:         Unit of data precision. The acronym stands for "unit in
!                    the last place," the smallest possible increment or decrement
!                    that can be made using a machine's floating point arithmetic.
!                    A 0.5 ulp maximum error is the best you could hope for, since
!                    this corresponds to always rounding to the nearest representable
!                    floating-point number. Value must be positive - if a negative
!                    value is supplied, the absolute value is used.
!                    If not specified, the default value is 1.
!                    This argument is ignored if the Percent optioanl argument is specifed.
!                    UNITS:      N/A
!                    TYPE:       INTEGER
!                    DIMENSION:  Scalar
!                    ATTRIBUTES: OPTIONAL, INTENT(IN)
!
!       Percent:     Specify a percentage difference value to use in comparing
!                    the numbers rather than testing within some numerical
!                    limit. The ULP argument is ignored if this argument is
!                    specified.
!                    UNITS:      N/A
!                    TYPE:       REAL(Single)  for REAL(Single) or COMPLEX(Single) x,y
!                                  OR
!                                REAL(Double)  for REAL(Double) or COMPLEX(Double) x,y
!                    DIMENSION:  Scalar
!                    ATTRIBUTES: OPTIONAL, INTENT(IN)
!
! FUNCTION RESULT:
!       Result:      The return value is a logical value indicating whether
!                    the inputs are equal (to within the required precision)
!                    .TRUE.  - if the floating point numbers are equal to
!                              within the specified tolerance. 
!                    .FALSE. - if the floating point numbers are different.
!                    UNITS:      N/A
!                    TYPE:       LOGICAL
!                    DIMENSION:  Scalar
!
! PROCEDURE:
!       ULP Test
!       --------
!       The test performed is
!
!         ABS( x - y ) < ( ULP * SPACING( MAX(ABS(x),ABS(y)) ) )
!
!       If the result is .TRUE., the numbers are considered equal.
!
!       The intrinsic function SPACING(x) returns the absolute spacing of numbers
!       near the value of x,
!
!                      {     EXPONENT(x)-DIGITS(x)
!                      {  2.0                        for x /= 0
!         SPACING(x) = {
!                      {  
!                      {  TINY(x)                    for x == 0
!
!       The ULP optional argument scales the comparison.
!
!       James Van Buskirk and James Giles suggested this method for floating
!       point comparisons in the comp.lang.fortran newsgroup.
!
!
!       Percent Test
!       ------------
!       The test performed is
!
!         100.0 * ABS((x-y)/x) < Percent
!
!       If the result is .TRUE., the numbers are considered equal.
!
!
!       For complex numbers, the same test is applied to both the real and
!       imaginary parts and each result is ANDed.
!
!----------------------------------------------------------------------------------

  ELEMENTAL FUNCTION Compare_Real_Single( x, y, ULP, Percent ) RESULT( Compare )
    ! Arguments
    REAL(Single),           INTENT(IN) :: x
    REAL(Single),           INTENT(IN) :: y
    INTEGER     , OPTIONAL, INTENT(IN) :: ULP
    REAL(Single), OPTIONAL, INTENT(IN) :: Percent
    ! Function result
    LOGICAL :: Compare
    ! Local variables
    LOGICAL      :: ULP_Test
    REAL(Single) :: Rel
    
    ! Set up
    ! ------
    ULP_Test = .TRUE.
    IF ( PRESENT(ULP) ) THEN
      Rel = REAL(ABS(ULP), Single)
    ELSE
      Rel = SP_ONE
    END IF
    IF ( PRESENT(Percent) ) THEN
      ULP_Test = .FALSE.
      ! Test for zero x (elementals can't be recursive)
      IF ( ABS(x) < ( SPACING( MAX(ABS(x),SP_ZERO) ) ) ) ULP_Test = .TRUE.
    END IF
    
    ! Compare the numbers
    ! -------------------
    IF ( ULP_Test ) THEN
      Compare = ABS(x-y) < ( Rel * SPACING( MAX(ABS(x),ABS(y)) ) )
    ELSE
      Compare = SP_HUNDRED*ABS((x-y)/x) < Percent
    END IF
  END FUNCTION Compare_Real_Single


  ELEMENTAL FUNCTION Compare_Real_Double( x, y, ULP, Percent ) RESULT( Compare )
    ! Arguments
    REAL(Double),           INTENT(IN) :: x
    REAL(Double),           INTENT(IN) :: y
    INTEGER     , OPTIONAL, INTENT(IN) :: ULP
    REAL(Double), OPTIONAL, INTENT(IN) :: Percent
    ! Function result
    LOGICAL :: Compare
    ! Local variables
    LOGICAL      :: ULP_Test
    REAL(Double) :: Rel
    
    ! Set up
    ! ------
    ULP_Test = .TRUE.
    IF ( PRESENT(ULP) ) THEN
      Rel = REAL(ABS(ULP), Double)
    ELSE
      Rel = DP_ONE
    END IF
    IF ( PRESENT(Percent) ) THEN
      ULP_Test = .FALSE.
      ! Test for zero x (elementals can't be recursive)
      IF ( ABS(x) < ( SPACING( MAX(ABS(x),DP_ZERO) ) ) ) ULP_Test = .TRUE.
    END IF
    
    ! Compare the numbers
    ! -------------------
    IF ( ULP_Test ) THEN
      Compare = ABS(x-y) < ( Rel * SPACING( MAX(ABS(x),ABS(y)) ) )
    ELSE
      Compare = DP_HUNDRED*ABS((x-y)/x) < Percent
    END IF
  END FUNCTION Compare_Real_Double


  ELEMENTAL FUNCTION Compare_Complex_Single( x, y, ULP, Percent ) RESULT( Compare )
    ! Arguments
    COMPLEX(Single),           INTENT(IN) :: x
    COMPLEX(Single),           INTENT(IN) :: y
    INTEGER        , OPTIONAL, INTENT(IN) :: ULP
    REAL(Single)   , OPTIONAL, INTENT(IN) :: Percent
    ! Function result
    LOGICAL :: Compare
    ! Local variables
    REAL(Single) :: xr, xi
    REAL(Single) :: yr, yi
    
    ! Separate real and complex parts
    ! -------------------------------
    xr=REAL(x,Single); xi=AIMAG(x)
    yr=REAL(y,Single); yi=AIMAG(y)
    
    ! Compare each part separately
    ! ----------------------------
    Compare = Compare_Real_Single(xr,yr,ULP=ULP,Percent=Percent) .AND. &
              Compare_Real_Single(xi,yi,ULP=ULP,Percent=Percent)
  END FUNCTION Compare_Complex_Single


  ELEMENTAL FUNCTION Compare_Complex_Double( x, y, ULP, Percent ) RESULT( Compare )
    ! Arguments
    COMPLEX(Double),           INTENT(IN) :: x
    COMPLEX(Double),           INTENT(IN) :: y
    INTEGER        , OPTIONAL, INTENT(IN) :: ULP
    REAL(Double)   , OPTIONAL, INTENT(IN) :: Percent
    ! Function result
    LOGICAL :: Compare
    ! Local variables
    REAL(Double) :: xr, xi
    REAL(Double) :: yr, yi
    
    ! Separate real and complex parts
    ! -------------------------------
    xr=REAL(x,Double); xi=AIMAG(x)
    yr=REAL(y,Double); yi=AIMAG(y)
    
    ! Compare each part separately
    ! ----------------------------
    Compare = Compare_Real_Double(xr,yr,ULP=ULP,Percent=Percent) .AND. &
              Compare_Real_Double(xi,yi,ULP=ULP,Percent=Percent)
  END FUNCTION Compare_Complex_Double

END MODULE Compare_Float_Numbers
