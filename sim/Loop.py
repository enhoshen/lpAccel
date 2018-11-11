import numpy as np
from nicotb import *
from util import *
def loopCtlType():
    LpCtl =  StructBusCreator( 'LpCtl' , ['dval','inc','reset'] )
    return LpCtl
def BusInit():
    ctlbus = loopCtlType().CreateStructBus('i_ctl')
    obus = CreateBus( ('o_loopEnd',) )
    return ctlbus, obus
def test():
    yield rst_out
    ctlbus , obus = BusInit()
    ctlbus.SetTo(0)
    for i in range ( 1000): 
        ctlbus[0].value = np.random.randint(0,high=2)
        ctlbus[1].value = 1
        obus.Read()
        ctlbus.Write()
        yield ck_ev
    FinishSim()
rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test()]
)
    
