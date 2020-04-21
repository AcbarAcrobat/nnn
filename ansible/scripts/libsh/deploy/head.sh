#!/bin/bash

clear

EXEC_TIMESTAMP=`date +%s`

# Have fun when you use that! =)
# Becareful, you need known what you doing =)



START_TIME=`date +%Y-%m-%d-%r`

LOG_FILE_NAME="./CI/logs/${SCRIPT_NAME}-${USER}-${START_TIME}.log"

# Don't forget about them...section

ansible_dir=`pwd`
#echo "ansible_dir: $ansible_dir"

cd ../

main_dir=`pwd`
#echo "main_dir: $main_dir"

cd $main_dir
cd ./ansible/

cd ../
root_dir=`pwd`
#echo "root_dir: $root_dir"

cd $root_dir
#eval ./ansible/requirements.sh

cd $ansible_dir

LOCAL_DIRECTORY="$root_dir/.local"
#echo LOCAL_DIRECTORY $LOCAL_DIRECTORY

uname=$(uname)

# echo "run_req_vault_pass: $run_req_vault_pass"

function_selector_runner(){

    escaped_list=`echo $@ |sed 's/[!]/\\\!/g'`

    test=`echo "${@}" | grep -E "\\!\_"  && echo 1 || echo 0`

    if [[ "$test" == 1 ]]; then
        #echo "test = 1"
        IFS='"\!_' in=($escaped_list)
        command_echo_run="${in[@]}"
    else
        #echo "else test != 1"
        IFS='"\' in=($@)

        command_echo_run=`echo ${in[@]}|sed 's/[!]/\\\!/g'`
    fi

    if [ "$type_of_run" = "print_only" ] || [ "$type_of_run" = "run_from_wrapper" ]; then

        if [ "$type_of_run" = "run_from_wrapper" ]; then
            
            echo "$command_echo_run"

        else

            string_column_one=`echo $command_echo_run | awk '{print $4}'` 


            echo -e "         ${YELLOW}Print type_of_run is${NC} print_only for manual run ${GREEN}${string_column_one}${NC}"
            echo "     |>.......................................................................................................................................................<|"
            echo "         "
            echo "         $command_echo_run"
            echo "         "
            echo "     |>.......................................................................................................................................................<|"

        fi

    else

        if [ "$type_of_run" = "debug" ]; then

            echo "     |>.......................................................................................................................................................<|"
            echo "          Start running command: $command_echo_run"
            echo "     |>.......................................................................................................................................................<|"
            eval "${command_echo_run}"
            echo "     |>.......................................................................................................................................................<|"
            echo "          Finish running command: $command_echo_run"
            echo "     |>.......................................................................................................................................................<|"

        else

            echo "     |>.......................................................................................................................................................<|"
            echo "$command_echo_run"
            eval "${command_echo_run}"
            echo "     |>.......................................................................................................................................................<|"
        fi

    fi

}
