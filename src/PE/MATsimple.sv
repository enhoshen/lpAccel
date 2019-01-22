import PECtlCfg::*;
import PECfg::*;

module AunitPacked16 (
`clk_input,
input           AuCtl     i_ctl,
input           [15:0] i_ipix,
input           [15:0] i_wpix,
output logic    [15:0] o_sum,
);

    //================
    //parameter
    //================
    //================
    //logic
    //================
    logic ce;
    logic [15:0] sum_w ;
    logic sum_rdy_w;
    logic sum_zero_w;
    //================
    //comb
    //================
        //============
        //submodule
        //============
    genvar i;
    generate 
        for ( i=0 ; i<2 ; i++) begin : ADDT_8b
            ADTMult8 adt8(
                .i_ctl(),
                .i_i(),
                .i_w(),
                .o_o()
            );
        end
    endgenerate 
    //================
    //seq
    //================
endmodule

module ADTMult8 (
`clk_input,
input  AuCtl  i_ctl,
input  [7:0]  i_i,
input  [7:0]  i_w,
output [15:0] o_o
);
    
    //================
    //parameter
    //================
    
    //================
    //logic
    //================
    logic [7:0] PP [8];
    logic [7:0] AndPP [8]; // ANDed partial product
    logic XnorBit [8];
    logic [1:0] FlipBit2b [4];
    logic [3:0] FlipBit4b [2];
    logic [7:0] FlipBit8b ; 
    logic PPSignExtend [8];
    logic signed [15:0] Sum ;
        assign o_o = (i_ctl.mode==XNOR)? (Sum-5'd16) : Sum;
    //================
    //comb
    //================

    integer i,i0,i1,i2,i3;
    always_comb begin
        Sum = 16'b0;
        for ( i=0 ; i<8 ; ++i)begin
            Sum = Sum + $signed({PPSignExtend[i],PP[i]<<i});
        end
    end
     always_comb begin 
        for ( i0=0 ; i0<8 ; ++i0)begin: and_partial_product
            AndPP [i0] = i_i & {8{i_w[i0]}};
        end
        for ( i1=0 ; i1<8 ; ++i1)begin: Xnor_bit
            XnorBit [i1] = i_i[7-i1] ~^ i_w[i1];
        end 
        for ( i2=0 ; i2<4 ; ++i2)begin: FlipBit_2b
            FlipBit2b [i2] = ~(AndPP [2*i2+1] [7-2*i2-:2]);
        end
        for ( i3=0 ; i3<2 ; ++i3)begin: FlipBit_4b
            FlipBit4b [i3] = ~(AndPP [4*i3+3] [7-4*i3-:4]);
        end
        FlipBit8b = ~ AndPP [7] ; 
    end

    genvar j , k;
    generate  
        for ( j=0 ; j<8 ; ++j )begin: Sign_extension
            localparam j7=7-j;
            if ( j==1 || j==5 ) 
                always_comb begin
                    case ( i_ctl.mode)
                        XNOR: PPSignExtend [j] = 1'b0; 
                        M1  : PPSignExtend [j] = 1'b0;
                        M2  : PPSignExtend [j] = (i_ctl.wNumT==SIGNED && i_w[j])? FlipBit2b[ j[2:1] ][1] : (i_ctl.iNumT==SIGNED)? AndPP[j][ {j7[2:1],1'b0}+1 ]  : 1'b0;
                        M4  : PPSignExtend [j] = (i_ctl.iNumT==SIGNED)? AndPP[j][ {j7[2],2'b0}+3 ] : 1'b0;  
                        M8  : PPSignExtend [j] = (i_ctl.iNumT==SIGNED)? AndPP[j][7] : 1'b0;
                        default : PPSignExtend[j] = 1'b0;
                    endcase
                end
            else ;       
            if ( j==3 ) 
                always_comb begin
                    case ( i_ctl.mode)
                        XNOR: PPSignExtend [j] = 1'b0; 
                        M1  : PPSignExtend [j] = 1'b0;
                        M2  : PPSignExtend [j] = (i_ctl.wNumT==SIGNED && i_w[j])? FlipBit2b[ j[2:1] ][1] : (i_ctl.iNumT==SIGNED)? AndPP[j][ {j7[2:1],1'b0}+1 ]  : 1'b0;
                        M4  : PPSignExtend [j] = (i_ctl.wNumT==SIGNED && i_w[j])? FlipBit4b[ j[2] ][3]   : (i_ctl.iNumT==SIGNED)? AndPP[j][ {j7[2],2'b0}+3 ] : 1'b0;
                        M8  : PPSignExtend [j] = (i_ctl.iNumT==SIGNED)? AndPP[j][7] : 1'b0;
                        default : PPSignExtend[j] = 1'b0;
                    endcase
                end
            else ;       
            if ( j==7 ) 
                always_comb begin
                    case ( i_ctl.mode)
                        XNOR: PPSignExtend [j] = 1'b0; 
                        M1  : PPSignExtend [j] = 1'b0;
                        M2  : PPSignExtend [j] = (i_ctl.wNumT==SIGNED && i_w[j])? FlipBit2b[ j[2:1] ][1] : (i_ctl.iNumT==SIGNED)? AndPP[j][ {j7[2:1],1'b0}+1 ]  : 1'b0;
                        M4  : PPSignExtend [j] = (i_ctl.wNumT==SIGNED && i_w[j])? FlipBit4b[ j[2] ][3]   : (i_ctl.iNumT==SIGNED)? AndPP[j][ {j7[2],2'b0}+3 ] : 1'b0;
                        M8  : PPSignExtend [j] = (i_ctl.wNumT==SIGNED && i_w[j])? FlipBit8b[7]          : (i_ctl.iNumT==SIGNED)? AndPP[j][7] : 1'b0;
                        default : PPSignExtend[j] = 1'b0;
                    endcase
                end
            else ;       
            if ( !j[0] )
                always_comb begin 
                    case ( i_ctl.mode )
                        XNOR: PPSignExtend [j] = 1'b0 ;
                        M1  : PPSignExtend [j] = 1'b0 ;
                        M2  : PPSignExtend [j] = (i_ctl.iNumT==SIGNED)? AndPP[j][ {j7[2:1],1'b0}+1 ]  : 1'b0;
                        M4  : PPSignExtend [j] = (i_ctl.iNumT==SIGNED)? AndPP[j][ {j7[2],2'b0}+3 ] : 1'b0;  
                        M8  : PPSignExtend [j] = (i_ctl.iNumT==SIGNED)? AndPP[j][7] : 1'b0;
                        default : PPSignExtend[j] = 1'b0;
                    endcase
                end
            else ;      
        end
        for ( j=0 ; j<8 ; ++j )begin: PP_row_right
            localparam j7=7-j;
            if ( j7[2] ) assign PP[j][ ({j7[2],2'b0}-1) -:4] = ( i_ctl.mode == M8 )? AndPP[j][ ({j7[2],2'b0}-1) -:4] : 4'b0;
            else ;
            if ( j7[1] ) assign PP[j][ ({j7[2:1],1'b0}-1) -:2] = ( i_ctl.mode >= M4 )? AndPP[j][ ({j7[2:1],1'b0}-1) -:2] : 2'b0;
            else ;
            if ( j7[0] ) assign PP[j][ (j7-1) ] = ( i_ctl.mode >= M2 )? AndPP[j][ (j7-1) ] : 1'b0;
            else ;// actually this part can be done in a for loop, but i_ctl.mode selection is tricky 
        end 
        for ( j=0 ; j<8 ; ++j )begin:PP_row_left
            localparam j7=7-j;
            if ( j[2] )begin: bit4_block
                if ( j[1:0]==2'b11 ) assign PP[j][ ({j7[2],2'b0}+4) +:4] = (i_ctl.mode==M8)?  ( (i_ctl.wNumT==SIGNED && i_w[j] )? FlipBit8b : AndPP[j][7-:4] ): PPSignExtend[j]  ;
                else                 assign PP[j][ ({j7[2],2'b0}+4) +:4]  = (i_ctl.mode==M8)? AndPP[j][7-:4]: PPSignExtend[j] ;
            end else;
            if ( j[1] )begin: bit2_block
                if ( j[1:0]==2'b11 ) assign PP[j][ ({j7[2:1],1'b0}+2) +:2] = (i_ctl.mode>=M4)? ( (i_ctl.wNumT==SIGNED && i_w[j])? FlipBit4b[j[2]][3-:2] : AndPP[j][ ({j7[2:1],1'b0}+2) +:2 ] ): PPSignExtend[j] ;
                else                 assign PP[j][ ({j7[2:1],1'b0}+2) +:2] = (i_ctl.mode>=M4)? AndPP[j][ ({j7[2:1],1'b0}+2) +:2 ] : PPSignExtend[j] ;
            end else;
            if ( j[0] )begin: bit1_block
                if ( j[1:0]==2'b11 ) assign PP[j][ j7+1 ] = (i_ctl.mode>=M2)? ( (i_ctl.wNumT==SIGNED && i_w[j] )? FlipBit2b[j[2:1]][1] : AndPP[j][j7+1] ) : PPSignExtend[j] ;
                else                 assign PP[j][ j7+1 ] = (i_ctl.mode>=M2)? AndPP[j][j7+1] : PPSignExtend[j] ;
            end else;    
        end
        for ( j=0 ; j<8 ; ++j )begin:diagonal
            localparam j7=7-j;
            if ( j[0] ) assign PP[j][j7] = (i_ctl.mode>=M2)? ( (i_ctl.wNumT==SIGNED && i_w[j])? FlipBit2b[j[2:1]][0] : AndPP[j][j7] ) : (i_ctl.mode==XNOR)? XnorBit[j] : AndPP[j][j7] ;
            else        assign PP[j][j7] = (i_ctl.mode==XNOR)? XnorBit[j] : AndPP[j][j7];
        end 

    endgenerate 
endmodule

