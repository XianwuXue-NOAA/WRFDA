module da_vtox_transforms

   !---------------------------------------------------------------------------
   ! Purpose: Contains routines used to transform control variable V to model
   !          variables X.
   !---------------------------------------------------------------------------
  
   use module_dm, only : wrf_dm_sum_real,wrf_dm_sum_reals
#ifdef RSL_LITE
   use module_dm, only : local_communicator, mytask, ntasks, ntasks_x, & 
      ntasks_y, data_order_xy, data_order_xyz
   use da_control, only : ips,ipe,jps,jpe,kps,kpe
#endif
#ifdef RSL
   use module_dm, only : invalid_message_value, glen, setup_halo_rsl, &
      stencil_24pt,reset_msgs_24pt,add_msg_24pt_real
#endif
   use module_domain, only : ep_type, vp_type, x_type, domain

   use da_control, only : trace_use, ims,ime,jms,jme,kms,kme,jds,jde,kds,kde, &
      its,ite,jts,jte,kts,kte, cos_xls, cos_xle, sin_xle, sin_xls, pi, global, &
      vertical_ip,alphacv_method,use_radarobs,use_radar_rf,use_ssmitbobs, &
      use_ssmiretrievalobs, use_ssmt2obs, use_ssmt1obs, use_gpspwobs, &
      use_gpsrefobs,sfc_assi_options, test_wrfvar, vert_corr, fg_format, &
      fg_format_kma_global, fg_format_wrf, ids,ide, stdout, vert_corr_2, &
      alphacv_method_vp, alphacv_method_xa, vertical_ip_0, trace_use_dull
   use da_define_structures, only : be_type, xbx_type,da_zero_vp_type,da_zero_x
   use da_dynamics, only : da_psichi_to_uv,da_psichi_to_uv_adj
   use da_physics, only : da_uvprho_to_w_lin,da_uvprho_to_w_adj, &
      da_pt_to_rho_adj, da_pt_to_rho_lin,da_moist_phys_lin, &
      da_moist_phys_adj, da_transform_xtogpsref_lin, da_transform_xtotpw, &
      da_transform_xtowtq, da_transform_xtotpw_adj, &
      da_transform_xtogpsref_adj, da_transform_xtowtq_adj
   use da_par_util, only : da_vv_to_cv,da_cv_to_vv
   use da_recursive_filter, only : da_transform_through_rf, &
      da_transform_through_rf_adj
   use da_reporting, only : da_error
   use da_spectral, only : da_vtovv_spectral,da_vtovv_spectral_adj
   use da_ssmi, only : da_transform_xtoseasfcwind_lin,da_transform_xtotb_adj, &
      da_transform_xtoseasfcwind_adj, da_transform_xtotb_lin
   use da_tools, only : da_set_boundary_xa
   use da_tracing, only : da_trace_entry, da_trace_exit
   use da_wrf_interfaces, only : wrf_debug

   implicit none


   contains

#include "da_add_flow_dependence_vp.inc"
#include "da_add_flow_dependence_vp_adj.inc"
#include "da_add_flow_dependence_xa.inc"
#include "da_add_flow_dependence_xa_adj.inc"
#include "da_check_eof_decomposition.inc"
#include "da_transform_vtovv.inc"
#include "da_transform_vtovv_adj.inc"
#include "da_transform_vtox.inc"
#include "da_transform_vtox_adj.inc"
#include "da_transform_vptox.inc"
#include "da_transform_vptox_adj.inc"
#include "da_transform_vvtovp.inc"
#include "da_transform_vvtovp_adj.inc"
#include "da_transform_vptovv.inc"
#include "da_vertical_transform.inc"
#include "da_get_vpoles.inc"
#include "da_get_spoles.inc"
#include "da_get_avpoles.inc"
#include "da_get_aspoles.inc"
#include "da_transform_vtovv_global.inc"
#include "da_transform_vtovv_global_adj.inc"

end module da_vtox_transforms
