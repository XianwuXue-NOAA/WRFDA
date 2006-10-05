#

GEN_BE_OBJS = da_gen_be.o da_constants.o da_be_spectral.o module_wrf_error.o \
  module_driver_constants.o da_tracing.o da_memory.o da_reporting.o

be :		setup                   \
                $(GEN_BE_LIBS)          \
                $(GEN_BE_OBJS)          \
                gen_be_stage0_wrf	\
                gen_be_ep2	\
		gen_be_stage1	        \
		gen_be_stage1_1dvar	\
		gen_be_stage2	        \
		gen_be_stage2_1dvar	\
		gen_be_stage2a	        \
		gen_be_stage3	        \
		gen_be_stage4_global	\
		gen_be_stage4_regional	\
		gen_be_cov2d		\
		gen_be_cov3d		\
		gen_be_diags		\
		gen_be_diags_read       \
		gen_be_read_regcoeffs    \
                advance_cymdh.exe
	cp *.exe ../main

gen_be_stage0_wrf.o      : gen_be_stage0_wrf.f90

gen_be_ep2.o   : gen_be_ep2.f90

gen_be_stage1_wrf.o      : gen_be_stage1_wrf.f90

gen_be_stage1_1dvar.o    : gen_be_stage1_1dvar.f90

gen_be_stage2.o          : gen_be_stage2.f90

gen_be_stage2_1dvar.o    : gen_be_stage2_1dvar.f90

gen_be_stage2a.o         : gen_be_stage2a.f90

gen_be_stage3.o          : gen_be_stage3.f90

gen_be_stage4_global.o   : gen_be_stage4_global.f90

gen_be_stage4_regional.o : gen_be_stage4_regional.f90

gen_be_cov2d.o           : gen_be_cov2d.f90

gen_be_cov3d.o           : gen_be_cov3d.f90

gen_be_diags.o           : gen_be_diags.f90

gen_be_diags_read.o      : gen_be_diags_read.f90

gen_be_read_regcoeffs.o  : gen_be_read_regcoeffs.f90

gen_be_stage0_wrf : gen_be_stage0_wrf.o
	$(LD) -o gen_be_stage0_wrf.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage0_wrf.o $(GEN_BE_LIB)

gen_be_ep2     : gen_be_ep2.o
	$(LD) -o gen_be_ep2.exe $(LDFLAGS) $(GEN_BE_OBJS)  gen_be_ep2.o $(GEN_BE_LIB)

gen_be_stage1 : gen_be_stage1.o
	$(LD) -o gen_be_stage1.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage1.o $(GEN_BE_LIB)

gen_be_stage1_1dvar : gen_be_stage1_1dvar.o
	$(LD) -o gen_be_stage1_1dvar.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage1_1dvar.o $(GEN_BE_LIB)

gen_be_stage2 : gen_be_stage2.o
	$(LD) -o gen_be_stage2.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage2.o $(GEN_BE_LIB)

gen_be_stage2_1dvar : gen_be_stage2_1dvar.o
	$(LD) -o gen_be_stage2_1dvar.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage2_1dvar.o $(GEN_BE_LIB)

gen_be_stage2a : gen_be_stage2a.o
	$(LD) -o gen_be_stage2a.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage2a.o $(GEN_BE_LIB) 

gen_be_stage3 : gen_be_stage3.o
	$(LD) -o gen_be_stage3.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage3.o  $(GEN_BE_LIB)

gen_be_stage4_global : gen_be_stage4_global.o
	$(LD) -o gen_be_stage4_global.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage4_global.o  $(GEN_BE_LIB)

gen_be_stage4_regional : gen_be_stage4_regional.o
	$(LD) -o gen_be_stage4_regional.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_stage4_regional.o $(GEN_BE_LIB)

gen_be_cov2d : gen_be_cov2d.o
	$(LD) -o gen_be_cov2d.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_cov2d.o $(GEN_BE_LIB)

gen_be_cov3d : gen_be_cov3d.o
	$(LD) -o gen_be_cov3d.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_cov3d.o $(GEN_BE_LIB)

gen_be_diags : gen_be_diags.o
	$(LD) -o gen_be_diags.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_diags.o $(GEN_BE_LIB)

gen_be_diags_read : gen_be_diags_read.o
	$(LD) -o gen_be_diags_read.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_diags_read.o $(GEN_BE_LIB)

gen_be_read_regcoeffs : gen_be_read_regcoeffs.o
	$(LD) -o gen_be_read_regcoeffs.exe $(LDFLAGS) $(GEN_BE_OBJS) gen_be_read_regcoeffs.o $(GEN_BE_LIB)

# DEPENDENCIES : only dependencies after this line (don't remove the word DEPENDENCIES)
