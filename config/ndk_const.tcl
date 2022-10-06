# ndk_const.tcl: Card specific constants
# Copyright (C) 2022 CESNET, z. s. p. o.
# Author(s): David Beneš 	 <xbenes52@vutbr.cz>
#            Vladislav Valek <valekv@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause


set OFM_PATH        $env(OFM_PATH)
set COMBO_BASE      $env(COMBO_BASE)
set FIRMWARE_BASE   $env(FIRMWARE_BASE)
set CARD_BASE       $env(CARD_BASE)
set CORE_BASE       $env(CORE_BASE)
set CARD_NDK_CONST  $env(CARD_NDK_CONST)
set CARD_USER_CONST $env(CARD_USER_CONST)
set APP_USER_CONST 	$env(APP_USER_CONST)
set OUTPUT_NAME     $env(OUTPUT_NAME)

set CORE_USER_CONST $CORE_BASE/config/user_const.tcl

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

# Source core constant values (common for all card types)
source $CORE_USER_CONST

# Source user constants specific for a current card type
source $CARD_USER_CONST

# Source application specific user constants, they have the highest priority
if {$APP_USER_CONST ne ""} {
	source $APP_USER_CONST
}

# Generating of the VHDL package
source $CORE_BASE/config/ndk_pkg_gen.tcl
