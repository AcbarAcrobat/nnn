#!/bin/bash

SCRIPT_NAME="services-builder"

. ./scripts/libsh/vault/main.sh
. ./scripts/libsh/head/clouds.sh all_services_deployer

. ./scripts/libsh/deploy.sh
. ./scripts/libsh/deploy/head.sh
. ./scripts/libsh/deploy/req_help.sh

. ./scripts/libsh/vault_run.sh
. ./scripts/libsh/cloud_api_gen.sh

if [ $cluster_type == 'swarm' ]; then
. ./scripts/libsh/deploy/playbooks_cluster_type/swarm.sh
fi

if [ $cluster_type == 'k8s' ]; then
. ./scripts/libsh/deploy/playbooks_cluster_type/k8s.sh
fi

if [ $cluster_type == 'none' ]; then
. ./scripts/libsh/deploy/playbooks_cluster_type/standalone.sh
fi

# . ./scripts/libsh/deploy/playbooks.sh
. ./scripts/libsh/deploy/last_info.sh