#!/bin/sh
if [ $1 == "ls" ]; then
   ls /opt/CAD/cell_lib/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Memory/
else 
   /opt/CAD/cell_lib/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Memory/$1/bin/$1 &
fi
