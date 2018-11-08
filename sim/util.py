from nicotb import *
import itertools
import numpy as np
class structBus:
    __slots__ = ['structName' , 'buses', 'busesMask']
    def __init__ (self, structName, buses):
        self.structName= structName
        self.buses = buses
        self.busesMask = [ True if i == 'logic' else False for i in structBusCreator.structAttr[self.structName][4] ]
    def __getitem__(self,i):
        return self.buses[i]
    def SetToZ(self):
        map(lambda x:x.SetToZ() , self.buses)
    def SetToX(self):
        map(lambda x:x.SetToX() , self.buses)
    def Write(self):
        map(lambda x:x.Write() , self.buses)
    def Read(self):
        map(lambda x:x.Read() , self.buses)
class structBusCreator():
    structlist = {'logic': lambda memName,memDim:(None,memName,memDim)}
    structAttr = {}
    def __init__ ( self, structName ,membName , memBW , memDim, memType):
        for T in memType:
            print(structBusCreator.structlist)
            assert structBusCreator.structlist.get(T) != None , "change the declaration order"
        if structBusCreator.structAttr.get(structName) == None :
            structBusCreator.structAttr[structName] = (structName, membName, memBW , memDim, memType)
        if structBusCreator.structlist.get(structName) == None:
            structBusCreator.structlist[structName] = self.createStructBus
        self.structName = structName
    def createTuple(self, signalName):
        sigNames = [ signalName+'.'+i for i in structBusCreator.structAttr[self.structName][1] ]
        sigDim  = [ i for i in structBusCreator.structAttr[self.structName][3] ]
        return tuple(itertools.zip_longest ( (None,) , sigNames , sigDim ) )
    def createStructBus (self, signalName):
        #buses = {'logic' :  CreateBus( self.createTuple(signalName) )}
        buses = []
        for _ , n , bw, dim ,t  in zip(*structBusCreator.structAttr[self.structName]) :
            
            if t=='logic':
                buses.append ( CreateBus( ((None, signalName+'.'+n ,dim),) ) )
            else:
                buses.append ( structBusCreator.structlist[t]( signalName+'.'+n ) )
        return structBus(self.structName,buses)
def clk_cnt():

    global n_clk
    while(1):
        yield ck_ev
        n_clk+=1    


