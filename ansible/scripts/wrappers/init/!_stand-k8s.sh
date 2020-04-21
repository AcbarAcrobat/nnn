#!/bin/bash

. ./scripts/libsh/head/clouds.sh stand-k8s

. ./scripts/libsh/head/main.sh

inventory=$1
product=$2
username=$3
password=$4
nowait=$5
type_of_run=$6
typeofcloud=$7
extra_args_type_of_run=$8

. ./scripts/libsh/head/stand.pci.sh

if [ "$1" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}inventory${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci stand-k8s
  exit

fi

if [ "$2" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "           Usage: $0 ${RED}product${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci stand-k8s
  exit

fi

if [ "$3" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}username${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci stand-k8s
  exit

fi

if [ "$4" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}password${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci stand-k8s
  exit

fi

if [ "$5" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "         Usage: $0 ${RED}nowait${NC} is must to be a specified! "
  echo -e "\n"
  echo -e "         Nowait Param: can be true of false "
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci stand-k8s
  exit

fi

if [ "$6" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "${YELLOW}Usage${NC}: $0 ${BLUE}type_of_run${NC} ${RED}is must to be a specified${NC}, and can be:"
  echo -e "                   "
  echo -e "         ${BLUE_BACK}create${NC} / ${BLACK_TO_WHITE}destroy${NC} / ${GREEN}true${NC} / ${RED}false${NC} / ${BLUE}print_only${NC} / ${CYAN}debug${NC} / ${LM}cloud_regen${NC} / ${RED}remove_unwanted${NC} / ${GREEN}add_wanted${NC}"
  echo -e "                   
                        ${BLUE}run_from_wrapper${NC}
        "
  echo "     |>.......................................................................................................................................................<|"
  echo -e "         ${RED}False to validate the type of run!${NC}"

  print_run_info_stand_pci stand-k8s
  exit

else

    if [ "$type_of_run" = "false" ] || [ "$type_of_run" = "true" ] || [ "$type_of_run" = "partial" ] || [ "$type_of_run" = "print_only" ] || [ "$type_of_run" = "run_from_wrapper" ] || [ "$type_of_run" = "debug" ] || [ "$type_of_run" = "cloud_regen" ] || [ "$type_of_run" = "destroy" ] || [ "$type_of_run" = "create" ]; then

        if [ "$type_of_run" != "run_from_wrapper" ]; then

            echo "     |>.......................................................................................................................................................<|"
            echo -e "         Passed value: ${RED}$type_of_run${NC} to run"
            echo "     |>.......................................................................................................................................................<|"

        fi

  else

    echo "     |>.......................................................................................................................................................<|"
    echo "          False to validate the type of run!"
    echo "          Usage: $0 type_of_run is must to be a specified, and can be a true or false!"
    echo "     |>.......................................................................................................................................................<|"
    exit

  fi

fi

echo -e "         ${RED}Inventory is:${NC} $inventory  ${RED}Product is:${NC} $product ${RED}Username is:${NC} $username ${RED}Password:${NC} $password ${RED}Wait After bootstrap is:${NC} $nowait ${RED}Type of run:${NC} $type_of_run"
echo "     |>.......................................................................................................................................................<|"

if [ "$type_of_run" = "true" ] || [ "$type_of_run" = "print_only" ]; then

    if [ "$type_of_run" != "run_from_wrapper" ]; then

        echo "     |>.......................................................................................................................................................<|"
        echo "         Running the type_of_run ./inventories/0z-cloud/products/$product/$inventory"
        echo "     |>.......................................................................................................................................................<|"
        echo "         Destroying VMs"
        echo "     |>.......................................................................................................................................................<|"

    fi

    if [ "$type_of_run" != "run_from_wrapper" ]; then

        echo "         Creating VMs"
        echo "     |>.......................................................................................................................................................<|"

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

        # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
        #                 ./\!_root_playbooks/${typeofcloud}/after_init_restart.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

        # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
        #         ./\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e stage="0"
else

    if [ "$type_of_run" = "destroy" ]; then 

        if [ "$type_of_run" != "run_from_wrapper" ]; then

            echo "     |>.......................................................................................................................................................<|"
            echo "         Running the destroy only for ./inventories/0z-cloud/products/$product/$inventory"
            echo "     |>.......................................................................................................................................................<|"

        fi


            if [ "${typeofcloud}" == "alicloud" ]; then

                function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
                    ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

            fi

            if [ "${typeofcloud}" == "vsphere" ]; then

                function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms \
                    ./\\!_root_playbooks/${typeofcloud}/destroy_danger.yml -e ansible_product="$product"

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

                echo "     |>.......................................................................................................................................................<|"
                echo "         Running the update internal only for ./inventories/0z-cloud/products/$product/$inventory"
                echo "     |>.......................................................................................................................................................<|"
            fi
        fi
    fi
fi

if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo "         Start regen the dynamic inventory for run"
    echo "     |>.......................................................................................................................................................<|"

fi

. ./scripts/libsh/cloud.regen.run.sh

if [ "$type_of_run" != "run_from_wrapper" ]; then
    echo "     |>.......................................................................................................................................................<|"
    echo "         Start checking echo from cloud-bind-frontend-dns hosts"
    echo "     |>.......................................................................................................................................................<|"
fi

if [ "$nowait" = "true" ] && [ "$type_of_run" != "run_from_wrapper" ]; then
    
    echo -e "${GREEN}         no awaiting${NC}"

else

function_selector_runner ansible -m shell -a \"'echo 1; hostname"' -i inventories/products/$product/$inventory/ cloud-bind-frontend-dns \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e "ansible_ssh_pass='$password'" 

fi


if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo "     |>.......................................................................................................................................................<|"
    echo "         Start checking echo from all hosts"
    echo "     |>.......................................................................................................................................................<|"

fi 

if [ "$nowait" = "true" ] && [ "$type_of_run" != "run_from_wrapper" ]; then
    
    echo -e "${GREEN}         no awaiting${NC}"

else

function_selector_runner ansible -m shell -a \"'echo 1; hostname"' -i inventories/products/$product/$inventory/ \
    all -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

fi

# LOADING SHARED PLAYBOOKS

. ./scripts/libsh/head/shared_books.sh

# CREATE RC LOCAL FOR ALL

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/rc_local.yml \
    -e HOSTS="all" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# SETUP DNS INITIALIZATION TO ALL HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/dns-initialization.yml \
    -e HOSTS="all" -u $username --become-user root  --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"


# SETUP SYSTEMD RESOLVED SERVICE TO ALL HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/systemd_resolved.yml \
    -u $username --become-user root --become -e "ansible_become_pass='$password'" \
    -e "ansible_ssh_pass='$password'" -e stage="1"

# CREATE CLOUD BIND GLUSTERFS STORAGE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/storage/glusterfs-cluster.yml \
    -e GLUSTERFS_CLUSTER_HOSTS="cloud-bind-frontend-dns-glusterfs-storage" \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# CREATE DATABASES CLUSTER GLUSTERFS STORAGE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/storage/glusterfs-cluster.yml \
    -e GLUSTERFS_CLUSTER_HOSTS="postgres-database-glusterfs" \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# CREATE BIND MASTERS GLUSTERFS STORAGE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/storage/glusterfs-cluster.yml \
    -e GLUSTERFS_CLUSTER_HOSTS="bind-master-glusterfs" \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# KUBERNETES CLUSTER


function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/k8/k8-cluster.yml \
    -e GLUSTERFS_CLUSTER_HOSTS="bind-master-glusterfs" \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"
    
function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/k8/k8-cluster.yml \
    -e GLUSTERFS_CLUSTER_HOSTS="bind-master-glusterfs" \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1" -e reset_cluster="1"

# SETUP CoreDNS FRONTEND SERVICE TO IDS HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/core-dns.yml \
    -e HOSTS="cloud-bind-frontend-dns" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2"

# SETUP DNS BACKEND SERVICE TO DNS BACKEND HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/dns-backend.yml \
    -e HOSTS="master-bind-master-backend" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2"


# NGINX FRONTEND ROLE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/nginx/nginx-frontend-ng.yml \
    -e HOSTS="nginx-frontend" -u $username --become-user root  --become \
    -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password" -e stage="2"

# INSTALLING NEW MAIN NETPLAN CONFIGURATION FOR BACKEND HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/\!_network/netplan.yml \
    -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# Perform keealived install for k8s masters

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/\!_network/keepalive_deploy.yml \
    -e HOSTS="vortex-core-master-backend" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# # INSTALLING THE MAIN NETWORK BALANCER FOR BACKEND HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/\!_network/keepalive_deploy.yml \
    -e HOSTS="network-balancer-stack" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# INSTALLING AUDITD & LOGROTATE CONFIGURATIONS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/compliance/audit.yml \
    -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/\!_bootstrap/logrotate.yml \
    -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/system/pam_d-all.yml \
    -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# Run the apt_install.yml playbook for all hosts

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo -e "       Run the ${RED}apt_install.yml${NC} playbook for all hosts, for install ${RED}necessary${NC} system packages"
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/\!_bootstrap/apt_install.yml \
        -e HOSTS='all' \
        -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo -e "       Run the ${RED}postfix.yml${NC} playbook for all hosts, for install ${RED}necessary${NC} system packages"
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/\!_bootstrap/postfix.yml \
        -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo -e "       Run the ${RED}clamav.yml${NC} playbook for all hosts, for install ${RED}Antivirus${NC} system packages"
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/security/clamav.yml \
        -u $username --become-user root \
        -e HOSTS='all' \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo -e "       Run the ${RED}apache2 web server${NC} playbook on mirror server host, for serving ${RED}public mirrors in private zone${NC}"
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/system/repository_mirror_server_apache.yml \
        -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"


# APT MIRROR

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo -e "       Run the ${RED}apt-mirror.yml${NC} playbook for all hosts, for install ${RED}Antivirus${NC} system packages"
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo -e "       ${RED}IMPORTANT!${NC} Be careful playbook change the sources.list after complete"
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo -e "       ${RED}You must hold and wait full apt-mirror sync before continue run a other playbooks or start deploy pipelines${NC}"
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/security/apt-mirror.yml \
        -u $username --become-user root \
        -e HOSTS='all' \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# LOGGING CLUSTER AND VIEWER

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/logging/logging-kibana-service.yml \
        -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/logging/logging-elasticsearch-cluster.yml \
        -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# FLUENTD PREPARE DIRS AND CONF

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/logging/fluentd-service.yml \
        -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# HOOK UPLOAD MISSED LOGS

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/hooks/fluent_past_logs_upload.yml \
#     -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

### END

. ./scripts/libsh/end/end.sh ${EXEC_TIMESTAMP}