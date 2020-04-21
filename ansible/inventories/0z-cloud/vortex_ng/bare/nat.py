#!/usr/bin/env python

import yaml
import json
import sys
import re
import os
import argparse
from collections import defaultdict

_data = { "_meta" : { "hostvars": {} }}
_matcher = {}
_hostlog = []

# Nice output
def print_json(data):
    print(json.dumps(data, indent=2))

# Load the YAML file
def load_file(file_name):
    with open(file_name, 'r') as fh:
        return yaml.load(fh, Loader=yaml.SafeLoader)

def get_yaml(file_name):
    script_path = os.path.dirname(os.path.realpath(__file__))
    file_name = file_name.replace(script_path, '')
    inventory_object = load_file("{}/{}".format(script_path, file_name))
    return inventory_object

def to_num_if(n):
    try:
        return int(n)
    except:
        pass
    try:
        return float(n)
    except:
        return n

class Group_Inventory_Object_Properties:
    def __init__(self, inventory_object, path=[""]):

        for g in inventory_object:

             if g in 'ansible_inventory_groups':
                    
                for item in inventory_object['ansible_inventory_groups']:

                    list_groups.append(item)

class CompareInventoryObjects:

    global names
    names = []

    def __init__(self, ifile, uniq_groups, global_hosts_result_inventory, path=[""]):
        
        json_data_raw = get_yaml(ifile)
        
        json_data = json_data_raw['cloud_bootstrap']['servers']
        
        json_data_services = json_data_raw['cloud_bootstrap']['services']

        for uniq_group in uniq_groups:

            for s in json_data:

                inventory_obj = json_data[s]

                for g in inventory_obj:

                    if g in 'ansible_inventory_groups':

                        list_groups = inventory_obj['ansible_inventory_groups']

                        for item in list_groups:

                            if item in uniq_group:

                                names.append({item: inventory_obj['name']})

        for group in uniq_groups:

            global_hosts_result_inventory.append("[" + group + ":children]")
            
            for k in names:

                for key,value in k.items():

                    if key ==  group:

                        global_hosts_result_inventory.append(value)

class Inventory_Object_Properties:

    def __init__(self, inventory_object, hosts_result_inventory, path=[""]):

        self.host_ip_line = ""
        self.host_ip = ""
        self.host_ssh_line = ""
        self.host_name_parent_object = ""
        self.host_name_target_object = ""
        self.host_name_target_vars_object = ""
        self.array_vars = []
        self.list_groups = []
        self.groups_array_objects = defaultdict(list)
        self.groups_array_objects_hosts = []

        for g in inventory_object:

            if type(g) == dict:

                for k,v in g:

                    if k == 'gw':

                        self.name = g['gw']
                        gw_value = g['gw']

                    elif k == 'gw':

                        for tag in g[k]:

                            self.gw.append(tag)

                    else:

                        self.var[k] = g[k]

            elif type(g) == str:
                
                self.name = g

                if g in 'ansible_inventory_groups':

                    self.list_groups = inventory_object['ansible_inventory_groups']
 

                if g in 'ansible_inventory_vars':

                    self.array_vars = inventory_object['ansible_inventory_vars'].items()

                if g in 'ssh':
                    
                    self.host_ssh_line = inventory_object['ssh']

                if g in 'name':

                    self.host_name_parent_object = inventory_object['name']

                if g in 'ip':

                    #self.host_ip = inventory_object['ip']
                    self.host_ip = inventory_object['ansible_inventory_vars']['second_ip']
                    
        self.host_name_parent_object
        self.host_name_target_vars_object = ("[" + self.host_name_parent_object + ":vars]")
        self.host_name_target_object = ("[" + self.host_name_parent_object + "]")

        self.host_ip_line = (self.host_name_parent_object + " ansible_ssh_host=" + self.host_ip + " " + self.host_ssh_line)

        #runpay.vortex.io ansible_ssh_host=10.3.221.113


        some_value_one = self.host_name_target_object
        some_value_two = self.host_ip_line

        hosts_result_list_list.append(some_value_one)
        hosts_result_list_list.append(some_value_two)

        #@ WIP 2 BUT WORKS, NEED TO NO WRITE VARS IF IT NOT PRESENT 
        print (self.host_name_target_vars_object)
        for k,v in self.array_vars:

            #print ("key " + k)
            #print ("value " + v)

            return_value = (k + "=\"" + v + "\"")

            #print ("return_value " + return_value)
            print (return_value)

        # # END WRITING VARS

class Host:

    def __init__(self, host, path):
        self.path = path
        self.var = {}
        self.name = ""
        self.path = ""
        self.tags = []

        if type(host) == dict:
            for k in host:
                print(k)
                if k == 'name':
                    self.name = host['name']
                elif k == 'tags':
                    for tag in host[k]:
                        self.tags.append(tag)
                else:
                    self.var[k] = host[k]
        elif type(host) == str:
            self.name = host

        if self.name in _hostlog:
            raise Exception("Error, host {} defined twice".format(self.name))
        _hostlog.append(self.name)

        self.tags = self.tags + self.split_tag() + self.matcher_tags()

        if len(self.var) > 0:
            _data['_meta']['hostvars'][self.name] = self.var
        for tag in self.tags:
            if not tag in _data:
                _data[tag] = { "hosts": [] }
            if not 'hosts' in _data[tag]:
                _data[tag]['hosts'] = []
            _data[tag]['hosts'].append(self.name)


    def split_tag(self):
        tags = []
        for part in re.compile('[^a-z]').split(self.name):
            if part == "": continue
            tags.append(part)
        return tags

    def matcher_tags(self):
        tag = []
        for match in _matcher:
            m = re.compile(match['regexp']).match(self.name)
            if m:
                if 'groups' in match:
                    for g in match['groups']:
                        tag.append(g)
                if 'capture' in match and match['capture']:
                    for m2 in m.groups():
                        tag.append(m2)
        return tag

    def group(self):
        return "-".join(self.path)

    def __repr__(self):
        return "host: {} group: {} vars: {} tags: {}".format(
                self.name, self.group(), self.var, self.tags)

class Groups:
    def __init__(self, groups, path=["root"]):

        # Call a subgroup (or vars)
        if type(groups) == dict:
            for g in groups:
                print(g)
                p = path + [g]
                fullpath = "-".join(p)
                if 'vars' == p[-1]:
                    _data["-".join(path)]['vars'] = groups['vars']
                elif 'include' in p[-1]:
                    for f in groups['include']:
                        Groups(get_yaml(f), p[:len(p)-1])
                else:
                    if 'hosts' != p[-1]:
                        if not fullpath in _data:
                            _data[fullpath] = {}
                        if not 'children' in _data["-".join(path)]:
                            _data["-".join(path)]['children'] = []

                            # workaround for https://github.com/ansible/ansible/issues/13655
                            if not 'vars' in _data["-".join(path)]:
                                _data["-".join(path)]['vars'] = {}

                        _data["-".join(path)]['children'].append("-".join(p))
                    Groups(groups[g], p)

        # Process groups
        elif type(groups) == list:
            for h in groups:
                if 'hosts' == path[-1]:
                    path.pop()
                hst = Host(h, path)
                fullpath = "-".join(path)
                for t in hst.tags:
                    tagfullpath = "{}-{}".format(fullpath,t)

                    if not tagfullpath in _data:
                        _data[tagfullpath] = {}
                    if not 'hosts' in _data[tagfullpath]:
                        _data[tagfullpath]['hosts'] = []

                    _data[tagfullpath]['hosts'].append(hst.name)

                    if not 'children' in _data[fullpath]:
                        _data[fullpath]['children'] = []

                        # workaround for https://github.com/ansible/ansible/issues/13655
                        if not 'vars' in _data[fullpath]:
                            _data[fullpath]['vars'] = {}

                    _data[fullpath]['children'].append(tagfullpath)

class TagVars:
    def __init__(self, tag, val):
        for k, v in val.items():
            if not tag in _data:
                _data[tag] = {}
            if not 'vars' in _data[tag]:
                _data[tag]['vars'] = {}
            _data[tag]['vars'][k] = v

class Inventory:
    commands = ["include", "matcher", "tagvars"]
    
    def __init__(self, ifile, hosts_result_inventory):
        json_data_raw = get_yaml(ifile)
        json_data = json_data_raw['cloud_bootstrap']['servers']
        
        global _matcher

        for el in json_data:

            parsed_object = Inventory_Object_Properties(json_data[el], [el], hosts_result_inventory)

class Groups_In_Inventory:
    commands = ["include", "matcher", "tagvars"]
    
    def __init__(self, ifile, hosts_result_inventory):
        json_data_raw = get_yaml(ifile)
        
        json_data = json_data_raw['cloud_bootstrap']['servers']

        for el in json_data:

            parsed_object = Group_Inventory_Object_Properties(json_data[el], [el])

def to_json(in_dict):
    return json.dumps(in_dict, sort_keys=True, indent=2)


def main(argv):
    global hosts_result_list_list
    hosts_result_list_list = []
    global _meta
    global result_groups
    global result_groups_hosts
    global list_groups
    global result_groups
    global result_inventory
    global global_hosts_result_inventory
    global hosts_result_inventory
    global global_group_vars_array

    global_group_vars_array = []
    
    hosts_result_inventory = []
    global_hosts_result_inventory = []
    result_inventory = []
    result_groups = []
    list_groups = []
    result_groups = {}
    result_groups_hosts = {}
    parser = argparse.ArgumentParser(description='Ansible Inventory System')
    parser.add_argument('--list', help='List all inventory groups', action="store_true")
    parser.add_argument('--host', help='List vars for a host')
    parser.add_argument('--from_inventory', help='Need setup parent inventory', action="store_true")
    parser.add_argument('--to_inventory', help='Need setup parent inventory', action="store_true")

    parser.add_argument('--file', help='File to open, default bootstrap_vms/group_vars/all.yml', 
            default='bootstrap_vms/group_vars/all.yml')
    args = parser.parse_args()
    #args = args.replace("bd", "y")

    inventory = Inventory(args.file, hosts_result_inventory)
    result_groups = Groups_In_Inventory(args.file, hosts_result_inventory)

    uniq_groups = set(list_groups)

    result_items = CompareInventoryObjects(args.file, uniq_groups, global_hosts_result_inventory)

    global_hosts_result_inventory = hosts_result_list_list + global_hosts_result_inventory

    #print(global_hosts_result_inventory)

    #WIP 3 MUST TO REFORMAT LIKE IN EXAMPLE https://docs.ansible.com/ansible/2.5/dev_guide/developing_inventory.html
    #output = to_json(global_hosts_result_inventory)

    #print(output)

    #@ CURRENT
    for item in global_hosts_result_inventory:
        print (item)

    if args.list:
        print_json(_data)
    if args.host:
        if args.host in _data['_meta']['hostvars']:
            print_json(_data['_meta']['hostvars'][args.host])
        else:
            print_json({})

if __name__ == '__main__':
    sys.exit(main(sys.argv))
