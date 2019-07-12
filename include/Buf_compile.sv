
`ifdef GATE_LEVEL
    `timescale 1ns/1ps
    `include "tsmc090.v"
    `include "../src/define.sv"
    `include "../src/MEM/MEMdefine.sv"
    `include "../BUFFER/BufDefine.sv"
    `include `syn_file(`GATE_LEVEL, .v) 
    `include "../src/BUFFER/Buffertest.sv"
`else
    `include "../src/define.sv"
    `include "../src/BUFFER/BufDefine.sv"
    `ifdef SIM 
        `include "../src/MEM/memv/SRAM_SP_1024x32.v"
        `include "../src/MEM/memv/SRAM_SP_512x16.v"
        `include "../src/MEM/memv/SRAM_SP_256x16.v"
    `endif 
    `include "../src/MEM/MEMdefine.sv"
    `include "../src/MEM/SRAM.sv"
    `include "../src/BUFFER/Buffertest.sv"
`endif

