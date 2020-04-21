#!/bin/bash
rm $LOCAL_DIRECTORY/current_tags.yml

for item in ${array_of_applications[@]}; do

    build_and_validate $item "services"

done

for item in ${array_of_services[@]}; do

    build_and_validate $item "dockerfiles"

done

for item in ${array_of_docs[@]}; do

    build_and_validate $item "docs" "-docs"

done

echo "cat ${LOCAL_DIRECTORY}/current_tags.yml"

cat "$LOCAL_DIRECTORY/current_tags.yml"

