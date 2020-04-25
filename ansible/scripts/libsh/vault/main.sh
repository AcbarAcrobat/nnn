#!/bin/bash

create_and_check_a_local_vault(){

    # usage create_and_check_a_local_vault vault_pass username;

    decrypt_vault_pass=$1
    username=$2

    if [ ! -d "$LOCAL_DIRECTORY" ]; then

        mkdir $LOCAL_DIRECTORY

    fi

    # rm $LOCAL_DIRECTORY/vault-password-file-tmp.yml
    # rm $LOCAL_DIRECTORY/vault-password-file.yml

    echo "$decrypt_vault_pass" >> $LOCAL_DIRECTORY/vault-password-file-tmp.yml
    echo "$decrypt_vault_pass" >> $LOCAL_DIRECTORY/vault-password-file.yml

    # cat $LOCAL_DIRECTORY/vault-password-file.yml
    # cat $LOCAL_DIRECTORY/vault-password-file-tmp.yml

    #ansible-vault view $ansible_dir/.files/protected/$username/vault-password-file.yml --vault-password-file $LOCAL_DIRECTORY/vault-password-file-tmp.yml  > $LOCAL_DIRECTORY/vault-password-file.yml
    ansible-vault view $ansible_dir/.files/protected/products/$product/$username/id_rsa --vault-password-file $LOCAL_DIRECTORY/vault-password-file.yml  > $LOCAL_DIRECTORY/id_rsa
    ansible-vault view $ansible_dir/.files/protected/products/$product/$username/pass.yml --vault-password-file $LOCAL_DIRECTORY/vault-password-file.yml  > $LOCAL_DIRECTORY/pass.yml
    ansible-vault view $ansible_dir/.files/protected/products/$product/$username/vault.cloud.yml --vault-password-file $LOCAL_DIRECTORY/vault-password-file.yml  > group_vars/products/$product/alicloud.yml

    cp -r $ansible_dir/.files/protected/products/$username/id_rsa.pub $LOCAL_DIRECTORY/id_rsa.pub

    # debug
    # cat $LOCAL_DIRECTORY/vault-password-file.yml
    # cat $LOCAL_DIRECTORY/id_rsa
    # cat $LOCAL_DIRECTORY/id_rsa.pub
    # cat $LOCAL_DIRECTORY/pass.yml

    # Control will enter here if $DIRECTORY doesn't exist.

    # Prevents cause when children dynamic inventory cannot access to main temporarity inventory for recreate local
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    echo -e "         ${GREEN}Inventory not${NC} a ${RED}production, current environment is${NC}: $inventory"
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"


    if [ "${typeofcloud}" == "bare" ]; then

        echo "     |>..........................................................................................................................................................................................<|"
        echo -e "         Used type of inventory: ${RED}${typeofcloud}${NC}"
        echo "     |>..........................................................................................................................................................................................<|"
        
        # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
        #     ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng-bare.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

    else

        function_selector_runner ansible-playbook -i $ansible_dir/inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/production/bootstrap_vms/ $ansible_dir/\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="production" -e stage="0"

    fi

    #

}