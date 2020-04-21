#!/bin/bash

inventory=$1
product=$2
username=$3
password=$4
apps=$5
type_of_run=$6
typeofcloud=$7
vault_pass=$8
ansible_global_gitlab_registry_site_name=$9
gitlab_project_name=${10}
gitlab_project_group=${11}
version_ansible_build_id=${12}
deploy_environment_security_configuration=${13}
cluster_type=${14}
extra_args_type_of_run=${15}

if [ "${13}" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}Security Type${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Valid Types for: $0 ${GREEN}pci${NC} | ${RED}minimal${NC} | ${BLUE}standalone${NC}"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info
  exit

else

  if [ "$deploy_environment_security_configuration" != "pci" ] && [ "$deploy_environment_security_configuration" != "minimal" ] && [ "$deploy_environment_security_configuration" != "standalone" ]; then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          ${RED}WARNING!${NC} Incorrect ${RED}Security Type${NC} is must have to be one of this values:"
  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Valid Types for: $0 ${GREEN}pci${NC} | ${RED}minimal${NC} | ${BLUE}standalone${NC}"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info
  exit

  fi

fi

if [ "${14}" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}Cluster Type${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Valid Types for: $0 ${GREEN}k8s${NC} | ${RED}swarm${NC} | ${BLUE}none${NC}"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info

  exit

else

  if [ "$cluster_type" != "k8s" ] && [ "$cluster_type" != "swarm" ] && [ "$cluster_type" != "none" ]; then

    echo "     |>.......................................................................................................................................................<|"
    echo -e "          ${RED}WARNING!${NC} Incorrect cluster type, pipeline must have one of this values: ${GREEN}k8s${NC} | ${RED}swarm${NC} | ${BLUE}none${NC}"
    echo "     |>.......................................................................................................................................................<|"


  print_run_info

  exit
  
  else

    if [ "$cluster_type" == "k8s" ] && [ $deploy_environment_security_configuration == "standalone" ]; then 

    echo "     |>.......................................................................................................................................................<|"
    echo -e "          ${RED}WARNING!${NC} Deployment strategy cannot be ${RED}k8s${NC} and ${RED}standalone${NC} in same time: Please change the ${RED}Cluster Type${NC} or Security configuration!"
    echo "     |>.......................................................................................................................................................<|"

    print_run_info

    exit

    fi

    if [ "$cluster_type" == "swarm" ] && [ $deploy_environment_security_configuration == "standalone" ]; then 

    echo "     |>.......................................................................................................................................................<|"
    echo -e "          ${RED}WARNING!${NC} Deployment strategy cannot be ${RED}swarm${NC} and ${RED}standalone${NC} in same time: Please change the ${RED}Cluster Type${NC} or Security configuration!"
    echo "     |>.......................................................................................................................................................<|"

    print_run_info

    exit

    fi

    if [ "$cluster_type" == "none" ] && [ $deploy_environment_security_configuration != "standalone" ]; then

    echo "     |>.......................................................................................................................................................<|"
    echo -e "          ${RED}WARNING!${NC} Deployment strategy cannot be ${RED}none${NC} and ${RED}not a standalone${NC} in same time: Please change the ${RED}Cluster Type${NC} or Security configuration!"
    echo "     |>.......................................................................................................................................................<|"

    print_run_info

    exit

    fi


  fi

fi

if [ "$1" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}inventory${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$2" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "           Usage: $0 ${RED}product${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$3" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}username${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$4" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage: $0 ${RED}password${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$5" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "         Usage: $0 ${RED}apps${NC} is must to be a specified! "
  echo -e "\n"
  echo -e "         apps Param: can be true of false "
  echo "     |>.......................................................................................................................................................<|"

  print_run_info
  exit

fi

if [ "$6" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "${YELLOW}Usage${NC}: $0 ${BLUE}type_of_run${NC} ${RED}is must to be a specified${NC}, and can be:"
  echo -e "                   "
  echo -e "         ${BLUE_BACK}create${NC} / ${BLACK_TO_WHITE}destroy${NC} / ${GREEN}update${NC} / ${RED}rollback${NC} / 
                    
                    ${BLUE}print_only${NC} / ${CYAN}debug${NC} / ${LM}cloud_regen${NC} / ${RED}true${NC} / ${GREEN}false${NC}"
  echo -e "                   
                        ${BLUE}run_from_wrapper${NC}
        "
  echo "     |>.......................................................................................................................................................<|"
    #   echo -e "         For partial run you must write which playbooks sections to be running:"
    #   echo -e "         ./\!_all_service_deployer.sh ${GREEN}develop${NC} ${RED}vortex${NC} vortex ${RED}1235${NC} ${BLUE}type_of_run${NC}"
    #   echo -e "          ${BLACK_TO_WHITE}Like${NC} example some role: ${BLACK_TO_WHITE}docker${NC} / ${BLACK_TO_WHITE}consul${NC} / ${BLACK_TO_WHITE}dns${NC} "
    #   echo -e "          ${BLACK_TO_WHITE}percona${NC} / ${BLACK_TO_WHITE}glusterfs${NC} / ${BLACK_TO_WHITE}etc${NC}"
  echo "     |>.......................................................................................................................................................<|"
  echo -e "         ${RED}False to validate the type of run!${NC}"

  print_run_info
  exit

else

    if [ "$type_of_run" = "destroy" ] || [ "$type_of_run" = "update" ] || [ "$type_of_run" = "rollback" ] || [ "$type_of_run" = "print_only" ] || [ "$type_of_run" = "scale" ] || [ "$type_of_run" = "debug" ] || [ "$type_of_run" = "true" ] || [ "$type_of_run" = "cloud_regen" ] || [ "$type_of_run" = "false" ]; then

        if [ "$type_of_run" != "run_from_wrapper" ]; then

            echo "     |>.......................................................................................................................................................<|"
            echo -e "         Passed value: ${RED}$type_of_run${NC} to run"
            echo "     |>.......................................................................................................................................................<|"

        fi

  else

    echo "     |>.......................................................................................................................................................<|"
    echo -e "          ${RED}False to validate the type of run!${NC}"
    echo "          Usage: $0 type_of_run is must to be a specified, and can be a true or false!"
    echo "     |>.......................................................................................................................................................<|"
    exit

  fi

fi

echo -e "                ${RED}Inventory is:${NC} $inventory  
                ${RED}Product is:${NC} $product 
                ${RED}Username is:${NC} *********
                ${RED}Password:${NC} ********* 
                ${RED}Applications for deploy:${NC} $apps 
                ${RED}Type of run:${NC} $type_of_run 
                ${GREEN}Ansible Vault Password:${NC} ********* 
                ${RED}Security Type:${NC} $deploy_environment_security_configuration
            "
echo "     |>.......................................................................................................................................................<|"
