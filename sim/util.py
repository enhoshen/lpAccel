from nicotb import *
from SVparse import *
import os
import itertools
import numpy as np
from nicotb.protocol import TwoWire
from nicotb.protocol import OneWire 
TOP = os.environ.get("TOPMODULE")
TEST = os.environ.get("TEST")
SV = os.environ.get("SV")
class StructBus:
    "name , bw , dim , type , enum literals"
    def __init__ (self, structName,attrs, buses):
        self.structName= structName
        self.attrs = attrs
        self.namelist = {v[0]:i for i,v in enumerate(self.attrs)}
        self.buses = buses
    def __getitem__(self,i):
        return self.buses[i]
    @property
    def values(self):
        return [ x.values for x in self.buses]
    @values.setter
    def values(self, v):
        for bb,vv in zip(self.buses,v):
            try:
                bb.values = vv 
            except:
                bb.value = vv
    def SetToZ(self):
        [ x.SetToZ() for x in self.buses ]
    def SetToX(self):
        [ x.SetToX() for x in self.buses ]
    def SetToN(self):
        [ x.SetToN() if isinstance(x,StructBus) else [s._x.fill(0) for s in x.signals]  for x in self.buses]
    def SetTo(self,n):
        self.SetToN()
        [ x.SetTo(n) if isinstance(x,StructBus) else [s._value.fill(n) for s in x.signals] for x in self.buses ]
    def Write(self):
        [ x.Write() for x in self.buses ]
    def Read(self):
        [ x.Read() for x in self.buses ]
    #TODO *arg setter
    def __setitem__(self, k , v):
        i = self.namelist[k]
        for x in v:
            self.buses[i].value = x
    def __getattr__(self,k):
        return self.buses[self.namelist[k]]
class StructBusCreator():
    structlist = {'logic':[],'enum':[]}
    def __init__ ( self, structName , attrs):
        for memb in attrs:
            assert self.structlist.get(memb[3] ) != None , "change the declaration order"
        if self.structlist.get(structName) == None:
            self.structlist[structName] = self
        self.structName = structName
        self.attrs = attrs
    @classmethod
    def Alltypes(cls,inc=True):
        FileParse(inc)
        for h in SVparse.hiers.values():
            for k,v in h.types.items():
                StructBusCreator(k,v)
    @classmethod
    def TopTypes(cls,inc=True):
        FileParse(inc)
        for T in SVparse.hiers[TOP].Types:
            for k,v in T.items():
                StructBusCreator(k,v)
    @classmethod
    def Get(cls,i,name):
        return cls.structlist[i].CreateStructBus(name)
    def CreateStructBus (self, signalName):
        #buses = {'logic' :  CreateBus( self.createTuple(signalName) )}
        buses = []
        attrs = self.structlist[self.structName].attrs
        for  n , bw, dim ,t ,*_ in attrs :
            
            if t=='logic':
                buses.append ( CreateBus( ((None, signalName+'.'+n ,dim),) ) )
            elif t == 'enum':
                buses.append ( CreateBus( ((None, signalName , dim ),) ) )
            else:
                buses.append ( self.structlist[t].CreateStructBus( signalName+'.'+n ) )
        return StructBus(self.structName,attrs,buses)
global ck_ev
class ProtoBus ():
    def __init__(self):
        pass
    def ArgParse(self, protoCallback, portCallback,*args , clk  , **kwargs):
        # args[0] is the data bus, it could be a list, ex: [hrdata,hwdata] in AHB
        # portCallback should return list of buses for protocl buses
        # protoCallback should create the protocal object, ex: TwoWire.Master
        kw = dict(kwargs)
        if len(args) == 0:
            self.data = kw['data']
        else:
            self.data = args[0]

        if len(args)==1:
            protolist =  portCallback( kw['name'] )
            kw.pop('name')
            self.proto = protoCallback( *(protolist+self.data) ,clk=clk ,**kw)
        else:
            self.proto = protoCallback( *args , clk=clk ,**kw)
    def SideChoose (self, side='master'):
        if side == 'master':
            self.master = self.proto
            return
        if side == 'slave':
            self.slave = self.proto
            return
    def SendIter(self,it):
        yield from self.master.SendIter(it)
    def Monitor(self):
        self.slave.Monitor()
    @property
    def values(self):
        return [ x.values for x in self.data]
class TwoWireBus ( ProtoBus):
    def __init__( self , *args ,clk , side='master' , **kwargs ):
        protoCallback = TwoWire.Master if side == 'master' else TwoWire.Slave
        self.ArgParse(protoCallback, self.PortParse, *args, clk=clk, **kwargs)
        self.SideChoose(side)
    def PortParse(self, name):
        self.rdy , self.ack = CreateBuses( [(name+'_rdy',) , (name+'_ack',) ])
        return [self.rdy , self.ack]
class OneWireBus ( ProtoBus): 
    def __init__(self, *args, clk , side = 'master' , **kwargs):
        protoCallback = OneWire.Master if side == 'master' else OneWire.Slave
        self.ArgParse(protoCallback, self.PortParse, *args , clk=clk , **kwargs)
        self.SideChoose(side)
    def PortParse(self,name):
        self.dval = CreateBus( (name+'_dval',))
        return [self.dval]
def FileParse(inc=True):
    p = SV if inc == True else [SV]
    SVparse.ParseFiles(p,inc)
def RdyAckBuses ( names ):
    return CreateBuses( [ () for n in names] )
def clk_cnt():

    global n_clk
    while(1):
        yield ck_ev
        n_clk+=1    

