import numpy as np
from nicotb import *
from util import *
def BusInit():
    SBC = StructBusCreator
    SBC.TopTypes()
    confbus = SBC.Get('Conf','i_PEconf')
    instbus = SBC.Get('Inst','i_PEinst')
    return confbus, instbus
def test():
    yield rst_out
    conf ,inst = BusInit()
    conf.SetTo(0)
    inst.SetTo(0)
    for i in range ( 3): 
        conf.Write()
        for i in range(4): 
            pass
        yield ck_ev
    FinishSim()
rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test()]
)
 
