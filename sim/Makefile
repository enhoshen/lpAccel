#NICOTB=../nicotb/lib
#NICOTB=/home/enhoshen/nicotb/lib
IRUN=irun
SYN=syn
TCHECK=
VERBOSE=
HOME=/home/enhoshen/research/lpAccel
#newnico
PY=python3
NICOTB=$(shell $(PY) -c "import nicotb; print(nicotb.__path__[0])")
PY_SUFFIX=$(shell $(PY) -c "from distutils.sysconfig import get_config_var; print(get_config_var('EXT_SUFFIX'))")
PRELOAD=$(shell $(PY) -c "from distutils.sysconfig import get_config_var; print(get_config_var('LDLIBRARY'))")
BRIDGE_SO=$(NICOTB)/bridge_vpi$(PY_SUFFIX)

Top_syn:
	make ARGS="+define+SDF=\\\"../$(SYN)/Top_syn.sdf\\\" +define+GATE_LEVEL +define+SRAM_GEN_MODE=SYNOPSYS32 +incdir+../$(SYN)/SAED32_EDK/lib/sram/verilog/ +incdir+../$(SYN)/SAED32_EDK/lib/stdcell_rvt/verilog/ +incdir+../$(SYN)/ +nowarn+SDFNCAP:SDFNDP:MACRDF:CUVWSP:SDFNSB:SDFNL1 " Top_test


#%: $(if $(SV),$(SV).sv,%.sv)
PRE := $(if$(SV),$(SV).sv, %.sv )
%: 
	LD_PRELOAD=$(PRELOAD) PYTHONPATH=`pwd`	GLOG_logtostderr=1	GLOG_minloglevel=0 NICOTB_MODE=VPI\
	TEST=$(if $(TEST),$(TEST),$@) \
	TOPMODULE=$(if $(TOPMODULE),$(TOPMODULE),$@) \
	PYTHONPATH=$(NICOTB)/python:`pwd` \
	$(IRUN) +access+rw -loadvpi $(BRIDGE_SO):VpiBoot \
    -y /opt/CAD/synopsys/synthesis/2017.09/dw/sim_ver +libext+.v \
	+incdir+$(HOME)/src \
	+incdir+$(HOME)/include \
	+incdir+/opt/CAD/synopsys/synthesis/2017.09/dw/sim_ver \
	+define+SIM=1	+define+$@\
	$(NICOTB)/verilog/Utils.sv \
	$(if $(SV),$(SV) , $@.sv) \
	$(TCHECK)\
	$(VERBOSE)\
	+sv
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
	-rm -rf ncsim* novas* irun* scoreboard.db __pycache__ INCA_libs
