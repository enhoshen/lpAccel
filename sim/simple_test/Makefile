#NICOTB=../nicotb/lib
#NICOTB=/opt/nicotb/lib
IRUN=irun
SYN=syn
HOME=/home/enhoshen/research/lpAccel
BRIDGE_SO=$(NICOTB)/bridge_vpi$(PY_SUFFIX)
NICOTB=$(shell $(PY) -c "import nicotb; print(nicotb.__path__[0])")

Top_syn:
	make ARGS="+define+SDF=\\\"../$(SYN)/Top_syn.sdf\\\" +define+GATE_LEVEL +define+SRAM_GEN_MODE=SYNOPSYS32 +incdir+../$(SYN)/SAED32_EDK/lib/sram/verilog/ +incdir+../$(SYN)/SAED32_EDK/lib/stdcell_rvt/verilog/ +incdir+../$(SYN)/ +nowarn+SDFNCAP:SDFNDP:MACRDF:CUVWSP:SDFNSB:SDFNL1 " Top_test

test:
	echo $(NICOTB)
	echo $(BRIDGE_SO)

%: $(if $(SV),$(SV).sv,%.sv)
	echo $(SV)
	GLOG_logtostderr=1 \
	TEST=$(if $(TEST),$(TEST),$@) \
	TOPMODULE=$(if $(TOPMODULE),$(TOPMODULE),$@) \
	PYTHONPATH=$(NICOTB)/python:`pwd` \
	$(IRUN) +access+rw -loadvpi $(NICOTB)/cpp/nicotb.so:VpiBoot \
    -y /opt/CAD/synopsys/synthesis/2017.09/dw/sim_ver +libext+.v \
	+incdir+$(HOME)/src \
	+incdir+$(HOME)/include \
	+incdir+/opt/CAD/synopsys/synthesis/2017.09/dw/sim_ver \
	$(ARGS) $(NICOTB)/verilog/Utils.sv $< \
	+sv
	echo $(SV) 
# dump_scoreboard help you recording the lastest run time and result
dump_scoreboard:
	@echo -e \
	".open scoreboard.db\n"\
	".header on\n"\
	".mode column\n"\
	".print ===============\n"\
	".print All Scoreboards\n"\
	".print ===============\n"\
	"select * from Scoreboard;\n"\
	".print\n"\
	".print =========\n"\
	".print All Tests\n"\
	".print =========\n"\
	"select * from Tests;\n"\
	 | sqlite3

clean:
	-rm -rf ncsim* novas* irun* *.rc scoreboard.db __pycache__ INCA_libs
