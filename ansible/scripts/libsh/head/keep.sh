if [[ $check_return_tag_int -eq 1 ]]; then

                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                echo "          Because we no have changes, set previous tag as target"
                version_ansible_build_id="$version_ansible_build_id"
                return_tag=$return_tag
                new_tag=$return_tag
                echo "          Build version is: ${return_tag}"
                echo "          Past version is: ${return_tag}"
                echo "          New version is ${new_tag}"
                echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

            else





                check_vr_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`
            check_vr_int=`echo $return_tag | grep -q -E "[0-9]{4}.[0-9]{2}.[0-9]{2}-[0-9a-z]{8}$" && echo 1 || echo 0`

            if []

        if [[ "$array_service_tag_from_files" == "latest" ]]; then

            if [[ "$return_tag" == "latest" ]]; then 

                echo "1)    
                            We build latest:latest target and must to check changes."
                echo "      Service primary config have latest value"
                echo "      parent repository tag is latest, set latest permanently"
                echo "."
                version_ansible_build_id="latest"
                new_tag=$version_ansible_build_id
                return_tag=$version_ansible_build_id
                echo "version_ansible_build_id: $version_ansible_build_id"
                echo "new tag: ${new_tag[@]}"
                echo "return_tag $return_tag"
                builded_commit=`git log --pretty=format:'%h' -n 1`
                published_commit=""
                echo "published_commit: $published_commit"
                echo "builded_commit: $builded_commit"

            else

                echo "1)    
                            We build latest:latest target and must to check changes."

  
            
           

                echo "Deployed now tag is latest"
                echo "return_tag $return_tag"
                echo "need to check changes between latest versions"
                echo "Service primary config have latest value"
                echo "parent repository tag is latest, set latest permanently"
                version_ansible_build_id="latest"
                new_tag=$version_ansible_build_id
                return_tag=$version_ansible_build_id
                echo "version_ansible_build_id: $version_ansible_build_id"
                echo "new tag: ${new_tag[@]}"
                echo "return_tag $return_tag"
                published_commit=""
                builded_commit=`git log --pretty=format:'%h' -n 1`
                echo "published_commit: $published_commit"
                echo "builded_commit: $builded_commit"
                echo "we rebuild ${version_ansible_build_id}"

            else

                echo "Current tag not is a latest"
                
                if [ -z "$return_tag" ]; then
                
                    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                    echo "Target tag is incorrect build version"
                    echo "Show broken return_tag: $return_tag"
                    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

                    if [ -z "$array_service_tag_from_files" ]; then

                        echo "Total all bad, cannot resolve"

                    else
                        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                        echo "Set current build tag as version_ansible_build_id"

                        #echo "$array_service_tag_from_files" | grep -q "version_ansible_build_id" && echo 0 || echo 1

                        version_ansible_build_id="$version_ansible_build_id"
                        new_tag=$version_ansible_build_id
                        return_tag=$version_ansible_build_id
                        echo "version_ansible_build_id: $version_ansible_build_id"
                        echo "new tag: ${new_tag[@]}"
                        echo "return_tag $return_tag"
                        published_commit=`echo $return_tag | cut -d - -f 2`
                        builded_commit=`git log --pretty=format:'%h' -n 1`
                        echo "published_commit: $published_commit"
                        echo "builded_commit: $builded_commit"
                        echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

                    fi

                else
                    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                    echo "Set parent stable tag as version_ansible_build_id"
                    version_ansible_build_id="$version_ansible_build_id"
                    new_tag=$return_tag
                    return_tag=$new_tag
                    echo "version_ansible_build_id: $version_ansible_build_id"
                    echo "new tag: ${new_tag[@]}"
                    echo "return_tag $return_tag"
                    published_commit=`echo $return_tag | cut -d - -f 2`
                    builded_commit=`git log --pretty=format:'%h' -n 1`
                    echo "published_commit: $published_commit"
                    echo "builded_commit: $builded_commit"
                    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
                    # version_ansible_build_id="$version_ansible_build_id"
                    # new_tag=$version_ansible_build_id
                    # echo "return_tag $return_tag"
                    # echo "new tag: ${new_tag[@]}"
                    # echo "version_ansible_build_id: $version_ansible_build_id"

                fi

            fi
        fi
