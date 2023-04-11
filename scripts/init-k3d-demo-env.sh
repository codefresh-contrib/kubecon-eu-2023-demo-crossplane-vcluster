#!/bin/bash
MYDIR=$(dirname $0)
k3d cluster delete crossplane
k3d cluster create crossplane
k3d kubeconfig get crossplane > /tmp/k3s-crossplane.config
export KUBECONFIG=/tmp/k3s-crossplane.config
helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
# https://github.com/crossplane/crossplane/issues/2121
helm install --repo https://argoproj.github.io/argo-helm --create-namespace --namespace argocd argocd argo-cd --version 5.21.0  --set "configs.cm.application\.resourceTrackingMethod=annotation" --wait
kubectl -n argocd apply -f $MYDIR/../argocd-applications