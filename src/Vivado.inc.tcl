# Vivado.inc.tcl: Vivado.tcl include
# Copyright (C) 2022 CESNET z.s.p.o.
# Author(s): David Beneš <xbenes52@vutbr.cz>
#            Vladislav Valek <valekv@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# configuration constants (populates all variables from env)
source $env(CARD_CONST)

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

# Propagating card constants to the Modules.tcl files of the underlying components.
# Insert others if needed.
set CARD_ARCHGRP(CORE_BASE)             $CORE_BASE

# make lists from associative arrays
set CARD_ARCHGRP_L [array get CARD_ARCHGRP]
set CORE_ARCHGRP_L [array get CORE_ARCHGRP]

# concatenate lists to be handed as a part of the ARCHGRP to the TOPLEVEL
set ARCHGRP_ALL [concat $CARD_ARCHGRP_L $CORE_ARCHGRP_L]

# Main component
lappend HIERARCHY(COMPONENTS) [list "TOPLEVEL" $CARD_BASE/src $ARCHGRP_ALL]

# XDC constraints for specific parts of the design
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/bitstream.xdc"
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/general.xdc"
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/pcie.xdc"
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/qsfp.xdc"
lappend SYNTH_FLAGS(CONSTR) "$CARD_BASE/constr/qsfp_loc.xdc"
