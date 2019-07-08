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
    #pack function repack the array with additional dimension bit_ch , spliting the rightmost diemension
    #which is the channel dimension
def Quantize(x,bw,th):
    bound = 2**(bw-1)
    Quant = np.rint(np.clip(x*bound/th,-bound,bound-1 )).astype(np.int16)
    uQuant = Quant.astype(np.uint16)
    return Quant , uQuant
def InputData(pch,tw,s,   xb,ab,th):
    data = np.random.randn(s,tw,int(pch*ab))
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
        data = np.random.randn(s,m,r,int(pch*ab) )
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
#TODO S has not been handled
def Conv1d( r , indata, wtdata):
    pad = indata
def PsumData(m,tw,ab,th,inputdata,weightdata):
    pass
if __name__ == "__main__":
    d,q,r,i=InputData(4,3,1,8,1.3)
    print( d , q ,r ) 
