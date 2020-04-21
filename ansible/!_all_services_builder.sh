#!/bin/bash

SCRIPT_NAME="services-builder"

. ./scripts/libsh/vault/main.sh
. ./scripts/libsh/head/clouds.sh all_services_builder

. ./scripts/libsh/deploy.sh
. ./scripts/libsh/deploy/head.sh
. ./scripts/libsh/deploy/req_help.sh

. ./scripts/libsh/vault_run.sh
. ./scripts/libsh/cloud_api_gen.sh

. ./scripts/libsh/deploy/prepare_ci.sh

. ./scripts/libsh/deploy/docker_build.sh