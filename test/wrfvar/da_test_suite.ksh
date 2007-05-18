# Define for your run

. ./region.ksh

export ID=${ID:-${MACHINE}_${FC}_${TYPE}}

export EXPT=${EXPT:-${ID}_suite_${NUM_PROCS}}

export REL_DIR=$HOME/code/$ID

export WRFVAR_DIR=${WRFVAR_DIR:-$REL_DIR/wrfvar}
export WRF_DIR=${WRF_DIR:-$REL_DIR/wrf}
export WPS_DIR=${WPS_DIR:-$REL_DIR/wps}
export OBSPROC_DIR=${OBSPROC_DIR:-$REL_DIR/3DVAR_OBSPROC}

export CLEAN=${CLEAN:-false}

export RUN_RESTORE_DATA_GRIB=${RUN_RESTORE_DATA_GRIB:-true}
export RUN_RESTORE_DATA_RTOBS=${RUN_RESTORE_DATA_RTOBS:-true}
export RUN_WPS=${RUN_WPS:-true}
export RUN_REAL=${RUN_REAL:-true}
export RUN_OBSPROC=${RUN_OBSPROC:-true}
export RUN_WRFVAR=${RUN_WRFVAR:-true}
export RUN_UPDATE_BC=${RUN_UPDATE_BC:-true}
export RUN_WRF=${RUN_WRF:-true}

export CYCLING=${CYCLING:-true}
export DUMMY=${DUMMY:-false}

export LONG_FCST_TIME_1=00
export LONG_FCST_RANGE_1=24
export NL_NTMAX=${NL_NTMAX:-2}
export MSS_RT_DIR=${MSS_RT_DIR:-mss:/BRESCH/RT/DATA}

export REG_DIR=$PWD
export EXP_DIR=$PWD/$EXPT
export OB_DIR=${OB_DIR:-$EXP_DIR/ob}
export RC_DIR=${RC_DIR:-$EXP_DIR/rc}
export FC_DIR=${FC_DIR:-$EXP_DIR/fc}

export RUN_DIR=$EXP_DIR
rm -rf $RUN_DIR

. $WRFVAR_DIR/setup.ksh $FC > /dev/null

export SCRIPT=$WRFVAR_DIR/scripts/da_run_suite.ksh
$WRFVAR_DIR/scripts/da_run_job.ksh

exit 0
