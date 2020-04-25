    service_name_from=$1
    containers_root=$2
    containers_prefix=$3

    item="${item}${containers_prefix}"
    echo "current service name: $item"
    echo "service_name_from: $service_name_from"
    cd $root_dir
    service_path="${containers_root}/${item}"
    echo "service_path $service_path"
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    echo -e "         ${GREEN}Start get changes in ${NC}app: ${RED}${item}${NC}";
    echo -e "         ${GREEN}Path to${NC} app: ${RED}${service_path}${NC}";
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    check_service_result=`check_for_changes $service_path`
    service_to_check_now=`echo $item | tr '-' '_'`
    echo "service_to_check_now: $service_to_check_now"
    service_possible_childrens="${service_to_check_now}_"
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    echo "service_possible_childrens: $service_possible_childrens"
    array_with_childrens=`cat ansible/group_vars/\!_Applications_Core/rails/rails_settings_map.yml |  grep -e "$service_possible_childrens+*" | grep -o '[a-z].*: '  | grep "$service_possible_childrens" | cut -d : -f 1 | grep -v docs | grep -v mongo`    
    check_docker_stack_exists_run_commands=$(ansible -m shell -a "test -e /mnt/cloud-bind-frontend-dns-glusterfs-storage/$inventory/stack/docker-stack.yml && echo 0 || echo 1 " -i ansible/inventories/products/$product/$inventory/ cloud-bind-frontend-dns[0] -u $username --become-user root --become -e "ansible_become_pass=$password" -e "ansible_ssh_pass=$password" &2>1)
    check_docker_stack_exists_run_commands_result=`echo $check_docker_stack_exists_run_commands | awk '{print $7}'`
    echo "check_docker_stack_exists_run_commands_result $check_docker_stack_exists_run_commands_result"
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    echo -e "         ${GREEN}Changes in${NC} app: ${RED}${check_service_result}${NC}";
    echo "                  Service name: $service_to_check_now"
    echo "                  Service possible sub apps: $service_possible_childrens"
    echo "                  Possible aaps list: $array_with_childrens"
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    #echo "check_docker_stack_exists_run_commands: $check_docker_stack_exists_run_commands"
    #|| [[ $check_docker_stack_exists_run_commands_result -eq 1 ]]
    #array_service_tag_from_files=`cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template.yml | grep -A 3 "    $service_to_check_now:" | grep tag | cut -d \" -f 2`
    array_service_tag_from_files=$(eval 'cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template.yml | grep -A 3 "    $service_to_check_now:" | grep tag | cut -d \" -f 2')        
    check_int=`echo $array_service_tag_from_files | grep -q "{{ version_ansible_build_id }}" && echo 1 || echo 0`
    echo "array_service_tag_from_files: $array_service_tag_from_files"
    #part_1=`echo 'ansible -m shell -a "cat /mnt/cloud-bind-frontend-dns-glusterfs-storage/'${inventory}'/stack/docker-stack.yml | grep -A 1 \"    '$service_to_check_now':\" | grep image | cut -d : -f 3 " -i ansible/inventories/products/'$product'/'$inventory'/ cloud-bind-frontend-dns[0] -u '$username' --become-user root --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"'`
    part_1=$(echo 'ansible -m shell -a "cat /mnt/cloud-bind-frontend-dns-glusterfs-storage/'${inventory}'/stack/docker-stack.yml | grep -A 1 \"    '$service_to_check_now':\" | grep image | cut -d : -f 3 " -i ansible/inventories/products/'$product'/'$inventory'/ cloud-bind-frontend-dns[0] -u '$username' --become-user root --become -e "ansible_become_pass='$password'" -e "ansible_ssh_pass='$password'"')
    #echo $part_1
    current_run_service_docker_tag_run_command=$(eval $part_1)
    #echo "current_run_service_docker_tag $current_run_service_docker_tag_run_command"
    return_code=`echo $current_run_service_docker_tag_run_command  | awk '{print $5}' | cut -d = -f 2`
    return_tag=`echo $current_run_service_docker_tag_run_command  | awk '{print $7}'`
    
    check_return_tag_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`

    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    echo "          Show return tag $return_tag"
    echo "          Show return code $return_code"
    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
    echo "          array_service_tag_from_files: $array_service_tag_from_files"

    if [[ $check_int -eq 1 ]]; then

        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo "          Set new stable tag as version_ansible_build_id"
        version_ansible_build_id="$version_ansible_build_id"
        new_tag=$version_ansible_build_id
        return_tag=$return_tag
        published_commit=`echo $return_tag | cut -d - -f 2`
        builded_commit=`git log --pretty=format:'%h' -n 1`
        echo "          Build version is: ${return_tag}"
        echo "          Past version is: ${return_tag}"
        echo "          New version is ${new_tag}"
        echo "          CI Published commit: $published_commit"
        echo "          CI Builded commit: $builded_commit"
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

    else

        if [[ "$array_service_tag_from_files" == "latest" ]]; then

            echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
            echo "          Because we want have latest, try validate latest"
            version_ansible_build_id="latest"
            return_tag=$version_ansible_build_id
            new_tag=$version_ansible_build_id
            echo "          Build version is: ${return_tag}"
            echo "          Past version is: ${return_tag}"
            echo "          New version is ${new_tag}"
            echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

        else

            echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
            echo "          Because we no have tag, ignore service to build"
            echo "          Service name is: ${service_to_check_now}"
            echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        fi


    fi

    if [[ $check_service_result -eq 1 ]]; then
    
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo -e "         ${GREEN}Because have changes, start rebuild${NC} app: ${RED}${item}${NC}";
        echo "              MAIN IF CHECKS check_service_result & check_service_result"
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo -e "         ${GREEN}Because have changes, start rebuild${NC} app: ${RED}${item}${NC}";
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo "          CI Version Build ID: $version_ansible_build_id"
        echo "          CI Published commit: $published_commit"
        echo "          CI Builded commit: $builded_commit"
        echo "          Return code: $return_code"
        echo "          Check service need to be deployed: $check_service_need_to_be_deployed"
        echo "          New version is ${new_tag}"
        echo "          Past version is: ${return_tag}"        
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

        cd ${root_dir}/${containers_root}/${item}
        
        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} ./ 
        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag ./ 
       
        # docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
        
        docker build --pull -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} . 
        docker tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
        docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$new_tag 
        
        #docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
        
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo "passed_ci_docker_tag_${service_to_check_now}: ${new_tag}" >> $LOCAL_DIRECTORY/current_tags.yml
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
  
        if [[ ! -z ${array_with_childrens[@]} ]]; then
            echo "array presented"
            for children in ${array_with_childrens[@]}; do
                echo $children
                echo "passed_ci_docker_tag_${children}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
            done
        else
            echo "no have a childs"
        fi
        
        cd $root_dir
    
    else

        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo -e "         ${GREEN}Because no have changes ${NC} we validate the app: ${RED}${item}${NC}";
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        echo "          CI Version Build ID: $version_ansible_build_id"
        echo "          CI Published commit: $published_commit"
        echo "          CI Builded commit: $builded_commit"
        echo "          Return code: $return_code"
        echo "          Check service need to be deployed: $check_service_need_to_be_deployed"
        echo "          New version is ${new_tag}"
        echo "          Past version is: ${return_tag}"        
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"


$$$$$$$$$$$$$$$
        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
        #new_tag=$return_tag
        check_service_need_to_be_deployed=$(cat ansible/group_vars/\!_ApplicationDocker_Template/docker-compose-template.yml | grep -q "    $service_to_check_now:" && echo 0 || echo 1)



        echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

        if [[ $check_service_need_to_be_deployed -eq 1 ]]; then
            
            echo "SECOND IF CHECKS check_service_need_to_be_deployed"
            echo "Service not presented in deploy template"
            echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
       
        else

            echo "SECOND ELSE CHECKS check_service_need_to_be_deployed"
            echo "Service presented in template to deploy"
            echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
            
            if [ -z "$published_commit" ] || [[ "$published_commit" == "bind" ]] || [[ "$published_commit" != "latest" ]]; then 
               
                echo "THIRD IF CHECKS published_commit & published_commit"
                echo "No have any getted container in docker stack configuration"
                echo ko
                echo "Must to build and push now"
                echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
                cd ${root_dir}/${containers_root}/${item}
                docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} ./ 
                docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
                docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
                docker build --pull -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} . 
                docker tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
                docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id 
                #docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}       
                echo "passed_ci_docker_tag_${service_to_check_now}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
                if [[ ! -z ${array_with_childrens[@]} ]]; then
                    echo "array presented"
                    for children in ${array_with_childrens[@]}; do
                        echo $children
                        echo "passed_ci_docker_tag_${children}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
                    done
                else
                    echo "no have a childs"
                fi
                cd $root_dir
            else 
                echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
                echo "THIRD ELSE CHECKS published_commit & published_commit"
                echo ok; 
                echo "We have a published commit, and need check the real changes"
                echo "branch_sha $branch_sha"
                echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

                if [ "$array_service_tag_from_files" != "latest" ]; then

                    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"
                    echo "array_service_tag_from_files is no latest"
                    echo "array_service_tag_from_files: $array_service_tag_from_files"
                    commit=`diff --old-line-format='' --new-line-format='' <(git rev-list --first-parent $builded_commit) <(git rev-list --first-parent $published_commit) | head -1`
                    branch_name=`git rev-parse --abbrev-ref HEAD`
                    branch_sha=`git rev-parse ${builded_commit}`
                    echo "branch_sha: $branch_sha"
                    echo "commit: $commit"
                    echo "branch_name: $branch_name"
                    p_b_commit=`diff --old-line-format='' --new-line-format='' <(git rev-list --first-parent $published_commit) <(git rev-list --first-parent $builded_commit) | head -1`
                    b_p_commit=`diff --old-line-format='' --new-line-format='' <(git rev-list --first-parent $builded_commit) <(git rev-list --first-parent $published_commit) | head -1`
                    echo "p_b_commit: $p_b_commit"
                    echo "b_p_commit: $b_p_commit"
                    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

                    changes=$(git diff --relative=$service_path $commit --quiet --; echo $?)
                    echo "changes $changes"

                    if [ $changes = 1 ]; then
                        echo "THIRD IF CHECKS changes for service"
                        echo "We have changes between published and builded now, must to update"
                        cd ${root_dir}/${containers_root}/${item}
                        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} ./ 
                        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
                        docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
                        docker build --pull -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} . 
                        docker tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
                        docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id 
                        #docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}       
                        echo "passed_ci_docker_tag_${service_to_check_now}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
                        if [[ ! -z ${array_with_childrens[@]} ]]; then
                            echo "array presented"
                            for children in ${array_with_childrens[@]}; do
                                echo $children
                                echo "passed_ci_docker_tag_${children}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
                            done
                        else
                            echo "no have a childs"
                        fi
                        cd $root_dir
                    else
                        
                        echo "We no have changes between published and builded now, go to save current tag"

                        echo "THIRD ELSE CHECKS changes for service"
                        if [[ ! -z ${array_with_childrens[@]} ]]; then
                            echo "array presented"
                            for children in ${array_with_childrens[@]}; do
                                echo $children
                                echo "passed_ci_docker_tag_${children}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
                            done
                        else
                            echo "no have a childs"

                        fi

                        echo "passed_ci_docker_tag_${service_to_check_now}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
                        echo 0

                    fi
                
                else

                    echo "FOUR ELSE CHECKS changes for service on latest and latest"
                    echo "array_service_tag_from_files: $array_service_tag_from_files"
                    
                    cd ${root_dir}/${containers_root}/${item}

                    

                    docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} ./ 
                    docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
                    docker build -q -f Dockerfile -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ./ 
                    docker build --pull -t ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} . 
                    docker tag ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item} 
                    docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}:$version_ansible_build_id 
                    #docker push ${ansible_global_gitlab_registry_site_name}/${gitlab_project_group}/${gitlab_project_name}/${item}       
                    
                    echo "passed_ci_docker_tag_${service_to_check_now}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
                    
                    if [[ ! -z ${array_with_childrens[@]} ]]; then
                        echo "array presented"
                        for children in ${array_with_childrens[@]}; do
                            echo $children
                            echo "passed_ci_docker_tag_${children}: ${version_ansible_build_id}" >> $LOCAL_DIRECTORY/current_tags.yml
                        done
                    else
                        echo "no have a childs"
                    fi
                    cd $root_dir
                    echo "Section for compare between latest from remote and builded"

                fi
            fi
        fi
    fi
    cd ${ansible_dir}

    echo -e "     ${GREEN}|>..........................................................................................................................................................................................<|${NC}"

}
