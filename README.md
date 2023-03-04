# Home K8s Gitops

[![Helm Lint](../../actions/workflows/helm-lint.yaml/badge.svg)](../../actions/workflows/helm-lint.yaml)

## Creating the kind cluster

1. Modify [`cluster-setup/kind/cluster-config.yaml`](cluster-setup/kind/cluster-config.yaml) to suit your needs. Especially the extraMounts.
2. Run the following to have the cluster up and running
 ```shell
kind create cluster --config cluster-setup/kind/cluster-config.yaml
```

## Setting up for first time:

### Setting up secrets

Create account on `Doppler`, and get a service token.

Store secrets `ES_DOPPLER_SECRET_TOKEN`, `ARGO_GITHUB_USERNAME` and `ARGO_GITHUB_PASSWORD` in the same env as the service token.

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