/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : O-2018.06
// Date      : Tue Jul 23 03:15:17 2019
/////////////////////////////////////////////////////////////


module SRAM_SP_WORDWD512_DWD16_SIZE1 ( i_clk, i_rstn, i_rw, ce, i_addr, 
    .o_rdata({\o_rdata[0][15] , \o_rdata[0][14] , \o_rdata[0][13] , 
        \o_rdata[0][12] , \o_rdata[0][11] , \o_rdata[0][10] , \o_rdata[0][9] , 
        \o_rdata[0][8] , \o_rdata[0][7] , \o_rdata[0][6] , \o_rdata[0][5] , 
        \o_rdata[0][4] , \o_rdata[0][3] , \o_rdata[0][2] , \o_rdata[0][1] , 
        \o_rdata[0][0] }), .i_wdata({\i_wdata[0][15] , \i_wdata[0][14] , 
        \i_wdata[0][13] , \i_wdata[0][12] , \i_wdata[0][11] , \i_wdata[0][10] , 
        \i_wdata[0][9] , \i_wdata[0][8] , \i_wdata[0][7] , \i_wdata[0][6] , 
        \i_wdata[0][5] , \i_wdata[0][4] , \i_wdata[0][3] , \i_wdata[0][2] , 
        \i_wdata[0][1] , \i_wdata[0][0] }) );
  input [8:0] i_addr;
  input i_clk, i_rstn, i_rw, ce, \i_wdata[0][15] , \i_wdata[0][14] ,
         \i_wdata[0][13] , \i_wdata[0][12] , \i_wdata[0][11] ,
         \i_wdata[0][10] , \i_wdata[0][9] , \i_wdata[0][8] , \i_wdata[0][7] ,
         \i_wdata[0][6] , \i_wdata[0][5] , \i_wdata[0][4] , \i_wdata[0][3] ,
         \i_wdata[0][2] , \i_wdata[0][1] , \i_wdata[0][0] ;
  output \o_rdata[0][15] , \o_rdata[0][14] , \o_rdata[0][13] ,
         \o_rdata[0][12] , \o_rdata[0][11] , \o_rdata[0][10] , \o_rdata[0][9] ,
         \o_rdata[0][8] , \o_rdata[0][7] , \o_rdata[0][6] , \o_rdata[0][5] ,
         \o_rdata[0][4] , \o_rdata[0][3] , \o_rdata[0][2] , \o_rdata[0][1] ,
         \o_rdata[0][0] ;
  wire   n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n2, n3;

  SRAM_SP_512x16 \syn_mode.rf_instance[0].genblk1.SRAM512x16  ( .Q({n19, n20, 
        n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34}), 
        .A(i_addr), .D({\i_wdata[0][15] , \i_wdata[0][14] , \i_wdata[0][13] , 
        \i_wdata[0][12] , \i_wdata[0][11] , \i_wdata[0][10] , \i_wdata[0][9] , 
        \i_wdata[0][8] , \i_wdata[0][7] , \i_wdata[0][6] , \i_wdata[0][5] , 
        \i_wdata[0][4] , \i_wdata[0][3] , \i_wdata[0][2] , \i_wdata[0][1] , 
        \i_wdata[0][0] }), .EMA({1'b0, 1'b0, 1'b0}), .CLK(i_clk), .CEN(n3), 
        .WEN(n2) );
  CLKINVX2 U2 ( .A(i_rw), .Y(n2) );
  CLKINVX2 U3 ( .A(ce), .Y(n3) );
  CLKBUFX40 U5 ( .A(n25), .Y(\o_rdata[0][9] ) );
  CLKBUFX40 U6 ( .A(n26), .Y(\o_rdata[0][8] ) );
  CLKBUFX40 U7 ( .A(n27), .Y(\o_rdata[0][7] ) );
  CLKBUFX40 U8 ( .A(n28), .Y(\o_rdata[0][6] ) );
  CLKBUFX40 U9 ( .A(n29), .Y(\o_rdata[0][5] ) );
  CLKBUFX40 U10 ( .A(n30), .Y(\o_rdata[0][4] ) );
  CLKBUFX40 U11 ( .A(n31), .Y(\o_rdata[0][3] ) );
  CLKBUFX40 U12 ( .A(n32), .Y(\o_rdata[0][2] ) );
  CLKBUFX40 U13 ( .A(n33), .Y(\o_rdata[0][1] ) );
  CLKBUFX40 U14 ( .A(n19), .Y(\o_rdata[0][15] ) );
  CLKBUFX40 U15 ( .A(n20), .Y(\o_rdata[0][14] ) );
  CLKBUFX40 U16 ( .A(n21), .Y(\o_rdata[0][13] ) );
  CLKBUFX40 U17 ( .A(n22), .Y(\o_rdata[0][12] ) );
  CLKBUFX40 U18 ( .A(n23), .Y(\o_rdata[0][11] ) );
  CLKBUFX40 U19 ( .A(n24), .Y(\o_rdata[0][10] ) );
  CLKBUFX40 U20 ( .A(n34), .Y(\o_rdata[0][0] ) );
endmodule


module SRAM_SP_WORDWD256_DWD16_SIZE1 ( i_clk, i_rstn, i_rw, ce, i_addr, 
    .o_rdata({\o_rdata[0][15] , \o_rdata[0][14] , \o_rdata[0][13] , 
        \o_rdata[0][12] , \o_rdata[0][11] , \o_rdata[0][10] , \o_rdata[0][9] , 
        \o_rdata[0][8] , \o_rdata[0][7] , \o_rdata[0][6] , \o_rdata[0][5] , 
        \o_rdata[0][4] , \o_rdata[0][3] , \o_rdata[0][2] , \o_rdata[0][1] , 
        \o_rdata[0][0] }), .i_wdata({\i_wdata[0][15] , \i_wdata[0][14] , 
        \i_wdata[0][13] , \i_wdata[0][12] , \i_wdata[0][11] , \i_wdata[0][10] , 
        \i_wdata[0][9] , \i_wdata[0][8] , \i_wdata[0][7] , \i_wdata[0][6] , 
        \i_wdata[0][5] , \i_wdata[0][4] , \i_wdata[0][3] , \i_wdata[0][2] , 
        \i_wdata[0][1] , \i_wdata[0][0] }) );
  input [7:0] i_addr;
  input i_clk, i_rstn, i_rw, ce, \i_wdata[0][15] , \i_wdata[0][14] ,
         \i_wdata[0][13] , \i_wdata[0][12] , \i_wdata[0][11] ,
         \i_wdata[0][10] , \i_wdata[0][9] , \i_wdata[0][8] , \i_wdata[0][7] ,
         \i_wdata[0][6] , \i_wdata[0][5] , \i_wdata[0][4] , \i_wdata[0][3] ,
         \i_wdata[0][2] , \i_wdata[0][1] , \i_wdata[0][0] ;
  output \o_rdata[0][15] , \o_rdata[0][14] , \o_rdata[0][13] ,
         \o_rdata[0][12] , \o_rdata[0][11] , \o_rdata[0][10] , \o_rdata[0][9] ,
         \o_rdata[0][8] , \o_rdata[0][7] , \o_rdata[0][6] , \o_rdata[0][5] ,
         \o_rdata[0][4] , \o_rdata[0][3] , \o_rdata[0][2] , \o_rdata[0][1] ,
         \o_rdata[0][0] ;
  wire   n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n2, n3;

  SRAM_SP_256x16 \syn_mode.rf_instance[0].genblk1.SRAM256x16  ( .Q({n19, n20, 
        n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34}), 
        .A(i_addr), .D({\i_wdata[0][15] , \i_wdata[0][14] , \i_wdata[0][13] , 
        \i_wdata[0][12] , \i_wdata[0][11] , \i_wdata[0][10] , \i_wdata[0][9] , 
        \i_wdata[0][8] , \i_wdata[0][7] , \i_wdata[0][6] , \i_wdata[0][5] , 
        \i_wdata[0][4] , \i_wdata[0][3] , \i_wdata[0][2] , \i_wdata[0][1] , 
        \i_wdata[0][0] }), .EMA({1'b0, 1'b0, 1'b0}), .CLK(i_clk), .CEN(n3), 
        .WEN(n2) );
  CLKINVX2 U2 ( .A(i_rw), .Y(n2) );
  CLKINVX2 U3 ( .A(ce), .Y(n3) );
  CLKBUFX40 U5 ( .A(n25), .Y(\o_rdata[0][9] ) );
  CLKBUFX40 U6 ( .A(n26), .Y(\o_rdata[0][8] ) );
  CLKBUFX40 U7 ( .A(n27), .Y(\o_rdata[0][7] ) );
  CLKBUFX40 U8 ( .A(n28), .Y(\o_rdata[0][6] ) );
  CLKBUFX40 U9 ( .A(n29), .Y(\o_rdata[0][5] ) );
  CLKBUFX40 U10 ( .A(n30), .Y(\o_rdata[0][4] ) );
  CLKBUFX40 U11 ( .A(n31), .Y(\o_rdata[0][3] ) );
  CLKBUFX40 U12 ( .A(n32), .Y(\o_rdata[0][2] ) );
  CLKBUFX40 U13 ( .A(n33), .Y(\o_rdata[0][1] ) );
  CLKBUFX40 U14 ( .A(n19), .Y(\o_rdata[0][15] ) );
  CLKBUFX40 U15 ( .A(n20), .Y(\o_rdata[0][14] ) );
  CLKBUFX40 U16 ( .A(n21), .Y(\o_rdata[0][13] ) );
  CLKBUFX40 U17 ( .A(n22), .Y(\o_rdata[0][12] ) );
  CLKBUFX40 U18 ( .A(n23), .Y(\o_rdata[0][11] ) );
  CLKBUFX40 U19 ( .A(n24), .Y(\o_rdata[0][10] ) );
  CLKBUFX40 U20 ( .A(n34), .Y(\o_rdata[0][0] ) );
endmodule


module SRAM_SP_WORDWD800_DWD32_SIZE2_1 ( i_clk, i_rstn, i_rw, ce, i_addr, 
    .o_rdata({\o_rdata[0][31] , \o_rdata[0][30] , \o_rdata[0][29] , 
        \o_rdata[0][28] , \o_rdata[0][27] , \o_rdata[0][26] , \o_rdata[0][25] , 
        \o_rdata[0][24] , \o_rdata[0][23] , \o_rdata[0][22] , \o_rdata[0][21] , 
        \o_rdata[0][20] , \o_rdata[0][19] , \o_rdata[0][18] , \o_rdata[0][17] , 
        \o_rdata[0][16] , \o_rdata[0][15] , \o_rdata[0][14] , \o_rdata[0][13] , 
        \o_rdata[0][12] , \o_rdata[0][11] , \o_rdata[0][10] , \o_rdata[0][9] , 
        \o_rdata[0][8] , \o_rdata[0][7] , \o_rdata[0][6] , \o_rdata[0][5] , 
        \o_rdata[0][4] , \o_rdata[0][3] , \o_rdata[0][2] , \o_rdata[0][1] , 
        \o_rdata[0][0] , \o_rdata[1][31] , \o_rdata[1][30] , \o_rdata[1][29] , 
        \o_rdata[1][28] , \o_rdata[1][27] , \o_rdata[1][26] , \o_rdata[1][25] , 
        \o_rdata[1][24] , \o_rdata[1][23] , \o_rdata[1][22] , \o_rdata[1][21] , 
        \o_rdata[1][20] , \o_rdata[1][19] , \o_rdata[1][18] , \o_rdata[1][17] , 
        \o_rdata[1][16] , \o_rdata[1][15] , \o_rdata[1][14] , \o_rdata[1][13] , 
        \o_rdata[1][12] , \o_rdata[1][11] , \o_rdata[1][10] , \o_rdata[1][9] , 
        \o_rdata[1][8] , \o_rdata[1][7] , \o_rdata[1][6] , \o_rdata[1][5] , 
        \o_rdata[1][4] , \o_rdata[1][3] , \o_rdata[1][2] , \o_rdata[1][1] , 
        \o_rdata[1][0] }), .i_wdata({\i_wdata[0][31] , \i_wdata[0][30] , 
        \i_wdata[0][29] , \i_wdata[0][28] , \i_wdata[0][27] , \i_wdata[0][26] , 
        \i_wdata[0][25] , \i_wdata[0][24] , \i_wdata[0][23] , \i_wdata[0][22] , 
        \i_wdata[0][21] , \i_wdata[0][20] , \i_wdata[0][19] , \i_wdata[0][18] , 
        \i_wdata[0][17] , \i_wdata[0][16] , \i_wdata[0][15] , \i_wdata[0][14] , 
        \i_wdata[0][13] , \i_wdata[0][12] , \i_wdata[0][11] , \i_wdata[0][10] , 
        \i_wdata[0][9] , \i_wdata[0][8] , \i_wdata[0][7] , \i_wdata[0][6] , 
        \i_wdata[0][5] , \i_wdata[0][4] , \i_wdata[0][3] , \i_wdata[0][2] , 
        \i_wdata[0][1] , \i_wdata[0][0] , \i_wdata[1][31] , \i_wdata[1][30] , 
        \i_wdata[1][29] , \i_wdata[1][28] , \i_wdata[1][27] , \i_wdata[1][26] , 
        \i_wdata[1][25] , \i_wdata[1][24] , \i_wdata[1][23] , \i_wdata[1][22] , 
        \i_wdata[1][21] , \i_wdata[1][20] , \i_wdata[1][19] , \i_wdata[1][18] , 
        \i_wdata[1][17] , \i_wdata[1][16] , \i_wdata[1][15] , \i_wdata[1][14] , 
        \i_wdata[1][13] , \i_wdata[1][12] , \i_wdata[1][11] , \i_wdata[1][10] , 
        \i_wdata[1][9] , \i_wdata[1][8] , \i_wdata[1][7] , \i_wdata[1][6] , 
        \i_wdata[1][5] , \i_wdata[1][4] , \i_wdata[1][3] , \i_wdata[1][2] , 
        \i_wdata[1][1] , \i_wdata[1][0] }) );
  input [9:0] i_addr;
  input i_clk, i_rstn, i_rw, ce, \i_wdata[0][31] , \i_wdata[0][30] ,
         \i_wdata[0][29] , \i_wdata[0][28] , \i_wdata[0][27] ,
         \i_wdata[0][26] , \i_wdata[0][25] , \i_wdata[0][24] ,
         \i_wdata[0][23] , \i_wdata[0][22] , \i_wdata[0][21] ,
         \i_wdata[0][20] , \i_wdata[0][19] , \i_wdata[0][18] ,
         \i_wdata[0][17] , \i_wdata[0][16] , \i_wdata[0][15] ,
         \i_wdata[0][14] , \i_wdata[0][13] , \i_wdata[0][12] ,
         \i_wdata[0][11] , \i_wdata[0][10] , \i_wdata[0][9] , \i_wdata[0][8] ,
         \i_wdata[0][7] , \i_wdata[0][6] , \i_wdata[0][5] , \i_wdata[0][4] ,
         \i_wdata[0][3] , \i_wdata[0][2] , \i_wdata[0][1] , \i_wdata[0][0] ,
         \i_wdata[1][31] , \i_wdata[1][30] , \i_wdata[1][29] ,
         \i_wdata[1][28] , \i_wdata[1][27] , \i_wdata[1][26] ,
         \i_wdata[1][25] , \i_wdata[1][24] , \i_wdata[1][23] ,
         \i_wdata[1][22] , \i_wdata[1][21] , \i_wdata[1][20] ,
         \i_wdata[1][19] , \i_wdata[1][18] , \i_wdata[1][17] ,
         \i_wdata[1][16] , \i_wdata[1][15] , \i_wdata[1][14] ,
         \i_wdata[1][13] , \i_wdata[1][12] , \i_wdata[1][11] ,
         \i_wdata[1][10] , \i_wdata[1][9] , \i_wdata[1][8] , \i_wdata[1][7] ,
         \i_wdata[1][6] , \i_wdata[1][5] , \i_wdata[1][4] , \i_wdata[1][3] ,
         \i_wdata[1][2] , \i_wdata[1][1] , \i_wdata[1][0] ;
  output \o_rdata[0][31] , \o_rdata[0][30] , \o_rdata[0][29] ,
         \o_rdata[0][28] , \o_rdata[0][27] , \o_rdata[0][26] ,
         \o_rdata[0][25] , \o_rdata[0][24] , \o_rdata[0][23] ,
         \o_rdata[0][22] , \o_rdata[0][21] , \o_rdata[0][20] ,
         \o_rdata[0][19] , \o_rdata[0][18] , \o_rdata[0][17] ,
         \o_rdata[0][16] , \o_rdata[0][15] , \o_rdata[0][14] ,
         \o_rdata[0][13] , \o_rdata[0][12] , \o_rdata[0][11] ,
         \o_rdata[0][10] , \o_rdata[0][9] , \o_rdata[0][8] , \o_rdata[0][7] ,
         \o_rdata[0][6] , \o_rdata[0][5] , \o_rdata[0][4] , \o_rdata[0][3] ,
         \o_rdata[0][2] , \o_rdata[0][1] , \o_rdata[0][0] , \o_rdata[1][31] ,
         \o_rdata[1][30] , \o_rdata[1][29] , \o_rdata[1][28] ,
         \o_rdata[1][27] , \o_rdata[1][26] , \o_rdata[1][25] ,
         \o_rdata[1][24] , \o_rdata[1][23] , \o_rdata[1][22] ,
         \o_rdata[1][21] , \o_rdata[1][20] , \o_rdata[1][19] ,
         \o_rdata[1][18] , \o_rdata[1][17] , \o_rdata[1][16] ,
         \o_rdata[1][15] , \o_rdata[1][14] , \o_rdata[1][13] ,
         \o_rdata[1][12] , \o_rdata[1][11] , \o_rdata[1][10] , \o_rdata[1][9] ,
         \o_rdata[1][8] , \o_rdata[1][7] , \o_rdata[1][6] , \o_rdata[1][5] ,
         \o_rdata[1][4] , \o_rdata[1][3] , \o_rdata[1][2] , \o_rdata[1][1] ,
         \o_rdata[1][0] ;
  wire   n2, n3;

  SRAM_SP_800x32 \syn_mode.rf_instance[0].genblk1.SRAM800x32  ( .Q({
        \o_rdata[0][31] , \o_rdata[0][30] , \o_rdata[0][29] , \o_rdata[0][28] , 
        \o_rdata[0][27] , \o_rdata[0][26] , \o_rdata[0][25] , \o_rdata[0][24] , 
        \o_rdata[0][23] , \o_rdata[0][22] , \o_rdata[0][21] , \o_rdata[0][20] , 
        \o_rdata[0][19] , \o_rdata[0][18] , \o_rdata[0][17] , \o_rdata[0][16] , 
        \o_rdata[0][15] , \o_rdata[0][14] , \o_rdata[0][13] , \o_rdata[0][12] , 
        \o_rdata[0][11] , \o_rdata[0][10] , \o_rdata[0][9] , \o_rdata[0][8] , 
        \o_rdata[0][7] , \o_rdata[0][6] , \o_rdata[0][5] , \o_rdata[0][4] , 
        \o_rdata[0][3] , \o_rdata[0][2] , \o_rdata[0][1] , \o_rdata[0][0] }), 
        .A(i_addr), .D({\i_wdata[0][31] , \i_wdata[0][30] , \i_wdata[0][29] , 
        \i_wdata[0][28] , \i_wdata[0][27] , \i_wdata[0][26] , \i_wdata[0][25] , 
        \i_wdata[0][24] , \i_wdata[0][23] , \i_wdata[0][22] , \i_wdata[0][21] , 
        \i_wdata[0][20] , \i_wdata[0][19] , \i_wdata[0][18] , \i_wdata[0][17] , 
        \i_wdata[0][16] , \i_wdata[0][15] , \i_wdata[0][14] , \i_wdata[0][13] , 
        \i_wdata[0][12] , \i_wdata[0][11] , \i_wdata[0][10] , \i_wdata[0][9] , 
        \i_wdata[0][8] , \i_wdata[0][7] , \i_wdata[0][6] , \i_wdata[0][5] , 
        \i_wdata[0][4] , \i_wdata[0][3] , \i_wdata[0][2] , \i_wdata[0][1] , 
        \i_wdata[0][0] }), .EMA({1'b0, 1'b0, 1'b0}), .CLK(i_clk), .CEN(n3), 
        .WEN(n2) );
  SRAM_SP_800x32 \syn_mode.rf_instance[1].genblk1.SRAM800x32  ( .Q({
        \o_rdata[1][31] , \o_rdata[1][30] , \o_rdata[1][29] , \o_rdata[1][28] , 
        \o_rdata[1][27] , \o_rdata[1][26] , \o_rdata[1][25] , \o_rdata[1][24] , 
        \o_rdata[1][23] , \o_rdata[1][22] , \o_rdata[1][21] , \o_rdata[1][20] , 
        \o_rdata[1][19] , \o_rdata[1][18] , \o_rdata[1][17] , \o_rdata[1][16] , 
        \o_rdata[1][15] , \o_rdata[1][14] , \o_rdata[1][13] , \o_rdata[1][12] , 
        \o_rdata[1][11] , \o_rdata[1][10] , \o_rdata[1][9] , \o_rdata[1][8] , 
        \o_rdata[1][7] , \o_rdata[1][6] , \o_rdata[1][5] , \o_rdata[1][4] , 
        \o_rdata[1][3] , \o_rdata[1][2] , \o_rdata[1][1] , \o_rdata[1][0] }), 
        .A(i_addr), .D({\i_wdata[1][31] , \i_wdata[1][30] , \i_wdata[1][29] , 
        \i_wdata[1][28] , \i_wdata[1][27] , \i_wdata[1][26] , \i_wdata[1][25] , 
        \i_wdata[1][24] , \i_wdata[1][23] , \i_wdata[1][22] , \i_wdata[1][21] , 
        \i_wdata[1][20] , \i_wdata[1][19] , \i_wdata[1][18] , \i_wdata[1][17] , 
        \i_wdata[1][16] , \i_wdata[1][15] , \i_wdata[1][14] , \i_wdata[1][13] , 
        \i_wdata[1][12] , \i_wdata[1][11] , \i_wdata[1][10] , \i_wdata[1][9] , 
        \i_wdata[1][8] , \i_wdata[1][7] , \i_wdata[1][6] , \i_wdata[1][5] , 
        \i_wdata[1][4] , \i_wdata[1][3] , \i_wdata[1][2] , \i_wdata[1][1] , 
        \i_wdata[1][0] }), .EMA({1'b0, 1'b0, 1'b0}), .CLK(i_clk), .CEN(n3), 
        .WEN(n2) );
  CLKINVX2 U2 ( .A(i_rw), .Y(n2) );
  CLKINVX2 U3 ( .A(ce), .Y(n3) );
endmodule


module SNPS_CLOCK_GATE_HIGH_BufferTest_0 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  TLATNTSCAX2 latch ( .E(EN), .SE(TE), .CK(CLK), .ECK(ENCLK) );
endmodule


module SRAM_SP_WORDWD800_DWD32_SIZE2_0 ( i_clk, i_rstn, i_rw, ce, i_addr, 
    .o_rdata({\o_rdata[0][31] , \o_rdata[0][30] , \o_rdata[0][29] , 
        \o_rdata[0][28] , \o_rdata[0][27] , \o_rdata[0][26] , \o_rdata[0][25] , 
        \o_rdata[0][24] , \o_rdata[0][23] , \o_rdata[0][22] , \o_rdata[0][21] , 
        \o_rdata[0][20] , \o_rdata[0][19] , \o_rdata[0][18] , \o_rdata[0][17] , 
        \o_rdata[0][16] , \o_rdata[0][15] , \o_rdata[0][14] , \o_rdata[0][13] , 
        \o_rdata[0][12] , \o_rdata[0][11] , \o_rdata[0][10] , \o_rdata[0][9] , 
        \o_rdata[0][8] , \o_rdata[0][7] , \o_rdata[0][6] , \o_rdata[0][5] , 
        \o_rdata[0][4] , \o_rdata[0][3] , \o_rdata[0][2] , \o_rdata[0][1] , 
        \o_rdata[0][0] , \o_rdata[1][31] , \o_rdata[1][30] , \o_rdata[1][29] , 
        \o_rdata[1][28] , \o_rdata[1][27] , \o_rdata[1][26] , \o_rdata[1][25] , 
        \o_rdata[1][24] , \o_rdata[1][23] , \o_rdata[1][22] , \o_rdata[1][21] , 
        \o_rdata[1][20] , \o_rdata[1][19] , \o_rdata[1][18] , \o_rdata[1][17] , 
        \o_rdata[1][16] , \o_rdata[1][15] , \o_rdata[1][14] , \o_rdata[1][13] , 
        \o_rdata[1][12] , \o_rdata[1][11] , \o_rdata[1][10] , \o_rdata[1][9] , 
        \o_rdata[1][8] , \o_rdata[1][7] , \o_rdata[1][6] , \o_rdata[1][5] , 
        \o_rdata[1][4] , \o_rdata[1][3] , \o_rdata[1][2] , \o_rdata[1][1] , 
        \o_rdata[1][0] }), .i_wdata({\i_wdata[0][31] , \i_wdata[0][30] , 
        \i_wdata[0][29] , \i_wdata[0][28] , \i_wdata[0][27] , \i_wdata[0][26] , 
        \i_wdata[0][25] , \i_wdata[0][24] , \i_wdata[0][23] , \i_wdata[0][22] , 
        \i_wdata[0][21] , \i_wdata[0][20] , \i_wdata[0][19] , \i_wdata[0][18] , 
        \i_wdata[0][17] , \i_wdata[0][16] , \i_wdata[0][15] , \i_wdata[0][14] , 
        \i_wdata[0][13] , \i_wdata[0][12] , \i_wdata[0][11] , \i_wdata[0][10] , 
        \i_wdata[0][9] , \i_wdata[0][8] , \i_wdata[0][7] , \i_wdata[0][6] , 
        \i_wdata[0][5] , \i_wdata[0][4] , \i_wdata[0][3] , \i_wdata[0][2] , 
        \i_wdata[0][1] , \i_wdata[0][0] , \i_wdata[1][31] , \i_wdata[1][30] , 
        \i_wdata[1][29] , \i_wdata[1][28] , \i_wdata[1][27] , \i_wdata[1][26] , 
        \i_wdata[1][25] , \i_wdata[1][24] , \i_wdata[1][23] , \i_wdata[1][22] , 
        \i_wdata[1][21] , \i_wdata[1][20] , \i_wdata[1][19] , \i_wdata[1][18] , 
        \i_wdata[1][17] , \i_wdata[1][16] , \i_wdata[1][15] , \i_wdata[1][14] , 
        \i_wdata[1][13] , \i_wdata[1][12] , \i_wdata[1][11] , \i_wdata[1][10] , 
        \i_wdata[1][9] , \i_wdata[1][8] , \i_wdata[1][7] , \i_wdata[1][6] , 
        \i_wdata[1][5] , \i_wdata[1][4] , \i_wdata[1][3] , \i_wdata[1][2] , 
        \i_wdata[1][1] , \i_wdata[1][0] }) );
  input [9:0] i_addr;
  input i_clk, i_rstn, i_rw, ce, \i_wdata[0][31] , \i_wdata[0][30] ,
         \i_wdata[0][29] , \i_wdata[0][28] , \i_wdata[0][27] ,
         \i_wdata[0][26] , \i_wdata[0][25] , \i_wdata[0][24] ,
         \i_wdata[0][23] , \i_wdata[0][22] , \i_wdata[0][21] ,
         \i_wdata[0][20] , \i_wdata[0][19] , \i_wdata[0][18] ,
         \i_wdata[0][17] , \i_wdata[0][16] , \i_wdata[0][15] ,
         \i_wdata[0][14] , \i_wdata[0][13] , \i_wdata[0][12] ,
         \i_wdata[0][11] , \i_wdata[0][10] , \i_wdata[0][9] , \i_wdata[0][8] ,
         \i_wdata[0][7] , \i_wdata[0][6] , \i_wdata[0][5] , \i_wdata[0][4] ,
         \i_wdata[0][3] , \i_wdata[0][2] , \i_wdata[0][1] , \i_wdata[0][0] ,
         \i_wdata[1][31] , \i_wdata[1][30] , \i_wdata[1][29] ,
         \i_wdata[1][28] , \i_wdata[1][27] , \i_wdata[1][26] ,
         \i_wdata[1][25] , \i_wdata[1][24] , \i_wdata[1][23] ,
         \i_wdata[1][22] , \i_wdata[1][21] , \i_wdata[1][20] ,
         \i_wdata[1][19] , \i_wdata[1][18] , \i_wdata[1][17] ,
         \i_wdata[1][16] , \i_wdata[1][15] , \i_wdata[1][14] ,
         \i_wdata[1][13] , \i_wdata[1][12] , \i_wdata[1][11] ,
         \i_wdata[1][10] , \i_wdata[1][9] , \i_wdata[1][8] , \i_wdata[1][7] ,
         \i_wdata[1][6] , \i_wdata[1][5] , \i_wdata[1][4] , \i_wdata[1][3] ,
         \i_wdata[1][2] , \i_wdata[1][1] , \i_wdata[1][0] ;
  output \o_rdata[0][31] , \o_rdata[0][30] , \o_rdata[0][29] ,
         \o_rdata[0][28] , \o_rdata[0][27] , \o_rdata[0][26] ,
         \o_rdata[0][25] , \o_rdata[0][24] , \o_rdata[0][23] ,
         \o_rdata[0][22] , \o_rdata[0][21] , \o_rdata[0][20] ,
         \o_rdata[0][19] , \o_rdata[0][18] , \o_rdata[0][17] ,
         \o_rdata[0][16] , \o_rdata[0][15] , \o_rdata[0][14] ,
         \o_rdata[0][13] , \o_rdata[0][12] , \o_rdata[0][11] ,
         \o_rdata[0][10] , \o_rdata[0][9] , \o_rdata[0][8] , \o_rdata[0][7] ,
         \o_rdata[0][6] , \o_rdata[0][5] , \o_rdata[0][4] , \o_rdata[0][3] ,
         \o_rdata[0][2] , \o_rdata[0][1] , \o_rdata[0][0] , \o_rdata[1][31] ,
         \o_rdata[1][30] , \o_rdata[1][29] , \o_rdata[1][28] ,
         \o_rdata[1][27] , \o_rdata[1][26] , \o_rdata[1][25] ,
         \o_rdata[1][24] , \o_rdata[1][23] , \o_rdata[1][22] ,
         \o_rdata[1][21] , \o_rdata[1][20] , \o_rdata[1][19] ,
         \o_rdata[1][18] , \o_rdata[1][17] , \o_rdata[1][16] ,
         \o_rdata[1][15] , \o_rdata[1][14] , \o_rdata[1][13] ,
         \o_rdata[1][12] , \o_rdata[1][11] , \o_rdata[1][10] , \o_rdata[1][9] ,
         \o_rdata[1][8] , \o_rdata[1][7] , \o_rdata[1][6] , \o_rdata[1][5] ,
         \o_rdata[1][4] , \o_rdata[1][3] , \o_rdata[1][2] , \o_rdata[1][1] ,
         \o_rdata[1][0] ;
  wire   n1, n3;

  SRAM_SP_800x32 \syn_mode.rf_instance[0].genblk1.SRAM800x32  ( .Q({
        \o_rdata[0][31] , \o_rdata[0][30] , \o_rdata[0][29] , \o_rdata[0][28] , 
        \o_rdata[0][27] , \o_rdata[0][26] , \o_rdata[0][25] , \o_rdata[0][24] , 
        \o_rdata[0][23] , \o_rdata[0][22] , \o_rdata[0][21] , \o_rdata[0][20] , 
        \o_rdata[0][19] , \o_rdata[0][18] , \o_rdata[0][17] , \o_rdata[0][16] , 
        \o_rdata[0][15] , \o_rdata[0][14] , \o_rdata[0][13] , \o_rdata[0][12] , 
        \o_rdata[0][11] , \o_rdata[0][10] , \o_rdata[0][9] , \o_rdata[0][8] , 
        \o_rdata[0][7] , \o_rdata[0][6] , \o_rdata[0][5] , \o_rdata[0][4] , 
        \o_rdata[0][3] , \o_rdata[0][2] , \o_rdata[0][1] , \o_rdata[0][0] }), 
        .A(i_addr), .D({\i_wdata[0][31] , \i_wdata[0][30] , \i_wdata[0][29] , 
        \i_wdata[0][28] , \i_wdata[0][27] , \i_wdata[0][26] , \i_wdata[0][25] , 
        \i_wdata[0][24] , \i_wdata[0][23] , \i_wdata[0][22] , \i_wdata[0][21] , 
        \i_wdata[0][20] , \i_wdata[0][19] , \i_wdata[0][18] , \i_wdata[0][17] , 
        \i_wdata[0][16] , \i_wdata[0][15] , \i_wdata[0][14] , \i_wdata[0][13] , 
        \i_wdata[0][12] , \i_wdata[0][11] , \i_wdata[0][10] , \i_wdata[0][9] , 
        \i_wdata[0][8] , \i_wdata[0][7] , \i_wdata[0][6] , \i_wdata[0][5] , 
        \i_wdata[0][4] , \i_wdata[0][3] , \i_wdata[0][2] , \i_wdata[0][1] , 
        \i_wdata[0][0] }), .EMA({1'b0, 1'b0, 1'b0}), .CLK(i_clk), .CEN(n1), 
        .WEN(n3) );
  SRAM_SP_800x32 \syn_mode.rf_instance[1].genblk1.SRAM800x32  ( .Q({
        \o_rdata[1][31] , \o_rdata[1][30] , \o_rdata[1][29] , \o_rdata[1][28] , 
        \o_rdata[1][27] , \o_rdata[1][26] , \o_rdata[1][25] , \o_rdata[1][24] , 
        \o_rdata[1][23] , \o_rdata[1][22] , \o_rdata[1][21] , \o_rdata[1][20] , 
        \o_rdata[1][19] , \o_rdata[1][18] , \o_rdata[1][17] , \o_rdata[1][16] , 
        \o_rdata[1][15] , \o_rdata[1][14] , \o_rdata[1][13] , \o_rdata[1][12] , 
        \o_rdata[1][11] , \o_rdata[1][10] , \o_rdata[1][9] , \o_rdata[1][8] , 
        \o_rdata[1][7] , \o_rdata[1][6] , \o_rdata[1][5] , \o_rdata[1][4] , 
        \o_rdata[1][3] , \o_rdata[1][2] , \o_rdata[1][1] , \o_rdata[1][0] }), 
        .A(i_addr), .D({\i_wdata[1][31] , \i_wdata[1][30] , \i_wdata[1][29] , 
        \i_wdata[1][28] , \i_wdata[1][27] , \i_wdata[1][26] , \i_wdata[1][25] , 
        \i_wdata[1][24] , \i_wdata[1][23] , \i_wdata[1][22] , \i_wdata[1][21] , 
        \i_wdata[1][20] , \i_wdata[1][19] , \i_wdata[1][18] , \i_wdata[1][17] , 
        \i_wdata[1][16] , \i_wdata[1][15] , \i_wdata[1][14] , \i_wdata[1][13] , 
        \i_wdata[1][12] , \i_wdata[1][11] , \i_wdata[1][10] , \i_wdata[1][9] , 
        \i_wdata[1][8] , \i_wdata[1][7] , \i_wdata[1][6] , \i_wdata[1][5] , 
        \i_wdata[1][4] , \i_wdata[1][3] , \i_wdata[1][2] , \i_wdata[1][1] , 
        \i_wdata[1][0] }), .EMA({1'b0, 1'b0, 1'b0}), .CLK(i_clk), .CEN(n1), 
        .WEN(n3) );
  CLKINVX2 U2 ( .A(i_rw), .Y(n3) );
  CLKINVX2 U3 ( .A(ce), .Y(n1) );
endmodule


module SNPS_CLOCK_GATE_HIGH_BufferTest_1 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;
  wire   n2;
  assign n2 = CLK;

  TLATNTSCAX2 latch ( .E(EN), .SE(TE), .CK(n2), .ECK(ENCLK) );
endmodule


module SNPS_CLOCK_GATE_HIGH_BufferTest_2 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;
  wire   n2;
  assign n2 = CLK;

  TLATNTSCAX2 latch ( .E(EN), .SE(TE), .CK(n2), .ECK(ENCLK) );
endmodule


module BufferTest ( i_clk, i_rstn, .i_Input({\i_Input[0][15] , 
        \i_Input[0][14] , \i_Input[0][13] , \i_Input[0][12] , \i_Input[0][11] , 
        \i_Input[0][10] , \i_Input[0][9] , \i_Input[0][8] , \i_Input[0][7] , 
        \i_Input[0][6] , \i_Input[0][5] , \i_Input[0][4] , \i_Input[0][3] , 
        \i_Input[0][2] , \i_Input[0][1] , \i_Input[0][0] }), .i_Weight({
        \i_Weight[0][15] , \i_Weight[0][14] , \i_Weight[0][13] , 
        \i_Weight[0][12] , \i_Weight[0][11] , \i_Weight[0][10] , 
        \i_Weight[0][9] , \i_Weight[0][8] , \i_Weight[0][7] , \i_Weight[0][6] , 
        \i_Weight[0][5] , \i_Weight[0][4] , \i_Weight[0][3] , \i_Weight[0][2] , 
        \i_Weight[0][1] , \i_Weight[0][0] }), .i_GB({\i_GB[0][31] , 
        \i_GB[0][30] , \i_GB[0][29] , \i_GB[0][28] , \i_GB[0][27] , 
        \i_GB[0][26] , \i_GB[0][25] , \i_GB[0][24] , \i_GB[0][23] , 
        \i_GB[0][22] , \i_GB[0][21] , \i_GB[0][20] , \i_GB[0][19] , 
        \i_GB[0][18] , \i_GB[0][17] , \i_GB[0][16] , \i_GB[0][15] , 
        \i_GB[0][14] , \i_GB[0][13] , \i_GB[0][12] , \i_GB[0][11] , 
        \i_GB[0][10] , \i_GB[0][9] , \i_GB[0][8] , \i_GB[0][7] , \i_GB[0][6] , 
        \i_GB[0][5] , \i_GB[0][4] , \i_GB[0][3] , \i_GB[0][2] , \i_GB[0][1] , 
        \i_GB[0][0] , \i_GB[1][31] , \i_GB[1][30] , \i_GB[1][29] , 
        \i_GB[1][28] , \i_GB[1][27] , \i_GB[1][26] , \i_GB[1][25] , 
        \i_GB[1][24] , \i_GB[1][23] , \i_GB[1][22] , \i_GB[1][21] , 
        \i_GB[1][20] , \i_GB[1][19] , \i_GB[1][18] , \i_GB[1][17] , 
        \i_GB[1][16] , \i_GB[1][15] , \i_GB[1][14] , \i_GB[1][13] , 
        \i_GB[1][12] , \i_GB[1][11] , \i_GB[1][10] , \i_GB[1][9] , 
        \i_GB[1][8] , \i_GB[1][7] , \i_GB[1][6] , \i_GB[1][5] , \i_GB[1][4] , 
        \i_GB[1][3] , \i_GB[1][2] , \i_GB[1][1] , \i_GB[1][0] }), r_Input_ack, 
        r_Input_rdy, r_Weight_ack, r_Weight_rdy, r_GB_ack, r_GB_rdy, 
        w_Input_ack, w_Input_rdy, w_Weight_ack, w_Weight_rdy, w_GB_ack, 
        w_GB_rdy, .o_Input({\o_Input[0][15] , \o_Input[0][14] , 
        \o_Input[0][13] , \o_Input[0][12] , \o_Input[0][11] , \o_Input[0][10] , 
        \o_Input[0][9] , \o_Input[0][8] , \o_Input[0][7] , \o_Input[0][6] , 
        \o_Input[0][5] , \o_Input[0][4] , \o_Input[0][3] , \o_Input[0][2] , 
        \o_Input[0][1] , \o_Input[0][0] }), .o_Weight({\o_Weight[0][15] , 
        \o_Weight[0][14] , \o_Weight[0][13] , \o_Weight[0][12] , 
        \o_Weight[0][11] , \o_Weight[0][10] , \o_Weight[0][9] , 
        \o_Weight[0][8] , \o_Weight[0][7] , \o_Weight[0][6] , \o_Weight[0][5] , 
        \o_Weight[0][4] , \o_Weight[0][3] , \o_Weight[0][2] , \o_Weight[0][1] , 
        \o_Weight[0][0] }), .o_GB({\o_GB[0][31] , \o_GB[0][30] , \o_GB[0][29] , 
        \o_GB[0][28] , \o_GB[0][27] , \o_GB[0][26] , \o_GB[0][25] , 
        \o_GB[0][24] , \o_GB[0][23] , \o_GB[0][22] , \o_GB[0][21] , 
        \o_GB[0][20] , \o_GB[0][19] , \o_GB[0][18] , \o_GB[0][17] , 
        \o_GB[0][16] , \o_GB[0][15] , \o_GB[0][14] , \o_GB[0][13] , 
        \o_GB[0][12] , \o_GB[0][11] , \o_GB[0][10] , \o_GB[0][9] , 
        \o_GB[0][8] , \o_GB[0][7] , \o_GB[0][6] , \o_GB[0][5] , \o_GB[0][4] , 
        \o_GB[0][3] , \o_GB[0][2] , \o_GB[0][1] , \o_GB[0][0] , \o_GB[1][31] , 
        \o_GB[1][30] , \o_GB[1][29] , \o_GB[1][28] , \o_GB[1][27] , 
        \o_GB[1][26] , \o_GB[1][25] , \o_GB[1][24] , \o_GB[1][23] , 
        \o_GB[1][22] , \o_GB[1][21] , \o_GB[1][20] , \o_GB[1][19] , 
        \o_GB[1][18] , \o_GB[1][17] , \o_GB[1][16] , \o_GB[1][15] , 
        \o_GB[1][14] , \o_GB[1][13] , \o_GB[1][12] , \o_GB[1][11] , 
        \o_GB[1][10] , \o_GB[1][9] , \o_GB[1][8] , \o_GB[1][7] , \o_GB[1][6] , 
        \o_GB[1][5] , \o_GB[1][4] , \o_GB[1][3] , \o_GB[1][2] , \o_GB[1][1] , 
        \o_GB[1][0] }) );
  input i_clk, i_rstn, \i_Input[0][15] , \i_Input[0][14] , \i_Input[0][13] ,
         \i_Input[0][12] , \i_Input[0][11] , \i_Input[0][10] , \i_Input[0][9] ,
         \i_Input[0][8] , \i_Input[0][7] , \i_Input[0][6] , \i_Input[0][5] ,
         \i_Input[0][4] , \i_Input[0][3] , \i_Input[0][2] , \i_Input[0][1] ,
         \i_Input[0][0] , \i_Weight[0][15] , \i_Weight[0][14] ,
         \i_Weight[0][13] , \i_Weight[0][12] , \i_Weight[0][11] ,
         \i_Weight[0][10] , \i_Weight[0][9] , \i_Weight[0][8] ,
         \i_Weight[0][7] , \i_Weight[0][6] , \i_Weight[0][5] ,
         \i_Weight[0][4] , \i_Weight[0][3] , \i_Weight[0][2] ,
         \i_Weight[0][1] , \i_Weight[0][0] , \i_GB[0][31] , \i_GB[0][30] ,
         \i_GB[0][29] , \i_GB[0][28] , \i_GB[0][27] , \i_GB[0][26] ,
         \i_GB[0][25] , \i_GB[0][24] , \i_GB[0][23] , \i_GB[0][22] ,
         \i_GB[0][21] , \i_GB[0][20] , \i_GB[0][19] , \i_GB[0][18] ,
         \i_GB[0][17] , \i_GB[0][16] , \i_GB[0][15] , \i_GB[0][14] ,
         \i_GB[0][13] , \i_GB[0][12] , \i_GB[0][11] , \i_GB[0][10] ,
         \i_GB[0][9] , \i_GB[0][8] , \i_GB[0][7] , \i_GB[0][6] , \i_GB[0][5] ,
         \i_GB[0][4] , \i_GB[0][3] , \i_GB[0][2] , \i_GB[0][1] , \i_GB[0][0] ,
         \i_GB[1][31] , \i_GB[1][30] , \i_GB[1][29] , \i_GB[1][28] ,
         \i_GB[1][27] , \i_GB[1][26] , \i_GB[1][25] , \i_GB[1][24] ,
         \i_GB[1][23] , \i_GB[1][22] , \i_GB[1][21] , \i_GB[1][20] ,
         \i_GB[1][19] , \i_GB[1][18] , \i_GB[1][17] , \i_GB[1][16] ,
         \i_GB[1][15] , \i_GB[1][14] , \i_GB[1][13] , \i_GB[1][12] ,
         \i_GB[1][11] , \i_GB[1][10] , \i_GB[1][9] , \i_GB[1][8] ,
         \i_GB[1][7] , \i_GB[1][6] , \i_GB[1][5] , \i_GB[1][4] , \i_GB[1][3] ,
         \i_GB[1][2] , \i_GB[1][1] , \i_GB[1][0] , r_Input_rdy, r_Weight_rdy,
         r_GB_rdy, w_Input_rdy, w_Weight_rdy, w_GB_rdy;
  output r_Input_ack, r_Weight_ack, r_GB_ack, w_Input_ack, w_Weight_ack,
         w_GB_ack, \o_Input[0][15] , \o_Input[0][14] , \o_Input[0][13] ,
         \o_Input[0][12] , \o_Input[0][11] , \o_Input[0][10] , \o_Input[0][9] ,
         \o_Input[0][8] , \o_Input[0][7] , \o_Input[0][6] , \o_Input[0][5] ,
         \o_Input[0][4] , \o_Input[0][3] , \o_Input[0][2] , \o_Input[0][1] ,
         \o_Input[0][0] , \o_Weight[0][15] , \o_Weight[0][14] ,
         \o_Weight[0][13] , \o_Weight[0][12] , \o_Weight[0][11] ,
         \o_Weight[0][10] , \o_Weight[0][9] , \o_Weight[0][8] ,
         \o_Weight[0][7] , \o_Weight[0][6] , \o_Weight[0][5] ,
         \o_Weight[0][4] , \o_Weight[0][3] , \o_Weight[0][2] ,
         \o_Weight[0][1] , \o_Weight[0][0] , \o_GB[0][31] , \o_GB[0][30] ,
         \o_GB[0][29] , \o_GB[0][28] , \o_GB[0][27] , \o_GB[0][26] ,
         \o_GB[0][25] , \o_GB[0][24] , \o_GB[0][23] , \o_GB[0][22] ,
         \o_GB[0][21] , \o_GB[0][20] , \o_GB[0][19] , \o_GB[0][18] ,
         \o_GB[0][17] , \o_GB[0][16] , \o_GB[0][15] , \o_GB[0][14] ,
         \o_GB[0][13] , \o_GB[0][12] , \o_GB[0][11] , \o_GB[0][10] ,
         \o_GB[0][9] , \o_GB[0][8] , \o_GB[0][7] , \o_GB[0][6] , \o_GB[0][5] ,
         \o_GB[0][4] , \o_GB[0][3] , \o_GB[0][2] , \o_GB[0][1] , \o_GB[0][0] ,
         \o_GB[1][31] , \o_GB[1][30] , \o_GB[1][29] , \o_GB[1][28] ,
         \o_GB[1][27] , \o_GB[1][26] , \o_GB[1][25] , \o_GB[1][24] ,
         \o_GB[1][23] , \o_GB[1][22] , \o_GB[1][21] , \o_GB[1][20] ,
         \o_GB[1][19] , \o_GB[1][18] , \o_GB[1][17] , \o_GB[1][16] ,
         \o_GB[1][15] , \o_GB[1][14] , \o_GB[1][13] , \o_GB[1][12] ,
         \o_GB[1][11] , \o_GB[1][10] , \o_GB[1][9] , \o_GB[1][8] ,
         \o_GB[1][7] , \o_GB[1][6] , \o_GB[1][5] , \o_GB[1][4] , \o_GB[1][3] ,
         \o_GB[1][2] , \o_GB[1][1] , \o_GB[1][0] ;
  wire   N0, input_mode, N1, weight_mode, N2, gb_mode, _16_net_, _17_net_,
         _18_net_, _19_net_, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16,
         N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30,
         N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44,
         N45, N46, N47, N48, N49, N50, N51, N52, net57, net63, net68, n4, n5,
         n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n161, n162, n163, n164, n165, n166,
         n167, n168, n169, n170, n171, n172, n173, n174, n175, n176, n177,
         n178, n179, n180, n181, n182, n183, n184, n185, n186, n187, n188,
         n189, n190, n191, n192, n193, n194, n195, n196, n197, n198, n199,
         n200, n201, n202, n203, n204, n205, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n239, n240, n241, n242, n243,
         n244, n245, n246, n247, n248, n249, n250, n251, n252, n253, n254,
         n255, n256, n257, n258, n259, n260, n261, n262, n263, n264, n265,
         n266, n267, n268, n269, n270, n271, n272, n273, n274, n275, n276,
         n277, n278, n279, n280, n281, n282, n283, n284, n285, n286, n287,
         n288;
  wire   [8:0] input_addr;
  wire   [7:0] weight_addr;
  wire   [9:0] gb_addr;
  assign w_GB_ack = 1'b1;
  assign w_Weight_ack = 1'b1;
  assign w_Input_ack = 1'b1;

  SRAM_SP_WORDWD512_DWD16_SIZE1 \genblk1[0].ibuf  ( .i_clk(i_clk), .i_rstn(
        i_rstn), .i_rw(input_mode), .ce(_16_net_), .i_addr(input_addr), 
        .o_rdata({\o_Input[0][15] , \o_Input[0][14] , \o_Input[0][13] , 
        \o_Input[0][12] , \o_Input[0][11] , \o_Input[0][10] , \o_Input[0][9] , 
        \o_Input[0][8] , \o_Input[0][7] , \o_Input[0][6] , \o_Input[0][5] , 
        \o_Input[0][4] , \o_Input[0][3] , \o_Input[0][2] , \o_Input[0][1] , 
        \o_Input[0][0] }), .i_wdata({\i_Input[0][15] , \i_Input[0][14] , 
        \i_Input[0][13] , \i_Input[0][12] , \i_Input[0][11] , \i_Input[0][10] , 
        \i_Input[0][9] , \i_Input[0][8] , \i_Input[0][7] , \i_Input[0][6] , 
        \i_Input[0][5] , \i_Input[0][4] , \i_Input[0][3] , \i_Input[0][2] , 
        \i_Input[0][1] , \i_Input[0][0] }) );
  SRAM_SP_WORDWD256_DWD16_SIZE1 \genblk2[0].wbuf  ( .i_clk(i_clk), .i_rstn(
        i_rstn), .i_rw(weight_mode), .ce(_17_net_), .i_addr(weight_addr), 
        .o_rdata({\o_Weight[0][15] , \o_Weight[0][14] , \o_Weight[0][13] , 
        \o_Weight[0][12] , \o_Weight[0][11] , \o_Weight[0][10] , 
        \o_Weight[0][9] , \o_Weight[0][8] , \o_Weight[0][7] , \o_Weight[0][6] , 
        \o_Weight[0][5] , \o_Weight[0][4] , \o_Weight[0][3] , \o_Weight[0][2] , 
        \o_Weight[0][1] , \o_Weight[0][0] }), .i_wdata({\i_Weight[0][15] , 
        \i_Weight[0][14] , \i_Weight[0][13] , \i_Weight[0][12] , 
        \i_Weight[0][11] , \i_Weight[0][10] , \i_Weight[0][9] , 
        \i_Weight[0][8] , \i_Weight[0][7] , \i_Weight[0][6] , \i_Weight[0][5] , 
        \i_Weight[0][4] , \i_Weight[0][3] , \i_Weight[0][2] , \i_Weight[0][1] , 
        \i_Weight[0][0] }) );
  SRAM_SP_WORDWD800_DWD32_SIZE2_1 \genblk3[0].ibuf  ( .i_clk(i_clk), .i_rstn(
        i_rstn), .i_rw(gb_mode), .ce(_18_net_), .i_addr(gb_addr), .o_rdata({
        n287, n285, n283, n281, n279, n277, n275, n273, n271, n269, n267, n265, 
        n263, n261, n259, n257, n255, n253, n251, n249, n247, n245, n243, n241, 
        n239, n237, n235, n233, n231, n229, n227, n225, n223, n221, n219, n217, 
        n215, n213, n211, n209, n207, n205, n203, n201, n199, n197, n195, n193, 
        n191, n189, n187, n185, n183, n181, n179, n177, n175, n173, n171, n169, 
        n167, n165, n163, n161}), .i_wdata({\i_GB[0][31] , \i_GB[0][30] , 
        \i_GB[0][29] , \i_GB[0][28] , \i_GB[0][27] , \i_GB[0][26] , 
        \i_GB[0][25] , \i_GB[0][24] , \i_GB[0][23] , \i_GB[0][22] , 
        \i_GB[0][21] , \i_GB[0][20] , \i_GB[0][19] , \i_GB[0][18] , 
        \i_GB[0][17] , \i_GB[0][16] , \i_GB[0][15] , \i_GB[0][14] , 
        \i_GB[0][13] , \i_GB[0][12] , \i_GB[0][11] , \i_GB[0][10] , 
        \i_GB[0][9] , \i_GB[0][8] , \i_GB[0][7] , \i_GB[0][6] , \i_GB[0][5] , 
        \i_GB[0][4] , \i_GB[0][3] , \i_GB[0][2] , \i_GB[0][1] , \i_GB[0][0] , 
        \i_GB[1][31] , \i_GB[1][30] , \i_GB[1][29] , \i_GB[1][28] , 
        \i_GB[1][27] , \i_GB[1][26] , \i_GB[1][25] , \i_GB[1][24] , 
        \i_GB[1][23] , \i_GB[1][22] , \i_GB[1][21] , \i_GB[1][20] , 
        \i_GB[1][19] , \i_GB[1][18] , \i_GB[1][17] , \i_GB[1][16] , 
        \i_GB[1][15] , \i_GB[1][14] , \i_GB[1][13] , \i_GB[1][12] , 
        \i_GB[1][11] , \i_GB[1][10] , \i_GB[1][9] , \i_GB[1][8] , \i_GB[1][7] , 
        \i_GB[1][6] , \i_GB[1][5] , \i_GB[1][4] , \i_GB[1][3] , \i_GB[1][2] , 
        \i_GB[1][1] , \i_GB[1][0] }) );
  SRAM_SP_WORDWD800_DWD32_SIZE2_0 \genblk3[1].ibuf  ( .i_clk(i_clk), .i_rstn(
        i_rstn), .i_rw(gb_mode), .ce(_19_net_), .i_addr(gb_addr), .o_rdata({
        n288, n286, n284, n282, n280, n278, n276, n274, n272, n270, n268, n266, 
        n264, n262, n260, n258, n256, n254, n252, n250, n248, n246, n244, n242, 
        n240, n238, n236, n234, n232, n230, n228, n226, n224, n222, n220, n218, 
        n216, n214, n212, n210, n208, n206, n204, n202, n200, n198, n196, n194, 
        n192, n190, n188, n186, n184, n182, n180, n178, n176, n174, n172, n170, 
        n168, n166, n164, n162}), .i_wdata({\i_GB[0][31] , \i_GB[0][30] , 
        \i_GB[0][29] , \i_GB[0][28] , \i_GB[0][27] , \i_GB[0][26] , 
        \i_GB[0][25] , \i_GB[0][24] , \i_GB[0][23] , \i_GB[0][22] , 
        \i_GB[0][21] , \i_GB[0][20] , \i_GB[0][19] , \i_GB[0][18] , 
        \i_GB[0][17] , \i_GB[0][16] , \i_GB[0][15] , \i_GB[0][14] , 
        \i_GB[0][13] , \i_GB[0][12] , \i_GB[0][11] , \i_GB[0][10] , 
        \i_GB[0][9] , \i_GB[0][8] , \i_GB[0][7] , \i_GB[0][6] , \i_GB[0][5] , 
        \i_GB[0][4] , \i_GB[0][3] , \i_GB[0][2] , \i_GB[0][1] , \i_GB[0][0] , 
        \i_GB[1][31] , \i_GB[1][30] , \i_GB[1][29] , \i_GB[1][28] , 
        \i_GB[1][27] , \i_GB[1][26] , \i_GB[1][25] , \i_GB[1][24] , 
        \i_GB[1][23] , \i_GB[1][22] , \i_GB[1][21] , \i_GB[1][20] , 
        \i_GB[1][19] , \i_GB[1][18] , \i_GB[1][17] , \i_GB[1][16] , 
        \i_GB[1][15] , \i_GB[1][14] , \i_GB[1][13] , \i_GB[1][12] , 
        \i_GB[1][11] , \i_GB[1][10] , \i_GB[1][9] , \i_GB[1][8] , \i_GB[1][7] , 
        \i_GB[1][6] , \i_GB[1][5] , \i_GB[1][4] , \i_GB[1][3] , \i_GB[1][2] , 
        \i_GB[1][1] , \i_GB[1][0] }) );
  SNPS_CLOCK_GATE_HIGH_BufferTest_0 clk_gate_gb_addr_reg ( .CLK(i_clk), .EN(
        N25), .ENCLK(net57), .TE(1'b0) );
  SNPS_CLOCK_GATE_HIGH_BufferTest_2 clk_gate_input_addr_reg ( .CLK(i_clk), 
        .EN(N6), .ENCLK(net63), .TE(1'b0) );
  SNPS_CLOCK_GATE_HIGH_BufferTest_1 clk_gate_weight_addr_reg ( .CLK(i_clk), 
        .EN(N16), .ENCLK(net68), .TE(1'b0) );
  AND2X8 C210 ( .A(w_GB_rdy), .B(1'b1), .Y(N52) );
  AND2X8 C209 ( .A(r_GB_rdy), .B(r_GB_ack), .Y(N51) );
  OR2X8 C208 ( .A(N51), .B(N52), .Y(N25) );
  AND2X8 C204 ( .A(w_Weight_rdy), .B(1'b1), .Y(N50) );
  AND2X8 C203 ( .A(r_Weight_rdy), .B(r_Weight_ack), .Y(N49) );
  OR2X8 C202 ( .A(N49), .B(N50), .Y(N16) );
  AND2X8 C198 ( .A(w_Input_rdy), .B(1'b1), .Y(N48) );
  AND2X8 C197 ( .A(r_Input_rdy), .B(r_Input_ack), .Y(N47) );
  OR2X8 C196 ( .A(N47), .B(N48), .Y(N6) );
  AND2X8 C192 ( .A(w_GB_rdy), .B(1'b1), .Y(N46) );
  AND2X8 C191 ( .A(r_GB_rdy), .B(r_GB_ack), .Y(N45) );
  OR2X8 C190 ( .A(N45), .B(N46), .Y(_19_net_) );
  AND2X8 C189 ( .A(w_GB_rdy), .B(1'b1), .Y(N44) );
  AND2X8 C188 ( .A(r_GB_rdy), .B(r_GB_ack), .Y(N43) );
  OR2X8 C187 ( .A(N43), .B(N44), .Y(_18_net_) );
  AND2X8 C186 ( .A(w_Weight_rdy), .B(1'b1), .Y(N42) );
  AND2X8 C185 ( .A(r_Weight_rdy), .B(r_Weight_ack), .Y(N41) );
  OR2X8 C184 ( .A(N41), .B(N42), .Y(_17_net_) );
  AND2X8 C183 ( .A(w_Input_rdy), .B(1'b1), .Y(N40) );
  AND2X8 C182 ( .A(r_Input_rdy), .B(r_Input_ack), .Y(N39) );
  OR2X8 C181 ( .A(N39), .B(N40), .Y(_16_net_) );
  AND2X8 C179 ( .A(N38), .B(1'b1), .Y(r_GB_ack) );
  AND2X8 C177 ( .A(N37), .B(1'b1), .Y(r_Weight_ack) );
  AND2X8 C175 ( .A(N36), .B(1'b1), .Y(r_Input_ack) );
  AND2X8 C173 ( .A(r_GB_rdy), .B(r_GB_ack), .Y(N2) );
  AND2X8 C171 ( .A(r_Weight_rdy), .B(r_Weight_ack), .Y(N1) );
  AND2X8 C169 ( .A(r_Input_rdy), .B(r_Input_ack), .Y(N0) );
  CLKINVX2 U5 ( .A(N2), .Y(gb_mode) );
  CLKINVX2 U6 ( .A(N1), .Y(weight_mode) );
  CLKINVX2 U7 ( .A(N0), .Y(input_mode) );
  CLKINVX2 U8 ( .A(w_GB_rdy), .Y(N38) );
  CLKINVX2 U9 ( .A(w_Weight_rdy), .Y(N37) );
  CLKINVX2 U10 ( .A(w_Input_rdy), .Y(N36) );
  DFFRHQX8 \gb_addr_reg[4]  ( .D(N30), .CK(net57), .RN(i_rstn), .Q(gb_addr[4])
         );
  DFFRHQX8 \gb_addr_reg[6]  ( .D(N32), .CK(net57), .RN(i_rstn), .Q(gb_addr[6])
         );
  DFFRHQX8 \gb_addr_reg[8]  ( .D(N34), .CK(net57), .RN(i_rstn), .Q(gb_addr[8])
         );
  DFFRHQX8 \gb_addr_reg[3]  ( .D(N29), .CK(net57), .RN(i_rstn), .Q(gb_addr[3])
         );
  DFFRHQX8 \gb_addr_reg[9]  ( .D(N35), .CK(net57), .RN(i_rstn), .Q(gb_addr[9])
         );
  DFFRHQX8 \gb_addr_reg[5]  ( .D(N31), .CK(net57), .RN(i_rstn), .Q(gb_addr[5])
         );
  DFFRHQX8 \gb_addr_reg[7]  ( .D(N33), .CK(net57), .RN(i_rstn), .Q(gb_addr[7])
         );
  DFFRHQX8 \gb_addr_reg[0]  ( .D(N26), .CK(net57), .RN(i_rstn), .Q(gb_addr[0])
         );
  DFFRHQX8 \gb_addr_reg[1]  ( .D(N27), .CK(net57), .RN(i_rstn), .Q(gb_addr[1])
         );
  DFFRQX4 \weight_addr_reg[0]  ( .D(N17), .CK(net68), .RN(i_rstn), .Q(
        weight_addr[0]) );
  DFFRQX4 \input_addr_reg[0]  ( .D(N7), .CK(net63), .RN(i_rstn), .Q(
        input_addr[0]) );
  DFFRHQX8 \gb_addr_reg[2]  ( .D(N28), .CK(net57), .RN(i_rstn), .Q(gb_addr[2])
         );
  DFFRQX4 \weight_addr_reg[2]  ( .D(N19), .CK(net68), .RN(i_rstn), .Q(
        weight_addr[2]) );
  DFFRQX4 \weight_addr_reg[4]  ( .D(N21), .CK(net68), .RN(i_rstn), .Q(
        weight_addr[4]) );
  DFFRQX4 \weight_addr_reg[6]  ( .D(N23), .CK(net68), .RN(i_rstn), .Q(
        weight_addr[6]) );
  DFFRQX4 \input_addr_reg[3]  ( .D(N10), .CK(net63), .RN(i_rstn), .Q(
        input_addr[3]) );
  DFFRQX4 \input_addr_reg[5]  ( .D(N12), .CK(net63), .RN(i_rstn), .Q(
        input_addr[5]) );
  DFFRQX4 \input_addr_reg[7]  ( .D(N14), .CK(net63), .RN(i_rstn), .Q(
        input_addr[7]) );
  DFFRQX2 \weight_addr_reg[7]  ( .D(N24), .CK(net68), .RN(i_rstn), .Q(
        weight_addr[7]) );
  DFFRQX2 \input_addr_reg[8]  ( .D(N15), .CK(net63), .RN(i_rstn), .Q(
        input_addr[8]) );
  DFFRQX2 \weight_addr_reg[5]  ( .D(N22), .CK(net68), .RN(i_rstn), .Q(
        weight_addr[5]) );
  DFFRQX2 \input_addr_reg[4]  ( .D(N11), .CK(net63), .RN(i_rstn), .Q(
        input_addr[4]) );
  DFFRQX2 \input_addr_reg[6]  ( .D(N13), .CK(net63), .RN(i_rstn), .Q(
        input_addr[6]) );
  DFFRQX4 \weight_addr_reg[1]  ( .D(N18), .CK(net68), .RN(i_rstn), .Q(
        weight_addr[1]) );
  DFFRQX4 \input_addr_reg[1]  ( .D(N8), .CK(net63), .RN(i_rstn), .Q(
        input_addr[1]) );
  DFFRQX4 \input_addr_reg[2]  ( .D(N9), .CK(net63), .RN(i_rstn), .Q(
        input_addr[2]) );
  DFFRQX2 \weight_addr_reg[3]  ( .D(N20), .CK(net68), .RN(i_rstn), .Q(
        weight_addr[3]) );
  INVXL U11 ( .A(weight_addr[3]), .Y(n82) );
  AOI2BB1X1 U12 ( .A0N(weight_addr[0]), .A1N(weight_addr[1]), .B0(n71), .Y(N18) );
  OA21X1 U13 ( .A0(n72), .A1(input_addr[7]), .B0(n78), .Y(N14) );
  OA21X1 U14 ( .A0(n79), .A1(weight_addr[6]), .B0(n84), .Y(N23) );
  OA21X1 U15 ( .A0(n89), .A1(gb_addr[6]), .B0(n88), .Y(N32) );
  NOR2X4 U16 ( .A(n73), .B(n74), .Y(n72) );
  AOI21X1 U17 ( .A0(n91), .A1(n90), .B0(n89), .Y(N31) );
  NOR2X4 U18 ( .A(n80), .B(n81), .Y(n79) );
  NOR2X4 U19 ( .A(n76), .B(n77), .Y(n75) );
  NOR2X4 U20 ( .A(n82), .B(n83), .Y(n4) );
  NOR2X4 U21 ( .A(n94), .B(n93), .Y(n92) );
  AND2X2 U22 ( .A(n189), .B(n190), .Y(n54) );
  AND2X2 U23 ( .A(n267), .B(n268), .Y(n13) );
  AND2X2 U24 ( .A(n187), .B(n188), .Y(n55) );
  AND2X2 U25 ( .A(n287), .B(n288), .Y(n51) );
  AND2X2 U26 ( .A(n185), .B(n186), .Y(n56) );
  AND2X2 U27 ( .A(n207), .B(n208), .Y(n44) );
  AND2X2 U28 ( .A(n191), .B(n192), .Y(n53) );
  AND2X2 U29 ( .A(n223), .B(n224), .Y(n36) );
  AND2X2 U30 ( .A(n285), .B(n286), .Y(n5) );
  AND2X2 U31 ( .A(n273), .B(n274), .Y(n10) );
  AND2X2 U32 ( .A(n275), .B(n276), .Y(n9) );
  AND2X2 U33 ( .A(n179), .B(n180), .Y(n59) );
  AND2X2 U34 ( .A(n219), .B(n220), .Y(n38) );
  AND2X2 U35 ( .A(n183), .B(n184), .Y(n57) );
  AND2X2 U36 ( .A(n253), .B(n254), .Y(n21) );
  AND2X2 U37 ( .A(n225), .B(n226), .Y(n35) );
  AND2X2 U38 ( .A(n193), .B(n194), .Y(n52) );
  AND2X2 U39 ( .A(n251), .B(n252), .Y(n22) );
  AND2X2 U40 ( .A(n209), .B(n210), .Y(n43) );
  AND2X2 U41 ( .A(n227), .B(n228), .Y(n34) );
  AND2X2 U42 ( .A(n221), .B(n222), .Y(n37) );
  AND2X2 U43 ( .A(n175), .B(n176), .Y(n61) );
  AND2X2 U44 ( .A(n277), .B(n278), .Y(n8) );
  AND2X2 U45 ( .A(n271), .B(n272), .Y(n11) );
  AND2X2 U46 ( .A(n173), .B(n174), .Y(n62) );
  AND2X2 U47 ( .A(n195), .B(n196), .Y(n50) );
  AND2X2 U48 ( .A(n177), .B(n178), .Y(n60) );
  AND2X2 U49 ( .A(n261), .B(n262), .Y(n17) );
  AND2X2 U50 ( .A(n229), .B(n230), .Y(n33) );
  AND2X2 U51 ( .A(n171), .B(n172), .Y(n63) );
  AND2X2 U52 ( .A(n181), .B(n182), .Y(n58) );
  AND2X2 U53 ( .A(n217), .B(n218), .Y(n39) );
  AND2X2 U54 ( .A(n249), .B(n250), .Y(n23) );
  AND2X2 U55 ( .A(n215), .B(n216), .Y(n40) );
  AND2X2 U56 ( .A(n169), .B(n170), .Y(n64) );
  AND2X2 U57 ( .A(n263), .B(n264), .Y(n16) );
  AND2X2 U58 ( .A(n231), .B(n232), .Y(n32) );
  AND2X2 U59 ( .A(n205), .B(n206), .Y(n45) );
  AND2X2 U60 ( .A(n167), .B(n168), .Y(n65) );
  AND2X2 U61 ( .A(n259), .B(n260), .Y(n18) );
  AND2X2 U62 ( .A(n237), .B(n238), .Y(n29) );
  AND2X2 U63 ( .A(n269), .B(n270), .Y(n12) );
  AND2X2 U64 ( .A(n197), .B(n198), .Y(n49) );
  AND2X2 U65 ( .A(n165), .B(n166), .Y(n66) );
  AND2X2 U66 ( .A(n233), .B(n234), .Y(n31) );
  AND2X2 U67 ( .A(n283), .B(n284), .Y(n6) );
  AND2X2 U68 ( .A(n199), .B(n200), .Y(n48) );
  AND2X2 U69 ( .A(n239), .B(n240), .Y(n28) );
  AND2X2 U70 ( .A(n163), .B(n164), .Y(n67) );
  AND2X2 U71 ( .A(n201), .B(n202), .Y(n47) );
  AND2X2 U72 ( .A(n211), .B(n212), .Y(n42) );
  AND2X2 U73 ( .A(n247), .B(n248), .Y(n24) );
  AND2X2 U74 ( .A(n235), .B(n236), .Y(n30) );
  AND2X2 U75 ( .A(n161), .B(n162), .Y(n68) );
  AND2X2 U76 ( .A(n279), .B(n280), .Y(n7) );
  AND2X2 U77 ( .A(n255), .B(n256), .Y(n20) );
  AND2X2 U78 ( .A(n265), .B(n266), .Y(n15) );
  AND2X2 U79 ( .A(n245), .B(n246), .Y(n25) );
  AND2X2 U80 ( .A(n281), .B(n282), .Y(n14) );
  AND2X2 U81 ( .A(n243), .B(n244), .Y(n26) );
  AND2X2 U82 ( .A(n203), .B(n204), .Y(n46) );
  AND2X2 U83 ( .A(n257), .B(n258), .Y(n19) );
  AND2X2 U84 ( .A(n213), .B(n214), .Y(n41) );
  AND2X2 U85 ( .A(n241), .B(n242), .Y(n27) );
  NOR2X4 U86 ( .A(n88), .B(n87), .Y(n86) );
  INVX2 U87 ( .A(gb_addr[3]), .Y(n93) );
  INVX2 U88 ( .A(gb_addr[5]), .Y(n90) );
  INVX2 U89 ( .A(gb_addr[7]), .Y(n87) );
  AND2XL U90 ( .A(weight_addr[1]), .B(weight_addr[0]), .Y(n71) );
  INVX2 U91 ( .A(input_addr[6]), .Y(n73) );
  INVX2 U92 ( .A(input_addr[4]), .Y(n76) );
  INVX2 U93 ( .A(weight_addr[5]), .Y(n80) );
  NAND2X1 U94 ( .A(input_addr[0]), .B(input_addr[1]), .Y(n70) );
  OA21X1 U95 ( .A0(gb_addr[8]), .A1(n86), .B0(n85), .Y(N34) );
  AOI21X1 U96 ( .A0(n88), .A1(n87), .B0(n86), .Y(N33) );
  AOI21X1 U97 ( .A0(n74), .A1(n73), .B0(n72), .Y(N13) );
  AOI21X1 U98 ( .A0(n81), .A1(n80), .B0(n79), .Y(N22) );
  INVX1 U99 ( .A(gb_addr[1]), .Y(n96) );
  AOI2B1XL U103 ( .A1N(input_addr[2]), .A0(n70), .B0(n69), .Y(N9) );
  OA21XL U104 ( .A0(input_addr[0]), .A1(input_addr[1]), .B0(n70), .Y(N8) );
  AOI21XL U105 ( .A0(n77), .A1(n76), .B0(n75), .Y(N11) );
  AOI21XL U106 ( .A0(n83), .A1(n82), .B0(n4), .Y(N20) );
  OA21XL U107 ( .A0(n75), .A1(input_addr[5]), .B0(n74), .Y(N12) );
  OA21XL U108 ( .A0(n69), .A1(input_addr[3]), .B0(n77), .Y(N10) );
  OA21XL U109 ( .A0(n4), .A1(weight_addr[4]), .B0(n81), .Y(N21) );
  OA21XL U110 ( .A0(n71), .A1(weight_addr[2]), .B0(n83), .Y(N19) );
  OA21XL U111 ( .A0(n95), .A1(gb_addr[2]), .B0(n94), .Y(N28) );
  AOI21XL U112 ( .A0(N26), .A1(n96), .B0(n95), .Y(N27) );
  AOI21XL U113 ( .A0(n94), .A1(n93), .B0(n92), .Y(N29) );
  OA21XL U114 ( .A0(n92), .A1(gb_addr[4]), .B0(n91), .Y(N30) );
  NOR2X2 U115 ( .A(N26), .B(n96), .Y(n95) );
  NAND2X2 U116 ( .A(n92), .B(gb_addr[4]), .Y(n91) );
  NAND2X2 U117 ( .A(n89), .B(gb_addr[6]), .Y(n88) );
  NOR2X4 U118 ( .A(n90), .B(n91), .Y(n89) );
  NAND2X2 U119 ( .A(n72), .B(input_addr[7]), .Y(n78) );
  NAND2X2 U120 ( .A(n75), .B(input_addr[5]), .Y(n74) );
  NAND2X2 U121 ( .A(n69), .B(input_addr[3]), .Y(n77) );
  NAND2X2 U122 ( .A(n79), .B(weight_addr[6]), .Y(n84) );
  NAND2X2 U123 ( .A(n4), .B(weight_addr[4]), .Y(n81) );
  CLKBUFX40 U124 ( .A(n51), .Y(\o_GB[0][31] ) );
  CLKBUFX40 U125 ( .A(n5), .Y(\o_GB[0][30] ) );
  CLKBUFX40 U126 ( .A(n6), .Y(\o_GB[0][29] ) );
  CLKBUFX40 U127 ( .A(n14), .Y(\o_GB[0][28] ) );
  CLKBUFX40 U128 ( .A(n7), .Y(\o_GB[0][27] ) );
  CLKBUFX40 U129 ( .A(n8), .Y(\o_GB[0][26] ) );
  CLKBUFX40 U130 ( .A(n9), .Y(\o_GB[0][25] ) );
  CLKBUFX40 U131 ( .A(n10), .Y(\o_GB[0][24] ) );
  CLKBUFX40 U132 ( .A(n11), .Y(\o_GB[0][23] ) );
  CLKBUFX40 U133 ( .A(n12), .Y(\o_GB[0][22] ) );
  CLKBUFX40 U134 ( .A(n13), .Y(\o_GB[0][21] ) );
  CLKBUFX40 U135 ( .A(n15), .Y(\o_GB[0][20] ) );
  CLKBUFX40 U136 ( .A(n16), .Y(\o_GB[0][19] ) );
  CLKBUFX40 U137 ( .A(n17), .Y(\o_GB[0][18] ) );
  CLKBUFX40 U138 ( .A(n18), .Y(\o_GB[0][17] ) );
  CLKBUFX40 U139 ( .A(n19), .Y(\o_GB[0][16] ) );
  CLKBUFX40 U140 ( .A(n20), .Y(\o_GB[0][15] ) );
  CLKBUFX40 U141 ( .A(n21), .Y(\o_GB[0][14] ) );
  CLKBUFX40 U142 ( .A(n22), .Y(\o_GB[0][13] ) );
  CLKBUFX40 U143 ( .A(n23), .Y(\o_GB[0][12] ) );
  CLKBUFX40 U144 ( .A(n24), .Y(\o_GB[0][11] ) );
  CLKBUFX40 U145 ( .A(n25), .Y(\o_GB[0][10] ) );
  CLKBUFX40 U146 ( .A(n26), .Y(\o_GB[0][9] ) );
  CLKBUFX40 U147 ( .A(n27), .Y(\o_GB[0][8] ) );
  CLKBUFX40 U148 ( .A(n28), .Y(\o_GB[0][7] ) );
  CLKBUFX40 U149 ( .A(n29), .Y(\o_GB[0][6] ) );
  CLKBUFX40 U150 ( .A(n30), .Y(\o_GB[0][5] ) );
  CLKBUFX40 U151 ( .A(n31), .Y(\o_GB[0][4] ) );
  CLKBUFX40 U152 ( .A(n32), .Y(\o_GB[0][3] ) );
  CLKBUFX40 U153 ( .A(n33), .Y(\o_GB[0][2] ) );
  CLKBUFX40 U154 ( .A(n34), .Y(\o_GB[0][1] ) );
  CLKBUFX40 U155 ( .A(n35), .Y(\o_GB[0][0] ) );
  CLKBUFX40 U156 ( .A(n36), .Y(\o_GB[1][31] ) );
  CLKBUFX40 U157 ( .A(n37), .Y(\o_GB[1][30] ) );
  CLKBUFX40 U158 ( .A(n38), .Y(\o_GB[1][29] ) );
  CLKBUFX40 U159 ( .A(n39), .Y(\o_GB[1][28] ) );
  CLKBUFX40 U160 ( .A(n40), .Y(\o_GB[1][27] ) );
  CLKBUFX40 U161 ( .A(n41), .Y(\o_GB[1][26] ) );
  CLKBUFX40 U162 ( .A(n42), .Y(\o_GB[1][25] ) );
  CLKBUFX40 U163 ( .A(n43), .Y(\o_GB[1][24] ) );
  CLKBUFX40 U164 ( .A(n44), .Y(\o_GB[1][23] ) );
  CLKBUFX40 U165 ( .A(n45), .Y(\o_GB[1][22] ) );
  CLKBUFX40 U166 ( .A(n46), .Y(\o_GB[1][21] ) );
  CLKBUFX40 U167 ( .A(n47), .Y(\o_GB[1][20] ) );
  CLKBUFX40 U168 ( .A(n48), .Y(\o_GB[1][19] ) );
  CLKBUFX40 U169 ( .A(n49), .Y(\o_GB[1][18] ) );
  CLKBUFX40 U170 ( .A(n50), .Y(\o_GB[1][17] ) );
  CLKBUFX40 U171 ( .A(n52), .Y(\o_GB[1][16] ) );
  CLKBUFX40 U172 ( .A(n53), .Y(\o_GB[1][15] ) );
  CLKBUFX40 U173 ( .A(n54), .Y(\o_GB[1][14] ) );
  CLKBUFX40 U174 ( .A(n55), .Y(\o_GB[1][13] ) );
  CLKBUFX40 U175 ( .A(n56), .Y(\o_GB[1][12] ) );
  CLKBUFX40 U176 ( .A(n57), .Y(\o_GB[1][11] ) );
  CLKBUFX40 U177 ( .A(n58), .Y(\o_GB[1][10] ) );
  CLKBUFX40 U178 ( .A(n59), .Y(\o_GB[1][9] ) );
  CLKBUFX40 U179 ( .A(n60), .Y(\o_GB[1][8] ) );
  CLKBUFX40 U180 ( .A(n61), .Y(\o_GB[1][7] ) );
  CLKBUFX40 U181 ( .A(n62), .Y(\o_GB[1][6] ) );
  CLKBUFX40 U182 ( .A(n63), .Y(\o_GB[1][5] ) );
  CLKBUFX40 U183 ( .A(n64), .Y(\o_GB[1][4] ) );
  CLKBUFX40 U184 ( .A(n65), .Y(\o_GB[1][3] ) );
  CLKBUFX40 U185 ( .A(n66), .Y(\o_GB[1][2] ) );
  CLKBUFX40 U186 ( .A(n67), .Y(\o_GB[1][1] ) );
  CLKBUFX40 U187 ( .A(n68), .Y(\o_GB[1][0] ) );
  NAND3X2 U188 ( .A(weight_addr[0]), .B(weight_addr[1]), .C(weight_addr[2]), 
        .Y(n83) );
  NAND3X2 U189 ( .A(gb_addr[0]), .B(gb_addr[1]), .C(gb_addr[2]), .Y(n94) );
  INVX2 U190 ( .A(gb_addr[0]), .Y(N26) );
  XNOR2X1 U191 ( .A(gb_addr[9]), .B(n85), .Y(N35) );
  NAND2X2 U192 ( .A(n86), .B(gb_addr[8]), .Y(n85) );
  INVXL U193 ( .A(weight_addr[0]), .Y(N17) );
  INVXL U194 ( .A(input_addr[0]), .Y(N7) );
  AND3X2 U195 ( .A(input_addr[1]), .B(input_addr[0]), .C(input_addr[2]), .Y(
        n69) );
  XNOR2X1 U196 ( .A(input_addr[8]), .B(n78), .Y(N15) );
  XNOR2X1 U197 ( .A(weight_addr[7]), .B(n84), .Y(N24) );
endmodule

