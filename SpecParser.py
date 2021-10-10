#!/usr/bin/python3

from os import major
import yaml

CONFIG       = 'config.yaml'
INSTRUCTIONS = 'instructions/instructions.yaml'
instrTotal   = None
instrNum     = None

def parse_config():
    with open(CONFIG,'r') as f:
        config_yaml = yaml.load(f.read(),Loader=yaml.SafeLoader)
        config_dict = {}
        for type in config_yaml['config']:
            for key,value in type.items():
                config_dict[key] = value
        return config_dict

def parse_instructions(config_dict):
    with open(INSTRUCTIONS,'r') as f:
        instructions_yaml = yaml.load(f.read(),Loader=yaml.SafeLoader)
        # immediate
        immediates_dict = {}
        for immediate in instructions_yaml['immediates']:
            for key,value in immediate.items():
                immediates_dict[key] = value
        # formats
        formats_dict = {}
        for format in instructions_yaml['formats']:
            for key,value in format.items():
                formats_dict[key] = value
        # opcodes 
        opcodes_dict = {}
        for opcode in instructions_yaml['opcodes']:
            for key,value in opcode.items():
                opcodes_dict[key] = value
        # instruction
        instructions_dict = {}
        supportISA = set(config_dict['supportISA'])
        supportMode = set(config_dict['supportMode'])
        for instr in instructions_yaml['instructions']:
            for key,value in instr.items():
                exts = set(value['ext'])
                mode = set(value['mode']) if value.get('mode') else set()
                if exts & supportISA:
                    if 'System' in exts and (mode & supportMode == set()):
                        break
                    instructions_dict[key] = value
        return immediates_dict, formats_dict, opcodes_dict, instructions_dict
def generate_opcode_tree(instructions_dict):
    global instrTotal
    global instrNum
    def find_next_opcode(current_opcodes):
        opcodes_hist = {}
        for instr,instr_data in instructions_dict.items():
            if current_opcodes.items() <= instr_data['opcodes'].items() :
                for opcode,_ in instr_data['opcodes'].items():
                    if opcode not in current_opcodes:
                        if opcodes_hist.get(opcode):
                            opcodes_hist[opcode] += 1
                        else:
                            opcodes_hist[opcode] = 1
        return max(opcodes_hist,key=opcodes_hist.get)
    def insert_opcode_tree(opcode_tree,node,current_opcodes,instr):
        global instrTotal
        global instrNum
        if instr['opcodes'] == current_opcodes :
            opcode_tree[node] = instr
            instrNum += 1
            print("insert instruction {} , {} / {}".format(instr['name'],instrNum,instrTotal))
        else : 
            minor_opcode = find_next_opcode(current_opcodes)
            next_opcodes = current_opcodes.copy()
            next_opcodes[minor_opcode] = instr['opcodes'][minor_opcode]
            if opcode_tree.get(node):
                pass
            else:
                opcode_tree[node] = {'opcode' : minor_opcode , 'oplist' :{} }
            insert_opcode_tree(opcode_tree[node]['oplist'],instr['opcodes'][minor_opcode],next_opcodes,instr)
    instrTotal = len(list(instructions_dict.keys()))
    instrNum = 0
    major_opcode = find_next_opcode({})
    opcode_tree = {'opcode' : major_opcode, 'oplist' : {}}
    instruction_list = []
    for instr_name,instr_data in instructions_dict.items():
        instr_data['name'] = instr_name
        instruction_list.append(instr_name)
        insert_opcode_tree(opcode_tree['oplist'],instr_data['opcodes'][major_opcode],{major_opcode : instr_data['opcodes'][major_opcode]}, instr_data)
    return instruction_list,opcode_tree

def parseSpec():
    config_dict = parse_config()
    immediates_dict, formats_dict, opcodes_dict,instructions_dict = parse_instructions(config_dict)
    instructions_list, opcode_tree = generate_opcode_tree(instructions_dict)
    return {'immediates' : immediates_dict , 'formats' : formats_dict , 'opcodes' : opcodes_dict , 'instructions_name' : instructions_list ,'instructions_tree' : opcode_tree}
    
if __name__ == '__main__':
    parseSpec()