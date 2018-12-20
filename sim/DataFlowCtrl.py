import numpy as np
from nicotb import *
from util import *
def BusInit():
    SBC = StructBusCreator
    SBC.TopTypes()
    dummy = CreateBus( ('dummy',) )
    confbus = SBC.Get('Conf','i_PEconf')
    instbus = SBC.Get('Inst','i_PEinst')
    inbus = TwoWireBus( [dummy],clk=ck_ev,side='master',name='Input')
    wbus = TwoWireBus( [dummy] , clk=ck_ev,side='master',name='Weight')
    return confbus, instbus , inbus ,wbus ,dummy
def test():
    yield rst_out
    conf ,inst , inbus ,wbus ,dummy= BusInit()
    conf.SetTo(0)
    inst.SetTo(0)
    for i in range ( 3): 
        conf.Tw.value = 4
        conf.values = ( 4,3,1,1,3,3,48,12,4,1,0,0,13)
        conf.Write()
        for i in range(1000): 
            inst.start =1
            inst.dval =1
            inst.Write()
            def it():
                for i in range(40):
                    yield dummy.values
            yield from inbus.SendIter(it())
            yield from wbus.SendIter(it())
            yield ck_ev
    FinishSim()
rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test()]
)
 
