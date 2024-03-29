#!/bin/bash

rm /etc/apt/sources.list


cat > /etc/apt/sources.list <<EOF
# ubuntu default repos
deb [arch=amd64] http://vortex-repo-01.vortex.co/security_ubuntu bionic-security main restricted
deb [arch=amd64] http://vortex-repo-01.vortex.co/security_ubuntu bionic-security universe
deb [arch=amd64] http://vortex-repo-01.vortex.co/security_ubuntu bionic-security multiverse

deb [arch=amd64] http://vortex-repo-01.vortex.co/us_archive_ubuntu_com/ bionic main restricted
deb [arch=amd64] http://vortex-repo-01.vortex.co/us_archive_ubuntu_com/ bionic-updates main restricted
deb [arch=amd64] http://vortex-repo-01.vortex.co/us_archive_ubuntu_com/ bionic universe
deb [arch=amd64] http://vortex-repo-01.vortex.co/us_archive_ubuntu_com/ bionic-updates universe
deb [arch=amd64] http://vortex-repo-01.vortex.co/us_archive_ubuntu_com/ bionic multiverse
deb [arch=amd64] http://vortex-repo-01.vortex.co/us_archive_ubuntu_com/ bionic-updates multiverse
deb [arch=amd64] http://vortex-repo-01.vortex.co/us_archive_ubuntu_com/ bionic-backports main restricted universe multiverse

# rabbitmq
deb [arch=amd64] http://vortex-repo-01.vortex.co/rabbitmq_local artful main

# pritunl
deb [arch=amd64] http://vortex-repo-01.vortex.co/pritunl_local bionic main

# percona
deb [arch=amd64] http://vortex-repo-01.vortex.co/percona_local bionic main
deb-src [arch=amd64] http://vortex-repo-01.vortex.co/percona_local bionic main

# php
deb [arch=amd64] http://vortex-repo-01.vortex.co/ondrej_php_local bionic main

# apache2
deb [arch=amd64] http://vortex-repo-01.vortex.co/ondrej_apache2_local bionic main

# mongodb
deb [arch=amd64] http://vortex-repo-01.vortex.co/mongodb_local xenial/mongodb-org/3.6 multiverse

# java
deb [arch=amd64] http://vortex-repo-01.vortex.co/java_local bionic main

# docker
deb [arch=amd64] http://vortex-repo-01.vortex.co/docker_local/ bionic stable

# ossec
deb [arch=amd64] http://vortex-repo-01.vortex.co/ossec_local/ bionic main

# REDIS IO
deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu bionic main
deb-src http://ppa.launchpad.net/chris-lea/redis-server/ubuntu bionic main

# TRYSTY
deb [arch=amd64] http://vortex-repo-01.vortex.co/ru_archive_ubuntu_com/ trusty main restricted

EOF