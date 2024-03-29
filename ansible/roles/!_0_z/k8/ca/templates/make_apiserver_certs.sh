#!/bin/bash

usage() {
	echo "make_apiserver_certs: helper script to generate certificates for apiservers"
	echo
	echo "usage: make_apiserver_certs [options] <host-ip> [host-ip...]"
	echo "--dns-name: External DNS name to include in the certificate. Can be specified multiple times"
	echo "--cluster-domain: Cluster Domain configured for kubernetes. Defaults to 'cluster.local'"
	echo "--cluster-ip: Cluster IP address for kubernetes service. Defaults to 10.96.0.1"
}

dns_names_new=({% for host in groups['kubernetes-master'] %}{{ hostvars[host]['ansible_nodename'] }} {% endfor %} ca.{{ public_consul_domain }} vortex.{{ public_consul_domain }} kubernetes.{{ public_consul_domain }} kubernetes.default kube-apiserver )

# for dns_host in ${dns_names[@]}; do
#    echo "dns_host ${dns_host}"
# done

cluster_domain={{ public_consul_domain }}
cluster_ip={{ k8s_primary_vip_gateway }}

while [[ $1 == -* ]]; do
	if [[ $1 == -*=* ]]; then
		set -- "${1%%=*}" "${1#*=}" "${@:2}"
	fi
	case "$1" in
	--dns-name)
		#dns_names+=( "$2" )
		dns_names=${dns_names_new[@]}
		shift 2
		;;
	--cluster-domain)
		cluster_domain="$2"
		shift 2
		;;
	--cluster-ip)
		cluster_ip="$2"
		;;
	*)
		echo "Unknown option '$1'"
		usage
		exit 1
		;;
	esac
done

if ! (( $# )); then
	echo "No host ips provided"
	usage
	exit 1
fi

expected_files=( {{ ca_service_settings.directories.pki }}/ca.pem {{ ca_service_settings.directories.pki }}/ca-key.pem {{ ca_service_settings.directories.config }}/ca-config.json )
for f in "${expected_files[@]}"; do
	missing=0
	if ! [[ -f "${f}" ]]; then
		echo "Expected $f, not found"
		missing=1
	fi
	if (( missing )); then
		echo "Generate the missing files or copy them to the expected location"
		exit 1
	fi
done

for ip in "$@"; do
	if [[ -f "apiserver:$ip.pem" ]]; then
		echo "certificate already generated for $ip"
		continue
	fi
	san_hosts="kubernetes,kubernetes.default,kubernetes.default.svc"
	if [[ "$cluster_domain" ]]; then
		san_hosts+=",kubernetes.default.svc.$cluster_domain"
	fi
	for dns_name in "${dns_names[@]}"; do
		san_hosts+=",$dns_name"
	done
	san_hosts+=",$ip"
	if [[ "$cluster_ip" ]]; then 
		san_hosts+=",$cluster_ip"
	fi
	echo '{ "CN": "kube-apiserver" }' | cfssl gencert -ca={{ ca_service_settings.directories.pki }}/ca.pem -ca-key={{ ca_service_settings.directories.pki }}/ca-key.pem -config={{ ca_service_settings.directories.config }}/ca-config.json -hostname="$san_hosts" -profile server - | cfssljson -bare {{ ca_service_settings.directories.pki }}/"apiserver_$ip"
	# rm "apiserver:$ip.csr"
done