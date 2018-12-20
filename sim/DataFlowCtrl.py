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
        conf.Tw.value = 4
        conf.values = ( 4,3,1,1,3,3,48,12,4,1,0,0,13)
        conf.Write()
        for i in range(1000): 
            inst.start =1
            inst.dval =1
            inst.Write()
            yield ck_ev
    FinishSim()
def test2():
    inbus = TwoWireBus( [dummy],clk=ck_ev ,A=6,side='master',name='Input')
    def i1():
        for i in range(40):
            print('hey',i)
            yield dummy.values
    yield from inbus.SendIter(i1())
    yield ck_ev
def test3():
    wbus = TwoWireBus( [dummy] , clk=ck_ev,A=6,side='master',name='Weight')
    def i2():
        for i in range(30):
            print('yo',i)
            yield dummy.values
    yield from wbus.SendIter(i2())
    yield ck_ev
dummy = CreateBus( ('dummy',) )
rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test(),test2(),test3()]
)
 
