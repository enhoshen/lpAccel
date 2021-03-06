`define IPcontIf_logic ( logname , ConfDWd, PConfDWd)\
    logic [ConfDWd-1:0]  logname``_IFLen;\
    logic [ConfDWd-1:0]  logname``_PopU;\
    logic [PConfDWd-1:0] logname``_Pch;\
    logic logname``_lastPix;\
    logic logname``_pop ;\
    logic logname``_noSpReuse;\
    logic logname``_stall;\
    logic logname``_start;\
    logic logname``_reset;\
    logic logname``_done;
`define IPcontIf_cont(ConfDWd,PConfDWd)\
    input [ConfDWd-1:0]i_cont_IFLen,\
    input [ConfDWd-1:0]i_cont_PopU,\
    input [PConfDWd-1:0]i_cont_Pch,\
    input i_cont_lastPix,\
    input i_cont_pop,\
    input i_cont_noSpReuse,\
    input i_cont_stall,\
    input i_cont_start,\
    input i_cont_reset,\
    input i_cont_done
`define IPcontIf_pc_ipad ( logname )\
    .i_cont_IFLen (logname``_IFLen),\
    .i_cont_PopU  (logname``_PopU ),\
    .i_cont_Pch   (logname``_Pch  ),\
    .i_cont_lastPix(logname``_lastPix),\
    .i_cont_pop   (logname``_pop  ),\
    .i_cont_noSpReuse(logname``_noSpReuse),\
    .i_cont_stall (logname``_stall),\
    .i_cont_start (logname``_start),\
    .i_cont_reset (logname``_reset),\
    .i_cont_done  (logname``_done )
`define IPcontIf_pc_pe ( logname)\
    .o_ipad_IFLen (logname``_IFLen),\
    .o_ipad_PopU  (logname``_PopU ),\
    .o_ipad_Pch   (logname``_Pch  ),\
    .o_ipad_lastPix(logname``_lastPix),\
    .o_ipad_pop   (logname``_pop  ),\
    .o_ipad_noSpReuse(logname``_noSpReuse),\
    .o_ipad_stall (logname``_stall),\
    .o_ipad_start (logname``_start),\
    .o_ipad_reset (logname``_reset),\
    .o_ipad_done  (logname``_done )
// PBpix interface
`define PBpixIf_logic(logname,name, DWd)\
    logic [DWd-1:0] logname_data;\
    logic logname_ready;\
    logic logname_valid;\
    logic logname_zero;
`define PBpixIf_in(name ,DWd)\
    input [DWd-1:0] i_``name``_data,\
    output o_``name``_ready,\
    input i_``name``_valid,\
    input i_``name``_zero
`define PBpixIf_pc_in(name, logname)\
    .i_``name``_data(logname``_data),\
    .o_``name``_ready(logname``_ready),\
    .i_``name``_valid(logname``_valid),\
    .i_``name``_zero(logname``_zero)
`define PBpixIf_out(name,DWd)\
    output [DWd-1:0] o_``name``_data,\
    input  o_``name``_ready,\
    output i_``name``_valid,\
    output o_``name``_zero
`define PBpixIf_pc_out(name,logname)\
    .o_``name``_data(logname``_data),\
    .o_``name``_ready(logname``_ready),\
    .i_``name``_valid(logname``_valid),\
    .o_``name``_zero(logname``_zero)

