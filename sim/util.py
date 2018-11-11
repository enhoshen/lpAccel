from nicotb import *
import itertools
import numpy as np
class StructBus:
    __slots__ = ['structName' , 'buses', 'busesMask']
    def __init__ (self, structName, buses):
        self.structName= structName
        self.buses = buses
        self.busesMask = [ True if i == 'logic' else False for i in StructBusCreator.structAttr[self.structName][4] ]
    def __getitem__(self,i):
        return self.buses[i]
    def SetToZ(self):
        [ x.SetToZ() for x in self.buses ]
    def SetToX(self):
        [ x.SetToX() for x in self.buses ]
    def SetTo(self,n):
        [ s._x.fill(0) for x in self.buses for s in x.signals ]
    def Write(self):
        [ x.Write() for x in self.buses ]
    def Read(self):
        [ x.Read() for x in self.buses ]
    #TODO *arg setter
class StructBusCreator():
    structlist = {'logic': lambda membName,memDim:(None,memName,memDim)}
    structAttr = {}
    def __init__ ( self, structName ,membName , membBW=None , membDim=None, membType=None):
        if membType != None:
            for T in membType:
                assert self.structlist.get(T) != None , "change the declaration order"
        _size = len(membName)
        dup = lambda x : [x for _ in range(_size) ]
        _bw =  membBW if membBW !=None else dup(1)
        _dim = membDim if membDim !=None else dup( tuple() )
        _type = membType if membType !=None else dup('logic')

        if self.structAttr.get(structName) == None :
            self.structAttr[structName] = (structName, membName, _bw , _dim, _type)
        if self.structlist.get(structName) == None:
            self.structlist[structName] = self.CreateStructBus
        self.structName = structName
    def CreateTuple(self, signalName):
        sigNames = [ signalName+'.'+i for i in self.self.structAttr[self.structName][1] ]
        sigDim  = [ i for i in self.structAttr[self.structName][3] ]
        return tuple(itertools.zip_longest ( (None,) , sigNames , sigDim ) )
    def CreateStructBus (self, signalName):
        #buses = {'logic' :  CreateBus( self.createTuple(signalName) )}
        buses = []
        for _ , n , bw, dim ,t  in zip(*self.structAttr[self.structName]) :
            
            if t=='logic':
                buses.append ( CreateBus( ((None, signalName+'.'+n ,dim),) ) )
            else:
                buses.append ( self.structlist[t]( signalName+'.'+n ) )
        return StructBus(self.structName,buses)
def clk_cnt():

    global n_clk
    while(1):
        yield ck_ev
        n_clk+=1    


