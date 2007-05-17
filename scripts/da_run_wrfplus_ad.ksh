#!/bin/ksh

# Called from da_transform_vtoy_adj inside WRFVAR. The script is only 
# temporary until we can couple the models through memory rather than files
#
# VAR provides files af00 to af06
#
# WRF produces gradient file wrfvar_input_d${DOMAIN}_2000-01-25_00:00:00 which
# is renamed gr00 for VAR

# Preserve wrfvar namelist.input

arg1=$1

cd $WORK_DIR/ad

if test $NUM_PROCS = 1; then
   ./wrfplus.exe > wrf_ad.out 2>wrf_ad.error
else
   if test $arg1 = pre; then
      cp namelist.input ..
   fi
   if test $arg1 = post; then
      mv ../namelist.output .
   fi
fi

