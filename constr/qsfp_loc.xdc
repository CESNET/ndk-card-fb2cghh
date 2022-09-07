# qsfp_loc.xdc
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# LOC locations for CMAC interfaces

set_property LOC CMACE4_X0Y1 [get_cells -hierarchical -filter {NAME =~ *eth_core_g[0].network_mod_core_i/cmac_eth_1x100g_i/* && REF_NAME==CMACE4}]
set_property LOC GTYE4_CHANNEL_X0Y12 [get_cells {usp_i/network_mod_i/eth_core_g[0].network_mod_core_i/cmac_eth_1x100g_i/inst/cmac_eth_1x100g_gt_i/inst/gen_gtwizard_gtye4_top.cmac_eth_1x100g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y13 [get_cells {usp_i/network_mod_i/eth_core_g[0].network_mod_core_i/cmac_eth_1x100g_i/inst/cmac_eth_1x100g_gt_i/inst/gen_gtwizard_gtye4_top.cmac_eth_1x100g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y14 [get_cells {usp_i/network_mod_i/eth_core_g[0].network_mod_core_i/cmac_eth_1x100g_i/inst/cmac_eth_1x100g_gt_i/inst/gen_gtwizard_gtye4_top.cmac_eth_1x100g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y15 [get_cells {usp_i/network_mod_i/eth_core_g[0].network_mod_core_i/cmac_eth_1x100g_i/inst/cmac_eth_1x100g_gt_i/inst/gen_gtwizard_gtye4_top.cmac_eth_1x100g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST}]

set_property LOC CMACE4_X0Y2 [get_cells -hierarchical -filter {NAME =~ *eth_core_g[1].network_mod_core_i/cmac_eth_1x100g_i/* && REF_NAME==CMACE4}]
set_property LOC GTYE4_CHANNEL_X0Y20 [get_cells {usp_i/network_mod_i/eth_core_g[1].network_mod_core_i/cmac_eth_1x100g_i/inst/cmac_eth_1x100g_gt_i/inst/gen_gtwizard_gtye4_top.cmac_eth_1x100g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y21 [get_cells {usp_i/network_mod_i/eth_core_g[1].network_mod_core_i/cmac_eth_1x100g_i/inst/cmac_eth_1x100g_gt_i/inst/gen_gtwizard_gtye4_top.cmac_eth_1x100g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y22 [get_cells {usp_i/network_mod_i/eth_core_g[1].network_mod_core_i/cmac_eth_1x100g_i/inst/cmac_eth_1x100g_gt_i/inst/gen_gtwizard_gtye4_top.cmac_eth_1x100g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y23 [get_cells {usp_i/network_mod_i/eth_core_g[1].network_mod_core_i/cmac_eth_1x100g_i/inst/cmac_eth_1x100g_gt_i/inst/gen_gtwizard_gtye4_top.cmac_eth_1x100g_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST}]
