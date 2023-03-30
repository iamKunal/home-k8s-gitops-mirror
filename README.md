# Home K8s Gitops

[![Helm Lint](../../actions/workflows/helm-lint.yaml/badge.svg)](../../actions/workflows/helm-lint.yaml) [![Mirror to Public Repo](../../actions/workflows/public-mirror.yaml/badge.svg)](../../actions/workflows/public-mirror.yaml)
## Creating the k3d cluser

1. Modify [`cluster-setup/k3d/cluster-config.yaml`](cluster-setup/k3d/cluster-config.yaml) to suit your needs. Especially the extraMounts.
2. Run the following to have the cluster up and running
 ```shell
k3d cluster create --config cluster-setup/k3d/cluster-config.yaml
```

## Setting up for first time:

### Setting up secrets

Create account on `Doppler`, and get a service token.

Store secrets the following secrets in the same env for which the service token was created:
- `ARGO_GITHUB_PASSWORD` - GitHub username
- `ARGO_GITHUB_USERNAME` - GitHub Token with Read access to the repo
- `ARGO_UI_ADMIN_PASSWORD` - Admin UI Password for Argo.
- `ES_DOPPLER_SECRET_TOKEN` - The service token just created. Should help with bootstrapping Doppler

To get all secrets that are to be configured run:
```shell
find apps/ -name config.json -exec $SHELL -c 'helm dependency update $(dirname {}) >/dev/null && helm template $(dirname {})' \; | yq -N 'select(.kind == "ExternalSecret") | .spec.data[].remoteRef.key' | sort | uniq
```


Create a copy of [`apps/external-secrets/templates/doppler-token-sample.yaml`](apps/external-secrets/templates/doppler-token-sample.yaml) to `apps/external-secrets/templates/doppler-token.yaml` and add in the doppler service token for configuring external secrets.

Once everything is up and running and ArgoCD syncs, the doppler token should be refreshed from Doppler itself.

### Starting up ArgoCD

Run the following to install crds first and then the remaining parts for basic setup:
```shell
helmfile template -f cluster-setup/first-run/ --environment with-crds --include-crds | yq '. | select (.kind == "CustomResourceDefinition" and .spec.group != "projectcontour.io")' | kubectl apply -f - && \
helmfile apply -f cluster-setup/first-run/
```

ArgoCD should then pick up all the apps from the repo automatically.

For any new changes, just make changes to repository and argo should pick them up.

## Setting up TCP Forwarding for non-http services

Contour's `HTTPProxy` does not support TCP services (and for ports other than `80`/`443`).

For that, MetalLb's `LoadBalancer` is utilized.

Required dependency is `gomplate`, can be installed via `brew`

To generate `nginx.conf` for TCP Forwarding via nginx, and start it as a TCP Proxy for LoadBalancers for the cluster, run the following at the root of the repo:
```shell
./startTcpForwarding.sh
```
