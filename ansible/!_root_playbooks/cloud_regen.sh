#!/bin/bash

# Script for regeniration the dynamic inventory in production

inventory=$1
product=$2
typeofcloud=$3
connect_type=$4

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
echo -e "         ${GREEN}Start regeneration${NC} cloud inventory: ${RED}${inventory}${NC}";
echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

if [ "$1" = "" ]
then

  echo "Usage: $0 inventory is must to be a specified"
  exit

fi

if [ "$2" = "" ]
then

  echo "Usage: $0 product is must to be a specified"
  exit

fi

if [ "$3" = "" ]
then

  echo "Usage: $0 type of install is must to be a specified: vsphere / alicloud / bare"
  exit

fi

if [ "$4" = "" ]
then

  echo "Usage: $0 type of connection is must to be a specified: private / public / green / blue / rollback"
  exit

fi

if [ $4 == 'private' ]; then
    connection_type="private"
else 
    if [ $4 == 'public' ]; then
        connection_type="public"
    else 
        if [ $4 == 'green' ]; then
            connection_type="green"
        else
            connection_type="none"
            echo -e "         Wrong type of connection, you must to be select one possible from a types - private / public / green / blue / rollback "
        fi

    fi
fi

if [ "$inventory" != "production" ] && [ "$inventory" != "alpha" ] && [ "$inventory" != "beta" ]; then

    before_inventory_parent=`ls -la ./inventories/0z-cloud/products/types/!_${typeofcloud}/$product/$inventory/v.py | awk '{print $NF}' | sed 's/\/r.py//' | sed 's/..\///'`

    echo "before_inventory_parent: $before_inventory_parent"

    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    echo -e "         ${GREEN}Detected ${NC}cloud inventory: ${RED}NON PRODUCTION INVENTORY ${NC}";
    echo -e "         ${GREEN}Before ${NC}cloud inventory: ${RED}${before_inventory_parent}${NC}";
    echo -e "         ${GREEN}Current ${NC}cloud inventory: ${RED}${inventory}${NC}";



    rm -rf ./inventories/products/$product/$inventory/inventory

    ./inventories/0z-cloud/products/types/!_${typeofcloud}/$product/$inventory/v.py --connection_type $connection_type >> ./inventories/products/$product/$inventory/inventory
    sed "s/$before_inventory_parent/$inventory/g" ./inventories/products/${product}/${inventory}/inventory >> ./inventories/products/${product}/${inventory}/inventory.new
    mv ./inventories/products/${product}/${inventory}/inventory.new ./inventories/products/${product}/${inventory}/inventory

    echo -e "         ${GREEN}Converting ${NC}cloud inventory: ${RED}DONE ${NC}";
    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

else

    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"
    echo -e "         ${GREEN}Detected ${NC}cloud inventory: ${RED}PRODUCTION INVENTORY ${NC}";
    echo -e "         ${GREEN}Current ${NC}cloud inventory: ${RED}${inventory}${NC}";

    rm -rf ./inventories/products/$product/$inventory/inventory
    ./inventories/0z-cloud/products/types/!_${typeofcloud}/$product/$inventory/v.py --connection_type ${connection_type} >> ./inventories/products/$product/$inventory/inventory
    
    echo "./inventories/0z-cloud/products/types/\!_${typeofcloud}/$product/$inventory/${connection_type} --connection_type >> ./inventories/products/$product/$inventory/inventory"

    echo -e "     ${GREEN}|>.......................................................................................................................................................<|${NC}"

fi