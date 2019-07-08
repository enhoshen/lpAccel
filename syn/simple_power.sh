echo "usage define three env varaiables DESIGN, TEST, MODULE beforehand" 
sh fsdb2saif.sh ../sim/${DESIGN}_${TEST}.fsdb
pt_shell -f primetime.tcl
