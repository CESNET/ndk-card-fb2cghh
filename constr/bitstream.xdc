# bitstream.xdc: Bitstream configuration for fb2cghh card
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): David Beneš <benes.david2000@seznam.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

set_property BITSTREAM.GENERAL.COMPRESS true            [current_design]
set_property CONFIG_MODE SPIx4                          [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4            [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable  [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES         [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes        [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN enable   [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0           [current_design]
