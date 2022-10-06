# Modules.tcl: script to compile card
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): David Beneš <xbenes52@vutbr.cz>
#            Vladislav Valek <xvalek14@vutbr.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# Globally defined variables
global CARD_COMMON_BASE
global BOARD
set BOARD "FB2CGHH"

# Paths
set LED_SERIAL_CTRL_BASE            "$ENTITY_BASE/comp/led_ctrl"
set BMC_BASE                        "$ENTITY_BASE/comp/bmc_driver"
set AXI_QUAD_FLASH_CONTROLLER_BASE  "$ENTITY_BASE/comp/axi_quad_flash_controller"
set BOOT_CTRL_BASE                  "$OFM_PATH/../core/intel/src/comp/boot_ctrl"

# Components
lappend COMPONENTS [list "FPGA_COMMON"                  $CARD_COMMON_BASE                $BOARD]
lappend COMPONENTS [list "LED_SERIAL_CTRL"              $LED_SERIAL_CTRL_BASE            "FULL"]
lappend COMPONENTS [list "BMC"                          $BMC_BASE                        "FULL"]
lappend COMPONENTS [list "AXI_QUAD_FLASH_CONTROLLER"    $AXI_QUAD_FLASH_CONTROLLER_BASE  "FULL"]
lappend COMPONENTS [list "BOOT_CTRL"                    $BOOT_CTRL_BASE                  "FULL"]

# IP sources
lappend MOD "$ENTITY_BASE/ip/pcie4_uscale_plus/pcie4_uscale_plus.xci"
lappend MOD "$ENTITY_BASE/ip/xvc_vsec/xvc_vsec.xci"
lappend MOD "$ENTITY_BASE/ip/cmac_eth_1x100g/cmac_eth_1x100g.xci"
lappend MOD "$ENTITY_BASE/ip/axi_quad_spi_0/axi_quad_spi_0.xci"

#Simulation
#lappend MOD "$ENTITY_BASE/ip/axi_quad_spi_0/axi_quad_spi_0_sim_netlist.vhdl"

# Top-level
lappend MOD "$ENTITY_BASE/fpga.vhd"
