# Copyright (C) 2017, Yu Sheng Lin, johnjohnlys@media.ee.ntu.edu.tw

# This file is part of Nicotb.

# Nicotb is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Nicotb is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Nicotb.  If not, see <http://www.gnu.org/licenses/>.
from os import environ
from nicotb import *
import numpy as np
from util import *
def rst_out_cb1():
	print("reset wait")
	yield rst_out
	print("reset out")
	yield rst_out
	print("this should not happen")

def rst_out_cb2():
	yield rst_out
	print("reset out 2")

def clk_cb():
        cbbus.SetToX()
        print( environ.get("TOPMODULE") )
        print ( type (cbbus) )
        cbbus[0].x = 0
        cbbus[2][0].value[0] = 0
        yield rst_out
        while True:
            yield clk
            abus.Read()
            cbbus[1].value = abus[0].value[0]    
            if abus.is_number:
                cbbus[0].value[0] = abus[0].value[0]
                cbbus[1].value[0] = abus[0].value[0]
            else:
                cbbus.SetToX()
            cbbus.Write()
mytype2 = StructBusCreator('mytype2' , ['l','m']  )
mytype = StructBusCreator ( 'mytype' ,  ['i','j','k'] , [3,3,6] , [(1,),(1,),(1,)] , ['logic','logic','mytype2'] )
cbbus = mytype.CreateStructBus('t')
abus = CreateBus( ('a',) )
'''
cbbus, abus = CreateBuses([
	(
		(""  , "c", (2,4)),
		(None, "b", (3,2,4)),
                (None, "t.i", ),
	),
	("a",),
])
'''
rst_out, clk = CreateEvents(["rst_out", "ck_ev"])

RegisterCoroutines([
	clk_cb(),
	rst_out_cb1(),
	rst_out_cb2(),
])


