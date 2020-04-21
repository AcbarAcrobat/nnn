#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

uname=`uname`

echo "         REQUIREMENTS HOST OS $uname"
echo "         DIR: $DIR"

if [ "${uname}" == "Darwin" ]; then
    echo "         OS TYPE: $uname"
    echo "         Installing brew..."
    yes '' |/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 2>&1
    brew update 2>&1
    
    pip install -r $DIR/requirements.yml 2>&1
    pip install --upgrade -r $DIR/requirements.yml 2>&1
    pip3 install -r $DIR/requirements.yml 2>&1
    pip3 install --upgrade -r $DIR/requirements.yml 2>&1

fi

if [ "${uname}" == "Linux" ]; then
    echo "         OS TYPE: $uname"
    echo "         Installing apt packages..."
    apt install software-properties-common -y -qq
    apt-repository ppa:ansible/ansible -y
    apt update -y -qq
    apt install ansible -y -qq
    apt install sshpass -y -qq
    apt install python-pip python3-pip -y -qq 2>&1
    pip --install upgrade pip 2>&1
    pip install -r $DIR/requirements.yml 2>&1
    pip install --upgrade -r $DIR/requirements.yml 2>&1
    pip3 install -r $DIR/requirements.yml 2>&1
    pip3 install --upgrade -r $DIR/requirements.yml 2>&1


    echo vm.overcommit_memory=1 >> /etc/sysctl.conf &>/dev/null
    echo vm.max_map_count=262144 >> /etc/sysctl.conf &>/dev/null
    sysctl -p /etc/sysctl.conf &>/dev/null
fi