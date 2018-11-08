# Notes for simulation using ncverilog and nicotb


## nicotb
### createbuses
* bus of 1D array signal shape should be tailed with a comma `,`...\
see the signal `t` from the following code:

tb.py:
```python
cbbus, abus = CreateBuses([             
        (                               
                (""  , "c", (2,4)),     
                (None, "b", (3,2,4)),   
                (None, "t", (2,)),      
        ),                              
        ("a",),                         
])                                      
```
tb.sv
```verilog                               
logic clk, rst;                
logic [3:0] a;                 
logic [10:0] b [3][2][4];      
logic [10:0] c [2][4];         
logic [3:0] t [2] ;            
```
* just like before, initialize your signal, or get as many `x` and `z` as you can
```verilog
def clk_cb():                
        cbbus.SetToX()       
        cbbus[0].x[1,1] = 0  
        cbbus[2].x = 0       
        yield rst_out        
        while True:          
            yield clk        
            abus.Read()      
```
* self defined packed struct signal can be directly controlled by its name
```verilog
structbus, abus = CreateBuses([
        (  
              (None, "mytype.member1", ),
              (None, "mytype.member2", ),
        ),
        ("a",),
])
```
## nWave
* If you have any self defined type, struct,`$fsdbDumpvars()` arguments should be `"+all"`..................
```verilog
inital begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars("+all"); // rather than something like $fsdbDumpvars(0,tb,'+mda');
end
```

## Makefile
* See for the [GNU make documentation](http://www.gnu.org/software/make/manual/make.html#Goals) for elaborated information
* Automatic variables : `%` `<` `@` 
## MISC
* I came across this issue where I create a file named `struct.py`, which appears to be a built-in file(?) for 
python to read, resulting constant compile error within this file even if I were just testing stuff using the python console!  
**Careful naming excluding any built-in names is a must, be more specific**, for example this file has something to do with systemverilog,
so I should have used name like `SVstruct.py` or so.
