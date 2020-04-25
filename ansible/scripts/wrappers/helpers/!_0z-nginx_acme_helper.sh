#!/bin/bash

. ./scripts/libsh/head/clouds.sh 0z-nginx_acme_helper

. ./scripts/libsh/head/main.sh

#WIP

print_run_info() { 

    echo -e "
         ${RED}Format for run is${NC}: ./\!_0z-nginx_acme_helper.sh ${RED}inventory product username password automatic type_of_run typeofcloud ${NC}"

    echo -e "
         ${GREEN}Example${NC}: ./\!_0z-nginx_acme_helper.sh ${GREEN}develop${NC} ${RED}vortex${NC} vortex password true true vsphere${NC}"

    echo -e "
         ${YELLOW}INFO${NC}: 

         # SCRIPTNAME                    #ENVIRONMENT  #PRODUCT     #USERNAME    #PASS      #automatic    #TYPE OF RUN  #TYPE OF CLOUD       #ACME CERTIFICATE PREFIX 
         ./\!_0z-nginx_acme_helper.sh    ${GREEN}develop${NC}       ${RED}vortex${NC}       vortex       ${RED}1235${NC}       ${BLUE}false${NC}         ${BLUE}print_only${NC}    ${BLACK_TO_WHITE}alicloud / vsphere${NC}   ${RED}example.domain.com${NC}"

    echo "     |>..........................................................................................................................................................................................<|"

    if [ -z "$extra_args_type_of_run" ]; then

        echo "         Extra args for passing to run: None / Select Cloud Provider: $CLOUD_PROVIDER"

    else

        echo "         Extra args for passing to run: $extra_args_type_of_run / Select Cloud Provider: $CLOUD_PROVIDER"

    fi

    echo "     |>..........................................................................................................................................................................................<|"

}

inventory=$1
product=$2
username=$3
password=$4
automatic=$5
type_of_run=$6
typeofcloud=$7
certificate_prefix=$8
extra_args_type_of_run=$9

if [ "$1" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}inventory${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$2" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "           Usage: $0 ${RED}product${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$3" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}username${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$4" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}password${NC} is must to be a specified!"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$5" = "" ]
then

  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "         Usage: $0 ${RED}automatic${NC} is must to be a specified, and can be:"
  echo -e "                   "
  echo -e "         ${BLUE_BACK}true${NC} / ${BLACK_TO_WHITE}false${NC}"
  echo -e "\n"
  echo -e "         automatic Param: can be true of false - if true, wrapper try to get certificate name from inventory"
  echo "     |>..........................................................................................................................................................................................<|"

  print_run_info
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
  echo "     |>..........................................................................................................................................................................................<|"
  echo -e "         ${RED}False to validate the type of run!${NC}"

  print_run_info
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

echo -e "         ${RED}Inventory is:${NC} $inventory  ${RED}Product is:${NC} $product ${RED}Username is:${NC} $username ${RED}Password:${NC} $password ${RED}Wait After bootstrap is:${NC} $automatic ${RED}Type of run:${NC} $type_of_run"
echo "     |>..........................................................................................................................................................................................<|"

if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo "         Start regen the dynamic inventory for run"
    echo "     |>..........................................................................................................................................................................................<|"

fi

. ./scripts/libsh/cloud.regen.run.sh

# UPDATE CORE DNS SERVICE

if [ "$inventory" != "production" ]; then

    echo -e "         ${YELLOW}Inventory${NC} not a ${RED}production${NC}, current environment is: $inventory"

    echo -e "         ${GREEN}Updating the frontend dns configuration${NC}"

    function_selector_runner ansible-playbook -i inventories/products/$product/production/ \
        playbook-library/!_bootstrap/core-dns.yml \
        -e HOSTS="cloud-bind-frontend-dns" -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2"


else

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/!_bootstrap/core-dns.yml \
        -e HOSTS="cloud-bind-frontend-dns" -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2"

fi

# CHECK AND UPDATE ENVIRONMENT DNS BACKEND CONFIGURATION

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/dns-backend.yml \
    -e HOSTS="master-bind-master-backend" -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="2" 

# CERTIFICATE OBTAIN VIA HELPER

auto_type(){

    public_consul_domain=`cat inventories/products/$product/$inventory/group_vars/all.yml | grep 'public_consul_domain: \"' | grep -e "[\"]" | awk '{print $2}' | sed 's/"//g'`
    echo -e "       ${RED}  Public Consul Domain${NC} $public_consul_domain"

    # declare prefixes_list=( 
    #     *.example.$public_consul_domain=_acme-challenge.example
    #     example.$public_consul_domain=_acme-challenge.example
    #     *.$public_consul_domain=_acme-challenge
    #     $public_consul_domain=_acme-challenge
    # )

    declare prefixes_list=( 
        *.$public_consul_domain=_acme-challenge
        $public_consul_domain=_acme-challenge
    )

    for item in ${prefixes_list[@]}; do
        
        domain_acme_name=`echo $item| cut -d "=" -f 1`
        domain_acme_txt_prefix=`echo $item| cut -d "=" -f 2`

        # echo "key=$key"
        # echo "value=$value"
        echo -e "         ${RED}Run obtain certificate for domain${NC} $domain_acme_name with prefix $domain_acme_txt_prefix"

        function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
        playbook-library/!_bootstrap/letsencrypt-pacemaker.yml \
        -u $username --become-user root \
        --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="3" \
        -e "acme_domain_for_obtain='$domain_acme_name'" -e acme_domain_prefix_txt="$domain_acme_txt_prefix"

    done 

}


default_type(){

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/letsencrypt-pacemaker.yml \
    -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="3" \
    -e "acme_domain_for_obtain='$certificate_prefix'" -e acme_domain_prefix_txt="_acme-challenge.$certificate_prefix"

}


if [ "$automatic" == "true" ]; then

    auto_type

else

    default_type

fi

# SYNC CERTIFICATES FROM CA ISSUE CENTR

    function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_bootstrap/letsencrypt-ca-sync-pacemaker.yml \
    -u $username --become-user root \
    --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'" -e stage="3"

# DEPLOY NGINX CONFIGURATION

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/cloud/nginx/nginx-frontend-ng.yml \
    -e HOSTS="nginx-frontend" -u $username --become-user root  --become \
    -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password" -e stage="2"


### END

. ./scripts/libsh/end/end.sh ${EXEC_TIMESTAMP}