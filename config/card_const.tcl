# ndk_const.tcl: Card specific constants
# Copyright (C) 2022 CESNET, z. s. p. o.
# Author(s): David Beneš 	 <xbenes52@vutbr.cz>
#            Vladislav Valek <valekv@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# ==============================================================================
# WARNING: The user should not deliberately change constants in this file. They
# are either set to default values or set from the environment variables.
# ==============================================================================

set OUTPUT_NAME   $env(OUTPUT_NAME)
set OFM_PATH      $env(OFM_PATH)
set COMBO_BASE    $env(COMBO_BASE)
set FIRMWARE_BASE $env(FIRMWARE_BASE)
set CARD_BASE     $env(CARD_BASE)
set CORE_BASE     $env(CORE_BASE)

set CORE_CONF  $CORE_BASE/config/core_conf.tcl
set CORE_CONST $CORE_BASE/config/core_const.tcl

set CARD_CONF  $env(CARD_CONF)
set CARD_CONST $env(CARD_CONST)

set APP_CONF $env(APP_CONF)

source $OFM_PATH/build/VhdlPkgGen.tcl
source $OFM_PATH/build/Shared.tcl

set CARD_NAME "FB2CGHH"
# Achitecture of Clock generator
set CLOCK_GEN_ARCH "USP"
# Achitecture of PCIe module
set PCIE_MOD_ARCH "USP"
# Achitecture of Network module
set NET_MOD_ARCH "CMAC"
# Achitecture of SDM/SYSMON module
set SDM_SYSMON_ARCH "USP_IDCOMP"

VhdlPkgBegin

# Source core configuration variables
source $CORE_CONF

# Source configuration variables specific for a current card type
source $CARD_CONF

# Source application user configurable parameters
if {$APP_CONF ne ""} {
	source $APP_CONF
}

# ==============================================================================
# Design configuration constants
# ==============================================================================

# ------------------------------------------------------------------------------
# ETH parameters:
# ------------------------------------------------------------------------------
# Number of Ethernet ports, must match number of items in list ETH_PORTS_SPEED!
# (with two QSFP). Set the correct number of ETH ports according to your card.
set ETH_PORTS         $env(ETH_PORTS)
# Speed for each one of the ETH_PORTS (allowed values: 100)
# ETH_PORT_SPEED is an array where each index represents given ETH_PORT and
# each index has associated a required port speed.
# NOTE: at this moment, all ports must have same speed !
set ETH_PORT_SPEED(0) $env(ETH_PORT_SPEED)
set ETH_PORT_SPEED(1) $env(ETH_PORT_SPEED)

# Number of channels for each one of the ETH_PORTS (allowed values: 1 for ETH_PORT_SPEED=100, 4 for ETH_PORT_SPEED<100)
# ETH_PORT_CHAN is an array where each index represents given ETH_PORT and
# each index has associated a required number of channels this port has.
# NOTE: at this moment, all ports must have same number of channels !
set ETH_PORT_CHAN(0) $env(ETH_PORT_CHAN)
set ETH_PORT_CHAN(1) $env(ETH_PORT_CHAN)

# Number of lanes for each one of the ETH_PORTS
# Typical values: 4 (QSFP), 8 (QSFP-DD)
set ETH_PORT_LANES(0) 4
set ETH_PORT_LANES(1) 4


# ------------------------------------------------------------------------------
# PCIe parameters (not all combinations work):
# ------------------------------------------------------------------------------
# Supported combinations for this card:
# 1x PCIe Gen3 x16 -- PCIE_ENDPOINTS=1, PCIE_ENDPOINT_MODE=0 (Note: default configuration)
# ------------------------------------------------------------------------------
# PCIe Generation (possible values: 3):
# 3 = PCIe Gen3
set PCIE_GEN           3
# PCIe endpoints (possible values: 1):
# 1 = 1x PCIe x16 in one slot or 1x PCIe x8 in one slot
set PCIE_ENDPOINTS     1
# PCIe endpoint mode (possible values: 0):
# 0 = 1x16 lanes
set PCIE_ENDPOINT_MODE 0


# ------------------------------------------------------------------------------
# DMA parameters:
# ------------------------------------------------------------------------------
# This variable can be changed in common Makefile
set DMA_TYPE    $env(DMA_TYPE)

set TSU_FREQUENCY 322265625

set MEM_PORTS 0

# Generating of the VHDL package
source $CORE_CONST
