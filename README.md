# RISC-V Decoder Generator

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

A RISC-V ISA docoder generator. 
```
Supported Backend : - System Verilog

Supported ISA     : - RV32/64 IMAFDQZfh
```
##  Project structure
```
├── backend
│   │ 
│   └── systemVerilog
│       │
│       ├── signals.yaml    -- singal defination for SystemVerilog
│       │
│       └── SVbackend.py       
│
├── config.yaml             -- generator config
│
├── decoder-gen.py          -- generator script
│
├── instructions
│   │
│   └── instructions.yaml   -- instruction defination
│
├── README.md
│
└── SpecParser.py           -- parse instructions 
```
## Getting Started <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See [deployment](#deployment) for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them.

```
python3
```

## Usage <a name = "usage"></a>

```
python3 gen-decoder.py -backend=sv
```
### This operation will generate 2 files : 

        - decode_pkg.sv : Define data struct

        - decoder.sv    : RISC-V decoder

### motify config (config.yaml)
``` 
    config:                                                   Add Atmoic & Float                             config: 

        - xlen : 64                                             ----------- >                                    - xlen : 64

        - supportISA  : [System,ZiCsr,RV64I,RV64M]              ----------- >                                    - supportISA  : [System,ZiCsr,RV64I,RV64M,RV64F,RV64A]

        - supportMode : [M,S]                                   ----------- >                                    - supportMode : [M,S]
```
### Add new instruction (instructions/instructions.yaml)
```
    instruction name    format                             opcodes[]                                         decode result            Extension

    - FCVTSLU   :    {format: R,  opcodes: {opcode: 7'b1010011 , func7: 7'b1101000 , rs2 : 5'b00011} , control : {use_rs2 : 1'b0} ,  ext: [RV64F]}
```
### Add new signal in SystemVerilog (backend/systemVerilog/signals.yaml)
```
    - enum : 

          name          enums

        imm_type_t : [R,I,S,B,U,J]
    
    - signal : 

          name             type              init/value(assign)                 port direction
        
        uret        : {type : "logic"       , init  : "1'b0"                , direction : output},

        rm          : {type : "logic[2:0]"  , value : "func3"               , direction : output},
```
