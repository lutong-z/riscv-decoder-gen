#!/usr/bin/python3

import yaml

PREFIX = 'prefix.yaml'
FORMAT = 'format.yaml'
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
def parse_format():
    with open(FORMAT,'r') as f:
        data = yaml.load(f.read(),Loader=yaml.SafeLoader)
        formatDict = {}
        for type in data['formats']:
            for key,value in type.items():
                formatDict[key] = value
        return formatDict
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
    printf(f,'/* Assignment */\n')
    for i,signal in enumerate(data['output']):
        for key,value in signal.items():
            if(value.get('value')):
                printf(f,'assign {} =  {};\n'.format(key.ljust(15),value['value']))
    for i,signal in enumerate(data['temp']):
        for key,value in signal.items():
            if(value.get('value')):
                printf(f,'assign {} =  {};\n'.format(key.ljust(15),value['value']))
    indentStr -=  4

def gen_insn_code(f, insn_decoder_data,format_data):
    global indentStr
    def gen_switch_tree(indent, opdict):
        global indentStr
        indentStr += 4
        for opval, opdata in list(opdict.items()):
            if(opdata.get('name')):
                printf(f,"/* {} */\n".format(opdata['name']))
            printf(f,"{} : begin\n".format(opval))

            if 'oplist' in opdata:
                name = opdata['opcode']
                indentStr += 4
                printf(f,"/* Decode {} */\n".format(name))
                printf(f,"case ({})\n".format(name))
                gen_switch_tree(indent + 4, opdata['oplist'])
                printf(f,"endcase\n")
                indentStr -= 4
            else:
                indentStr += 4
                insn_format = opdata['format']
                fields = format_data[insn_format]['fields']
                if(opdata.get('name')):
                    printf(f,"uop = uop_t.{};\n".format(opdata['name']))
                if 'rs1' in fields:
                    printf(f,"rdRs1En = 1'b1;\n")
                if 'rs2' in fields:
                    printf(f,"rdRs2En = 1'b1;\n")
                if format_data[insn_format].get('immediates'):
                    printf(f,"immType = immType_t.{};\n".format(format_data[insn_format]['immediates'][0]))
                if opdata.get('func'):
                    insn_func = opdata['func']
                    for key,value in insn_func.items():
                        printf(f,"{} = {};\n".format(key,value))
                # insn_func = opdata['func']
                # printf(f,"decode_format_{}(ctx);\n".format(insn_format))
                # printf(f,"{}(env, ctx);\n".format(insn_func))
                indentStr -= 4
            printf(f,"end\n")

        printf(f,"default: begin\n")
        indentStr += 4
        printf(f,"illigal = 1'b1;\n")
        indentStr -= 4
        printf(f,"end\n")
        indentStr -= 4
        
    indentStr += 4 
    indentStr += 4
    printf(f,"/* Decode {} */\n".format(insn_decoder_data['opcode']))
    printf(f,"case ({}) \n".format(insn_decoder_data['opcode'].lower()))
    gen_switch_tree(indentStr, insn_decoder_data['oplist'])
    printf(f,"endcase\n")
    indentStr -= 4 
    printf(f,"end\n")
    indentStr -= 4


def main():
    prefix = parse_prefix()
    format = parse_format()
    instr  = parse_instr()
    decode_instr = transform_insn_data(instr)

    with open(OUTPUT,'w') as f:
        gen_prefix(f,prefix)
        gen_param(f,instr)
        gen_init(f,prefix)
        gen_insn_code(f,decode_instr,format)
        gen_assign(f,prefix)
        printf(f,'endmodule')
if __name__ == '__main__' : 
    main()