import numpy as np
from nicotb import *
from nicotb.primitives import JoinableFork
from NicoUtil import *
from itertools import repeat
def BusInit():
    SBC = StructBusCreator
    SBC.TopTypes()
    confbus = SBC.Get('Conf','i_PEconf')
    instbus = SBC.Get('Inst','i_PEinst')
    dummy = CreateBus( ('dummy',) )
    inbus = TwoWireBus( [dummy],clk=ck_ev ,A=2,name='Input' )
    wbus = TwoWireBus ( [dummy],clk=ck_ev ,A=5,name='Weight') 
    obus = TwoWireBus ( [dummy],clk=ck_ev ,side='slave',A=5,name='MAIN')
    return confbus, instbus , inbus , wbus , obus , dummy
def test():
    yield rst_out
    conf ,inst , inbus ,wbus ,obus ,dummy = BusInit()
    conf.SetTo(0)
    inst.SetTo(0)
    config = [ (  4,4,2,1,1,3,3, 48,12,13*4,4,1,2,1,1,0,1,0,13),\
                (  4,2,3,1,1,3,3, 24,12,13*2,4,1,3,2,0,0,2,1,13),\
                 (  1,2,3,1,3,3,3, 6,3,13*2,3,0,3,2,0,0,2,1,13)  ]

    def it(i):
        for _ in range(i):
            yield dummy.values
    for i1 in range (1 ): 
        conf.values = config[0] 
        conf.Au.values[0] = 3
        print(conf.Au.values)
        print (conf)
        print(inst)
        conf.Write()
        s = conf.S.value[0]
        r = conf.R.value[0]
        pm = conf.Pm.value[0]
        pch = conf.Pch.value[0]
        tw = conf.Tw.value[0]
        tw_padded = tw+r-1
        xb=conf.Xb.value[0]
        upix = conf.Upix.value[0]
        j = []
        if conf.PixReuse.value[0] == 1:
            j.append( JoinableFork( inbus.SendIter(it(xb*tw_padded*pch*s)) ) )
            j.append( JoinableFork( wbus.SendIter(it(pm*pch*r*s)) ) )
            j.append( JoinableFork( obus.MyMonitor(tw*xb*s*pm*pch*r) ) )
        else:
            j.append( JoinableFork( inbus.SendIter(it(xb*tw*upix*s)) ) )
            j.append( JoinableFork( wbus.SendIter(it(pm*pch*r*s)) ) )
            j.append( JoinableFork( obus.MyMonitor(tw*xb*s*pm*pch*r) ) )
        
        inst.reset.value =1
        inst.Write()
        yield ck_ev
        yield ck_ev
        inst.reset.value =0
        inst.start.value =1
        inst.dval.value =1
        inst.Write()
        yield ck_ev
        inst.reset.value =0
        inst.start.value =0
        inst.Write()
        for jj in j:
            yield from jj.Join()
            
        [jj.Destroy() for jj in j]
        yield from repeat(ck_ev,100)
    FinishSim()

rst_out , ck_ev = CreateEvents(["rst_out","ck_ev"])
RegisterCoroutines(
    [test()]

)
 
