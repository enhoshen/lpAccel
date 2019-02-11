# Simulation for this project
* SV variable define the simulated .sv source file path
## StructBus
`TODO`
## Protocol Wrapper
`TODO`
### ProtoBus
ProtoBus wraps similar protocol class in `Nicotb.protocols`, including argument parser for easier protocol bus initialization, easier data/control generator with master and slave selections.
## SVparse
SVparse see verilog module, file, package as **hier**, as they are ones that contain `typedef`, `logic`, `port` and `parameter`. And they are ones that need constant review and reference while writing verilog codes.  
This module parse the mentioned **hier** into a tree-like structure, so visible parameters and types from the a hier's vertical relations with its parent hiers could be directly accessed and easily examined in the provided helper functions.
### Interactive python shell usage
Simply type `python -i SVparse.py includefilepath` in the console. The included files then parsed into the class SVparse for further usages.
#### hiers.hier_name.ShowTypes
#### hiers.hier_name.ShowParams
#### hiers.hier_name.ShowPorts
#### hiers.hier_name.ShowConnect
All of the parsed hierarchies are stored in `SVparse.hiers` dictionary, I provide a instance `hiers` for easier access to the hiers inside the dictionary.  
The Above commands essentially was of `SVparse.hiers['hier_name'].ShowTypes` form.
```shell
>>> hiers.PE

-------------------------PE-------------------------
    params     :['IDLE', 'WRITE', 'READ', 'DONE']
     scope     :'PE.sv'
     types     :[]
     child     :[]
     ports     :['i i_PEconf', 'i i_PEinst', 'i i_Input', 'i i_Weight', 'o o_Psum']

>>> hiers.PE.ShowConnect
Error: Can't open display: (null)
.*,
`rdyack_connect(Input,),
`rdyack_connect(Weight,),
`rdyack_connect(Psum,),
.i_PEconf(),
.i_PEinst(),
.i_Input(),
.i_Weight(),
.o_Psum()
>>>   
```
#### ShowPaths()
#### ShowFiles(file_index [,start_line[, end_line]] )
#### Reset()

### Class Structure
`TODO`
#### hiers
#### SVstr
