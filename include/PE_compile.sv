`ifdef GATE_LEVEL
    `timescale 1ns/1ps
    `include "tsmc090.v"
    `include "../src/MEM/memv/MEMV_include.sv"
    `include "../src/define.sv"
    `include "../src/PE/PEdefine.sv"
    `include `syn_file(`GATE_LEVEL, .v) 
    `include "../src/PE/PE.sv"
`else
    `include "../src/define.sv"
    `include "../src/MEM/MEMdefine.sv"
    `include "../src/common/CommonDefine.sv"
    `include "../src/PE/PEdefine.sv"
    `include "../src/common/LoopCounter.sv"
    `include "../src/common/Controllers.sv"
    `include "../src/common/myControllers.sv"
    //`include "../src/MEM/memv/MEMV_include.sv"
    `ifdef SIM 
        //`include "../src/MEM/memv/RF_2P_32x32.v" 
    `endif 
    `include "../src/MEM/RF.sv"
    // for simulation
    `include "../src/PE/MATmux.sv"
    //`include "../src/PE/MATbooth.sv"
    //`include "../src/PE/MATsimple.sv"
    `include "../src/PE/DatapathControl.sv"
    `include "../src/PE/FetchStage.sv"
    `include "../src/PE/MultStage.sv"
    `include "../src/PE/SumStage.sv"
    `include "../src/PE/PathStage.sv"
    `include "../src/PE/PE.sv"


`endif
