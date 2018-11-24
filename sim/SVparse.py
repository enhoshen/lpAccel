import numpy as np
class SVparse():
    package = {}
    parameter = {}
    typeName = {'logic'}
    def __init__(self):
        self.base_path = '/home/enhoshen/research/lpAccel/'
        self.queue  = []
        self.keyword = { 'logic':self.LogicParse , 'parameter':self.ParamParse, 'localparam':self.ParamParse,\
                        'typedef':['ID'] , 'struct':self.StructParse , 'packed':[] , 'package':['ID' ,'endpackage'] ,}
    def Readfile(self , path):
        self.f = open(base_path+path)
        self.lines = iter(f.readlines(),None)
    def LogicParse(self, s ):
        bw = s.BracketParse()
        bw = SVstr(''if bw == () else bw[0])
        name = s.IDParse()
        dim = s.BracketParse()  
        return (name,bw.Slice2num(),self.Tuple2num(dim),'logic')
    def ParamParse(self, s):
        name = s.IDParse()
        s.rstrip().rstrip(';')
        _n=self.parameter[name]=s.lstrip('=').S2num()
        return name,_n
    def StructParse(self, lines):
        _step = 0
        rule = [ '{' , '}' ]
        attrlist = []
        _s = SVstr(next(lines).lstrip().split('//')[0].rstrip(';'))
        while(1):
            _w = ''
            if _step == 2:
                name = _s.IDParse()
                return (name,attrlist), _s
            if _s.End():
                _s = SVstr(next(lines,'OutofEdge').lstrip().split('//')[0].rstrip(';'))
            _w = _s.lsplit() 
            if _w == rule[_step]:
                _step = _step+1
                continue
            _catch = self.keyword[_w](_s) 
            if _w in self.typeName:
                attrlist.append(_catch) 
    def CleanParse(self, s):
        return s.split('//')[0]
    def Parsefile(self):
        pass                   
    def Tuple2num(self, t):
        return tuple(map(lambda x : int(x),t))

class SVstr():
    sp_chars = ['=','{','}','[',']','::' ]
    def __init__(self,s):
        self.s = s
    def split( self, sep=None, maxsplit=-1):
        return self.s.split(sep=sep,maxsplit=maxsplit)
    def lstrip(self,chars=None):
        self.s = self.s.lstrip(chars)
        return self
    def rstrip(self,chars=None):
        self.s = self.s.rstrip(chars)
        return self
    def lsplit(self,sep=None):    
        #split sep or any special chars from the start
        self.lstrip()
        _s = ''
        if self.s[0] in self.sp_chars:
            _s = self.s[0]
            self.s = self.s[1:]
            return _s
        _s = self.s.split(sep,maxsplit=1)
        self.s , _s = (_s[1] , _s[0]) if len(_s) != 1 else ('', _s[0][0])
        return _s
    def FirstSPchar(self):
        # FUCKING cool&concise implementation:
        return next( (i for i,x in enumerate(self.s) if x in self.sp_chars) , -1)
        #_specC = [ x for x in (map(self.s.find,self.sp_chars)) if x > -1]
        #_idx = -1 if len(_specC) == 0 else min(_specC)
        #return _idx
    def IDParse (self):
        # find one identifier at the start of the string
        self.s = self.s.lstrip()
        _idx = self.FirstSPchar()
        if _idx != -1:
            _s = self.s[0:_idx]
            self.s = self.s[_idx:]
            return _s.rstrip()
        _s = self.s.rstrip('\n').rstrip().split(maxsplit=1)
        self.s =  _s[1] if len(_s)>1 else ''
        return _s[0].rstrip(';')
    def BracketParse(self,  bracket = '[]' ):
        # find and convert every brackets at the start of the string
        self.s = self.s.lstrip()
        num = []
        while(1):
            if self.End() or self.s[0] != bracket[0]:
                break
            rbrack = self.s.find(bracket[1])
            num.append(self.s[1:rbrack] )
            self.s=self.s[rbrack+1:].lstrip()
        return tuple(num)
    def KeywordParse(self, key , rules ):
        _step = 0
        self.s = self.s.lsplit()
        if self.s == None:
            raise StopIteration
        if _step == len(rules) :
            return
    def Arit2num(self, s):
        pass
    def S2num(self,parameters=SVparse.parameter):
        _lflag = False
        if '$clog2' in self.s:
            _lflag=True
            self.s = self.s.split('(')[1].split(')')[0] 
        #TODO package import :: symbol
        if self.s in parameters:
            self.s = parameters[self.s]
        _n = int(self.s)
        self.s = ''
        return int(np.log2(_n)) if _lflag==True else _n
    def Slice2num(self,parameters=SVparse.parameter):
        if self.s == '':
            return 1
        self.s,_e = self.s.split(':')
        if self.s in parameters:
            return parameters[self.s]-SVstr(_e).S2num(parameters)+1
        else:
            return self.S2num(parameters)-SVstr(_e).S2num(parameters)+1
    def __len__(self):
        return len(self.s)
    def __contains__(self,st):
        return st in self.s
    def End(self):
        return self.s==''
if __name__ == '__main__':

    sv = SVparse()
    ss = SVstr
    print(ss('[3]').BracketParse() )
    print(sv.ParamParse(ss('DW  =4;'))  )
    #print(ss(' happy=4;').IDParse())
    #print(sv.parameter)
    #print(ss('waddr;\n').IDParse() )
    #print(sv.LogicParse(ss(' [ $clog2(DW):0]waddr[3] [2][1];')) )
  #  print(sv.Slice2num(' 13:0 '))
    print(sv.StructParse(iter([' {logic a [2];','parameter sex =5;',' logic b [3];', '} mytype;',' logic x;'])))
    print(sv.parameter)
