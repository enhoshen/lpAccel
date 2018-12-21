import numpy as np
from nicotb import *
from nicotb.primitives import JoinableFork
from util import *
def BusInit():
    SBC = StructBusCreator
    SBC.TopTypes()
    confbus = SBC.Get('Conf','i_PEconf')
    instbus = SBC.Get('Inst','i_PEinst')
    dummy = CreateBus( ('dummy',) )
    inbus = TwoWireBus( [dummy],clk=ck_ev ,A=6,name='Input' )
    wbus = TwoWireBus ( [dummy],clk=ck_ev ,A=6,name='Weight') 
    return confbus, instbus , inbus , wbus , dummy
def test():
    yield rst_out
    conf ,inst , inbus ,wbus ,dummy = BusInit()
    conf.SetTo(0)
    inst.SetTo(0)
    def it(i):
        for _ in range(i):
            yield dummy.values
    for i1 in range ( 3): 
        conf.Tw.value = 4
        conf.values = ( 4,3,1,1,3,3,48,12,4,1,0,0,13)
        conf.Write()
        j1 = JoinableFork( inbus.SendIter(it(30)) )
        j2 = JoinableFork( wbus.SendIter(it(30)) )
        for i2 in range(1000): 
            inst.start =1
            inst.dval =1
            inst.Write()
            yield from j1.Join()
            yield from j2.Join()
            for x in [inbus.SendIter(it(30)) , wbus.SendIter(it(40))]:
                Fork(x)
            yield ck_ev
            
        j1.Destroy()
        j2.Destroy()
    FinishSim()
rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test()]
)
 
