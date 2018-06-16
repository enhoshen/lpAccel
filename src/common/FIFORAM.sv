module FIFORAM#(
    parameter Size   = 12,
    parameter DWd    = 16,
    parameter AWd    = $clog2(wordWd),
    parameter InsNum = 16
){
`clk_input,
input                  i_pop,
input                  i_lastpix, // reset read index to start
input                  i_read,
input                  i_write,
input                  i_dupWrite,  // data reuse, end++ but not actually write data 
input [InsNum*DWd-1:0] i_wdata,
output[InsNum*DWd-1:0] o_rdata,
output                 o_rvalid
};
    //=====================
    //logic
    //=====================
    logic [AWd-1:0] start_r , start_w; // the current working data frame start, if write data address larger than start, stall the write
    logic [AWd-1:0] end_r   , end_w; 
    logic rvalid_w , rvalid_r;

        assign o_rvalid = rvalid_r;
        assign rvalid_w = i_read; 


    `RF2PIf_sharedCtl_logic( rf , wordWd , DWd , AWd );
        assign rf_read = i_read;
        assign rf_write= i_write;
        assign rf_raddr=  
    //=====================
    //module
    //=====================

    genvar i;
    generate 
        for ( i=0 ; i<InsNum ; i=i+1)begin: rf
            RF_2P#(
                .wordWd(wordWd),
                .DWd(DWd),
                .AWd(AWd)
            ) R (
                `RF2PIf_sharedCtl_pc_rf( rf ),
                .i_wdata( i_wdata[i*DWd+:DWd] ),
                .o_rdata( o_rdata[i*DWd+:DWd] )
            );
        end
    endgenerate 
    
    //======================
    //comb
    //======================
    always_comb begin
        start_w = start_r;
        end_w   = end_r;
        if ( i_write || i_dupWrite ) begin
            end_w =( (end_r+1'b1) == Size)? 0 : end_r+1'b1;
        end
        else begin
        end
        if ( i_pop ) begin
            start_w =( (start_r+1'b1) == Size)? 0 : start_r+1'b1;
        end
        else begin
        end
    end
    
    //======================
    //seq
    //======================
    `ff_rstn
        rvalid_r <= 1'b0;
    `ff_nocg
        rvalid_r <= rvalid_w;
    `ff_end

    `ff_rstn
    `ff_cg()
    `ff_end
        
endmodule
