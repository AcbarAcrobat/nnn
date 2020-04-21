#!/bin/bash

logit()
{
    echo -e "[${USER}][`date`] - ${*}" >> ${LOG_FILE_NAME}
}

create_and_check_a_local_vault(){

    # usage create_and_check_a_local_vault vault_pass username;

    decrypt_vault_pass=$1
    username=$2

    if [ ! -d "$LOCAL_DIRECTORY" ]; then

        mkdir $LOCAL_DIRECTORY

    fi

    # rm $LOCAL_DIRECTORY/vault-password-file-tmp.yml
    rm -rf $LOCAL_DIRECTORY/vault-password-file.yml

    echo "$decrypt_vault_pass" >> $LOCAL_DIRECTORY/vault-password-file-tmp.yml
    echo "$decrypt_vault_pass" >> $LOCAL_DIRECTORY/vault-password-file.yml

    # cat $LOCAL_DIRECTORY/vault-password-file.yml
    # cat $LOCAL_DIRECTORY/vault-password-file-tmp.yml

    #ansible-vault view $ansible_dir/.files/protected/$username/vault-password-file.yml --vault-password-file $LOCAL_DIRECTORY/vault-password-file-tmp.yml  > $LOCAL_DIRECTORY/vault-password-file.yml
    ansible-vault view $ansible_dir/.files/protected/products/$product/$username/id_rsa --vault-password-file $LOCAL_DIRECTORY/vault-password-file.yml  > $LOCAL_DIRECTORY/id_rsa
    ansible-vault view $ansible_dir/.files/protected/products/$product/$username/pass.yml --vault-password-file $LOCAL_DIRECTORY/vault-password-file.yml  > $LOCAL_DIRECTORY/pass.yml
    ansible-vault view $ansible_dir/.files/protected/products/$product/$username/vault.cloud.yml --vault-password-file $LOCAL_DIRECTORY/vault-password-file.yml  > group_vars/products/$product/alicloud.yml

    cp -r $ansible_dir/.files/protected/products/$product/$username/id_rsa.pub $LOCAL_DIRECTORY/id_rsa.pub

    # debug
    # cat $LOCAL_DIRECTORY/vault-password-file.yml
    # cat $LOCAL_DIRECTORY/id_rsa
    # cat $LOCAL_DIRECTORY/id_rsa.pub
    # cat $LOCAL_DIRECTORY/pass.yml

    # Control will enter here if $DIRECTORY doesn't exist.

    # Prevents cause when children dynamic inventory cannot access to main temporarity inventory for recreate local
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    echo -e "         ${GREEN}Inventory not${NC} a ${RED}production, current environment is${NC}: $inventory"
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"


    if [ "${typeofcloud}" == "bare" ]; then

        echo "     |>.......................................................................................................................................................<|"
        echo -e "         Used type of inventory: ${RED}${typeofcloud}${NC}"
        echo "     |>.......................................................................................................................................................<|"
        
        # function_selector_runner ansible-playbook -i inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/$inventory/bootstrap_vms/ \
        #     ./\\!_root_playbooks/${typeofcloud}/bootstrap-ng-bare.yml -e ansible_product="$product" -e ansible_environment="$inventory" -e destroy_instances="true"

    else

        function_selector_runner ansible-playbook -i $ansible_dir/inventories/0z-cloud/products/types/\\!_${typeofcloud}/$product/production/bootstrap_vms/ $ansible_dir/\\!_root_playbooks/${typeofcloud}/bootstrap-ng.yml -e ansible_product="$product" -e ansible_environment="production" -e stage="0"

    fi

    #

}

run_req_vault_pass(){

    vault_pass_in=$1

    if [ -z "$vault_pass_in" ];then

        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo -e "          Usage: $0 ${RED}vault_pass${NC} is must to be a specified!"
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

        print_run_info   

        exit 1

    fi

    echo "                Vault password: ***********"

}

run_req_registry_sitename(){

    ansible_global_gitlab_registry_site=$1

    if [ -z "$ansible_global_gitlab_registry_site" ];then

        echo "     |>.......................................................................................................................................................<|"
        echo -e "          Usage: $0 ${RED}ansible_global_gitlab_registry_site${NC} is must to be a specified!"
        echo "     |>.......................................................................................................................................................<|"

        print_run_info   

        exit 1

    fi

    echo "                Docker registry uri: $ansible_global_gitlab_registry_site"

}

run_req_gitlab_project_group(){

    ansible_global_gitlab_project_group=$1

    if [ -z "$ansible_global_gitlab_project_group" ];then

        echo "     |>.......................................................................................................................................................<|"
        echo -e "          Usage: $0 ${RED}ansible_global_gitlab_project_group${NC} is must to be a specified!"
        echo "     |>.......................................................................................................................................................<|"

        print_run_info   

        exit 1

    fi

    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    echo "                Project group: $ansible_global_gitlab_project_group"
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

}

run_req_gitlab_project_name(){

    ansible_global_gitlab_project_name=$1

    if [ -z "$ansible_global_gitlab_project_name" ];then

        echo "     |>.......................................................................................................................................................<|"
        echo -e "          Usage: $0 ${RED}ansible_global_gitlab_project_name${NC} is must to be a specified!"
        echo "     |>.......................................................................................................................................................<|"

        print_run_info   

        exit 1

    fi

    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    echo "                Project name: $ansible_global_gitlab_project_name"
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

}

usage_cloud(){

    set=$1

    echo "     |>.......................................................................................................................................................<|"
    echo -e "         Usage: $0 ${RED}Select Cloud Provider${NC} is must to be a specified!"
    echo -e "         "
    echo -e "         Avaliable options: $0 ${T1_T1}vsphere${NC} / ${T1_T1}alicloud${NC} /  ${T1_T1}bare${NC}"

    echo "     |>.......................................................................................................................................................<|"
    
    print_run_info

    if [ "$set" = 'ERROR' ]; then

        exit

    fi

}



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

print_run_info() { 

pipelinename="all_services_deployer"

    echo -e "        
    # SCRIPTNAME ./\!_${pipelinename}.sh ${YELLOW}INFO${NC} - ${RED}correct format for run${NC} PARAMS:>              
    |
    * ENVIRONMENT  * PRODUCT * USERNAME  * PASS   * APPS   * RUNTYPE     * CLOUD_TYPE  * A_VAULT_PASSWORD  * REGISTRY_URL         * PROJECT_NAMESPACE  * GIT_GROUP  * VERSION   * SECURITY * CLUSTER_TYPE
     [${GREEN}development${NC}]  [${RED}vortex${NC}]  [username]  [pass]   [rails]  [${GREEN}print_only${NC}]  [${BLUE}bare${NC}]        [vault_password]    [registry.domain.com]  [vortex_engine]      [vortex]     [1234-sha]  [${GREEN}pci${NC}]      [k8s]

        POSSIBLE VALUES:

            ${GREEN}ENVIRONMENT:${NC} 

                - development / stand / stage / sandbox / testing / production / etc

            ${RED}PRODUCT:${NC}

                - vortex / your_product_name / etc

            ${YELLOW}RUNTYPE:${NC}

                - true (AUTORUN THE WRAPPER) / false (DIFFERENT RUN THE WRAPPER) / ${RED}print_only${NC} (PRINT COMMANDS TO RUN, SHOW ONLY WHAT HAPPENED IF BE TRUE)

            ${BLACK_TO_WHITE}CLOUD_TYPE:${NC} 

                - alicloud / digitalocean / azure / aws / vsphere / ${RED}bare${NC} (baremetal - can be used for any as default and simplest)

            SECURITY:

                - minimal / ${GREEN}pci${NC} / standalone 

            CLUSTER TYPE: 

                - k8s / swarm / none

     |>.......................................................................................................................................................<|

        ${YELLOW}FULL LINE EXAMPLE:${NC}

        ./\!_${pipelinename}.sh develop vortex user password rails print_only bare vault_password registry.vortex.com vortex_engine vortex 1234-sha pci
                "

        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}${LIEV} Zen...${NC}"

}

build_and_validate() {

    service_name_from=$1
    containers_root=$2
    containers_prefix=$3

    tags_get $service_name_from $containers_root $containers_prefix;

    echo "         MUST_BUILD: $MUST_BUILD"

    if [[ $MUST_BUILD -eq 1 ]]; then

        build_image_and_push $service_name_from $containers_root $containers_prefix;

    else 

       if [[ $MUST_BUILD -eq 2 ]]; then 

            echo -e "     ${RED}|>.......................................................................................................................................................<|${NC}"
            echo "          MUST_BUILD: $MUST_BUILD"
            echo "          Start build special service: $service_name_from"
            echo "          Set build ID to latest"
            version_ansible_build_id="latest"

            cd ${root_dir}/${containers_root}/${service_name_from}
            
            docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${service_name_from} ./ 
            docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${service_name_from}:$version_ansible_build_id ./ 
        
            # docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
            
            docker build --pull -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${service_name_from} . 
            docker tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${service_name_from}:$version_ansible_build_id ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${version_ansible_build_id} 
            docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${service_name_from}:$version_ansible_build_id 
            
            cd ${root_dir}

            echo "          Done build special service: $service_name_fro"
            echo -e "     ${RED}|>.......................................................................................................................................................<|${NC}"

        fi

    fi

}

tags_get() {

    service_name_from=$1
    containers_root=$2
    containers_prefix=$3

    item="${item}${containers_prefix}"
    echo -e "     ${RED}|>.......................................................................................................................................................<|${NC}"
    echo "          Running for service with name: $item"
    echo -e "     ${RED}|>.......................................................................................................................................................<|${NC}"
    echo "         service_name_from: $service_name_from"
    cd $root_dir
    service_path="${containers_root}/${item}"
    echo "         service_path $service_path"
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    echo -e "         ${GREEN}Start get changes in ${NC}app: ${RED}${item}${NC}";
    echo -e "         ${GREEN}Path to${NC} app: ${RED}${service_path}${NC}";
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    check_service_result=`check_for_changes $service_path`
    service_to_check_now=`echo $item | tr '-' '_'`
    echo "         service_to_check_now: $service_to_check_now"
    service_possible_childrens="${service_to_check_now}_"
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    echo "         service_possible_childrens: $service_possible_childrens"
    #ls -la ./
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    array_with_childrens=`cat ansible/group_vars/\!_Applications_Core/rails/rails_settings_map.yml |  grep -e "$service_possible_childrens+*" | grep -o '[a-z].*: '  | grep "$service_possible_childrens" | cut -d : -f 1 | grep -v docs | grep -v mongo`    
    check_docker_stack_exists_run_commands=$(ansible -m shell -a "test -e /mnt/cloud-bind-frontend-dns-glusterfs-storage/$inventory/stack/docker-stack.yml && echo 0 || echo 1 " -i ansible/inventories/products/$product/$inventory/ cloud-bind-frontend-dns[0] -u $username --become-user root --become -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password" )
    check_docker_stack_exists_run_commands_result=`echo $check_docker_stack_exists_run_commands | awk '{print $7}'`
    echo "     check_docker_stack_exists_run_commands_result $check_docker_stack_exists_run_commands_result"
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    echo -e "                  ${GREEN}Changes in${NC} app: ${RED}${check_service_result}${NC}";
    echo "                  Service name: $service_to_check_now"
    echo "                  Service possible sub apps: $service_possible_childrens"
    echo "                  Possible apps list: $array_with_childrens"
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    
    #echo "check_docker_stack_exists_run_commands: $check_docker_stack_exists_run_commands"
    #|| [[ $check_docker_stack_exists_run_commands_result -eq 1 ]]
    #array_service_tag_from_files=`cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template.yml | grep -A 3 "    $service_to_check_now:" | grep tag | cut -d \" -f 2`

    echo "          SECURITY CONFIGURATION IS: $deploy_environment_security_configuration"

    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

    if [ $deploy_environment_security_configuration == 'pci' ]; then

        echo "          START CHECKING TAGS FOR PCI CONFIGURATION"

        echo "          CHECKING THE DB CONTAINERS ARRAY FOR PRESENTED CONTAINER TAG"

        array_service_tag_from_files=$(eval 'cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template-pci-databases.yml | grep -A 3 "    $service_to_check_now:" | grep tag | cut -d \" -f 2')        
        check_int=`echo $array_service_tag_from_files | grep -q "{{ version_ansible_build_id }}" && echo 1 || echo 0`
        echo "          array_service_tag_from_files: $array_service_tag_from_files"

        part_1=`ansible -m shell -a "cat /mnt/cloud-bind-frontend-dns-glusterfs-storage/${inventory}/stack/docker-stack.yml | grep -A 1 \"    $service_to_check_now:\" | grep image | cut -d : -f 3 " -i ansible/inventories/products/$product/$inventory/ cloud-bind-frontend-dns[0] -u $username --become-user root --become -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password"`
        echo "part_1: $part_1"
        return_code=`echo $part_1 | awk '{print $5}' | cut -d = -f 2`
        return_tag=`echo $part_1 | awk '{print $7}'`
        
        check_return_tag_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`

        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo "          Show return tag $return_tag"
        echo "          Show return code $return_code"
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo "          array_service_tag_from_files: $array_service_tag_from_files"

        if [ -z "$array_service_tag_from_files" ]; then

            echo "          CHECKING THE SERVICES CONTAINERS ARRAY FOR PRESENTED CONTAINER TAG"

            array_service_tag_from_files=$(eval 'cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template-pci-services.yml | grep -A 3 "    $service_to_check_now:" | grep tag | cut -d \" -f 2')        
            check_int=`echo $array_service_tag_from_files | grep -q "{{ version_ansible_build_id }}" && echo 1 || echo 0`
            echo "          array_service_tag_from_files: $array_service_tag_from_files"

            part_1=`ansible -m shell -a "cat /mnt/cloud-bind-frontend-dns-glusterfs-storage/${inventory}/stack/docker-stack.yml | grep -A 1 \"    $service_to_check_now:\" | grep image | cut -d : -f 3 " -i ansible/inventories/products/$product/$inventory/ cloud-bind-frontend-dns[0] -u $username --become-user root --become -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password"`
            echo "part_1: $part_1"
            return_code=`echo $part_1 | awk '{print $5}' | cut -d = -f 2`
            return_tag=`echo $part_1 | awk '{print $7}'`
            
            check_return_tag_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`

            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          Show return tag $return_tag"
            echo "          Show return code $return_code"
            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          array_service_tag_from_files: $array_service_tag_from_files"

        fi

        if [ -z "$array_service_tag_from_files" ]; then

            echo "          CHECKING THE VPN CONTAINERS ARRAY FOR PRESENTED CONTAINER TAG"

            array_service_tag_from_files=$(eval 'cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template-pci-vpn.yml | grep -A 3 "    $service_to_check_now:" | grep tag | cut -d \" -f 2')        
            check_int=`echo $array_service_tag_from_files | grep -q "{{ version_ansible_build_id }}" && echo 1 || echo 0`
            echo "          array_service_tag_from_files: $array_service_tag_from_files"

            part_1=`ansible -m shell -a "cat /mnt/cloud-bind-frontend-dns-glusterfs-storage/${inventory}/stack/docker-vpn-stack.yml | grep -A 1 \"    $service_to_check_now:\" | grep image | cut -d : -f 3 " -i ansible/inventories/products/$product/$inventory/ cloud-bind-frontend-dns[0] -u $username --become-user root --become -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password"`
            echo "part_1: $part_1"
            return_code=`echo $part_1 | awk '{print $5}' | cut -d = -f 2`
            return_tag=`echo $part_1 | awk '{print $7}'`
            
            check_return_tag_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`

            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          Show return tag $return_tag"
            echo "          Show return code $return_code"
            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          array_service_tag_from_files: $array_service_tag_from_files"

        fi

        if [ -z "$array_service_tag_from_files" ]; then

            echo "          CHECKING THE SECURITY SERVICES CONTAINERS ARRAY FOR PRESENTED CONTAINER TAG"

            array_service_tag_from_files=$(eval 'cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template-pci-security-apps.yml | grep -A 3 "    $service_to_check_now:" | grep tag | cut -d \" -f 2')        
            check_int=`echo $array_service_tag_from_files | grep -q "{{ version_ansible_build_id }}" && echo 1 || echo 0`
            echo "          array_service_tag_from_files: $array_service_tag_from_files"

            part_1=`ansible -m shell -a "cat /mnt/cloud-bind-frontend-dns-glusterfs-storage/${inventory}/stack/docker-security-stack.yml | grep -A 1 \"    $service_to_check_now:\" | grep image | cut -d : -f 3 " -i ansible/inventories/products/$product/$inventory/ cloud-bind-frontend-dns[0] -u $username --become-user root --become -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password"`
            echo "part_1: $part_1"
            return_code=`echo $part_1 | awk '{print $5}' | cut -d = -f 2`
            return_tag=`echo $part_1 | awk '{print $7}'`
            
            check_return_tag_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`

            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          Show return tag $return_tag"
            echo "          Show return code $return_code"
            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          array_service_tag_from_files: $array_service_tag_from_files"

        fi

        if [ -z "$array_service_tag_from_files" ]; then

            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          ERROR!: array_service_tag_from_files is null!"
            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

        fi

        if [[ $check_int -eq 1 ]]; then

            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          Set new stable tag as version_ansible_build_id"
            version_ansible_build_id="$version_ansible_build_id"
            new_tag=$version_ansible_build_id
            return_tag=$return_tag
            published_commit=`echo $return_tag | cut -d - -f 2`
            builded_commit=`git log --pretty=format:'%h' -n 1`
            echo "          Build version is: ${version_ansible_build_id}"
            echo "          Past version is: ${return_tag}"
            echo "          New version is ${new_tag}"
            echo "          CI Published commit: $published_commit"
            echo "          CI Builded commit: $builded_commit"
            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            
            MUST_BUILD="1"
        else

            if [[ "$array_service_tag_from_files" == "latest" ]]; then

                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                echo "          Because we want have latest, try validate latest"
                version_ansible_build_id="latest"
                return_tag=$version_ansible_build_id
                new_tag=$version_ansible_build_id
                echo "          Build version is: ${return_tag}"
                echo "          Past version is: ${return_tag}"
                echo "          New version is ${new_tag}"
                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                MUST_BUILD="1"
            else

                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                echo "          Because we no have tag, ignore service to build"
                echo "          Service name is: ${service_to_check_now}"
                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                
                if [[ $service_to_check_now == "fluentd" ]]; then
                    MUST_BUILD="2"
                else
                    MUST_BUILD="0"
                fi

            fi

        fi

    else 

        if [ $deploy_environment_security_configuration == 'minimal' ]; then

        array_service_tag_from_files=$(eval 'cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template.yml | grep -A 3 "    $service_to_check_now:" | grep tag | cut -d \" -f 2')        
        check_int=`echo $array_service_tag_from_files | grep -q "{{ version_ansible_build_id }}" && echo 1 || echo 0`
        echo "          array_service_tag_from_files: $array_service_tag_from_files"

        part_1=`ansible -m shell -a "cat /mnt/cloud-bind-frontend-dns-glusterfs-storage/${inventory}/stack/docker-stack.yml | grep -A 1 \"    $service_to_check_now:\" | grep image | cut -d : -f 3 " -i ansible/inventories/products/$product/$inventory/ cloud-bind-frontend-dns[0] -u $username --become-user root --become -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password"`
        echo "part_1: $part_1"
        return_code=`echo $part_1 | awk '{print $5}' | cut -d = -f 2`
        return_tag=`echo $part_1 | awk '{print $7}'`
        
        check_return_tag_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`

        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo "          Show return tag $return_tag"
        echo "          Show return code $return_code"
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo "          array_service_tag_from_files: $array_service_tag_from_files"

        if [[ $check_int -eq 1 ]]; then

            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo "          Set new stable tag as version_ansible_build_id"
            version_ansible_build_id="$version_ansible_build_id"
            new_tag=$version_ansible_build_id
            return_tag=$return_tag
            published_commit=`echo $return_tag | cut -d - -f 2`
            builded_commit=`git log --pretty=format:'%h' -n 1`
            echo "          Build version is: ${version_ansible_build_id}"
            echo "          Past version is: ${return_tag}"
            echo "          New version is ${new_tag}"
            echo "          CI Published commit: $published_commit"
            echo "          CI Builded commit: $builded_commit"
            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            
            MUST_BUILD="1"
        else

            if [[ "$array_service_tag_from_files" == "latest" ]]; then

                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                echo "          Because we want have latest, try validate latest"
                version_ansible_build_id="latest"
                return_tag=$version_ansible_build_id
                new_tag=$version_ansible_build_id
                echo "          Build version is: ${return_tag}"
                echo "          Past version is: ${return_tag}"
                echo "          New version is ${new_tag}"
                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                MUST_BUILD="1"
            else

                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                echo "          Because we no have tag, ignore service to build"
                echo "          Service name is: ${service_to_check_now}"
                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

                if [[ $service_to_check_now == "fluentd" ]]; then
                    MUST_BUILD="2"
                else
                    MUST_BUILD="0"
                fi

            fi

        fi

        fi

    fi

}

build_image_and_push() {

    service_name_from=$1
    containers_root=$2
    containers_prefix=$3

    if [[ $check_service_result -eq 1 ]]; then
    
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo -e "         ${GREEN}Because have changes, start rebuild${NC} app: ${RED}${item}${NC}";
        echo "              MAIN IF CHECKS check_service_result & check_service_result"
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo -e "         ${GREEN}Because have changes, start rebuild${NC} app: ${RED}${item}${NC}";
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo "          CI Version Build ID: $version_ansible_build_id"
        echo "          CI Published commit: $published_commit"
        echo "          CI Builded commit: $builded_commit"
        echo "          Return code: $return_code"
        echo "          Check service need to be deployed: $check_service_need_to_be_deployed"
        echo "          New version is ${new_tag}"
        echo "          Past version is: ${return_tag}"        
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

        cd ${root_dir}/${containers_root}/${service_name_from}
        
        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} ./ 
        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag ./ 
       
        # docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
        
        docker build --pull -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} . 
        docker tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
        docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag 
        
        #docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
        
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo "passed_ci_docker_tag_${service_to_check_now}: ${new_tag}" >> $LOCAL_DIRECTORY/current_tags.yml
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
  
        if [[ ! -z ${array_with_childrens[@]} ]]; then
            echo "     array presented"
            for children in ${array_with_childrens[@]}; do
                echo $children
                echo "passed_ci_docker_tag_${children}: ${new_tag}" >> $LOCAL_DIRECTORY/current_tags.yml
            done
        else
            echo "          no have a childs"
        fi
        
        cd $root_dir
    
    else

        check_rt_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`
        check_rtl_int=`echo $return_tag | grep -q -E "latest" && echo 1 || echo 0`

        if [[ $check_rt_int -eq 1 ]] || [[ $check_rtl_int -eq 1 ]]; then

            version_ansible_build_id="$version_ansible_build_id"
            new_tag=$return_tag
            return_tag=$return_tag
            #published_commit=`echo $return_tag | cut -d - -f 2`
            builded_commit=`git log --pretty=format:'%h' -n 1`
            MUST_BUILD="1"

        else 

            version_ansible_build_id="$version_ansible_build_id"
            new_tag=$version_ansible_build_id
            return_tag=$return_tag
            builded_commit=`git log --pretty=format:'%h' -n 1`
            MUST_BUILD="1"

        fi

        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo -e "         ${GREEN}Because no have changes ${NC} we validate the app: ${RED}${item}${NC}";
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo "          Set new stable tag as replaced getted tag"
        echo "          Build version is: ${return_tag}"
        echo "          Past version is: ${return_tag}"
        echo "          New version is ${new_tag}"
        echo "          CI Published commit: $published_commit"
        echo "          CI Builded commit: $builded_commit"
        echo "          CI Version Build ID: $version_ansible_build_id"
        echo "          Return code: $return_code"
        echo "          Check service need to be deployed: $check_service_need_to_be_deployed"
        echo "          New version is ${new_tag}"
        echo "          Past version is: ${return_tag}"        
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

        cd ${root_dir}/${containers_root}/${service_name_from}
                
        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} ./ 
        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag ./ 
    
        # docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
        
        docker build --pull -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} . 
        docker tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
        docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag 
        
        #docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
        
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
        echo "passed_ci_docker_tag_${service_to_check_now}: ${new_tag}" >> $LOCAL_DIRECTORY/current_tags.yml
        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

        if [[ ! -z ${array_with_childrens[@]} ]]; then
            echo "          array presented"
            for children in ${array_with_childrens[@]}; do
                echo $children
                echo "passed_ci_docker_tag_${children}: ${new_tag}" >> $LOCAL_DIRECTORY/current_tags.yml
            done
        else
            echo "          no have a childs"
        fi
        
        cd $root_dir

    fi
}

function check_for_changes(){

    set -e

    logic_folders=$@

    commit=`diff --old-line-format='' --new-line-format='' <(git rev-list --first-parent develop) <(git rev-list --first-parent HEAD) | head -1`
    branch=`git rev-parse --abbrev-ref HEAD`

    if [ $branch = "qa" ]; then
        echo 1
    elif [ $branch = "master" ]; then
        echo 1
    else
        for folder in ${logic_folders[@]}; do

            changes=$(git diff --relative=$folder $commit --quiet --; echo $?)

            if [ $changes = 1 ]; then

                echo 1
                
            else

                echo 0

            fi

        done
    fi
    
}