# Vivado.inc.tcl: Vivado.tcl include
# Copyright (C) 2022 CESNET z.s.p.o.
# Author(s): David Beneš <benes.david2000@seznam.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# NDK constants (populates all NDK variables from env)
source $env(CARD_NDK_CONST)

# Include common card script
source $CORE_BASE/Vivado.inc.tcl

# Design parameters
set SYNTH_FLAGS(MODULE)    "fpga"
set SYNTH_FLAGS(FPGA)      "xcku15p-ffve1760-2-e"
set SYNTH_FLAGS(MCS_IFACE) "SPIx4"
set SYNTH_FLAGS(BOARD)     $CARD_NAME

# Optimization directives for implementation
#set SYNTH_FLAGS(SOPT_DIRECTIVE)  "Explore"
#set SYNTH_FLAGS(PLACE_DIRECTIVE) "Explore"
#set SYNTH_FLAGS(POPT_DIRECTIVE)  "Explore"
#set SYNTH_FLAGS(ROUTE_DIRECTIVE) "Explore"

set SYNTH_FLAGS(SOPT_DIRECTIVE)  "ExploreWithRemap"
set SYNTH_FLAGS(PLACE_DIRECTIVE) "ExtraTimingOpt"
set SYNTH_FLAGS(POPT_DIRECTIVE)  "Explore"
set SYNTH_FLAGS(ROUTE_DIRECTIVE) "NoTimingRelaxation"

# Main component
lappend HIERARCHY(COMPONENTS) [list "TOPLEVEL" $CARD_BASE/src "FULL"]

# XDC constraints for specific parts of the design
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/bitstream.xdc"
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/general.xdc"
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/pcie.xdc"
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/qsfp.xdc"
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/qsfp_loc.xdc"
