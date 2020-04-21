#!/bin/bash

. ./scripts/libsh/head/main.sh
. ./scripts/libsh/head/clouds.sh 0z-quality_assurance


os_echo(){

    #echo "         Start install requirements to localhost which OS TYPE: $uname"

    #source ./requirements.sh $uname

    #echo "         Done install requirements to localhost"
    echo "     |>.......................................................................................................................................................<|"

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

        echo "     |>.......................................................................................................................................................<|"
        echo -e "         Current run OS cannot pass checks ${GREEN}${uname}${NC} not validated"
        echo "     |>.......................................................................................................................................................<|"
        exit 1
    fi

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

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage for: $0 ${RED}inventory${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci 0z-quality_assurance
  exit

fi

if [ "$2" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "           Usage for: $0 ${RED}product${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci 0z-quality_assurance
  exit

fi

if [ "$3" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage for: $0 ${RED}username${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci 0z-quality_assurance
  exit

fi

if [ "$4" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "          Usage for: $0 ${RED}password${NC} is must to be a specified!"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci 0z-quality_assurance
  exit

fi

if [ "$5" = "" ]
then

  echo "     |>.......................................................................................................................................................<|"
  echo -e "         Usage for: $0 ${RED}automatic${NC} is must to be a specified, and can be:"
  echo -e "                   "
  echo -e "         ${BLUE_BACK}true${NC} / ${BLACK_TO_WHITE}false${NC}"
  echo -e "\n"
  echo -e "         automatic Param: can be true of false - if true, wrapper try to get certificate name from inventory"
  echo "     |>.......................................................................................................................................................<|"

  print_run_info_stand_pci 0z-quality_assurance
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
  echo "     |>.......................................................................................................................................................<|"
  echo -e "         ${RED}False to validate the type of run!${NC}"

  print_run_info_stand_pci 0z-quality_assurance
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
    echo "          Usage for: $0 type_of_run is must to be a specified, and can be a true or false!"
    echo "     |>.......................................................................................................................................................<|"
    exit

  fi

fi

echo -e "         ${RED}Inventory is:${NC} $inventory  ${RED}Product is:${NC} $product ${RED}Username is:${NC} $username ${RED}Password:${NC} $password ${RED}Wait After bootstrap is:${NC} $automatic ${RED}Type of run:${NC} $type_of_run"
echo "     |>.......................................................................................................................................................<|"

# PY REQ

if [ "$type_of_run" != "run_from_wrapper" ]; then

    echo "         Start regen the dynamic inventory for run"
    echo "     |>.......................................................................................................................................................<|"

fi

. ./scripts/libsh/cloud.regen.run.sh

# RUN QA TESTS SETTINGS GENERATION

function_selector_runner ansible-playbook -i inventories/products/$product/$inventory/ \
    playbook-library/!_test_suite/python_qa.yml \
    -e HOSTS="nginx-frontend" -u $username --become-user root --become -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password" -e stage="2"

### END

. ./scripts/libsh/end/end.sh ${EXEC_TIMESTAMP}