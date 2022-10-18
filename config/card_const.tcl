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
# Other parameters:
# ------------------------------------------------------------------------------
set TSU_FREQUENCY 322265625

set MEM_PORTS 0
