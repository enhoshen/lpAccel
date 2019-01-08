# Processing unit implementation
## Dataflow Controller
Dataflow Controller mainly consist of three parts:
1. Loop index computation, it records the current state of the ongoing 1D convolution within the PE, and it helps determine viable data prefetching of *input*, *weight*, and sends out any doable dot product operations (**psum+=input*weight** down the datapath. These three control unit are generally multi-layer loop with increments of 1, they can all be implemented with the module single increment Loop counter module `LoopCounter` under `src/common/LoopCtrl.sv`
2. `TODO`
3. `TODO` 
