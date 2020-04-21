#!/bin/bash

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo "              Perform Standalone Security Configuration Environment Deploy Pipeline"
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

# Deploy the docker-stack.yml from template on target application cluster

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/\\!_A_Deploy_pipeline/docker-compose-deploy-playbook.yml \
    -u $username --become-user root --become -e HOSTS="cloud-bind-frontend-dns" \
    -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password" -e stage="docker-stack-deploy" -e version_ansible_build_id="${version_ansible_build_id}" -e "@../.local/current_tags.yml"

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

# # INIT ALL DATABASES AND PERFORM MIGRATIONS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/hooks/init_dbs_all_standalone.yml \
    -e HOSTS="nginx-frontend[0]" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"