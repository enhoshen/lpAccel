module test ;
    function overflow 
        input a , b;
        begin
            if(a+b {$bits(a){1'b1}})
                overflow = 
        end
    
endmodule
