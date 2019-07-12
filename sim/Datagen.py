import numpy as np
from math import ceil
class LayerConf():
    def __init__(self,*arg,**kwarg):
        # avoid invoking setattr at initialization, use self.__dict__['attr']
        self.__dict__['dic']={}
        self.__dict__['arglist']= [ 'H','W','R','S','E','F','U','C','M','B','Xb','Wb','Ab','Ob','Tm','Tw','Th','Tb','Pch','Pm','Au']
        for i,v in enumerate(arg):
            self.dic[ self.arglist[i] ] = v 
        for i , v in kwarg.items(): 
            self.dic[i]=v
    def __getattr__(self,n):
        return self.dic[n] 
    def __setattr__(self,n,v):
        self.dic[n]=v
    def __repr__(self):
        s=""
        w=5
        for i in self.arglist:
            s+=f"{i:<{w}}"
        s+='\n'
        for i in self.arglist:
            v=self.dic.get(i)
            s+=f"{ '' if v==None else v:<{w}}" 
        return s
    def ToPEconf(self):
        upix = 12 if self.Pch*self.U >= 12 else self.Pch*self.U
        peconf=[self.Pch , self.Pm ,self.Au , self.Tb , self.U , self.R , self.S , self.Pch*self.R*self.Pm , self.Pch*self.R , self.Pm*self.Tw , upix , upix!=12 , self.Xb , self.Wb, 1,1,1 ,0, self.Tw]
        return peconf
class ModelConf():
    def __init__(self , layers=[]):
        self.layers=layers
        pass 
    def AddLayer(self, conf):
        self.layers.append(conf)
    def __getitem__(self,i):
        return self.layers[i]
    def __iadd__(self, conf):
        self.layers.append(conf)
    def __iter__(self):
        yield from self.layers 
AlexBest = ModelConf( [ LayerConf(227,227,11,11,55,55,4,3,64,4,8,4,4,4,64,55,55,4,2,4 ),
                        LayerConf(31,31,5,5,27,27,1,64,256,4,4,4,4,4,64,27,27,4,4,4),
                        LayerConf(15,15,3,3,13,13,1,256,256,4,4,4,4,4,64,13,13,4,4,4),
                        LayerConf(15,15,3,3,13,13,1,256,256,4,4,4,4,4,64,13,13,4,4,4),
                        LayerConf(15,15,3,3,13,13,1,256,256,4,4,4,4,4,64,13,13,4,4,4)] )
Vgg16 = ModelConf ( [   LayerConf(),
                        LayerConf()])
                    
for i in AlexBest:
    print( i ) 
def Pack(repack,x,bit_ch,pch,ab):
    ch_pack = int(16/ab)
    for i in range(bit_ch):
        for j in range(pch):
            for k in range(ch_pack):
                temp = (x[...,j*ch_pack+k]/(2**(ab*i))).astype(np.uint16)
                temp = (temp % (2**ab)).astype(np.uint16)
                temp = (temp * (2**(ab*k))).astype(np.uint16)
                repack [i,...,j]+= temp
    #pack function repack the array with additional dimension bit_ch , spliting the rightmost diemension
    #which is the channel dimension
def Quantize(x,bw,th):
    bound = 2**(bw-1)
    Quant = np.rint(np.clip(x*bound/th,-bound,bound-1 )).astype(np.int16)
    uQuant = Quant.astype(np.uint16)
    return Quant , uQuant
def InputData(pch,tw,s,   xb,ab,th):
    data = np.random.randn(s,tw,int(pch*16/ab))
    Quant , uQuant = Quantize(data,ab*xb,th)
    np.set_printoptions(formatter={'int':hex})
    Repack= np.zeros( shape=(xb,s,tw,pch ),dtype=np.uint16 )
    Pack( Repack , uQuant , xb , pch ,ab)
    Repack= np.swapaxes(Repack,0,1)
    print(s,xb,tw,pch)
    def it(bus):
        size =(s*xb*tw*pch)
        print ( size)
        for i in range(size):
            bus.value = Repack.flat[i]
            yield bus.value
        print("input done")
    return data , Quant , Repack , it
def WeightData(pch,r,m,s,    wb,ab,th):
    def onefilter( pch,r,m,s,  wb,ab,th):
        data = np.random.randn(s,m,r,int(pch*16/ab) )
        Quant , uQuant = Quantize(data,ab*wb,th)
        np.set_printoptions(formatter={'int':hex})
        Repack= np.zeros( shape=(wb,s,m,r,pch ),dtype=np.uint16 )
        Pack( Repack , uQuant , wb , pch ,ab)
        Repack= np.swapaxes(Repack,0,1)
        return data , Quant , uQuant , Repack, Pack
    datas , Quants, uQuants, Repacks, Packs = zip ( * [onefilter(pch,r,m,s, wb,ab,th) for i in range(16)])
    print(s,wb,m,r,pch)
    def it(bus):
        size = (s*wb*m*r*pch)
        print(size)
        for i in range(size):
            for f in range(16):
                bus.value[f] = Repacks[f].flat[i]
            yield bus.values
        print("weight done")
    return datas , Quants , Repacks , it
def Conv1d( r , indata, wtdata):
    pad = indata
def PsumData(m,tw,ab,th,inputdata,weightdata):
    pass
def BufData(Tm,B,Tw,Th,Pch,S,Xb,Wb):
    input_size = B*Th*Tw*Pch*Xb
    weight_size = Tm*S*S*Pch*Wb
    ibuf_write = Pch*Tw*Xb *ceil(Th/16)*B
    wbuf_write = S*S*Pch*Tm*Wb *B*ceil(Th/16) 
    ibuf_read = Tw*Pch*Xb  *B*S*ceil(Th/16) 
    wbuf_read = S*S*Pch*Tm*Wb  *B*ceil(Th/16)
    psum_write = Tw*Th *B*ceil(Tm/16)
    gb_write = input_size + weight_size + psum_write 
    gb_read = ibuf_write + wbuf_write + psum_write
    def ibuf_r(bus):
        for i in range (ibuf_read):
            bus.values = np.random.randint( np.iinfo(np.uint16).max ,size=16,dtype=np.uint16) 
            yield bus.values
    def ibuf_w(bus):
        for i in range (ibuf_write):
            bus.values = np.random.randint( np.iinfo(np.uint16).max ,size=16,dtype=np.uint16) 
            yield bus.values
    def wbuf_r(bus):
        for i in range (wbuf_read):
            bus.values = np.random.randint( np.iinfo(np.uint16).max ,size=16,dtype=np.uint16) 
            yield bus.values
    def wbuf_w(bus):
        for i in range (wbuf_write):
            bus.values = np.random.randint( np.iinfo(np.uint16).max ,size=16,dtype=np.uint16) 
            yield bus.values
    def gbuf_r(bus):
        for i in range (gb_read//4):
            bus.values = np.random.randint( np.iinfo(np.uint32).max ,size=32,dtype=np.uint32) 
            yield bus.values
    def gbuf_w(bus):
        for i in range (gb_write//4):
            bus.values = np.random.randint( np.iinfo(np.uint32).max ,size=32,dtype=np.uint32) 
            yield bus.values
    return ibuf_r ,ibuf_w , wbuf_r , wbuf_w , gbuf_r ,gbuf_w
if __name__ == "__main__":
    pass
    #d,q,r,i=InputData(4,3,1,8,1.3)
    #print( d , q ,r ) 
