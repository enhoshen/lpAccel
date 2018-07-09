// require files: common/define.sv 
//                MEM/MEM.sv
//                MEM/memv/*
//                MEM/MEMdefine.sv

// TODO: empty , full situations
module FIFORAM#(
    parameter Size   = 12,
    parameter DWd    = 16,
    parameter AWd    = $clog2(Size),
    parameter InsNum = 16
)(
`clk_input,
input                  i_pop,
input                  i_lastpix, // reset read index to start
input                  i_read,
input                  i_write,
`rdyack_port(write),
input                  i_dupWrite,  // data reuse, end++ but not actually write data 
input [InsNum*DWd-1:0] i_wdata,
output[InsNum*DWd-1:0] o_rdata,
output                 o_rvalid
);
    //=====================
    //logic
    //=====================
    logic [AWd-1:0] start_r , start_w; // the current working data frame start, if write data address larger than start, stall the write
    logic [AWd-1:0] end_r   , end_w; 
    logic [AWd-1:0] raddr_r , raddr_w;
    logic rvalid_w , rvalid_r;
        assign o_rvalid = rvalid_r;
        assign rvalid_w = i_read; 
    logic ce;
        assign ce = ( i_pop || i_lastpix || i_read || i_write || i_dupWrite);

    `RF2PIf_sharedCtl_logic( rf , Size , DWd , AWd );
        assign rf_read = i_read;
        assign rf_write= i_write;
        assign rf_waddr= end_r ;
        assign rf_raddr= raddr_r; 
    //=====================
    //module
    //=====================

    genvar i;
    generate 
        for ( i=0 ; i<InsNum ; i=i+1)begin: rf
            RF_2P#(
                .wordWd(Size),
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
     
    generate if ( 2**AWd != Size) begin
        always_comb begin
            if ( i_write || i_dupWrite ) 
                end_w =( (end_r+1'b1) == Size)? 'b0 : end_r+1'b1;
            else 
                end_w=end_r;
            
            if ( i_pop ) 
                start_w =( (start_r+1'b1) == Size)? 'b0 : start_r+1'b1;
            else 
                start_w = start_r; 
            case ( {i_read ,i_pop ,i_lastpix} )
                3'b1x0: raddr_w = ((raddr_r + 1'b1)==Size)? 'b0 : raddr_r+1'b1; 
                3'b111: raddr_w = ((start_r+1'b1) == Size)? 'b0 : start_r+1'b1;
                3'b101: raddr_w = start_r ;
                default:raddr_w = raddr_r ;
            endcase
        end
    end
    else begin
        always_comb begin
            start_w = (i_pop)? start_r+1'b1 : start_r;
            end_w   = (i_write|| i_dupWrite)? end_r+1'b1 :end_r;
            case ( {i_read ,i_pop ,i_lastpix} )
                3'b1x0: raddr_w = raddr_r+1'b1; 
                3'b111: raddr_w = start_r+1'b1;
                3'b101: raddr_w = start_r ;
                default:raddr_w = raddr_r ;
            endcase
       end

    end
    endgenerate     
    //======================
    //seq
    //======================
    `ff_rstn
        rvalid_r <= 1'b0;
    `ff_nocg
        rvalid_r <= rvalid_w;
    `ff_end

    `ff_rstn
        start_r  <= '0;
        end_r    <= '0;
        raddr_r  <= '0; 
    `ff_cg( ce )
        start_r  <= start_w;
        end_r    <= end_w;
        raddr_r  <= raddr_w;
    `ff_end
        
endmodule
