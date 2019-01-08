# Simulation for this project
* SV variable define the simulated .sv source file path
## StructBus
`TODO`
## Protocol Wrapper
`TODO`
### ProtoBus
ProtoBus wraps similar protocol class in `Nicotb.protocols`, including argument parser for easier protocol bus initialization, easier data/control generator with master and slave selections.
## SVparse
`TODO`
SVparse see verilog module, file, package as **hier**, as they are ones that contains `typedef`, `logic`, `port` and `parameter`. And they are ones that need constant review and reference while writing verilog codes.  
This module parse the mentioned **hier** into a tree-like structure, so visible parameters and types from the a hier's vertical relations with its parent hiers could be directly accessed and easily examined in the provided helper functions.
### Interactive python shell usage
Simply type `python -i SVparse.py includefilepath` in the console. The included files then parsed into the class SVparse for further usages.
#### SVparse.hiers[hier_name].ShowTypes()
#### SVparse.hiers[hier_name].ShowParams()
#### ShowPaths()
#### ShowFiles(file_index [,start_line[, end_line]] )
### Class Structure
#### hiers
#### SVstr
