# card_const.tcl: Card specific parameters (developement only)
# Copyright (C) 2022 CESNET, z. s. p. o.
# Author(s): David Beneš 	 <xbenes52@vutbr.cz>
#            Vladislav Valek <valekv@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# WARNING: The user should not deliberately change parameters in this file. For
# the description of this file, visit the Parametrization section in the
# documentation of the NDK-CORE repostiory

set CARD_NAME "FB2CGHH"
# Achitecture of Clock generator
set CLOCK_GEN_ARCH "USP"
# Achitecture of PCIe module
set PCIE_MOD_ARCH "USP"
# Achitecture of Network module
set NET_MOD_ARCH "CMAC"
# Achitecture of SDM/SYSMON module
set SDM_SYSMON_ARCH "USP_IDCOMP"

# Total number of QSFP cages
set QSFP_CAGES       2
# I2C address of each QSFP cage
set QSFP_I2C_ADDR(0) "0xA0"
set QSFP_I2C_ADDR(1) "0xA0"

# ------------------------------------------------------------------------------
# PCIe parameters (not all combinations work):
# ------------------------------------------------------------------------------
# PCIe Generation (possible values: 3):
# 3 = PCIe Gen3
set PCIE_GEN           3
# PCIe endpoints (possible values: 1):
# 1 = 1x PCIe x16 in one slot or 1x PCIe x8 in one slot
set PCIE_ENDPOINTS     1

# ------------------------------------------------------------------------------
# Other parameters:
# ------------------------------------------------------------------------------
set TSU_FREQUENCY 322265625

set MEM_PORTS 2
