# Notes for Systemverilog programming and this projects
## Syntax
### Implicit port connection
Port connection made easy:
* named port connection with the same name can be replaced by `.portName,`
```verilog
module MD (input port1, output port2);
logic port1;
logic port2;
MD dut(
.port1(port1),
.port2
)
```
* `.*` automated connection for all name matched port-logic pairs, use with care
* ref:[Systemverilog Implicit name connection](http://www.sunburst-design.com/papers/CummingsDesignCon2005_SystemVerilog_ImplicitPorts.pdf)
### Assignment pattern
Assignment pattern `'{}` is used for array or self defined struct
```verilog
typedef struct packed { logic a , logic b } mytype;
mytype t;
    assign t = '{a:1 , b:0} ;
```
