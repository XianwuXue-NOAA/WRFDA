#!/bin/ksh
#########################################################################
# Script: da_run_nup.ksh
#
# Purpose: Run WRF's nup utility.
#########################################################################

#########################################################################
# Ideally, you should not need to change the code below, but if you 
# think it necessary then please email wrfhelp@ucar.edu with details.
#########################################################################

export DATE=${DATE:-2003010100}
export FCST_RANGE=${FCST_RANGE:-6}
export LBC_FREQ=${LBC_FREQ:-06}
export DUMMY=${DUMMY:-false}
export REGION=${REGION:-con200}
export DOMAIN=${DOMAIN:-01}
export EXPT=${EXPT:-test}
export SOLVER=${SOLVER:-em}
export NUM_PROCS=${NUM_PROCS:-1}
export HOSTS=${HOSTS:-$HOME/hosts}
if [[ -f $HOSTS ]]; then
   export RUN_CMD=${RUN_CMD:-mpirun -machinefile $HOSTS -np $NUM_PROCS}
else
   export RUN_CMD=${RUN_CMD:-mpirun -np $NUM_PROCS}
fi
export CLEAN=${CLEAN:-false}

# Directories:
export REL_DIR=${REL_DIR:-$HOME/trunk}
export WRFVAR_DIR=${WRFVAR_DIR:-$REL_DIR/wrfvar}
export DAT_DIR=${DAT_DIR:-$HOME/data}
export REG_DIR=${REG_DIR:-$DAT_DIR/$REGION}
export EXP_DIR=${EXP_DIR:-$REG_DIR/$EXPT}
export NUP_INPUT1_DIR=${NUP_INPUT1_DIR:-$RC_DIR}
export NUP_INPUT2_DIR=${NUP_INPUT2_DIR:-$RC_DIR}
export NUP_OUTPUT_DIR=${NUP_OUTPUT_DIR:-$RC_DIR}
export WRF_DIR=${WRF_DIR:-$REL_DIR/wrf}
export RUN_DIR=${RUN_DIR:-$EXP_DIR/run/$DATE/nup}
export WORK_DIR=$RUN_DIR/working

if [[ ! -d $NUP_OUTPUT_DIR/$DATE ]]; then mkdir -p $NUP_OUTPUT_DIR/$DATE; fi

rm -rf $WORK_DIR
mkdir -p $RUN_DIR $WORK_DIR
cd $WORK_DIR

#Get extra namelist variables:
. ${WRFVAR_DIR}/scripts/da_get_date_range.ksh

echo "<HTML><HEAD><TITLE>$EXPT nup</TITLE></HEAD><BODY>"
echo "<H1>$EXPT nup</H1><PRE>"

date    

echo 'REL_DIR          <A HREF="file:'$REL_DIR'">'$REL_DIR'</a>'
echo 'WRF_DIR          <A HREF="file:'$WRF_DIR'">'$WRF_DIR'</a>' $WRF_VN
echo 'RUN_DIR          <A HREF="file:'$RUN_DIR'">'$RUN_DIR'</a>'
echo 'WORK_DIR         <A HREF="file:'$WORK_DIR'">'$WORK_DIR'</a>'
echo 'NUP_INPUT1_DIR <A HREF="file:'$NUP_INPUT1_DIR'">'$NUP_INPUT1_DIR'</a>'
echo 'NUP_INPUT2_DIR <A HREF="file:'$NUP_INPUT2_DIR'">'$NUP_INPUT2_DIR'</a>'
echo 'NUP_OUTPUT_DIR <A HREF="file:'$NUP_OUTPUT_DIR'">'$NUP_OUTPUT_DIR'</a>'
echo "DATE             $DATE"
echo "END_DATE         $END_DATE"
echo "FCST_RANGE       $FCST_RANGE"

cp namelist.input $RUN_DIR

echo '<A HREF="namelist.input">Namelist input</a>'

if $DUMMY; then
   echo "Dummy nup"
   echo Dummy nup > wrfinput_d${DOMAIN}
   echo Dummy nup > wrfbdy_d${DOMAIN}
else
   ln -fs ${WRF_DIR}/main/nup.exe .
   $RUN_CMD ./nup.exe
   RC=$?

   if [[ -f namelist.output ]]; then
     cp namelist.output $RUN_DIR/namelist.output
   fi

   rm -rf $RUN_DIR/rsl
   mkdir -p $RUN_DIR/rsl
   mv rsl* $RUN_DIR/rsl
   cd $RUN_DIR/rsl
   for FILE in rsl*; do
      echo "<HTML><HEAD><TITLE>$FILE</TITLE></HEAD>" > $FILE.html
      echo "<H1>$FILE</H1><PRE>" >> $FILE.html
      cat $FILE >> $FILE.html
      echo "</PRE></BODY></HTML>" >> $FILE.html
      rm $FILE
   done
   cd $RUN_DIR

   echo '<A HREF="namelist.output">Namelist output</a>'
   echo '<A HREF="rsl/rsl.out.0000.html">rsl.out.0000</a>'
   echo '<A HREF="rsl/rsl.error.0000.html">rsl.error.0000</a>'
   echo '<A HREF="rsl">Other RSL output</a>'

   echo $(date +'%D %T') "Ended $RC"
fi

if [[ -f $WORK_DIR/wrfinput_d${DOMAIN} ]]; then
   mv $WORK_DIR/wrfinput_d${DOMAIN} $NUP_OUTPUT_DIR/$DATE
fi

if [[ -f $WORK_DIR/wrfbdy_d${DOMAIN} ]]; then
   mv $WORK_DIR/wrfbdy_d${DOMAIN} $NUP_OUTPUT_DIR/$DATE
fi

if $CLEAN; then
   rm -rf $WORK_DIR
fi

date

echo "</BODY></HTML>"

exit 0
