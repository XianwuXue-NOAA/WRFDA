# CONVERTOR

CONVERTOR_OBJS	=	module_kma2netcdf_interface.o \
		module_netcdf2kma_interface.o

CONVERTOR_MODULES =	module_kma_wave2grid.o \
		module_wave2grid_kma.o \
                da_wrfvar_io.o \
                da_tracing.o \
                da_memory.o \
                da_par_util1.o

module_kma_wave2grid.o: \
		kma_wave2grid/BSSLZ1.inc \
		kma_wave2grid/CUT.inc \
		kma_wave2grid/FFT991.inc \
		kma_wave2grid/G2W.inc \
		kma_wave2grid/G2WDZ.inc \
		kma_wave2grid/G2WPP.inc \
		kma_wave2grid/GAUSS.inc \
		kma_wave2grid/GOUT.inc \
		kma_wave2grid/IDCMP.inc \
		kma_wave2grid/LGNDR1.inc \
		kma_wave2grid/LGNUV.inc \
		kma_wave2grid/LGNW2G.inc \
		kma_wave2grid/LT2GAU.inc \
		kma_wave2grid/MNMX.inc \
		kma_wave2grid/RADB2M.inc \
		kma_wave2grid/RADB3M.inc \
		kma_wave2grid/RADB4M.inc \
		kma_wave2grid/RADB5M.inc \
		kma_wave2grid/RADBGM.inc \
		kma_wave2grid/RADF2M.inc \
		kma_wave2grid/RADF3M.inc \
		kma_wave2grid/RADF4M.inc \
		kma_wave2grid/RADF5M.inc \
		kma_wave2grid/RADFGM.inc \
		kma_wave2grid/REOWAV.inc \
		kma_wave2grid/REOWV.inc \
		kma_wave2grid/RESET.inc \
		kma_wave2grid/RFFTBM.inc \
		kma_wave2grid/RFFTFM.inc \
		kma_wave2grid/RFFTIM.inc \
		kma_wave2grid/RFTB1M.inc \
		kma_wave2grid/RFTB2M.inc \
		kma_wave2grid/RFTB9M.inc \
		kma_wave2grid/RFTF1M.inc \
		kma_wave2grid/RFTF2M.inc \
		kma_wave2grid/RFTF3M.inc \
		kma_wave2grid/RFTF9M.inc \
		kma_wave2grid/RFTI1M.inc \
		kma_wave2grid/SETARY.inc \
		kma_wave2grid/W2G.inc \
		kma_wave2grid/W2GCONV.inc \
		kma_wave2grid/W2GPXY.inc \
		kma_wave2grid/W2GUV.inc \
		kma_wave2grid/WAVMAG.inc \
		kma_wave2grid/WEIHT2.inc \
		kma_wave2grid/ZNME2PXX.inc \
		kma_wave2grid/module_kma_wave2grid.f90
		$(CPP) -I./kma_wave2grid $(CPPFLAGS) kma_wave2grid/module_kma_wave2grid.f90 > module_kma_wave2grid.f
		$(FC) -c -I./kma_wave2grid $(FIXEDFLAGS) module_kma_wave2grid.f

module_wave2grid_kma.o: \
		wave2grid_kma/BSSLZ1.inc \
		wave2grid_kma/CR8I2V.inc \
		wave2grid_kma/CVDATE.inc \
		wave2grid_kma/GAUSS.inc \
		wave2grid_kma/GH2TV.inc \
		wave2grid_kma/LT2GAU.inc \
		wave2grid_kma/GPLHGT.inc \
		wave2grid_kma/MINMAX.inc \
		wave2grid_kma/MONTWO.inc \
		wave2grid_kma/OUTZ.inc \
		wave2grid_kma/PRESUB.inc \
		wave2grid_kma/REDANL.inc \
		wave2grid_kma/REDDAT.inc \
		wave2grid_kma/REDDAT_ASCII.inc \
		wave2grid_kma/REDDAT_BIN.inc \
		wave2grid_kma/REDGES.inc \
		wave2grid_kma/REDHED.inc \
		wave2grid_kma/RESET.inc \
		wave2grid_kma/SPLDIF3_H.inc \
		wave2grid_kma/TETEN.inc \
		wave2grid_kma/PACK.inc \
		wave2grid_kma/VPRM.inc \
		wave2grid_kma/WRTDAT.inc \
		wave2grid_kma/WRTEOF.inc \
		wave2grid_kma/WRTHED.inc \
		wave2grid_kma/ZE2TVE.inc \
		wave2grid_kma/ZMNLAT.inc \
		wave2grid_kma/ZMNT.inc \
		wave2grid_kma/PREGSM.inc \
		wave2grid_kma/PREGSM1.inc \
		wave2grid_kma/Einc_to_Ganl.inc \
		wave2grid_kma/RELHUM.inc       \
		wave2grid_kma/module_wave2grid_kma.f90
		$(CPP) -I./wave2grid_kma $(CPPFLAGS) wave2grid_kma/module_wave2grid_kma.f90 > module_wave2grid_kma.f
		$(FC) -c -I./wave2grid_kma $(FIXEDFLAGS) module_wave2grid_kma.f

# DEPENDENCIES : only dependencies after this line (don't remove the word DEPENDENCIES)

