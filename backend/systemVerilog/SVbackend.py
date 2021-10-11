#!/usr/bin/python3

import yaml
import numpy as np
HEADER = 'decoder_pkg.sv'
MODULE = 'decoder.sv'
SIGNAL = 'backend/systemVerilog/signals.yaml'
indent = 0
def printf(f,string = ''):
    f.write( ' ' * indent + string )

def parse_signal():
    with open(SIGNAL,'r') as f:
        signal_yaml = yaml.load(f.read(),Loader=yaml.SafeLoader)
        enum_dict   = signal_yaml['enum']
        signal_dict = signal_yaml['signals']
    return {'enum' : enum_dict, 'signal' : signal_dict}

def insert_signal(spec,signal_dict):
    for opcode,data in spec['opcodes'].items():
        if opcode in signal_dict['signal']:
            pass
        else:
            upper,lower = data.split('..')
            length = int(upper) - int(lower) + 1
            signal_dict['signal'][opcode] = {'type' : "logic[{}:0]".format(length-1), 'value' : "instruction[{}:{}]".format(upper,lower)}
    signal_dict['enum']['uop_t'] = spec['instructions_name']
    return signal_dict

def gen_header(signal_dict):
    def gen_enum(f):
        global indent
        indent += 4
        printf(f,'/* define enum */\n')
        for enum,data in signal_dict['enum'].items():
            width = int(np.ceil(np.log2(len(data))))
            printf(f,"typedef enum logic[{}:0]{}\n".format(width,'{'))
            indent += 4
            string = ''
            for i,item in enumerate(data):
                string = string + item
                if i != len(data)-1:
                    string = string + ', ' if i%10 != 9 else (string + ',\n' + " "*indent)
                else:
                    string = string + '\n'
            printf(f,string)
            indent -= 4
            printf(f,'{} {};\n'.format("}",enum))
        indent -= 4
    with open(HEADER,'w') as f:
        global indent
        indent = 0
        printf(f,'package {};\n'.format(HEADER.split(".")[0]))
        gen_enum(f)
        printf(f,'endpackage\n')


def gen_module(spec,signal_dict):
    def gen_io_define(f):
        global indent
        printf(f,'module {}\n'.format(MODULE.split(".")[0]))
        printf(f,'    import {}::*;\n(\n'.format(HEADER.split(".")[0]))
        indent += 4 
        input_dict = {}
        output_dict = {}
        for name,data in signal_dict['signal'].items():
            if data.get('direction'):
                if data['direction'] == 'input':
                    input_dict[name] = data
                elif data['direction'] == 'output':
                    output_dict[name] = data
        printf(f,'/* input signal */\n')
        for name,data in input_dict.items():
            printf(f,'input       {} {},\n'.format(data['type'].ljust(15) ,name))
        printf(f,'/* output signal */\n')
        for i,(name,data) in enumerate(output_dict.items()):
                if i == len(output_dict.items()) - 1:
                    printf(f,'output      {} {}\n);\n'.format(data['type'].ljust(15) ,name))
                else:
                    printf(f,'output      {} {},\n'.format(data['type'].ljust(15) ,name))
        indent -= 4 

    def gen_signal_define(f):
        global indent
        indent += 4 
        temp_dict = {}
        for name,data in signal_dict['signal'].items():
            if data.get('direction'):
                continue
            else:
                temp_dict[name] = data
        printf(f,'/* temp signal */\n')
        for name,data in temp_dict.items():
            printf(f,'{} {};\n'.format(data['type'].ljust(15) ,name))
        indent -= 4 
        
    def signal_initialize(f):
        global indent
        indent += 4 
        printf(f,'/* Decode Logic */\n')
        printf(f,'always_comb begin\n')
        indent += 4 
        printf(f,'/* Signal initialize*/\n')
        for name,data in signal_dict['signal'].items():
            if data.get('init'):
                printf(f,'{} = {};\n'.format(name.ljust(15) ,data['init']))
        indent -= 4

    def gen_decode_tree(f):
        def gen_case_tree(instructions_tree):
            global indent
            printf(f,'/* {} */\n'.format(instructions_tree['opcode']))
            printf(f,'unique casez({})\n'.format(instructions_tree['opcode']))
            indent += 4
            for value,data in instructions_tree['oplist'].items():
                printf(f,'{} : begin\n'.format(value))
                indent += 4
                if data.get('oplist') :
                    gen_case_tree(data)
                else :
                    printf(f,'/* {} */\n'.format(data['name']))
                    printf(f,'uop = {}::{};\n'.format(HEADER.split('.')[0],data['name']))
                    instr_format = data['format']
                    for register in spec['formats'][instr_format]['fields']:
                        if register == 'rd' :
                            continue
                        signal_name = "use_{}".format(register)
                        if not (data.get('control') and signal_name in data['control']):
                            assert signal_name in signal_dict['signal'], "Undefined signal {}".format(signal_name)
                            printf(f,"{}  = 1'b1;\n".format(signal_name))
                    if data.get('control'):
                        for signal,value in data['control'].items():
                            assert signal in signal_dict['signal'], "Undefined signal {}".format(signal)
                            printf(f,'{} = {};\n'.format(signal,value))
                    if set(data['ext']) & set(["RV32F","RV32D","RV32Q","RV32Zfh","RV64F","RV64D","RV64Q","RV64Zfh"]) :
                        if 'func3' not in data['opcodes']:
                            assert 'func3' in signal_dict['signal'], "Undefined signal {}".format('func3')
                            printf(f,"check_frm = 1'b1;\n")
                indent -= 4
                printf(f,'end\n')
            printf(f,'{} : begin\n'.format('default'))
            indent += 4
            printf(f,"illigal = 1'b1;\n")
            indent -= 4
            printf(f,'end\n')
            indent -= 4
            printf(f,'endcase\n')
        instructions_tree = spec['instructions_tree']
        global indent
        indent += 4
        gen_case_tree(instructions_tree)
        indent -= 4
    def gen_imm_selector(f):
        global indent
        immediates = spec['immediates']
        assert 'imm_type' in signal_dict['signal'], "Undefined signal {}".format('imm_type')
        assert 'imm'      in signal_dict['signal'], "Undefined signal {}".format('imm')
        indent += 4
        printf(f,'/* Imm Selector */\n')
        printf(f,'unique case(imm_type)\n')
        indent += 4
        for type,data in immediates.items():
            printf(f,'{}::{}: begin\n'.format(HEADER.split('.')[0],type))
            indent += 4
            printf(f,"use_imm = 1'b1;\n")
            if '..' in str(list(data['data'].keys())[0]) :
                upper = list(data['data'].keys())[0].split('..')[0]
            else:
                upper = list(data['data'].keys())[0]
            if '..' in str(list(data['data'].keys())[-1]) :
                lower = list(data['data'].keys())[-1].split('..')[1]
            else:
                lower = list(data['data'].keys())[-1]
            upper = int(upper)
            lower = int(lower)
            if data['signed'] :
                pass
                context = "imm[32:{}] = ".format(upper+1) + "{" + str(32-upper) + "{" + "instruction[{}]".format(upper) + "}};\n"
                printf(f,context)
            else:
                context = "imm[32:{}] = ".format(upper+1) + "{" + str(32-upper) + "{1'b0}};\n"
                printf(f,context)
            for seg,value in data['data'].items():
                if '..' in str(seg):
                    dest = seg.split('..')
                    src  = value.split('..')
                    printf(f,"imm[{}:{}] = instruction[{}:{}];\n".format(dest[0],dest[1],src[0],src[1])) 
                else :
                    printf(f,"imm[{}] = instruction[{}];\n".format(seg,value)) 
            if lower != 0 :
                printf(f,"imm[{}:0] = {}'b0;\n".format(lower,lower+1))
            indent -= 4
            printf(f,'end\n')
        printf(f,'default: begin\n')
        printf(f,"    imm = 33'b0;\n")
        printf(f,"    use_imm = 1'b0;\n")
        printf(f,'end\n')
        indent -= 4
        printf(f,'endcase\n')
        indent -= 4
        printf(f,'end\n')
        indent -= 4
    def gen_assign(f):
        global indent
        indent += 4 
        printf(f,'/* Signal Assignment */\n')
        for name,data in signal_dict['signal'].items():
            if data.get('value'):
                printf(f,'assign {} = {};\n'.format(name.ljust(15) ,data['value']))
        indent -= 4
    with open(MODULE,'w') as f:
        global indent
        indent = 0
        gen_io_define(f)
        gen_signal_define(f)
        signal_initialize(f)
        gen_decode_tree(f)
        gen_imm_selector(f)
        gen_assign(f)
        printf(f,"endmodule")
def sv_backend(spec):
    signal_dict = parse_signal()
    signal_dict = insert_signal(spec,signal_dict)
    gen_header(signal_dict)
    gen_module(spec,signal_dict)
