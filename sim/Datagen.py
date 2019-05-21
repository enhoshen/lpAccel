import numpy as np
def Pack(repack,x,bit_ch,pch,ab):
    ch_pack = int(16/ab)
    for i in range(bit_ch):
        for j in range(pch):
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
def InputData(pch,tw,xb,ab,th):
    data = np.random.randn(tw,int(pch*ab))
    Quant , uQuant = Quantize(data,ab*xb,th)
    np.set_printoptions(formatter={'int':hex})
    Repack= np.zeros( shape=(xb,tw,pch ),dtype=np.uint16 )
    Pack( Repack , uQuant , xb , pch ,ab)
    print(xb,tw,pch)
    def it(bus):
        for i in range(xb):
            for j in range(tw):
                for k in range(pch):
                    bus.value = Repack[i,j,k]
                    yield bus.value
        print("input done")
    return data , Quant , Repack , it
def WeightData(pch,r,m,wb,ab,th):
    data = np.random.randn(m,r,int(pch*ab) )
    Quant , uQuant = Quantize(data,ab*wb,th)
    np.set_printoptions(formatter={'int':hex})
    Repack= np.zeros( shape=(wb,m,r,pch ),dtype=np.uint16 )
    Pack( Repack , uQuant , wb , pch ,ab)
    print(wb,m,r,pch)
    def it(bus):
        print(wb*m*r*pch)
        for i in range(wb*m*r*pch):
            bus.value = Repack.flat[i]
            yield bus.value
        print("weight done")
    return data , Quant , Repack , it
#TODO S has not been handled
def Conv1d( r , indata, wtdata):
    pad = indata
def PsumData(m,tw,ab,th,inputdata,weightdata):
    pass
if __name__ == "__main__":
    d,q,r,i=InputData(4,3,1,8,1.3)
    print( d , q ,r ) 
