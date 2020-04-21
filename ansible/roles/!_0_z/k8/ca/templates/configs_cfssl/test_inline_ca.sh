{% raw %}#!/bin/bash

rm -rf {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca
rm -rf {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca
rm -rf {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca
rm -rf {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca

mkdir {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca
cd {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca
cat << EOF > {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca-config.json
{
    "signing": {
        "profiles": {
            "intermediate": {
                "usages": [
                    "signature",
                    "digital-signature",
                    "cert sign",
                    "crl sign"
                ],
                "expiry": "26280h",
                "ca_constraint": {
                    "is_ca": true,
                    "max_path_len": 0,
                    "max_path_len_zero": true
                }
            }
        }
    }
}
EOF
cat << EOF > {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca-csr.json
{
    "CN": "my-root-ca",
    "hosts": [
      "ubuntu",
      "{% endraw %}{{ K8S_CLUSTER_ADDRESS }}{% raw %}",
      "{% endraw %}{{ CALICO_ETCD_CLUSTER_IP }}{% raw %}",
      "vortex",
      "kubernetes",
      "{% endraw %}{{ public_consul_domain }}{% raw %}",
      "vortex.{% endraw %}{{ public_consul_domain }}{% raw %}",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local",
      {% endraw %}{% for host in groups['kubernetes-master'] %}{% raw %}
      "{% endraw %}{{ hostvars[host]['ansible_nodename'] }}{% raw %}",
      "{% endraw %}{{ hostvars[host]['second_ip'] }}{% raw %}",
      "{% endraw %}{{ hostvars[host]['ansible_default_ipv4']['address'] }}{% raw %}"{% endraw %}{% if not loop.last %}{% raw %},
      {% endraw %}{% endif %}{% endfor %}{% raw %}
    ],
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "87600h"
    }
}
EOF
cfssl genkey -initca {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca-csr.json | cfssljson -bare {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/ca
cd ..
mkdir {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca
cd {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca
cat << EOF > {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca-csr.json
{
    "CN": "kubernetes-ca",
    "hosts": [
      "ubuntu",
      "{% endraw %}{{ K8S_CLUSTER_ADDRESS }}{% raw %}",
      "{% endraw %}{{ CALICO_ETCD_CLUSTER_IP }}{% raw %}",
      "vortex",
      "kubernetes",
      "{% endraw %}{{ public_consul_domain }}{% raw %}",
      "vortex.{% endraw %}{{ public_consul_domain }}{% raw %}",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local",
      {% endraw %}{% for host in groups['kubernetes-master'] %}{% raw %}
      "{% endraw %}{{ hostvars[host]['ansible_nodename'] }}{% raw %}",
      "{% endraw %}{{ hostvars[host]['second_ip'] }}{% raw %}",
      "{% endraw %}{{ hostvars[host]['ansible_default_ipv4']['address'] }}{% raw %}"{% endraw %}{% if not loop.last %}{% raw %},
      {% endraw %}{% endif %}{% endfor %}{% raw %}
    ],
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "26280h"
    }
}
EOF
cfssl genkey -initca {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca-csr.json | cfssljson -bare {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca
cfssl sign -ca {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/ca.pem -ca-key {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/ca-key.pem -config {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/root-ca-config.json -profile intermediate {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca.csr | cfssljson -bare {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca
cfssl print-defaults config {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-ca-config.json
cd ..
mkdir {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca
cd {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca
cat << EOF > {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca-csr.json
{
    "CN": "kubernetes-front-proxy-ca",
    "hosts": [
      "ubuntu",
      "{% endraw %}{{ K8S_CLUSTER_ADDRESS }}{% raw %}",
      "{% endraw %}{{ CALICO_ETCD_CLUSTER_IP }}{% raw %}",
      "vortex",
      "kubernetes",
      "{% endraw %}{{ public_consul_domain }}{% raw %}",
      "vortex.{% endraw %}{{ public_consul_domain }}{% raw %}",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local",
      {% endraw %}{% for host in groups['kubernetes-master'] %}{% raw %}
      "{% endraw %}{{ hostvars[host]['ansible_nodename'] }}{% raw %}",
      "{% endraw %}{{ hostvars[host]['second_ip'] }}{% raw %}",
      "{% endraw %}{{ hostvars[host]['ansible_default_ipv4']['address'] }}{% raw %}"{% endraw %}{% if not loop.last %}{% raw %},
      {% endraw %}{% endif %}{% endfor %}{% raw %}
    ],
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "26280h"
    }
}
EOF
cfssl genkey -initca {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca-csr.json | cfssljson -bare {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca
cfssl sign -ca {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/ca.pem -ca-key {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/ca-key.pem -config {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/root-ca-config.json -profile intermediate {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca.csr | cfssljson -bare {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca
cfssl print-defaults config {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/kubernetes-front-proxy-ca-config.json
cd ..

mkdir {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca
cd {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca
cat << EOF > {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca-config.json
{
    "signing": {
        "profiles": {
            "server": {
                "expiry": "8700h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "8700h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "8700h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF
cat << EOF > {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca-csr.json
{
    "CN": "etcd-ca",
    "hosts": [
      "ubuntu",
      "{% endraw %}{{ K8S_CLUSTER_ADDRESS }}{% raw %}",
      "{% endraw %}{{ CALICO_ETCD_CLUSTER_IP }}{% raw %}",
      "vortex",
      "kubernetes",
      "{% endraw %}{{ public_consul_domain }}{% raw %}",
      "vortex.{% endraw %}{{ public_consul_domain }}{% raw %}",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local",
      {% endraw %}{% for host in groups['kubernetes-master'] %}{% raw %}
      "{% endraw %}{{ hostvars[host]['ansible_nodename'] }}{% raw %}",
      "{% endraw %}{{ hostvars[host]['second_ip'] }}{% raw %}",
      "{% endraw %}{{ hostvars[host]['ansible_default_ipv4']['address'] }}{% raw %}"{% endraw %}{% if not loop.last %}{% raw %},
      {% endraw %}{% endif %}{% endfor %}{% raw %}
    ],
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "26280h"
    }
}
EOF
cfssl genkey -initca {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca-csr.json | cfssljson -bare {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca
cfssl sign -ca {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/ca.pem -ca-key {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/ca-key.pem -config {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/root-ca/root-ca-config.json -profile intermediate {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca.csr | cfssljson -bare {% endraw %}{{ ca_service_settings.directories.pki }}{% raw %}/etcd-ca
cd ..
{% endraw %}