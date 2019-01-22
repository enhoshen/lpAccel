typedef enum logic [1:0] {FULL,HEAD,BIN,RSHIFT} boothT;

import PECtlCfg::*;
import PECfg::*;
module MATbooth8 (
`clk_input,
input AuCtl i_ctl,
input [7:0] i_i,
input [7:0] i_w,
output logic signed[15:0] o_o
);
    //--------------
    //TODO
    // remember sign extension after masking
    // remember the add 1 after bit flip, but doesn't need it if PP is 0
    //
    //--------------
    //===============
    //logic
    //===============
    logic signed [8:0] PP1,PP1SE; // SE: sign extended
    logic signed [8:0] PP2,PP2SE;
    logic signed [3:0] PP_2bOvlp1,PP_2bOvlp1SE; // Ovlp: overlaped PP
    logic signed [8:0] PP3,PP3SE;
    logic signed [5:0] PP_2b4bOvlp,PP_2b4bOvlpSE;
    logic signed [8:0] PP4,PP4SE;
    logic signed [3:0] PP_2bOvlp3,PP_2bOvlp3SE;
    logic signed [6:0] PP_end,PP_endSE;
    boothT bT_PP1;
    boothT bT_PP2;
    boothT bT_PP3;
    boothT bT_PP4;
    boothT bt_PP_end;
    
    logic [2:0] boothSel_PP2;
    logic [2:0] boothSel_PP3;
    logic [2:0] boothSel_PP4;
    
    
    logic [7:0] PP1b ;
        assign PP1b = (i_ctl.mode==XNOR)? ~(i_i^i_w) : i_i&i_w;   
    logic [10:0] w_ext; 
        assign w_ext = ( i_ctl.wNumT==SIGNED )? { {2{i_w[7]}},i_w,1'b0 } : { 2'b0,i_w,1'b0 };
    
    logic signed [15:0] sum8b; // PP1 2 3 4
        assign sum8b = PP1 + (PP2<<2) + (PP3<<4) + (PP4<<6);
        //assign o_o=sum8b;
    logic signed [4:0] sum2b;  // PP2b Ovlp 1 3
        assign sum2b = PP_2bOvlp1 + PP_2bOvlp3;
    logic signed [8:0] sum4b;
        assign sum4b = (PP_end<<2) + PP_2b4bOvlp;
    
    //===============
    //comb
    //===============
    
    always_comb begin
        case ( i_ctl.mode)
            M1|XNOR|M2: o_o = sum8b + (sum2b<<6) + (sum4b<<4);
            M4:         o_o = sum8b + (sum4b<<4);
            default:         o_o = sum8b;
        endcase
    end
        
    integer i;
    always_comb begin
        //case ( i_ctl.mode )
            /*
            M2:begin
                PP1SE =        (i_ctl.iNumT==SIGNED)? {i_i[7],i_i[7:6],6'b0}      :{1'b0,i_i[7:6],6'b0};
                PP2SE =        (i_ctl.iNumT==SIGNED)? {i_i[7],i_i[7:6],6'b0}      :{1'b0,i_i[7:6],6'b0};
                PP_2bOvlp1SE=  (i_ctl.iNumT==SIGNED)? {{2{i_i[5]}},i_i[5:4]}      :{2'b0,i_i[5:4]};
                PP3SE =        (i_ctl.iNumT==SIGNED)? {{3{i_i[5]}},i_i[5:4],4'b0} :{3'b0,i_i[5:4],4'b0}; 
                PP_2b4bOvlpSE=(i_ctl.iNumT==SIGNED)? {{2{i_i[3]}},i_i[3:2],2'b0} :{2'b0,i_i[3:2],2'b0};
                PP4SE =        (i_ctl.iNumT==SIGNED)? {{5{i_i[3]}},i_i[3:2],2'b0} :{5'b0,i_i[3:2],2'b0};
                PP_2bOvlp3SE= (i_ctl.iNumT==SIGNED)? {{2{i_i[1]}},i_i[1:0]}      :{2'b0,i_i[1:0]};
                PP_endSE =     (i_ctl.iNumT==SIGNED)? {{3{i_i[1]}},i_i[1:0],2'b0} :{3'b0,i_i[1:0],2'b0};
            end
            M4:begin
                PP1SE =        (i_ctl.iNumT==SIGNED)? {i_i[7],i_i[7:4],4'b0}      :{1'b0,i_i[7:4],4'b0};
                PP2SE =        (i_ctl.iNumT==SIGNED)? {i_i[7],i_i[7:4],4'b0}      :{1'b0,i_i[7:4],4'b0};
                PP_2bOvlp1SE=  4'b0;
                PP3SE =        (i_ctl.iNumT==SIGNED)? {i_i[7],i_i[7:4],4'b0}      :{1'b0,i_i[7:4],4'b0}; 
                PP_2b4bOvlpSE=(i_ctl.iNumT==SIGNED)? {{2{i_i[3]}},i_i[3:0]}      :{2'b0,i_i[3:0]};
                PP4SE =        (i_ctl.iNumT==SIGNED)? {{5{i_i[3]}},i_i[3:0]}      :{5'b0,i_i[3:0]};
                PP_2bOvlp3SE= 4'b0;
                PP_endSE =     (i_ctl.iNumT==SIGNED)? {i_i[3],i_i[3:0],2'b0}      :{1'b0,i_i[3:0],2'b0};
            end
            */
            //M8:begin
                             
                PP1SE =        {i_i[7],i_i};     
                PP2SE =        {i_i[7],i_i};     
                PP_2bOvlp1SE=  4'b0;
                PP3SE =        {i_i[7],i_i};     
                PP_2b4bOvlpSE=6'b0;     
                PP4SE =        {i_i[7],i_i};     
                PP_2bOvlp3SE= 4'b0;
                PP_endSE =     7'b0 ; 
            //end 
            /*   
            default:begin
                PP1SE = {1'b0,PP1b[7],7'b0};
                PP2SE = {2'b0,PP1b[6],6'b0};
                PP_2bOvlp1SE= {2'b0,PP1b[5],1'b0};
                PP3SE = {4'b0,PP1b[4],4'b0}; 
                PP_2b4bOvlpSE= {2'b0,PP1b[3],3'b0};
                PP4SE = {6'b0,PP1b[2],2'b0};
                PP_2bOvlp3SE=  {2'b0,PP1b[1],1'b0};
                PP_endSE = {4'b0,PP1b[0],2'b0};
            end
        
        endcase
        */
    end
    booth_configurable booth_cPP1 ( .sel(w_ext[2:0]) , .bT(bT_PP1) , .in(PP1SE) , .out(PP1) );
    booth_configurable booth_cPP2 ( .sel(boothSel_PP2) , .bT(bT_PP2) , .in(PP2SE) , .out(PP2) );
    booth_tail #(.DW(4)) booth_tPP_2bOvlp1  ( .sel(w_ext[4:2]) , .in(PP_2bOvlp1SE) , .out(PP_2bOvlp1) );
    booth_configurable booth_cPP3 ( .sel(boothSel_PP3) , .bT(bT_PP3) , .in(PP3SE) , .out(PP3) );
    booth_tail #(.DW(6)) booth_tPP_2b4bOvlp ( .sel(w_ext[6:4]) , .in(PP_2b4bOvlpSE) , .out(PP_2b4bOvlp) );
    booth_configurable booth_cPP4 ( .sel(boothSel_PP4) , .bT(bT_PP4) , .in(PP4SE) , .out(PP4) );
    booth_tail #(.DW(4)) booth_tPP_2bOvlp3  ( .sel(w_ext[8:6]) , .in(PP_2bOvlp3SE) , .out(PP_2bOvlp3) );
    booth_configurable #(.DW(7)) booth_cPP_end ( .sel(w_ext[10:8]) , .bT(bt_PP_end) , .in(PP_endSE) , .out(PP_end) );

    always_comb begin
        bT_PP1 = (i_ctl.mode==M1||i_ctl.mode==XNOR)? BIN:FULL;
        bT_PP2 = (i_ctl.mode==M1||i_ctl.mode==XNOR)? RSHIFT:(i_ctl.mode==M2)? HEAD:FULL;
        bT_PP3 = (i_ctl.mode==M1||i_ctl.mode==XNOR)? RSHIFT:(i_ctl.mode==M8)? FULL:HEAD;
        bT_PP4 = (i_ctl.mode==M1||i_ctl.mode==XNOR)? RSHIFT:(i_ctl.mode==M2)? HEAD:FULL;
        bt_PP_end = (i_ctl.mode==M1||i_ctl.mode==XNOR)? RSHIFT: FULL;
        boothSel_PP2 = (i_ctl.mode==M2 && i_ctl.wNumT==SIGNED)? 3'b0 : w_ext[4:2];
        boothSel_PP3 = (i_ctl.mode!=M8 && i_ctl.wNumT==SIGNED )? 3'b0 :w_ext[6:4];
        boothSel_PP4 = (i_ctl.mode==M2 && i_ctl.wNumT==SIGNED )? 3'b0 :w_ext[8:6];

    end
endmodule
module booth_tail#(
parameter DW = 9
)(
input [2:0] sel,
input [DW-1:0] in,
output logic [DW-1:0] out
);
    always_comb begin 
        case ( sel [2:1] )
            2'b00: out='0;
            2'b01: out=in;
            2'b10: out=~(in<<1);
            2'b11: out=~in;
        endcase
    end
endmodule
module booth_configurable#(
parameter DW = 9
)(
input [2:0] sel,
input boothT bT,
input [DW-1:0] in,
output logic [DW-1:0] out
);
    logic [DW-1:0] temp;
    logic [2:0] sel_msk;
        assign sel_msk = (bT==HEAD)? sel&3'b001 : sel;
    //assign out = temp;
    logic single, double, neg;
        assign single = sel_msk[0]^sel_msk[1];
        assign double = (sel_msk[0]&&sel_msk[1]&&(!sel_msk[2]) ) || ((!sel_msk[0])&&(!sel_msk[1])&&sel_msk[2]) ;
        assign neg    = sel_msk[2];
    logic [DW-1:0]single_double_sel;
        assign single_double_sel = (in & {DW{!single}}) | (in<<1 & {DW{!double}}) ;
        assign out = !neg ^ single_double_sel;
    /*
    always_comb begin
        if (sel_msk == 3'b011 | sel_msk==3'b100)
            temp=in<<1;
        else if(sel_msk == 3'b111 | sel_msk==3'b000)
            temp='0;
        else
            temp =in;
    

        if (bT==FULL|bT==HEAD)
            out = (sel_msk[2] && (sel_msk[1:0]!=2'b11) )? ~temp : temp;
    
        else if(bT==BIN)
            out=in ;
        else    
            out=in>>1;   
    
    end
    */
endmodule
  
/*
                PP1SE = ()        9'b0_10000000;
                PP2_msk =       9'b0_01000000;
                PP_2bOvlp1_msk=   4'b0010;
                PP3_msk =     9'b0_00010000; 
                PP_2b4b_Ovlp_msk= 6'b001000;
                PP4_msk =   9'b0_00000100;
                PP_2b_Ovlp3_msk=  4'b0010;
                PP_end_msk=   7'b0_000100;
            end
            M2:begin  
                PP1_msk =         9'b0_11000000;
                PP2_msk =       9'b0_11000000;
                PP_2bOvlp1_msk=   4'b0011;
                PP3_msk =     9'b0_00110000; 
                PP_2b4b_Ovlp_msk= 6'b001100;
                PP4_msk =   9'b0_00001100;
                PP_2b_Ovlp3_msk=  4'b0011;
                PP_end_msk=   7'b0_001100;                  
            end
            M4:begin 
                PP1_msk =         9'b0_11110000;
                PP2_msk =       9'b0_11110000;
                PP_2bOvlp1_msk=   4'b0000;
                PP3_msk =     9'b0_11110000; 
                PP_2b4b_Ovlp_msk= 6'b001111;
                PP4_msk =   9'b0_00001111;
                PP_2b_Ovlp3_msk=  4'b0000;
                PP_end_msk=   7'b0_111100;   
            end
            M8:begin
                PP1_msk =         9'b0_11111111;
                PP2_msk =       9'b0_11111111;
                PP_2bOvlp1_msk=   4'b0000;
                PP3_msk =     9'b0_11111111; 
                PP_2b4b_Ovlp_msk= 6'b000000;
                PP4_msk =   9'b0_11111111;
                PP_2b_Ovlp3_msk=  4'b0000;
                PP_end_msk=   7'b0_000000; 

*/
