import numpy as np
from nicotb import *
from util import *
def BusInit():
    SBC = StructBusCreator
    SBC.Alltypes(inc=False)
    ctlbus = SBC.Get('LpCtl','i_ctl')
    obus = CreateBus( ('o_loopEnd',) )
    return ctlbus, obus
def test():
    yield rst_out
    ctlbus , obus = BusInit()
    ctlbus.SetTo(0)
    for i in range ( 1000): 
        ctlbus[0].value = 1 if np.random.randint(0,high=11) > 1 else 0;
        ctlbus[1].value = 1
        obus.Read()
        ctlbus.Write()
        yield ck_ev
    FinishSim()
rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test()]
)
    
