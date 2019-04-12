import numpy as np
def Pack(repack,x,bit_ch,ch,ab):
    ch_new = int(ch*ab/16)
    ch_pack = int(16/ab)
    for i in range(bit_ch):
        for j in range(ch_new):
            for k in range(ch_pack):
                temp = (x[...,j*ch_pack+k]/(2**(ab*i))).astype(np.uint16)
                temp = (temp % (2**ab)).astype(np.uint16)
                temp = (temp * (2**(ab*k))).astype(np.uint16)
                repack [i,...,j]+= temp
def Quantize(x,bw,th):
    bound = 2**(bw-1)
    Quant = np.rint(np.clip(x*bound/th,-bound,bound-1 )).astype(np.int16)
    uQuant = Quant.astype(np.uint16)
    return Quant , uQuant
def InputData(ch,tw,xb,ab,th):
    data = np.random.randn(tw,ch)
    Quant , uQuant = Quantize(data,ab+xb,th)
    np.set_printoptions(formatter={'int':hex})
    Repack= np.zeros( shape=(xb,tw,int(ch*ab/16) ),dtype=np.uint16 )
    Pack( Repack , uQuant , xb , ch ,ab)
    ch_new = int(ch*ab/16)
    print(xb,tw,ch_new)
    def it(bus):
        for i in range(xb):
            for j in range(tw):
                for k in range(ch_new):
                    bus.value = Repack[i,j,k]
                    yield bus.value
        print("input done")
    return data , Quant , Repack , it
def WeightData(ch,r,m,wb,ab,th):
    data = np.random.randn(m,r,ch)
    Quant , uQuant = Quantize(data,ab+wb,th)
    np.set_printoptions(formatter={'int':hex})
    Repack= np.zeros( shape=(wb,m,r,int(ch*ab/16) ),dtype=np.uint16 )
    Pack( Repack , uQuant , wb , ch ,ab)
    ch_new = int(ch*ab/16)
    print(wb,m,r,ch_new)
    def it(bus):
        for i in range(wb*m*r*ch_new):
            bus.value = Repack.flat[i]
            yield bus.value
        print("weight done")
    return data , Quant , Repack , it
def Conv1d( r , indata, wtdata):
    pad = indata
def PsumData(m,tw,ab,th,inputdata,weightdata):
    pass
if __name__ == "__main__":
    d,q,r,i=InputData(4,3,1,8,1.3)
    print( d , q ,r ) 
