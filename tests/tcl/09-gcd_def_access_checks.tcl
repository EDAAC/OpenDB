source [file join [file dirname [info script]] "test_helpers.tcl"]

# Open database, load lef and design

set db [dbDatabase_create]
set lef_parser [new_lefin $db true]
set def_parser [new_defin $db]

$lef_parser createTechAndLib nangate45 ./OpenDB/tests/data/gcd_nangate45/NangateOpenCellLibrary.mod.lef 

set chip [$def_parser createChip [$db getLibs] ./OpenDB/tests/data/gcd_nangate45/floorplan.def]

# Block checks

set block [$chip getBlock]

check "block name" {$block getName} "gcd"

check "def units" {set units [$block getDefUnits]} 2000

check "number of children" {llength [set children [$block getChildren]]} 0
check "number of instances" {llength [set insts [$block getInsts]]} 314
check "number of pins" {llength [set bterms [$block getBTerms]]} 54
check "number of obstructions" {llength [set obstructions [$block getObstructions]]} 0
check "number of blockages"  {llength [set blockages [$block getBlockages]]} 0

check "number of nets" {llength [set nets [$block getNets]]} 482
check "number of vias" {llength [set vias [$block getVias]]} 0
check "number of rows" {llength [set rows [$block getRows]]} 56

set bbox [$block getBBox]
check "bbox" {list [$bbox xMin] [$bbox yMin] [$bbox xMax] [$bbox yMax]} "0 0 200260 201600"

check "block gcell grid" {$block getGCellGrid}  "" ; # Return value is currently NULL, better to be an empty list

check "block die area" {$block getDieArea} "0 0 200260 201600"
check "number of regions" {llength [set regions [$block getRegions]]} 0
check "number of nondefault rules" {llength [set non_default_rules [$block getNonDefaultRules]]} 0
check "number of scenarios" {$block getNumberOfScenarios} 0

# Row checks

set row [lindex $rows 0] 

check "row name" {$row getName} ROW_0
check "row site" {[$row getSite] getName} FreePDK45_38x28_10R_NP_162NW_34O
check "row origin" {$row getOrigin} "20140 22400"
check "row orientation" {$row getOrient} "FS"
check "row direction" {$row getDirection} HORIZONTAL; # Not sure about the expected value here
check "row site count" {$row getSiteCount} 422
check "row site spacing" {$row getSpacing} 380
check "row bbox" {list [[$row getBBox] xMin] [[$row getBBox] yMin] [[$row getBBox] xMax] [[$row getBBox] yMax]} "20140 22400 180500 25200" ; # Guess at the xMax value

# Instance checks

set inst [lindex $insts 0]
check "instance name" {$inst getName} "_297_"
check "orientation" {$inst getOrient} "N"
check "origin" {list [[$inst getBBox] xMin] [[$inst getBBox] yMin]} "0 0"

check "placement status" {$inst getPlacementStatus} "UNPLACED"
check "master cell" {[set master [$inst getMaster]] getName} INV_X1
check "number of inst pins" {llength [set iterms [$inst getITerms]]} 4
check "instance halo" {$inst getHalo}  "" ; # Return value is currently NULL, better to be an empty list

# Cell master checks

check "master name" {$master getName} INV_X1
check "master origin" {$master getOrigin} "0 0"
check "master width" {$master getWidth} [expr 0.38 * $units]
check "master height" {$master getHeight} [expr 1.4 * $units]
check "master type" {$master getType} "CORE"
check "master logically equiv" {$master getLEQ} "" ; # Return value is currently NULL, better to be an empty list
check "master electrially equiv" {$master getEEQ} "" ; # Return value is currently NULL, better to be an empty list
check "master symmetry" {list [$master getSymmetryX] [$master getSymmetryY] [$master getSymmetryR90]} "1 1 0"
check "master number of terms" {llength [$master getMTerms]} 4
check "master library" {[$master getLib] getName} nangate45
check "master num obstructions" {llength [$master getObstructions]} 0
check "master placement boundary" {set rect [$master getPlacementBoundary]; list [$rect xMin] [$rect yMin] [$rect xMax] [$rect yMax]} "0 0 760 2800"
check "master term count" {$master getMTermCount} 4
check "master site" {[$master getSite] getName} FreePDK45_38x28_10R_NP_162NW_34O

# Net checks

set net [lindex $nets 0]

check "net name" {$net getName} clk
check "net weight" {$net getWeight} 1
check "net term count" {$net getTermCount} 36
check "net iterm count" {$net getITermCount} 35
check "net bterm count" {$net getBTermCount} 1

check "net sigType" {$net getSigType} "SIGNAL"
check "net wires" {$net getWire} "" ; # Return value is currently NULL, better to be an empty list
check "net swires" {$net getSWires} ""
check "net global wire" {$net getGlobalWire} "" ; # Return value is currently NULL, better to be an empty list
check "net non default rule" {$net getNonDefaultRule} ""  ; # Return value is currently NULL, better to be an empty list

exit_summary
