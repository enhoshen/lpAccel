//`include "PE.sv"
import PECtlCfg::*;
import PECfg::*;


module MATmux(
`clk_input,
input AuCtl i_ctl,
input [DWD-1:0] i_ipix,
input [DWD-1:0] i_wpix,
output [DWD-1:0] o_sum,
);
    //=================
    //parameter
    //=================
    //=================
    //logic
    //=================
    wire [AUMASKWD-1:0] msk_ipix ,msk_wpix;
        assign msk_ipix = {AUMULTSIZE{i_ipix}} & i_ctl.AuMask;
        assign msk_wpix = {AUMULTSIZE{i_wpix}} & i_ctl.AuMask;
    wire [DWD-1:0] msk1b_ipix,msk2b_ipix,msk4b_ipix ;
        assign  msk1b_ipix=msk_ipix[0+:DWD];   
        assign  msk2b_ipix=msk_ipix[DWD+:DWD];
        assign  msk4b_ipix=msk_ipix[2*DWD+:DWD];
    wire [DWD-1:0] msk1b_wpix,msk2b_wpix,msk4b_wpix ;
        assign  msk1b_wpix=msk_wpix[0+:DWD];   
        assign  msk2b_wpix=msk_wpix[DWD+:DWD];
        assign  msk4b_wpix=msk_wpix[2*DWD+:DWD];
        // num range 1b: -1~1
        //           2b: -2~3
        //           4b: -8~15
    //logic signed [1:0] setd1b_ipix [16]; // sign extend 
    logic signed [2:0] setd2b_ipix [8] ;
    logic signed [4:0] setd4b_ipix [4] ;
    //logic signed [1:0] setd1b_wpix [16]; // sign extend 
    logic signed [2:0] setd2b_wpix [8] ;
    logic signed [4:0] setd4b_wpix [4] ;
        // num range 1bx1b: -1~1 
        //           2bx2b: -6~9
        //           4bx4b: -120~225  
    logic signed  m1b [16];
    logic signed [4:0] m2b [8];
    logic signed [8:0] m4b [4];
        // num range sum1b:-16~16
        //           sum2b:-48~72
        //           sum4b:-480~900
    logic [4:0] sum1b ;
    logic signed [7:0] sum2b ;
    logic signed [10:0]sum4b ;

    logic signed [AUODWD-1:0] sum_w;
        assign o_sum = sum_w ;
        // control
`ifdef MULT8
    logic  [DWD-1:0] msk8b_ipix;
    logic  [DWD-1:0] msk8b_wpix;
        assign  msk8b_ipix=msk_ipix[3*DWD+:DWD];
        assign  msk8b_wpix=msk_wpix[3*DWD+:DWD];
    logic signed [8:0] setd8b_ipix [2];
    logic signed [8:0] setd8b_wpix [2];
    logic signed [16:0] m8b[2];
    logic signed [16:0] sum8b;
`endif   
    //================
    //submodule
    //================
    ADDT #(
        .ODWD(5),
        .DWD(1),
        .NUM(16)
    ) AT1b(
        .i_in(m1b),
        .o_out(sum1b)
    );
    ADDT #(
        .ODWD(8),
        .DWD(5),
        .NUM(8)
    ) AT2b(
        .i_in(m2b),
        .o_out(sum2b)
    );
    ADDT #(
        .ODWD(11),
        .DWD(9),
        .NUM(4)
    ) AT4b(
        .i_in(m4b),
        .o_out(sum4b)
    );
`ifdef MULT8
    ADDT #(
        .ODWD(17),
        .DWD(17),
        .NUM(2)
    )AT8b(
        .i_in(m8b),
        .o_out(sum8b)
    );
`endif   



    //================
    //combination
    //================
    
    integer i;
    always_comb begin
         
        for ( i = 0 ; i <16; i=i+1)begin: m1  
            case(i_ctl.mode) 
                XNOR: begin
                    m1b[i] = msk1b_ipix[i] ~^ msk1b_wpix[i];
                end
                default  : begin
                    m1b[i] = msk1b_ipix[i] &  msk1b_wpix[i];
                end       
            endcase
        end
        for ( i = 0 ; i <8; i=i+1)begin: m2  
            setd2b_ipix[i] = (i_ctl.iNUMT==SIGNED)? $signed(msk2b_ipix[i*2+:2]):$unsigned(msk2b_ipix[i*2+:2]); 
            setd2b_wpix[i] = (i_ctl.wNUMT==SIGNED)? $signed(msk2b_wpix[i*2+:2]):$unsigned(msk2b_wpix[i*2+:2]);
            m2b [i] = setd2b_ipix[i]*setd2b_wpix[i];
        end
        for ( i = 0 ; i <4; i=i+1)begin: m4
            setd4b_ipix[i] = (i_ctl.iNUMT==SIGNED)? $signed(msk4b_ipix[i*4+:4]):$unsigned(msk4b_ipix[i*4+:4]); 
            setd4b_wpix[i] = (i_ctl.wNUMT==SIGNED)? $signed(msk4b_wpix[i*4+:4]):$unsigned(msk4b_wpix[i*4+:4]);
            m4b [i] = setd4b_ipix[i]*setd4b_wpix[i]; 
        end
        `ifdef MULT8 
            for ( i=0 ; i<2 ; ++i)begin: m8
                setd8b_ipix[i] =(i_ctl.iNUMT==SIGNED)? $signed(msk8b_ipix[i*8+:8]) : $unsigned(msk8b_ipix[i*8+:8];
                setd8b_wpix[i] =(i_ctl.wNUMT==SIGNED)? $signed(msk8b_wpix[i*8+:8]) : $unsigned(msk8b_wpix[i*8+:8];
                m8b[i] = setd8b_ipix[i] * setd8b_wpix[i];
            end
        `endif
        case ( i_ctl.mode )
            XNOR: sum_w = sum1b - 5'd16;
            M1:   sum_w = (i_ctl.iNUMT == i_ctl.wNumT)? sum1b : -sum1b ;
            M2:   sum_w = sum2b;
            M4:   sum_w = sum4b;
            `ifdef MULT8
                M8:   sum_w = sum8b[15:0];
            `endif
        endcase
        

    end
endmodule


module ADDT #(
    parameter ODWD = 16,
    parameter DWD =8,
    parameter NUM = 8
)(
input signed [DWD-1:0] i_in [NUM],
output signed [ODWD-1:0] o_out
);
    logic signed [ODWD-1:0] out; 
        assign o_out = out;
    integer i;
    
    always_comb  begin
        out = {ODWD{1'd0}};
            for ( i=0 ; i< NUM ; i=i+1)begin
                out = out + (i_in[i]); 
            end
    end

endmodule


