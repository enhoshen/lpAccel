import numpy as np
from nicotb import *
from nicotb.primitives import JoinableFork
from NicoUtil import *
from SVparse import SVparse
from itertools import repeat
def BusInit():
    SBC = StructBusCreator
    SBC.TopTypes()
    confbus = SBC.Get('Conf','i_PEconf')
    instbus = SBC.Get('Inst','i_PEinst')
    dummy = CreateBus( ('dummy',) )
    return confbus , instbus , dummy
def Ctlrdyack(dummy):
    inbus = TwoWireBus( dummy,clk=ck_ev ,A=2,name='Input' )
    wbus = TwoWireBus ( dummy,clk=ck_ev ,A=5,name='Weight') 
    obus = TwoWireBus ( dummy,clk=ck_ev ,side='slave',A=5,name='MAIN')
    return inbus , wbus , obus 
def PErdyack(data):
    inbus = TwoWireBus( data[0],clk=ck_ev ,A=2,name='Input' )
    wbus = TwoWireBus ( data[1],clk=ck_ev ,A=5,name='Weight') 
    obus = TwoWireBus ( data[2],clk=ck_ev ,side='slave',A=5,name='Psum')
    return inbus , wbus , obus
def DataBusInit():
    Input , Weight , Psum = CreateBuses([
        (('','i_Input',(1,)) ,),
        ((None,'i_Weight',(16,)) ,),
        ((None,'o_Psum', (16,))  ,)
    ])
    return Input , Weight , Psum
    #TODO
def InputData(ch,tw,xb,ab,th):
    data = np.random.randn(ch,tw)
    bound = 2**(ab*xb-1)
    Quant = np.rint(np.clip(data*bound/th,-bound,bound-1 )).astype(np.int16)
    uQuant = Quant.astype(np.uint16)
    print(Quant)
    np.set_printoptions(formatter={'int':hex})
    print(uQuant)
    ch_new = int(ch*ab/16)
    ch_pack = int(16/ab)
    Repack= np.zeros( shape=(xb,int(ch*ab/16),tw),dtype=np.uint16 )
    for i in range(xb):
        for j in range(ch_new):
            for k in range(ch_pack):
                temp = (uQuant[j*ch_pack+k,:]/(2**(ab*i))).astype(np.uint16)
                temp = (temp % (2**ab)).astype(np.uint16)
                temp = (temp * (2**(ab*k))).astype(np.uint16)
                Repack[i,j,:] += temp
    print(Repack)
    return data , Quant , Repack
def WeightData(ch,r,m,wb,ab,th):
    data = np.random.randn(m,ch,r)
    bound = 2**(ab*wb-1)
    Quant = np.rint(np.clip(data*bound/th,-bound,bound-1 )).astype(np.int16)
    uQuant = Quant.astype(np.uint16)
    print(Quant)
    np.set_printoptions(formatter={'int':hex})
    print(uQuant)
    ch_new = int(ch*ab/16)
    ch_pack = int(16/ab)
    Repack= np.zeros( shape=(wb,m,ch_new,r),dtype=np.uint16 )
    for i in range(wb):
        for j in range(m):
            for k in range(ch_new):
                for l in range(ch_pack):
                    temp = (uQuant[j,k*ch_pack+l,:]/(2**(ab*i))).astype(np.uint16)
                    temp = (temp % (2**ab)).astype(np.uint16)
                    temp = (temp * (2**(ab*l))).astype(np.uint16)

                    Repack[i,j,k,:] += temp
    print(Repack)
    return data , Quant , Repack

def test():
    yield rst_out
    conf ,inst ,dummy = BusInit()
    data = DataBusInit()
    print(data)
    
    inbus , wbus ,obus = PErdyack(data)
    SVparse.hiers['PE'].ShowPorts
    conf.SetTo(0)
    inst.SetTo(0)
    config = [ (  4,4,2,1,1,3,3, 48,12,13*4,4,1,2,1,1,0,1,0,13),\
                (  4,2,3,1,1,3,3, 24,12,13*2,4,1,3,2,0,0,2,1,13),\
                 (  1,2,3,1,3,3,3, 6,3,13*2,3,0,3,2,0,0,2,1,13)  ]

    def it(i):
        for _ in range(i):
            yield dummy.value
    for i1 in range (1 ): 
        conf.values = config[0] 
        print (conf)
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
        ab = 1 if conf.Au.value[0] == 0 else conf.Au.value[0]-1
        Input = InputData(pch*ab,tw,2,ab,1.3)
        Weight = WeightData(pch*ab,r,pm,2,ab,1.3)
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
 
