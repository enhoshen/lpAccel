import numpy as np
import parser as ps
import re
from os import environ
from collections import namedtuple
from collections import deque
class SVhier ():
    def __init__(self,name,scope):
        self.hier= name
        self.params = {}
        self.types = {}
        self.child = {}
        self._scope = scope
        if scope != None:
            scope.child[name] = self
    @property
    def scope(self):
        return self._scope
    @scope.setter
    def scope(self,scope):
        self._scope=scope
    @property
    def Params(self):
        if self._scope == None:
            return deque([h.params for _ , h in self.child.items()]) 
        else:
            _l = self._scope.Params
            _l.appendleft(self.params)
            return _l
    @property
    def Types(self):
        if self._scope == None:
            return deque([h.types for _ , h in self.child.items()]) 
        else:
            _l = self._scope.Types
            _l.appendleft(self.types)
        return _l
    @property
    def ShowTypes(self):
        for k,v in self.types.items():
            self.TypeStr(k,v)
    @property
    def ShowParams(self):
        self.ParamStr()
    def TypeStr(self,n,l,w=13):
        print('{0:{fill}{align}{width}}'.format(self.hier+'.'+n,width=4*w,align='^',fill='-'))
        for i in ['name','BW','dimension' , 'type']:
            print('{:{width}}'.format(i,width=w) , end=' ')
        print('\n{0:{fill}{align}{width}}'.format('',width=4*w,align='<',fill='=') )
        for i in l:
            for idx,x in enumerate(i):
                if idx < 4:
                    print ('{:{width}}'.format(x.__repr__(),width=w) , end=' ')
                else:
                    print('\n{:{align}{width}}'.format(x.__repr__(),width=4*w,align='^'))
            print()
    def ParamStr(self,w=13):
        for i in ['name','value']:
            print('{:{width}}'.format(i,width=w) , end=' ')
        print('\n{0:{fill}{align}{width}}'.format('',width=2*w,align='<',fill='=')  )
        l = self.params
        for k,v in l.items():
            print ('{:{width}}{:{width}}'.format(k,v.__repr__(),width=w) , end=' ')
            print()
       
    def __repr__(self):
        return '\n=====name=====:'+self.hier+'\n'+'=====params=====:{:}\n'.format(self.params.__repr__(),align='^')+\
                '=====scope=====:{:}\n'.format(self._scope.hier)+\
                '=====types=====:{:}\n'.format([x for x in self.types].__repr__(),align='^')+ \
                '=====child=====:{:}\n'.format( [x for x in self.child].__repr__(),align='^')
class SVparse():
    package = {}
    hiers = {}
    gb_hier = SVhier('files',None)
    gb_hier.types =  {'integer':None,'int':None,'logic':None}
    cur_scope = ''
    base_path = '/home/enhoshen/research/lpAccel/'
    include_path = '/home/enhoshen/research/lpAccel/include/' 
    def __init__(self,name,scope):
        self.cur_hier = SVhier(name,scope) if scope != None else SVhier(name,self.gb_hier) 
        SVparse.hiers[name]= self.cur_hier
        self.cur_key = ''
        self.keyword = { 'logic':self.LogicParse , 'parameter':self.ParamParse, 'localparam':self.ParamParse,\
                        'typedef':self.TypeParse , 'struct':self.StructParse  , 'package':self.HierParse , 'enum': self.EnumParse,\
                        'module':self.HierParse , 'import':self.ImportParse}
    @classmethod
    def ParseFiles(cls , path , inc=True ):
        _top =  environ.get("TOPMODULE") 
        _top = _top if _top != None else ''
        paths = cls.IncludeFileParse(path) if inc == True else path
        for p in  paths:
            print(p)
            n = p.rsplit('/',maxsplit=1)[1]
            cur_parse = SVparse( n , cls.gb_hier)
            cur_parse.Readfile(p)
    @classmethod 
    def IncludeFileParse(cls , path):
        f = open(cls.include_path+path)
        paths = []
        for line in f.readlines():
            line = line.split('//')[0]
            if '`include' in line:
                line = line.split('`include')[1].split()[0].replace('"','')
                paths.append( cls.include_path+line)
        return paths
    def Readfile(self , path):
        self.f = open(path)
        self.lines = iter(self.f.readlines())
        _s = self.Rdline(self.lines)
        while(1):
            _w = ''
            if _s == None:
                return
            if _s.End():
                _s=self.Rdline(self.lines)
                continue 
            _w = _s.lsplit()
            _catch = None
            if _w in {'typedef','package','import','module'}:
                self.cur_key = _w
                _catch = self.keyword[_w](_s,self.lines) 
    def LogicParse(self, s ,lines):
        bw = s.BracketParse()
        bw = SVstr(''if bw == () else bw[0])
        name = s.IDParse()
        dim = s.BracketParse()  
        return (name,bw.Slice2num(self.cur_hier.Params),self.Tuple2num(dim),'logic')
    def ParamParse(self, s ,lines):
        #TODO type parse (in SVstr) , array parameter 
        name = s.IDParse()
        dim = s.BracketParse()
        s.rstrip().rstrip(';').rstrip(',')
        _n=self.cur_hier.params[name]=s.lstrip('=').S2num(self.cur_hier.Params)
        return name,_n
    def EnumParse(self, s , lines):
        
        if 'logic' in s:
            s.lsplit()
        bw = s.BracketParse()
        bw = SVstr('' if bw==() else bw[0])    
        _s = s.lsplit('}')
        _enum = SVstr(_s).ReplaceSplit(['{',','] )
        for i,p in enumerate(_enum):
            self.cur_hier.params[p]= i
        name = s.IDParse()
        return ( name ,bw.Slice2num(self.cur_hier.Params),() , 'enum' , _enum  )
    def ImportParse(self, s , lines):
        s = s.split(';')[0]
        _pkg , _param = s.rstrip().split('::')
        if _param == '*':
            for k,v in self.package[_pkg].params.items():
                self.cur_hier.params[k] = v
            for k,v in self.package[_pkg].types.items():
                self.cur_hier.types[k] = v
        else:
            self.cur_hier.params[_param] = self.package[_pkg].params[_param]
            self.cur_hier.types[_param] = self.package[_pkg].types[_param]
    def StructParse(self ,s ,lines ):
        _step = 0      
        rule = [ '{' , '}' ]
        attrlist = []
        _s = s
        while(1):
            _w = ''
            if _step == 2:
                name = _s.IDParse()
                return (name,attrlist)
            if _s.End():
                _s=self.Rdline(lines)
                continue
            _w = _s.lsplit()
            if _w == rule[_step]:     
                _step = _step+1
                continue
            if _w in self.keyword:
                _catch = self.keyword[_w](_s,lines)
                attrlist.append(_catch)
                continue
            for t in self.cur_hier.Types:
                if _w in t :
                    _n = _s.IDParse()
                    dim = s.BracketParse()
                    attrlist.append( ( _n , np.sum([x[1] for x in t[_w] ]) ,self.Tuple2num(dim) , _w) )
                    break
    def TypeParse(self, s , lines):
        _w = s.lsplit()
        _catch = self.keyword[_w](s , lines)
        if _w == 'struct':
            self.cur_hier.types[_catch[0]] = _catch[1]
        else :
            self.cur_hier.types[_catch[0]] = [_catch] 
    def HierParse(self,  s , lines):
        name = s.IDParse()
        new_hier = SVhier(name, self.cur_hier)
        SVparse.hiers[name] = new_hier        
        self.cur_hier = new_hier
        _end = {'package':'endpackage' , 'module':'endmodule'}[self.cur_key]
        if self.cur_key == 'package':
            self.package[name] = new_hier
        while(1):
            _w=''
            if s.End():
                s = self.Rdline(lines)
                continue
            _w = s.lsplit()
            if _w == _end:
                break 
            if _w in self.keyword:
                _k = self.cur_key
                self.cur_key = _w
                _catch = self.keyword[_w](s,lines)
                self.cur_key = _k
        self.cur_hier = self.cur_hier.scope   
    def Rdline(self, lines):
        s = next(lines,None) 
        return SVstr(s.lstrip().split('//')[0].rstrip().strip(';')) if s != None else None
    def Tuple2num(self, t ):
        return tuple(map(lambda x : SVstr(x).S2num(params=self.cur_hier.Params) ,t))
class SVstr():
    sp_chars = ['=','{','}','[',']','::',';']
    op_chars = ['+','-','*','/','(',')']
    def __init__(self,s):
        self.s = s
    def __repr__(self):
        return self.s
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
        if self.End():
            return ''
        _s = self.s
        if sep == None:    
            _idx = SVstr(_s).FirstSPchar()
            _spidx = _s.find(' ')
            if _idx != -1 and (_idx < _spidx or _spidx == -1):
                if _idx == 0:
                    _s , self.s = _s[0] , _s[1:]
                else:
                    _s , self.s = _s[0:_idx] , _s[_idx:]
            else:
                _s  = _s.split(maxsplit=1)
                self.s = _s[1] if len(_s)>1 else ''
                _s = _s[0]
            return _s
        _s = _s.split(sep,maxsplit=1)
        if len(_s)!=0:
            self.s=_s[1]
            _s = _s[0]
        else:
            _s = ''
            self.s=''
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
    def TypeParse(self , params):
        pass
    def KeywordParse(self, key , rules ):
        _step = 0
        self.s = self.s.lsplit()
        if self.s == None:
            raise StopIteration
        if _step == len(rules) :
            return
    def Arit2num(self, s):
        pass
    def S2num(self,params):
        _s = self.s.lstrip()
        if '$clog2' in _s:
            _temp = self.s.split('(')[1].split(')')[0] 
            _s = _s.replace( _s[_s.find('$'):_s.find(')')+1] , 'int(np.log2('+ _temp + '))')
        _s_no_op = SVstr(_s).ReplaceSplit(self.op_chars)
        #TODO package import :: symbol  , white spaces around '::' not handled
        for w in _s_no_op:
            if '::' in w:
                _pkg , _param = w.split('::')
                _s = _s.replace(_pkg+'::'+_param,str(SVparse.package[_pkg].params[_param]) )
            for p in params:    
                if w in p:
                    _s = _s.replace( w , str(p[w]) )
                    break
        _s = _s.replace('{','[').replace('}',']').replace('\'','')
        return eval(ps.expr(_s).compile('file.py'))
    def Slice2num(self,params):
        if self.s == '':
            return 1
        _temp = self.s.replace('::','  ')
        _idx = _temp.find(':')
        _s,_e = self.s[0:_idx] , self.s[_idx+1:]
        return SVstr(_s).S2num(params)-SVstr(_e).S2num(params)+1
    def ReplaceSplit(self, clist):
        _s = self.s
        for c in clist:
            _s = _s.replace(c, ' ')
        return _s.split()
    def __len__(self):
        return len(self.s)
    def __contains__(self,st):
        return st in self.s
    def End(self):
        return self.s==''
if __name__ == '__main__':

    #sv = SVparse('SVparse',None)
    #print (sv.gb_hier.child)
    #ss = SVstr
    #print(ss('[3]').BracketParse() )
    #print(sv.ParamParse(ss('DW  =4;'))  )
    #print(ss(' happy=4;').IDParse())
    #print(sv.parameter)
    #print(ss('waddr;\n').IDParse() )
    #print(sv.LogicParse(ss(' [ $clog2(DW):0]waddr[3] [2][1];')) )
    #print(sv.Slice2num(' 13:0 '))
    #print(sv.StructParse(iter([' {logic a [2];','parameter sex =5;',' logic b [3];', '} mytype;',' logic x;'])))
    import sys
    SVparse.ParseFiles(sys.argv[1])
    #
    #print('typedef \'Conf\' under PECfg:')
    #    #SVparse.IncludeFileParse('PE_compile.sv')
    #for i in SVparse.gb_hier.child['DatapathControl.sv'].Types:
    #    print(i)
    #for i in SVparse.hiers.keys():
    #    print (i)
    #print(SVparse.hiers['PECtlCfg'])
