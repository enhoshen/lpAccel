//`include "PE.sv"
import PECtlCfg::*;
import PECfg::*;


module Aunit (
`clk_input,
input [AuMaskWd-1:0] i_ctl_mask , 
input AuCtl i_ctl,
input [AuMaskWd-1:0] i_ipix,
`pbpix_input(ipix),
input [AuMaskWd-1:0] i_wpix,
`pbpix_input(wpix),
output [AuODWd-1:0] o_sum,
`pbpix_output(sum)
);
    //=================
    //parameter
    //=================
    localparam ODWd = PECtlCfg::AuODWd;
    localparam DWd  = PECfg::DWd;
    localparam AuMaskWd = PECtlCfg::AuMaskWd;    
    //=================
    //logic
    //=================
    wire [AuMaskWd-1:0] msk_ipix ,msk_wpix;
        assign msk_ipix = i_ipix & i_ctl_mask;
        assign msk_wpix = i_wpix & i_ctl_mask;
    wire [DWd-1:0] msk1b_ipix,msk2b_ipix,msk4b_ipix ;
        assign  msk1b_ipix=msk_ipix[1*DWd-1:0];   
        assign  msk2b_ipix=msk_ipix[2*DWd-1:1*DWd];
        assign  msk4b_ipix=msk_ipix[3*DWd-1:2*DWd];
    wire [DWd-1:0] msk1b_wpix,msk2b_wpix,msk4b_wpix ;
        assign  msk1b_wpix=msk_wpix[1*DWd-1:0];   
        assign  msk2b_wpix=msk_wpix[2*DWd-1:1*DWd];
        assign  msk4b_wpix=msk_wpix[3*DWd-1:2*DWd];
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

    logic signed [ODWd-1:0] sum_r , sum_w;
        assign o_sum = sum_r ;
        // control
`ifdef MULT8
    logic  [DWd-1:0] msk8b_ipix;
    logic  [DWd-1:0] msk8b_wpix;
        assign  msk8b_ipix=msk_ipix[4*DWd-1:3*DWd];
        assign  msk8b_wpix=msk_wpix[4*DWd-1:3*DWd];
    logic signed [7:0] setd8b_ipix [2];
    logic signed [7:0] setd8b_wpix [2];
    logic signed [15:0] m8b[2];
    logic signed [15:0] sum8b;
`endif   
    logic sum_rdy_w ;
         assign sum_rdy_w = ( wpix_rdy && ipix_rdy ) || ( sum_rdy && !sum_ack);
    logic sum_zero_w ;
        assign sum_zero_w = ipix_zero && wpix_zero;

    wire forward ;
        assign forward = wpix_rdy && ipix_rdy &&  (!sum_rdy || sum_ack) ;
        assign ipix_ack = forward;
        assign wpix_ack = forward;
    wire ce ;
        assign ce = (forward && wpix_zero && ipix_zero && i_ctl.work)||(sum_ack && wpix_zero && ipix_zero && i_ctl.work) ; 
    //================
    //submodule
    //================
    ADDT #(
        .ODWd(5),
        .DWd(1),
        .Num(16)
    ) AT1b(
        .i_in(m1b),
        .o_out(sum1b)
    );
    ADDT #(
        .ODWd(8),
        .DWd(5),
        .Num(8)
    ) AT2b(
        .i_in(m2b),
        .o_out(sum2b)
    );
    ADDT #(
        .ODWd(11),
        .DWd(9),
        .Num(4)
    ) AT4b(
        .i_in(m4b),
        .o_out(sum4b)
    );
`ifdef MULT8
    ADDT #(
        .ODWd(16),
        .DWd(16),
        .Num(2)
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
            setd2b_ipix[i] = (i_ctl.iNumT==SIGNED)? $signed(msk2b_ipix[i*2+:2]):$unsigned(msk2b_ipix[i*2+:2]); 
            setd2b_wpix[i] = (i_ctl.wNumT==SIGNED)? $signed(msk2b_wpix[i*2+:2]):$unsigned(msk2b_wpix[i*2+:2]);
            m2b [i] = setd2b_ipix[i]*setd2b_wpix[i];
        end
        for ( i = 0 ; i <4; i=i+1)begin: m4
            setd4b_ipix[i] = (i_ctl.iNumT==SIGNED)? $signed(msk4b_ipix[i*4+:4]):$unsigned(msk4b_ipix[i*4+:4]); 
            setd4b_wpix[i] = (i_ctl.wNumT==SIGNED)? $signed(msk4b_wpix[i*4+:4]):$unsigned(msk4b_wpix[i*4+:4]);
            m4b [i] = setd4b_ipix[i]*setd4b_wpix[i]; 
        end
        `ifdef MULT8 
            for ( i=0 ; i<2 ; ++i)begin: m8
                setd8b_ipix[i] = $signed(msk8b_ipix[i*8+:8]);
                setd8b_wpix[i] = $signed(msk8b_wpix[i*8+:8]);
                m8b[i] = setd8b_ipix[i] * setd8b_wpix[i];
            end
        `endif
        case ( i_ctl.mode )
            XNOR: sum_w = sum1b - 5'd16;
            M1:   sum_w = (i_ctl.iNumT == i_ctl.wNumT)? sum1b : -sum1b ;
            M2:   sum_w = sum2b;
            M4:   sum_w = sum4b;
            `ifdef MULT8
                M8:   sum_w = sum8b;
            `endif
        endcase
        

    end
    
    `ff_rstn 
        sum_r <= '0; 
    `ff_cg( ce  )
        sum_r <= sum_w; 
    `ff_end

    `ff_rstn
        sum_rdy <= 1'b0;
        sum_zero<= 1'b1;
    `ff_cg( i_ctl.work )
        sum_rdy <= sum_rdy_w;
        sum_zero<= sum_zero_w;
    `ff_end
endmodule


module ADDT #(
    parameter ODWd = 16,
    parameter DWd =8,
    parameter Num = 8
)(
input signed [DWd-1:0] i_in [Num],
output signed [ODWd-1:0] o_out
);
    logic signed [ODWd-1:0] out; 
        assign o_out = out;
    integer i;
    
    always_comb  begin
        out = {ODWd{1'd0}};
            for ( i=0 ; i< Num ; i=i+1)begin
                out = out + (i_in[i]); 
            end
    end

endmodule


