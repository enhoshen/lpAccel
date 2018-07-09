# ==================================================================
# This confidential and proprietary software may be used only as 
# authorized by a licensing agreement from National Taiwan University.
# (C) COPYRIGHT 2018 Media IC & System Lab,
# Graduate Institute of Electronics Engineering,
# National Taiwan University. ALL RIGHTS RESERVED
# -------------------------------------------------------------------
# FILE NAME      : DivPipe_test.py
# TYPE           : TESTBENCH
# DEPARTMENT     : Media IC & System Lab
# AUTHOR         : Shih-Yi, Wu
# AUTHOR'S EMAIL : sywu@media.ee.ntu.edu.tw
# --------------------------------------------------------------------
from nicotb import *
from nicotb.utils import Scoreboard, BusGetter, Stacker
from nicotb.protocol import OneWire, TwoWire
import numpy as np
from itertools import repeat
from collections import deque
from ctypes import *
import os

# ========== Global variable ========== #
NUMBW = 16
DENBW = 16

# ========== Bus declaration ========== #
i_dval ,i_dat, o_dval, o_bus = CreateBuses([
    (("i_dval"),),
    (
     ("num"),
     ("den")
    ),
    (("quot_dval"),),
    (("quot"),),
])

# ========== verify function ========== #
def div(num, den):
    golden = list()
    for i in range(len(num)):
        ans = num[i] / den[i] if den[i] != 0 else 0
        ans = np.floor(ans) if ans > 0 else np.ceil(ans)
        golden.append([ans])
    golden = np.asarray(golden, dtype=np.int32)
    return golden

def create_scoreboard(tst_num, golden):
    file_name = os.path.basename(__file__)
    file_name = file_name.split(".")[0]
    scb = Scoreboard(file_name)
    test = scb.GetTest(file_name)
    st = Stacker(tst_num, callbacks=[test.Get])
    bg = BusGetter(callbacks=[st.Get])
    test.Expect((golden,))
    return bg

# ====== simulation time counter ====== # (fix)
n_clk = 0
def clk_cnt():
    global n_clk
    while(1):
        yield ck_ev
        n_clk += 1

# ========= Event declaration ========= # (fix)
rst_out_ev, ck_ev = CreateEvents(["rst_out", "ck_ev",])

def main():
    # ===== Define Data and protocol ====== # 
    # Using data valid protocol to check the result (One Wire)
    master = OneWire.Master(i_dval, i_dat, ck_ev, strict=strict)

    tst_num = 100
    nums = np.random.randint(0, 2**NUMBW, tst_num, dtype=np.int32) - 2**(NUMBW-1)
    dens = np.random.randint(0, 2**DENBW, tst_num, dtype=np.int32) - 2**(DENBW-1)

    golden = div(nums, dens)

    scb_bg = create_scoreboard(tst_num, golden)
    # Using data valid protocol to check the result (One Wire)
    slave = OneWire.Slave(o_dval, o_bus, ck_ev, callbacks=[scb_bg.Get])

    # ========= Reset ========= # (fix)
    yield rst_out_ev
    yield ck_ev

    # ===== Sending Data ====== # 
    values = master.values
    def it():
        for i in range(tst_num):
            values.num[0] = nums[i]
            values.den[0] = dens[i]
            yield values
    yield from master.SendIter(it(), latency=30)

    # ========= Finish ========= # (fix)
    yield from repeat(ck_ev, 100)
    FinishSim()
    print("clk number:", n_clk)


sim_cfg = CreateBus(("GATE_LEVEL",))
sim_cfg.Read()
strict = False if sim_cfg.GATE_LEVEL.value[0] else True
# ========= RegisterCoroutines ========= # (fix)
RegisterCoroutines([
    main(),
    clk_cnt(),
])