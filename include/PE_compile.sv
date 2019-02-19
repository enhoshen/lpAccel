`include "../src/define.sv"
`include "../src/MEM/MEMdefine.sv"
`include "../src/common/CommonDefine.sv"
`include "../src/PE/PEdefine.sv"
`include "../src/common/LoopCounter.sv"
`include "../src/common/Controllers.sv"
`ifdef SIM
//`include "../src/MEM/memv/MEMV_include.sv"
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
`include "../src/PE/PE.sv"
