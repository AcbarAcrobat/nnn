#!/bin/bash
# elastic Docker Copyright (C) 2019 elastic Inc. (License GPLv2)

set -e

# Files created by elasticsearch should always be group writable too
umask 0002

run_as_other_user_if_needed() {
  if [[ "$(id -u)" == "0" ]]; then
    # If running as root, drop to specified UID and run command
    exec chroot --userspec=1000 / "${@}"
  else
    # Either we are running in Openshift with random uid and are a member of the root group
    # or with a custom --user
    exec "${@}"
  fi
}

#Disabling xpack features

elasticsearch_config_file="/usr/share/elasticsearch/config/elasticsearch.yml"

# Execute elasticsearch

run_as_other_user_if_needed /usr/share/elasticsearch/bin/elasticsearch 