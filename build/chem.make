# CHEM


CHEM_OBJS = \
	module_chem_utilities.o \
	module_data_radm2.o \
	module_data_racm.o \
	module_data_sorgam.o \
	module_radm.o \
	module_racm.o \
	module_phot_mad.o \
	module_dep_simple.o \
	module_bioemi_simple.o \
	module_bioemi_beis311.o \
	module_vertmx_wrf.o \
	module_aerosols_sorgam.o \
	module_input_chem_data.o \
	module_input_chem_bioemiss.o \
	module_ctrans_grell.o \
	module_emissions_anthropogenics.o \
	module_data_mgn2mech.o \
	module_bioemi_megan2.o \
	module_data_megan2.o \
	convert_bioemiss_megan2.o \
	chemics_init.o \
	chem_driver.o \
	photolysis_driver.o \
	mechanism_driver.o \
	emissions_driver.o \
	dry_dep_driver.o \
	aerosol_driver.o

module_data_radm2.o: 

module_data_racm.o: 

module_chem.utilities.o: 

module_radm.o: 

module_racm.o: 

module_phot_mad.o: 

module_input_chem_data.o: module_aerosols_sorgam.o

module_input_chem_bioemiss.o: 

module_dep_simple.o: 

module_bioemi_simple.o: 

module_vertmx_wrf.o: 

module_emissions_anthropogenics.o: 

module_data_sorgam.o: 

module_aerosols_sorgam.o: 

module_ctrans_grell.o:

chem_driver.o: module_radm.o module_racm.o module_data_racm.o module_chem_utilities.o module_data_radm2.o module_dep_simple.o module_bioemi_simple.o module_vertmx_wrf.o module_phot_mad.o module_aerosols_sorgam.o

chemics_init.o: module_phot_mad.o module_aerosols_sorgam.o

aerosol_driver.o: module_aerosols_sorgam.o

photolysis_driver.o: module_phot_mad.o

mechanism_driver.o: module_data_radm2.o module_radm.o module_data_racm.o module_aerosols_sorgam.o

emissions.o: module_data_radm2.o module_radm.o module_bioemi_simple.o module_bioemi_beis311.o module_emissions_anthropogenics.o

dry_dep_driver.o: module_data_radm2.o module_dep_simple.o module_aerosols_sorgam.o

