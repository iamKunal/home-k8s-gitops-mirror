#!/usr/bin/env zsh

kubectl --context kind-"$(yq -r '.name' "$(dirname "$0")/../kind/cluster-config.yaml" )" get services --all-namespaces -o json | jq -r '.items[] | { name: .metadata.name, namespace: .metadata.namespace, ports: .spec.ports, ip: .status.loadBalancer?|.ingress[]?|.ip  }' | jq -s