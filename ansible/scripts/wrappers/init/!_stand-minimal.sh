#!/bin/bash

. ./scripts/libsh/head/clouds.sh stand-minimal
. ./scripts/libsh/head/main.sh

os_echo(){

    #echo "         Start install requirements to localhost which OS TYPE: $uname"

    #source ./requirements.sh $uname

    #echo "         Done install requirements to localhost"
    echo "     |>..........................................................................................................................................................................................<|"

}

run_req(){

    typeofcloud=$1
    uname=$2

    echo "         CLOUD TYPE REQ: ${typeofcloud}"

    echo "         RUNNED REQ: $uname"

    if [ "$uname" == "Darwin" ]; then

        os_echo;

    elif [ "$uname" == "Linux" ]; then

        os_echo;

    elif [ "$uname" == "MINGW32_NT" ]; then
        
        os_echo;

    elif [ "$uname" == "MINGW64_NT" ]; then

        echo "     |>..........................................................................................................................................................................................<|"
        echo -e "         Current run OS cannot pass checks ${GREEN}${uname}${NC} not validated"
        echo "     |>..........................................................................................................................................................................................<|"
        exit 1
    fi

}

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

  print_run_info_stand_pci stand-minimal
  exit

fi

if [ "$2" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "           Usage: $0 ${RED}product${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci stand-minimal
  exit

fi

if [ "$3" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}username${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci stand-minimal
  exit

fi

if [ "$4" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}password${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci stand-minimal
  
  exit

fi

if [ "$5" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "         Usage: $0 ${RED}nowait${NC} is must to be a specified! "
  echo -e "\n"
  echo -e "         Nowait Param: can be true of false "
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info_stand_pci stand-minimal
  
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
    #   echo -e "         ./\!_stand-minimal.sh ${GREEN}develop${NC} ${RED}vortex${NC} vortex ${RED}1235${NC} ${BLUE}type_of_run${NC}"
    #   echo -e "          ${BLACK_TO_WHITE}Like${NC} example some role: ${BLACK_TO_WHITE}docker${NC} / ${BLACK_TO_WHITE}consul${NC} / ${BLACK_TO_WHITE}dns${NC} "
    #   echo -e "          ${BLACK_TO_WHITE}percona${NC} / ${BLACK_TO_WHITE}glusterfs${NC} / ${BLACK_TO_WHITE}etc${NC}"
  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "         ${RED}False to validate the type of run!${NC}"

  
  print_run_info_stand_pci stand-minimal
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

    

    if [ "$type_of_run" != "run_from_wrapper" ]; then

        echo "     |>..........................................................................................................................................................................................<|"
        echo "         Running the type_of_run ./inventories/0z-cloud/products/$product/$inventory"
        echo "     |>..........................................................................................................................................................................................<|"
        echo "         Destroying VMs"
        echo "     |>..........................................................................................................................................................................................<|"

    fi


    # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
    #         ./\\!_root_playbooks/${typeofcloud}/destroy_danger.yml -e ansible_product="$product"

    if [ "$type_of_run" != "run_from_wrapper" ]; then

        echo "         Creating VMs"
        echo "     |>..........................................................................................................................................................................................<|"

    fi

    function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
            ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e stage="0"

    # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
    #         ./\\!_root_playbooks/${typeofcloud}/generate_inventory_replace_0z.yml -e ansible_product="$product"

else

    if [ "$type_of_run" = "destroy" ]; then 

        if [ "$type_of_run" != "run_from_wrapper" ]; then

            echo "     |>..........................................................................................................................................................................................<|"
            echo "         Running the destroy only for ./inventories/0z-cloud/products/$product/$inventory"
            echo "     |>..........................................................................................................................................................................................<|"

        fi


            if [ "${typeofcloud}" == "alicloud" ]; then

                function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
                    ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

            fi

            if [ "${typeofcloud}" == "bare" ]; then

                echo "     |>..........................................................................................................................................................................................<|"
                echo -e "         BAREMETAL INVENTORY: ${RED}${typeofcloud}${NC}"
                echo "     |>..........................................................................................................................................................................................<|"
                
                # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
                #     ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng-bare.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

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

    echo "         Awaiting upstart from cloud-bind-frontend-dns hosts"
    echo "     |>..........................................................................................................................................................................................<|"

fi

# if [ "$nowait" = "true" ] && [ "$type_of_run" != "run_from_wrapper" ]; then
    
#     echo -e "${GREEN}         no awaiting${NC}"
#     echo "     |>..........................................................................................................................................................................................<|"

# else

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ vsphere-playbooks/vsphere.wait_up.yml \
#     -e HOSTS="ids-keepalive-servers" -u $username --become-user root  --become \
#     -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

# fi


# CREATE A k8 cluster SERVICE

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/cloud/k8/k8-cluster.yml \
#     -u $username --become-user root --become \
#     -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"


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
    echo "         Done checking echo from cloud-bind-frontend-dns hosts"
    echo "     |>..........................................................................................................................................................................................<|"
    echo "         Start install the keepalived gateway"
    echo "     |>..........................................................................................................................................................................................<|"

fi

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/!_network/keepalive_deploy.yml -e HOSTS="ids-keepalive-servers" \
#     -u $username --become-user root  --become -e "ansible_become_pass='$password'" \
#     -e "ansible_ssh_pass='$password'"

if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo "         Done install the keepalived gateway"
    echo "     |>..........................................................................................................................................................................................<|"
    echo "         Start install the siple firewall and rc.local on ids keepalived servers"
    echo "     |>..........................................................................................................................................................................................<|"

fi

# LOADING SHARED PLAYBOOKS

. ./scripts/libsh/head/shared_books.sh

## IDS BOOTSTRAP SECTION

# CREATE RC LOCAL FOR IDS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/rc_local.yml \
    -e HOSTS="ids-keepalive-servers" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# MAKE A SIMPLE FIREWALL

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/!_bootstrap/simple_firewall.yml \
#     -e HOSTS="ids-keepalive-servers" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo "         Awaiting upstart all hosts"
    echo "     |>..........................................................................................................................................................................................<|"

fi

# if [ "$nowait" = "true" ] && [ "$type_of_run" != "run_from_wrapper" ]; then
    
#     echo -e "${GREEN}         no awaiting${NC}"

# else

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ vsphere-playbooks/vsphere.wait_up.yml \
#     -e HOSTS="all" -u $username --become-user root --become \
#     -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

# fi

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
# CREATE RC LOCAL TO ALL OTHER HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/rc_local.yml \
    -e HOSTS="all" -u $username --become-user root --limit "!ids-keepalive-servers" \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# SETUP DNS SERVICE TO IDS HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/dns-initialization.yml \
    -e HOSTS="all" -u $username --become-user root  --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# SETUP SYSTEMD RESOLVED SERVICE TO ALL HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/systemd_resolved.yml \
    -u $username --become-user root --become -e "ansible_become_pass='$password'" \
    -e "ansible_ssh_pass='$password'" -e stage="1"

# SSH LOCALHOST DEPENDENCY

function_selector_runner ansible-playbook playbook-library/system/ssh_deps.yml 

# SSH KEYUPLOAD

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/system/ssh.yml \
    -e HOSTS="all" -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
    --tags add_user -e stage="1"

## MASKED WIP
# ansible-playbook -i inventories/products/$product/$inventory/ playbook-library/!_bootstrap/ssh.yml \
#     -e HOSTS="ids-keepalive-servers" -u $username --become-user root  --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"
#####

# CREATE A CONSUL SERVICE DISCOVERY SERVICE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/consul/!_consul_cloud_playbook.yml \
    -e HOSTS="all" -u $username --become-user root  --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e "consul_upgrade=true" -e stage="1"

# CREATE CLOUD BIND GLUSTERFS STORAGE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/storage/glusterfs-cluster.yml \
    -e GLUSTERFS_CLUSTER_HOSTS="cloud-bind-frontend-dns-glusterfs-storage" \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

### GLUSTERFS SECTION >

# CREATE BIND MASTER BACKEND GLUSTERFS STORAGE

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/storage/glusterfs-cluster.yml \
#     -e GLUSTERFS_CLUSTER_HOSTS="app-glusterfs-cluster" \
#     -u $username --become-user root --become \
#     -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

# CREATE DATABASE GLUSTERFS STORAGE

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/storage/glusterfs-cluster.yml \
#     -e GLUSTERFS_CLUSTER_HOSTS="database-glusterfs-cluster" \
#     -u $username --become-user root --become \
#     -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

# CREATE BIND MASTERS GLUSTERFS STORAGE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/storage/glusterfs-cluster.yml \
    -e GLUSTERFS_CLUSTER_HOSTS="bind-master-glusterfs" \
    -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# CREATE BIND MASTERS GLUSTERFS STORAGE
# sentry-web-glusterfs-cluster

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/storage/glusterfs-cluster.yml \
#     -e GLUSTERFS_CLUSTER_HOSTS="sentry-web-glusterfs-cluster" \
#     -u $username --become-user root --become \
#     -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
#     -e clean_glusterfs_all=true -e clean_glusterfs_reintall=true

# # sentry-cache-glusterfs-cluster

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/storage/glusterfs-cluster.yml \
#     -e GLUSTERFS_CLUSTER_HOSTS="sentry-cache-glusterfs-cluster" \
#     -u $username --become-user root --become \
#     -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
#     -e clean_glusterfs_all=true -e clean_glusterfs_reintall=true

# # sentry-database-glusterfs-cluster

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/storage/glusterfs-cluster.yml \
#     -e GLUSTERFS_CLUSTER_HOSTS="sentry-database-glusterfs-cluster" \
#     -u $username --become-user root --become \
#     -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
#     -e clean_glusterfs_all=true -e clean_glusterfs_reintall=true

### GLUSTERFS SECTION<

# DOCKER INSTALL FOR ALL HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/docker/docker-install-auto-cloud.yml \
    -e HOSTS="all" -u $username --become-user root --become \
    -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2"

# SETUP CoreDNS FRONTEND SERVICE TO IDS HOSTS

if [ "$inventory" != "production" ]; then

    echo "     |>..........................................................................................................................................................................................<|"
    echo "          Inventory not a production, current environment is: $inventory"
    echo "          We not recommends to deploy core-dns main service other then production inventory"
    echo "     |>..........................................................................................................................................................................................<|"


    if [ "$type_of_run" == "print_only" ]; then

        echo "     |>..........................................................................................................................................................................................<|"
        echo "         Show core-dns runline"
        echo "     |>..........................................................................................................................................................................................<|"


        function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/!_bootstrap/core-dns.yml \
        -e HOSTS="cloud-bind-frontend-dns" -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2"
    echo "     |>..........................................................................................................................................................................................<|"

    fi 

else

    echo "     |>..........................................................................................................................................................................................<|"
    echo "         Show core-dns runline"
    echo "     |>..........................................................................................................................................................................................<|"

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/core-dns.yml \
    -e HOSTS="cloud-bind-frontend-dns" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2"

    echo "     |>..........................................................................................................................................................................................<|"

fi


# SETUP DNS FRONTEND SERVICE TO IDS HOSTS

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/!_bootstrap/dns-frontend.yml \
#     -e HOSTS="cloud-bind-frontend-dns" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

# SETUP DNS BACKEND SERVICE TO IDS HOSTS

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/dns-backend.yml \
    -e HOSTS="master-bind-master-backend" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2" 

# Obtaining Certificates

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/letsencrypt-pacemaker.yml \
    -e HOSTS="master-bind-master-backend" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="3" \
    -e acme_domain_for_obtain="vortex.com"

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/letsencrypt-pacemaker.yml \
    -e HOSTS="master-bind-master-backend" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="4" \
    -e acme_domain_for_obtain="*.vortex.com" -e acme_domain_prefix_txt=""

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/letsencrypt-pacemaker.yml \
    -e HOSTS="master-bind-master-backend" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="5" \
    -e acme_domain_for_obtain="*.business.vortex.com" -e acme_domain_prefix_txt=""

# # SETUP IMMORTAL CHECKS BACKEND SERVICE TO ALL DNS HOSTS

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/cloud/immortal/immortal.yml \
#     -e DELEGATE_HOSTS="master-bind-master-backend" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"


### SWARM CLUSTERS >

# CREATE A DOCKER SWARM CLUSTER

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/swarm/swarm-cluster.yml \
    -e SWARM_MASTERS="swarm-cluster" \
    -u $username --become-user root --become -e "ansible_become_pass='$password'" \
    -e "ansible_ssh_pass='$password'" \
    -e leave_cluster="true" -e stage="2"

# CREATE A DOCKER DATABASE SWARM CLUSTER

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/cloud/swarm/swarm-cluster.yml \
#     -e SWARM_MASTERS="database-swarm-masters" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
#     -e leave_cluster="true"

# # CREATE A DOCKER DATABASE SWARM CLUSTER

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/cloud/swarm/swarm-cluster.yml \
#     -e SWARM_MASTERS="database-swarm-masters" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
#     -e leave_cluster="true"

# CREATE SENTRY SWARM CLUSTERS

# sentry-database-swarm-cluster

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/cloud/swarm/swarm-cluster.yml \
#     -e SWARM_MASTERS="sentry-database-swarm-cluster" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
#     -e leave_cluster="true"

# sentry-cache-swarm-cluster

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/cloud/swarm/swarm-cluster.yml \
#     -e SWARM_MASTERS="sentry-cache-swarm-cluster" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
#     -e leave_cluster="true"

# sentry-web-swarm-cluster

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/cloud/swarm/swarm-cluster.yml \
#     -e SWARM_MASTERS="sentry-web-swarm-cluster" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" \
#     -e leave_cluster="true"

### SWARM CLUSTERS <

# BOOTSTRAP OR UPDATE PERCONA CLUSTER

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/database/percona-cluster.yml \
#     -e HOSTS="percona-cluster" \
#     -e bootstrap_cluster="true" \
#     -e clear_cluster="true" \
#     -u $username --become-user root  --become -e "ansible_become_pass='$password'" \
#     -e "ansible_ssh_pass='$password'"

# BOOTSTRAP OR UPDATE POSTGRES Sentry CLUSTER

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/database/postgres-cluster.yml \
#     -e HOSTS="sentry-postgres-cluster" \
#     -e bootstrap_cluster="true" \
#     -e clear_cluster="true" \
#     -u $username --become-user root  --become -e "ansible_become_pass='$password'" \
#     -e "ansible_ssh_pass='$password'"

# BOOTSTRAP RABBITMQ CLUSTER SERVICE

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/core_services/rabbitmq-docker-cluster.yml \
#     -e HOSTS="rabbitmq-cluster" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

# ELASTIC SEARCH CLUSTER

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/database/elasticsearch-cluster.yml \
#     -e HOSTS="elasticsearch-cluster" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

# REDIS DOCKER CLUSTER FOR SENTRY

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/database/redis-io-cluster.yml \
#     -e HOSTS="sentry-redis-io-cluster" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"

# NGINX FRONTEND ROLE

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/nginx/nginx-frontend-ng.yml \
    -e HOSTS="nginx-frontend" -u $username --become-user root  --become \
    -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password" -e stage="2"

#

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

# APT MIRROR

echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
echo -e "       Run the ${RED}apt-mirror.yml${NC} playbook for all hosts, for install ${RED}Antivirus${NC} system packages"
echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
echo -e "       ${RED}IMPORTANT!${NC} Be careful playbook change the sources.list after complete"
echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
echo -e "       ${RED}You must hold and wait full apt-mirror sync before continue run a other playbooks or start deploy pipelines${NC}"
echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

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

# # ELASTICSEARCH PREPARE DIRS AND CONF

# function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
#     playbook-library/database/elasticsearch-stack.yml \
#     -e HOSTS="gitlab-server" -u $username --become-user root \
#     --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="1"

# WIP....

### END

. ./scripts/libsh/end/end.sh ${EXEC_TIMESTAMP}