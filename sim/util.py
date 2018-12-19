from nicotb import *
from SVparse import *
import os
import itertools
import numpy as np
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
    def value(self):
        return [ x.value for x in self.buses]
    def SetToZ(self):
        [ x.SetToZ() for x in self.buses ]
    def SetToX(self):
        [ x.SetToX() for x in self.buses ]
    def SetToN(self):
        [ s._x.fill(0) for x in self.buses for s in x.signals ]
    def SetTo(self,n):
        self.SetToN()
        [ s._v.fill(n) for x in self.buses for s in x.signals]
    def Write(self):
        [ x.Write() for x in self.buses ]
    def Read(self):
        [ x.Read() for x in self.buses ]
    #TODO *arg setter
    def __setitem__(self, k , v):
        i = self.namelist[k]
        for x in v:
            self.buses[i].value = x
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
def FileParse(inc=True):
    p = SV if inc == True else [SV]
    SVparse.ParseFiles(p,inc)

def clk_cnt():

    global n_clk
    while(1):
        yield ck_ev
        n_clk+=1    

