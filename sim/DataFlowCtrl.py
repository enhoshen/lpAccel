import numpy as np
from nicotb import *
from nicotb.primitives import JoinableFork
from util import *
from itertools import repeat
def BusInit():
    SBC = StructBusCreator
    SBC.TopTypes()
    confbus = SBC.Get('Conf','i_PEconf')
    instbus = SBC.Get('Inst','i_PEinst')
    dummy = CreateBus( ('dummy',) )
    inbus = TwoWireBus( [dummy],clk=ck_ev ,A=6,name='Input' )
    wbus = TwoWireBus ( [dummy],clk=ck_ev ,A=6,name='Weight') 
    obus = TwoWireBus ( [dummy],clk=ck_ev ,side='slave',A=6,name='Psum')
    return confbus, instbus , inbus , wbus , obus , dummy
def test():
    yield rst_out
    conf ,inst , inbus ,wbus ,obus ,dummy = BusInit()
    conf.SetTo(0)
    inst.SetTo(0)
    def it(i):
        for _ in range(i):
            yield dummy.values
    for i1 in range (2 ): 
        conf.values = ( 4,4,1,1,1,3,3,48,12,64,12,1,1,1,13)
        conf.Write()
        j1 = JoinableFork( inbus.SendIter(it(15*4)) )
        j2 = JoinableFork( wbus.SendIter(it(48)) )
        inst.start.value =1
        inst.dval.value =1
        inst.Write()
        yield from j1.Join()
        yield from j2.Join()
        yield ck_ev
            
        j1.Destroy()
        j2.Destroy()
    yield from repeat(ck_ev,100)
    FinishSim()

rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test()]
)
 
