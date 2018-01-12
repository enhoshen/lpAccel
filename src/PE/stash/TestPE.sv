`define test(arg)  `"arg``_output`"
`define strconc(arg1,arg2) `"arg1``arg2`"
module TB;
int i = 10;

initial begin
    $display( `test( `strconc(i,name)   );
    $display( `test(name)  );
    $display( `strconc(i,name)  );
    #1 ;
    i=2;
    $display( i  );
 
    $finish ;
end

endmodule

