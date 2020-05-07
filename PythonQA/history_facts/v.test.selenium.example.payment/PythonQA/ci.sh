#!/bin/bash

pip3 install --no-cache-dir -r ./requirements.txt

ansible-playbook -i inventories/products/%ANSIBLE_PRODUCT%/%ANSIBLE_ENVIRONMENTY% ./playbook-library/!_test_suite/python_qa.yml 

python3 -m pytest -p no:cacheprovider