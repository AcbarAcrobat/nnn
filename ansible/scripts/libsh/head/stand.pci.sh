#!/bin/bash

# # Run the init playbooks clean cloud init 

# echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
# echo -e "       Run the ${RED}apt_install.yml${NC} playbook for all hosts, for install ${RED}necessary${NC} system packages"
# echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

#     function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#         playbook-library/\!_0_init/afterinstall.yml \
#         -u $username --become-user root \
#         --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

