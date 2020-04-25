#!/bin/bash

if [ "$type_of_run" = "true" ] || [ "$type_of_run" = "print_only" ]; then



    if [ "$type_of_run" != "run_from_wrapper" ]; then

        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo -e "         ${GREEN}Running the type_of_run${NC} ./inventories/0z-cloud/products/$product/$inventory"
        echo "     |>..........................................................................................................................................................................................<|"
        echo "         Destroying VMs"
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

    fi

    if [ "$type_of_run" != "run_from_wrapper" ]; then

        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo "         Creating VMs"
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

    fi

    if [ "${typeofcloud}" == "bare" ]; then

        echo "     |>..........................................................................................................................................................................................<|"
        echo -e "         Used type of inventory: ${RED}${typeofcloud}${NC}"
        echo "     |>..........................................................................................................................................................................................<|"
        
        # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
        #     ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng-bare.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

    else


        if [ "${typeofcloud}" == "bare" ]; then

        echo -e "                  :other baremethal magic:"

        else 

            if [ "${typeofcloud}" == "alicloud" ]; then

                function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
                    ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

            fi

            if [ "${typeofcloud}" == "vsphere" ]; then

                function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms \
                    ./\\!_root_playbooks/${typeofcloud}/destroy_danger.yml -e ansible_product="$product"

            fi
        fi
        

    fi

else

    if [ "$type_of_run" = "destroy" ]; then 

        if [ "$type_of_run" != "run_from_wrapper" ]; then

            echo "     |>..........................................................................................................................................................................................<|"
            echo -e "         ${GREEN}Running the destroy only${NC} for ./inventories/0z-cloud/products/$product/$inventory"
            echo "     |>..........................................................................................................................................................................................<|"

        fi


            if [ "${typeofcloud}" == "alicloud" ]; then

                function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
                    ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

            fi

            if [ "${typeofcloud}" == "vsphere" ]; then

                function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms \
                    ./\\!_root_playbooks/${typeofcloud}/destroy_danger.yml -e ansible_product="$product"

            fi

            if [ "${typeofcloud}" == "bare" ]; then

                echo "     |>..........................................................................................................................................................................................<|"
                echo -e "          Used type of inventory: ${RED}${typeofcloud}${NC}"
                echo "     |>..........................................................................................................................................................................................<|"
                
                # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
                #     ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng-bare.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

            fi

        exit 1

    else

        if [ "$type_of_run" = "create" ] || [ "$type_of_run" = "partial" ]; then 

            if [ "$type_of_run" != "run_from_wrapper" ]; then

                echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
                echo -e "         ${GREEM}Creating VMs${NC}"
                echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

            fi

            if [ "${typeofcloud}" == "bare" ]; then

                echo "     |>..........................................................................................................................................................................................<|"
                echo -e "          Used type of inventory: ${RED}${typeofcloud}${NC}"
                echo "     |>..........................................................................................................................................................................................<|"
                
                # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
                #     ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng-bare.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

            else

                function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms \
                    ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e stage="0"

            fi

            if  [ "$type_of_run" = "partial" ]; then
            
                if [ "$type_of_run" != "run_from_wrapper" ]; then

                echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
                echo "Go next because partial"
                echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

                fi

            else

                exit 1

            fi

        else

            if [ "$type_of_run" != "run_from_wrapper" ]; then

                echo "     |>..........................................................................................................................................................................................<|"
                echo -e "         ${RED}Running the update internal only for${NC} ./inventories/0z-cloud/products/$product/$inventory"
                echo "     |>..........................................................................................................................................................................................<|"
            fi
        fi
    fi
fi

if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    echo -e "         ${GREEN}Start regen the dynamic inventory${NC} for run: $type_of_run"
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

fi

## Custom

# Decrypt personal settings for deploy process start

create_and_check_a_local_vault $vault_pass $username;

### CREATING DEPLOY VIA DOCKER ANSIBLE CONTAINER (FOR PCI WIP)
####

DOCKER_VERSION="latest"

cd ${ansible_dir}

#

. ./scripts/libsh/cloud.regen.run.sh