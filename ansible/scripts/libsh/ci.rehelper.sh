#!/usr/bin/env bash


function check_for_changes(){

    set -e

    # populate logic_folders
    logic_folders=()
    script=()
    populate_folders="yes"

    for arg in "$@"
    do
        if [ $arg = "--script" ]; then
            populate_folders=""
            continue;
        fi

        if [ $populate_folders ]; then
            logic_folders+=($arg)
        else
            script+=($arg)
        fi
    done

    commit=$(diff --old-line-format='' --new-line-format='' <(git rev-list --first-parent develop) <(git rev-list --first-parent HEAD) | head -1)
    branch=$(git rev-parse --abbrev-ref HEAD)
    should_run_script=0

    if [ $branch = "develop-qa" ]; then
        echo "Will NOT run script because current branch is develop"
        should_run_script=0
    elif [ $branch = "master" ]; then
        echo "Will NOT run script because current branch is master"
        should_run_script=0
    else
        for folder in ${logic_folders[@]}; do
            echo "Check for changes in $folder"
            changes=$(git diff --relative=$folder $commit --quiet --; echo $?)

            if [ $changes = 1 ]; then
                should_run_script=1
                echo "There are changes in $folder"
            else
                echo "No changes in $folder"
            fi
        done
    fi

    

    if [ $should_run_script = 1 ]; then
        echo "${script[@]}"
        ${script[@]}
    fi

}