#!/bin/bash

SCRIPT_NAME="services-internal"

. ./scripts/libsh/vault/main.sh
. ./scripts/libsh/head/clouds.sh all_services_internal

. ./scripts/libsh/deploy.sh
. ./scripts/libsh/deploy/head.sh
. ./scripts/libsh/deploy/req_help.sh

. ./scripts/libsh/vault_run.sh
. ./scripts/libsh/cloud_api_gen.sh

. ./scripts/libsh/system/install_main_backend.sh

. ./scripts/libsh/deploy/last_info.sh