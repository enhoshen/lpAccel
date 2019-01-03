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
    inbus = TwoWireBus( [dummy],clk=ck_ev ,A=1,name='Input' )
    wbus = TwoWireBus ( [dummy],clk=ck_ev ,A=1,name='Weight') 
    obus = TwoWireBus ( [dummy],clk=ck_ev ,side='slave',A=4,name='Psum')
    return confbus, instbus , inbus , wbus , obus , dummy
def test():
    yield rst_out
    conf ,inst , inbus ,wbus ,obus ,dummy = BusInit()
    conf.SetTo(0)
    inst.SetTo(0)
    config = [ ( 4,4,1,1,1,3,3,48,12,64,12,1,2,1,1,13),\
                ( 4,4,1,1,4,3,3,48,12,64,12,0,2,1,1,13) ]

    def it(i):
        for _ in range(i):
            yield dummy.values
    for i1 in range (1 ): 
        conf.values = config[0] 
        conf.Write()
        j = []
        j.append( JoinableFork( inbus.SendIter(it(2*15*4)) ) )
        j.append( JoinableFork( wbus.SendIter(it(48)) ) )
        j.append( JoinableFork( obus.MyMonitor(13*2*48) ) )
        inst.start.value =1
        inst.dval.value =1
        inst.Write()
        for jj in j:
            yield from jj.Join()
        yield ck_ev
            
        [jj.Destroy() for jj in j]
        yield from repeat(ck_ev,100)
    FinishSim()

rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test()]
)
 
