     if [[ $check_service_result -eq 1 ]]; then

            echo "              MAIN IF CHECKS check_service_result & check_service_result"
            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
            echo -e "         ${GREEN}Because have changes, start rebuild${NC} app: ${RED}${item}${NC}";
            echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
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
            
