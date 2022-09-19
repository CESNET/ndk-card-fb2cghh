# user_const.tcl: Default parameters
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): David Beneš <benes.david2000@seznam.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

set PROJECT_NAME ""

# ==============================================================================
# ETH parameters:
# ==============================================================================
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

# ==============================================================================
# PCIe parameters (not all combinations work):
# ==============================================================================
# Supported combinations for this card:
# 1x PCIe Gen3 x16 -- PCIE_GEN=3, PCIE_ENDPOINTS=1, PCIE_ENDPOINT_MODE=0 (Note: default configuration)
# ------------------------------------------------------------------------------
# PCIe Generation (possible values: 3, 4, 5):
# 3 = PCIe Gen3
# 4 = PCIe Gen4 (Stratix 10 with P-Tile or Agilex)
# 5 = PCIe Gen5 (Agilex with R-Tile)
set PCIE_GEN           3
# PCIe endpoints (possible values: 1, 2, 4):
# 1 = 1x PCIe x16 in one slot
# 2 = 2x PCIe x16 in two slot OR 2x PCIe x8 in one slot (bifurcation x8+x8)
# 4 = 4x PCIe x8 in two slots (bifurcation x8+x8)
set PCIE_ENDPOINTS     1
# PCIe endpoint mode (possible values: 0, 1):
# 0 = 1x16 lanes
# 1 = 2x8 lanes (bifurcation x8+x8)
set PCIE_ENDPOINT_MODE 0
# ------------------------------------------------------------------------------

# ==============================================================================
# DMA parameters:
# ==============================================================================
# If you do not have access to a non-public repository with DMA IP, set to false.
# If the DMA module is disabled, loopback will be implemented instead.
set DMA_ENABLE           true
# The minimum number of RX/TX DMA channels for this card is 16.
set DMA_RX_CHANNELS      16
set DMA_TX_CHANNELS      16
# In blocking mode, packets are dropped only when the RX DMA channel is off.
# In non-blocking mode, packets are dropped whenever they cannot be sent.
set DMA_RX_BLOCKING_MODE true
# ------------------------------------------------------------------------------

# Other parameters:
# =================
set TSU_ENABLE true
set TSU_FREQUENCY 322265625

set MEM_PORTS 0
