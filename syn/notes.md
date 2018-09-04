# Synthesis and tools notes
## design compiler
* use variables just like using shell
useful variable such as `$current_design`, so that your tcl files can be easily modular.
```shell
source $current_design\_syn.sdc
report_timing >> $current_design.txt
```
