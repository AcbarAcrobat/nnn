#!/bin/bash

. ./scripts/libsh/head/clouds.sh internal-services-recreate

. ./scripts/libsh/head/main.sh

inventory=$1
product=$2
username=$3
password=$4
nowait=$5
type_of_run=$6
typeofcloud=$7
extra_args_type_of_run=$8

if [ "$1" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}inventory${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci internal-services-recreate
  exit

fi

if [ "$2" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "           Usage: $0 ${RED}product${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci internal-services-recreate
  exit

fi

if [ "$3" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}username${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci internal-services-recreate
  exit

fi

if [ "$4" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}password${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci internal-services-recreate
  exit

fi

if [ "$5" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "         Usage: $0 ${RED}nowait${NC} is must to be a specified! "
  echo -e "\n"
  echo -e "         Nowait Param: can be true of false "
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci internal-services-recreate
  exit

fi

if [ "$6" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "${YELLOW}Usage${NC}: $0 ${BLUE}type_of_run${NC} ${RED}is must to be a specified${NC}, and can be:"
  echo -e "                   "
  echo -e "         ${BLUE_BACK}create${NC} / ${BLACK_TO_WHITE}destroy${NC} / ${GREEN}true${NC} / ${RED}false${NC} / ${BLUE}print_only${NC} / ${CYAN}debug${NC} / ${LM}cloud_regen${NC} / ${RED}remove_unwanted${NC} / ${GREEN}add_wanted${NC}"
  echo -e "                   
                        ${BLUE}run_from_wrapper${NC}
        "
  echo "     |>..........................................................................................................................................................................................<|"
    #   echo -e "         For partial run you must write which playbooks sections to be running:"
    #   echo -e "         ./\!_internal-services-recreate.sh ${GREEN}develop${NC} ${RED}vortex${NC} vortex 1235${NC} ${BLUE}type_of_run${NC}"
    #   echo -e "          ${BLACK_TO_WHITE}Like${NC} example some role: ${BLACK_TO_WHITE}docker${NC} / ${BLACK_TO_WHITE}consul${NC} / ${BLACK_TO_WHITE}dns${NC} "
    #   echo -e "          ${BLACK_TO_WHITE}percona${NC} / ${BLACK_TO_WHITE}glusterfs${NC} / ${BLACK_TO_WHITE}etc${NC}"
  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "         ${RED}False to validate the type of run!${NC}"

  print_run_info_stand_pci internal-services-recreate
  exit

else

    if [ "$type_of_run" = "false" ] || [ "$type_of_run" = "true" ] || [ "$type_of_run" = "partial" ] || [ "$type_of_run" = "print_only" ] || [ "$type_of_run" = "run_from_wrapper" ] || [ "$type_of_run" = "debug" ] || [ "$type_of_run" = "cloud_regen" ] || [ "$type_of_run" = "destroy" ] || [ "$type_of_run" = "create" ]; then

        if [ "$type_of_run" != "run_from_wrapper" ]; then

            echo "     |>..........................................................................................................................................................................................<|"
            echo -e "         Passed value: ${RED}$type_of_run${NC} to run"
            echo "     |>..........................................................................................................................................................................................<|"

        fi

  else

    echo "     |>..........................................................................................................................................................................................<|"
    echo "          False to validate the type of run!"
    echo "          Usage: $0 type_of_run is must to be a specified, and can be a true or false!"
    echo "     |>..........................................................................................................................................................................................<|"
    exit

  fi

fi

echo -e "         ${RED}Inventory is:${NC} $inventory  ${RED}Product is:${NC} $product ${RED}Username is:${NC} $username ${RED}Password:${NC} $password ${RED}Wait After bootstrap is:${NC} $nowait ${RED}Type of run:${NC} $type_of_run"
echo "     |>..........................................................................................................................................................................................<|"

if [ "$type_of_run" = "true" ] || [ "$type_of_run" = "print_only" ]; then

    # PY REQUIREMENTS

    if [ "$type_of_run" != "run_from_wrapper" ]; then

        echo "     |>..........................................................................................................................................................................................<|"
        echo "         Running the type_of_run ./inventories/0z-cloud/products/$product/$inventory"
        echo "     |>..........................................................................................................................................................................................<|"
        echo "         Destroying VMs"
        echo "     |>..........................................................................................................................................................................................<|"

    fi

    if [ "$type_of_run" != "run_from_wrapper" ]; then

        echo "         Creating VMs"
        echo "     |>..........................................................................................................................................................................................<|"

    fi

    function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
            ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e stage="0"

else

    if [ "$type_of_run" = "destroy" ]; then 

        if [ "$type_of_run" != "run_from_wrapper" ]; then

            echo "     |>..........................................................................................................................................................................................<|"
            echo "         Running the destroy only for ./inventories/0z-cloud/products/$product/$inventory"
            echo "     |>..........................................................................................................................................................................................<|"

        fi

            if [ "${typeofcloud}" == "bare" ]; then

                echo -e "         :other baremethal magic:"

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

        exit 1

    else

        if [ "$type_of_run" = "create" ] || [ "$type_of_run" = "partial" ]; then 

            if [ "$type_of_run" != "run_from_wrapper" ]; then

                echo "Creating VMs"

            fi

            function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms \
                ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e stage="0"


            if  [ "$type_of_run" = "partial" ]; then
            
                if [ "$type_of_run" != "run_from_wrapper" ]; then

                echo "Go next because partial"

                fi

            else

                exit 1

            fi

        else

            if [ "$type_of_run" != "run_from_wrapper" ]; then

                echo "     |>..........................................................................................................................................................................................<|"
                echo "         Running the update internal only for ./inventories/0z-cloud/products/$product/$inventory"
                echo "     |>..........................................................................................................................................................................................<|"
            fi
        fi
    fi
fi

if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo "         Start regen the dynamic inventory for run"
    echo "     |>..........................................................................................................................................................................................<|"

fi

. ./scripts/libsh/cloud.regen.run.sh

if [ "$type_of_run" != "run_from_wrapper" ]; then
    echo "     |>..........................................................................................................................................................................................<|"
    echo "         Start checking echo from cloud-bind-frontend-dns hosts"
    echo "     |>..........................................................................................................................................................................................<|"
fi

if [ "$nowait" = "true" ] && [ "$type_of_run" != "run_from_wrapper" ]; then
    
    echo -e "${GREEN}         no awaiting${NC}"

else

function_selector_runner ansible -m shell -a \"'echo 1; hostname"' -i inventories/products/$product/$inventory/ cloud-bind-frontend-dns \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e "ansible_ssh_pass='$password'" 

fi


if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo "     |>..........................................................................................................................................................................................<|"
    echo "         Start checking echo from all hosts"
    echo "     |>..........................................................................................................................................................................................<|"

fi 

if [ "$nowait" = "true" ] && [ "$type_of_run" != "run_from_wrapper" ]; then
    
    echo -e "${GREEN}         no awaiting${NC}"

else

function_selector_runner ansible -m shell -a \"'echo 1; hostname"' -i inventories/products/$product/$inventory/ \
    all -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

fi

# GITLAB SERVER

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/services/gitlab-server.yml \
    -e HOSTS="gitlab-server" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# NGINX FRONTEND ROLE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/nginx/nginx-frontend-ng.yml \
    -e HOSTS="nginx-frontend" -u $username --become-user root  --become \
    -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password" -e stage="2"

# UPDATE DNS BACKEND SERVICE TO IDS HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/dns-backend.yml \
    -e HOSTS="master-bind-master-backend" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2"
#

# GITLAB RUNNERS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/services/gitlab-runners.yml \
    -e HOSTS="gitlab-runners" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# WIP....

# TEAMCITY SERVER

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/teamcity/teamcity-server.yml \
    -e HOSTS="teamcity-server" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# TEAMCITY AGENT
function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/teamcity/teamcity-agent.yml \
    -e HOSTS="teamcity-agent" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# PGCLUSTER with PG Control Cluster Service

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/database/pgcluster.yml \
    -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

### END

. ./scripts/libsh/end/end.sh ${EXEC_TIMESTAMP}