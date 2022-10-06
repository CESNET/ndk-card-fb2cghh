# card_conf.tcl: User changeable parameters for the card
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): David Beneš     <xbenes52@vutbr.cz>
#            Vladislav Valek <valekv@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# NOTE: For the detailed description of this file, visit the Configuration section
# in the documentation of the NDK-CORE repository.

set PROJECT_NAME ""

# ------------------------------------------------------------------------------
# DMA parameters:
# ------------------------------------------------------------------------------
# The minimum number of RX/TX DMA channels for this card is 16.
set DMA_RX_CHANNELS      16
set DMA_TX_CHANNELS      16
# In blocking mode, packets are dropped only when the RX DMA channel is off.
# In non-blocking mode, packets are dropped whenever they cannot be sent.
set DMA_RX_BLOCKING_MODE true

# -----------------
# Other parameters:
# -----------------
set TSU_ENABLE true
