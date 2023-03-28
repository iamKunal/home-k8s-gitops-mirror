#!/usr/bin/env zsh

#cluster_name=kind-"$(yq -r '.name' "$(dirname "$0")/../kind/cluster-config.yaml" )"
cluster_name=k3d-"$(yq -r '.metadata.name' "$(dirname "$0")/../k3d/cluster-config.yaml" )"

kubectl --context "$cluster_name" get services --all-namespaces -o json | jq -r '.items[] | { name: .metadata.name, namespace: .metadata.namespace, ports: .spec.ports, ip: .status.loadBalancer?|.ingress[]?|.ip  }' | jq -s