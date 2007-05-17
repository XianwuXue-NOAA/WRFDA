#!/bin/ksh

# Called from da_solve inside WRFVAR. The script is only temporary until we
# can couple the models through memory rather than files
#
# When called the first time, wrfvar_output does not exist, so use the
# existing wrfvar_input as the initial file
#
# The T+0 input to VAR is wrfinput_d${DOMAIN} described above.
#
# The other input files for VAR are the T+1,T+2,T+3 dumps

arg1=$1

cd $WORK_DIR/nl

export G95_UNIT_ENDIAN_98=BIG

if test $NUM_PROCS = 1; then
   ./wrf.exe > wrf_nl.out 2>wrf_nl.error
else
   if test $arg1 = pre; then
      mv ../namelist.output ../namelist_wrfvar.output
      cp namelist.input ..
   fi
   if test $arg1 = post; then
      mv ../namelist.output .
   fi
fi

exit 0


