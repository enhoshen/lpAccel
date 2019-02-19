import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed{
    MSconf msconf;
    SSctl ssctl;
} FSpipein;
typedef struct packed{
    MSctl msctl;
    SSctl ssctl;
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
input  FSctl i_ctl,
`rdyack_input(MAIN),
`rdyack_output(FS),
input  FSin   i_data[PEROW],
output FSout  o_data[PEROW],
input  FSpipein i_FSpipe_MAIN,
output FSpipeout o_FSpipe_FS
);

    //===============
    //logic
    //===============
    AuCtl auctl;
    logic [PSUMDWD-1:0] psum_FS [PEROW] ;
    //===============
    //comb
    //===============
    always_comb begin
        auctl.mode = i_FSpipe_MAIN.msconf.mode;
        auctl.iNumT = i_FSpipe_MAIN.msconf.iNumT;
        auctl.wNumT = i_FSpipe_MAIN.msconf.wNumT;
    end

    genvar pe_row;
    generate 
        if (ATYPE==MUX)begin
            assign auctl.AuMask = (auctl.mode == XNOR)? {48'b0 ,16'hffff }: 16'hffff << (auctl.mode-1'b1);
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
    `forward ( FD, MAIN, FS)
    `ff_rstn
        o_FSpipe_FS <= '0;
        for ( int i =0 ; i<PEROW ; ++i)begin
            o_data[i] <= '0;
        end
    `ff_cg( `rdyNack(MAIN) || `rdyNack(FS) )
        o_FSpipe_FS.ssctl <= i_FSpipe_MAIN.ssctl;
        o_FSpipe_FS.msctl <= {auctl};
        for ( int i =0 ; i<PEROW ; ++i)begin
            o_data[i] <= {i_data[i].Input_IP,i_data[i].Weight_WP,i_data[i].Psum_PP};
        end 
    `ff_end

endmodule
