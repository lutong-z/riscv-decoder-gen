#!/usr/bin/python3

import yaml

PREFIX = 'prefix.yaml'
INSTRUCTION = 'instruction.yaml'
OUTPUT = 'decoder.sv'
indentStr  = 0

def printf(f,string):
    f.write(indentStr * ' ' + string)

def gen_header(f):
    f.write('/*\n')
    f.write(' * THIS FILE IS GENERATED, DO NOT EDIT IT MANUALLY\n')
    f.write(' * (C) 2021 Lutong Zhang <lutong.z@rioslab.org>\n')
    f.write(' */\n\n')
    
def parse_prefix():
    with open(PREFIX,'r') as f:
        data = yaml.load(f.read(),Loader=yaml.SafeLoader)
        return data
def parse_instr():
    with open(INSTRUCTION,'r') as f:
        data = yaml.load(f.read(),Loader=yaml.SafeLoader)
        return data
def transform_insn_data(insn_data):

    def get_first_opcode():
        opcode_checklist = dict()
        for opcode in insn_data['opcodes']:
            name = list(opcode.keys())[0]
            opcode_checklist[name] = 0

        for insn in insn_data['instructions']:
            value = list(insn.values())[0]

            for opcode in value['opcodes']:
                opcode_checklist[opcode] += 1
        return max(opcode_checklist, key=opcode_checklist.get)

    def find_next_opcode(major_opcode_dict):
        opcode_check = dict()
        
        for opcode in insn_data['opcodes']:
            name = list(opcode.keys())[0]
            opcode_check[name] = 0

        for insn in insn_data['instructions']:
            value = list(insn.values())[0]
            op_names = value['opcodes']
            if major_opcode_dict.items() <= op_names.items():
                for op in op_names:
                    if op not in major_opcode_dict:
                        opcode_check[op] += 1
        
        return max(opcode_check, key=opcode_check.get)

    def insert_into_opcode_tree(result, call_string, major, curr_op_val, insn):
        if call_string.items() == insn['opcodes'].items(): # we found a insn heroe
            result[curr_op_val] = insn
        else:
            minor_opcode = find_next_opcode(call_string)
            value = insn['opcodes'][minor_opcode]
            new_call_string = call_string.copy()
            new_call_string[minor_opcode] = insn['opcodes'][minor_opcode]
            if not curr_op_val in list(result.keys()):
                result[curr_op_val] = {'opcode': minor_opcode, 'oplist': {}}
            insert_into_opcode_tree(result[curr_op_val]['oplist'], new_call_string, minor_opcode, value, insn)


    major_opcode = get_first_opcode()
    result = {'opcode': major_opcode,  'oplist':{}}

    for insn in insn_data['instructions']:
        name, insn_dat = list(insn.items())[0]
        insn_dat['name'] = name
        insert_into_opcode_tree( result['oplist'], {major_opcode: insn_dat['opcodes'][major_opcode]},
                                major_opcode,
                                insn_dat['opcodes'][major_opcode],
                                insn_dat)

    return result
def gen_prefix(f,data):
    gen_header(f)
    printf(f,'module decoder(\n')
    global indentStr
    indentStr += 4
    printf(f,'// input signal\n')
    for signal in data['input']:
        for key,value in signal.items():
            printf(f,'input  {} {},\n'.format(value['type'].ljust(15),key))
    printf(f,'// output signal\n')
    for i,signal in enumerate(data['output']):
        for key,value in signal.items():
            if i == len(data['output']) -1 : 
                printf(f,'output {} {}\n'.format(value['type'].ljust(15),key))
            else:
                printf(f,'output {} {},\n'.format(value['type'].ljust(15),key))
    indentStr -= 4
    printf(f,');\n')
def gen_param(f,data):
    global indentStr
    indentStr += 4
    printf(f,'// parameter\n')
    for op in data['opcode']:
        for key,value in op.items():
            printf(f,'localparam {} = {};\n'.format(key.ljust(15),value))
    indentStr -= 4
def gen_init(f,data):
    global indentStr
    indentStr +=  4
    printf(f,'// temp varible\n')
    for signal in data['temp']:
        for key,value in signal.items():
            printf(f,'{} {};\n'.format(value['type'].ljust(15),key))
    printf(f,'// decode logic\n')
    printf(f,'always_comb  begin\n')
    indentStr +=  4
    for i,signal in enumerate(data['output']):
        for key,value in signal.items():
            if(value.get('init')):
                printf(f,'{} =  {};\n'.format(key.ljust(15),value['init']))
    for i,signal in enumerate(data['temp']):
        for key,value in signal.items():
            if(value.get('init')):
                printf(f,'{} =  {};\n'.format(key.ljust(15),value['init']))
    indentStr -=  4
    indentStr -=  4

def gen_assign(f,data):
    global indentStr
    indentStr +=  4
    for i,signal in enumerate(data['output']):
        for key,value in signal.items():
            if(value.get('value')):
                printf(f,'assign {} =  {};\n'.format(key.ljust(15),value['value']))
    for i,signal in enumerate(data['temp']):
        for key,value in signal.items():
            if(value.get('value')):
                printf(f,'assign {} =  {};\n'.format(key.ljust(15),value['value']))
    indentStr -=  4
def gen_insn_code(f, insn_decoder_data):

    def gen_switch_tree(indent, opdict):
        indentStr = " " * (indent)
        indentStr4 = " " * (indent + 4)

        for opval, opdata in list(opdict.items()):
            f.write(indentStr + "case {}:\n".format(opval))

            if 'oplist' in opdata:
                name = opdata['opcode']
                f.write(indentStr4 + "/* Decode {} */\n".format(name))
                f.write(indentStr4 + "switch (extract32(ctx->opcode, {}, {})) {{\n"
                                     .format(0, 0))
                gen_switch_tree(indent + 4, opdata['oplist'])
            else:
                insn_name = opdata['name']
                insn_format = opdata['format']
                insn_func = opdata['func']
                f.write(indentStr4 + "/* {} */\n".format(insn_name))
                f.write(indentStr4 + "decode_format_{}(ctx);\n".format(insn_format))
                f.write(indentStr4 + "{}(env, ctx);\n".format(insn_func))

            f.write(indentStr4 + "break;\n")
        f.write(indentStr + "default:\n")
        f.write(indentStr + "    kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);\n")
        f.write(indentStr + "    break;\n")
        f.write(indentStr + "}\n")
        
    indent = 4
    indentStr = ' ' * 4
    f.write(indentStr + "/* Decode {} */\n".format(insn_decoder_data['opcode']))
    f.write(indentStr + "switch ({}) {{\n".format(insn_decoder_data['opcode'].lower()))
    gen_switch_tree(indent, insn_decoder_data['oplist'])

    f.write("}\n")
def main():
    prefix = parse_prefix()
    instr  = parse_instr()
    decode_instr = transform_insn_data(instr)

    with open(OUTPUT,'w') as f:
        gen_prefix(f,prefix)
        gen_param(f,instr)
        gen_init(f,prefix)
        gen_insn_code(f,decode_instr)
        gen_assign(f,prefix)
        printf(f,'endmodule')
if __name__ == '__main__' : 
    main()