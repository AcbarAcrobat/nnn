#!/bin/bash

pipelinename=$1

clear
EXEC_TIMESTAMP=`date +%s`

# Have fun when you use that! =)
# Becareful, you need known what you doing =)
. ./scripts/libsh/head/colors.sh

# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[0;93m'
# BLUE='\033[0;44m'
# CYAN='\033[0;46m'
# LM='\033[0;105m'
# NC='\033[0m' # No Color
# BLACK_TO_WHITE='\033[1;30;47m'
# BLUE_BACK='\033[1;12;86m'
# T1_T1='\033[1;25;86m'

START_TIME=`date +%Y-%m-%d-%r`

LOG_FILE_NAME="./CI/logs/${pipelinename}-${USER}-${START_TIME}.log"

logit()
{
    echo -e "[${USER}][`date`] - ${*}" >> ${LOG_FILE_NAME}
}

uname=$(uname)

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

usage_cloud(){

    set=$1

    info_name=$2

    echo "     |>..........................................................................................................................................................................................<|"
    echo -e "         Usage: $0 ${RED}Select Cloud Provider${NC} is must to be a specified!"
    echo -e "         "
    echo -e "         Avaliable options: $0 ${T1_T1}vsphere${NC} / ${T1_T1}alicloud${NC} / ${T1_T1}bare${NC}"

    echo "     |>..........................................................................................................................................................................................<|"
    
    eval $info_name
    #"print_run_info"

    if [ "$set" = 'ERROR' ]; then 

        exit

    fi

}

print_run_info_stand_pci() { 

    pipelinename=$1

    echo -e "        WRAPPER NAME: ${RED}./\!_${pipelinename}.sh${NC}

        ${RED}Usage runline correct format for run is${NC}: 
        
        ./\!_${pipelinename}.sh ${RED}inventory product username password nowait type_of_run typeofcloud ${NC}"

    echo -e "        
            ${YELLOW}INFO${NC}: 

                #ENVIRONMENT   #PRODUCT       #USERNAME         #PASS       #NOWAIT    #TYPE_OF_RUN    #TYPE_OF_CLOUD 
                ${GREEN}development${NC}    ${RED}vortex${NC}         vortex            password    true       true            ${RED}bare${NC}

            ${GREEN}Example${NC}:

                ./\!_${pipelinename}.sh ${GREEN}develop${NC} ${RED}vortex${NC} vortex password true true vsphere${NC}

        POSSIBLE VALUES:

            ${GREEN}ENVIRONMENT:${NC} 

                - development / stand / stage / sandbox / testing / production / etc

            ${RED}PRODUCT:${NC}

                - vortex / your_product_name / etc

            ${BLUE}NOWAIT:${NC}

                - true / false

            ${YELLOW}TYPE_OF_RUN:${NC}

                - true (AUTORUN THE WRAPPER)
                - false (DIFFERENT RUN THE WRAPPER)
                - ${RED}print_only${NC} (PRINT COMMANDS TO RUN, SHOW ONLY WHAT HAPPENED IF BE TRUE)

            ${BLACK_TO_WHITE}TYPE_OF_CLOUD:${NC} 

                - alicloud / digitalocean / azure / aws / vsphere
                - ${RED}bare${NC} (baremetal - can be used for any as default and simplest)
                "

    echo "     |>..........................................................................................................................................................................................<|"

}