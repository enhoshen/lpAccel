import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed{
    FSctl fsctl;
    MSconf msconf;
    SSctl ssctl;
    PPctl ssppctl;
} FSpipein;
typedef struct packed{
    MSctl msctl;
    SSctl ssctl;
    PPctl ssppctl;
} FSpipeout;
typedef struct packed{
    logic [DWD-1:0]  Input_IP ;
    logic [DWD-1:0]  Weight_WP;
    logic [PSUMDWD-1:0]  Psum_PP  ;
} FSin;
typedef struct packed{
    logic [DWD-1:0]  Input_FS ;
    logic [DWD-1:0]  Weight_FS;
    logic [PSUMDWD-1:0]  Psum_FS  ;
} FSout;
module FetchStage(
`clk_input,
input  FSpipein i_pipe,
`rdyack_input(MAIN),
`rdyack_output(FS),
input  FSin   i_data[PEROW],
output FSout  o_data[PEROW],
output FSpipeout o_FSpipe_FS
);
    //===============
    //parameter
    //===============

    //===============
    //logic
    //===============
    AuCtl auctl;
    MSctl msctl;
        assign msctl = {auctl};
    FSctl i_ctl;
        assign i_ctl = i_pipe.fsctl;
    logic [PSUMDWD-1:0] psum_FS [PEROW] ;
    //===============
    //comb
    //===============
    `forward ( FD, MAIN, FS)
    always_comb begin
        auctl.mode = i_pipe.msconf.mode;
        auctl.iNumT = i_pipe.msconf.iNumT;
        auctl.wNumT = i_pipe.msconf.wNumT;
    end
    
    genvar pe_row;
    generate 
        if (ATYPE==MUX)begin
            parameter [63:0] MUXMASK [4] = {64'h0000_0000_0000_ffff,64'h0000_0000_ffff_0000,64'h0000_ffff_0000_0000,64'hffff_0000_0000_0000};
            logic [1:0] modem1;
                assign modem1 = auctl.mode - 1'b1;
            assign auctl.AuMask = (auctl.mode == XNOR)? {48'b0 ,16'hffff }:MUXMASK[modem1];
        end
        else if (ATYPE == SIMPLE)begin
            initial General::TODO;
        end
        else if (ATYPE == BOOTH)begin
            initial General::TODO;
        end
        else begin
            initial ErrorAu;
        end
    
        for ( pe_row = 0 ; pe_row < PEROW ; ++pe_row ) begin
            always_comb begin
                if ( i_ctl.psum_mode == D16)
                    psum_FS[pe_row] = (i_ctl.psum_parity)? i_data[pe_row].Psum_PP >> DWD : i_data[pe_row].Psum_PP;
                else
                    psum_FS[pe_row] = i_data[pe_row].Psum_PP;
            end
        end
    endgenerate

    //===============
    //sequential
    //===============
    `ff_rstn
        o_FSpipe_FS <= '0;
        for ( int i =0 ; i<PEROW ; ++i)begin
            o_data[i] <= '0;
        end
    `ff_cg( `rdyNack(MAIN) || `rdyNack(FS) )
        o_FSpipe_FS <= {msctl, i_pipe.ssctl , i_pipe.ssppctl};
        for ( int i =0 ; i<PEROW ; ++i)begin
            o_data[i] <= {i_data[i].Input_IP,i_data[i].Weight_WP,i_data[i].Psum_PP};
        end 
    `ff_end

endmodule
