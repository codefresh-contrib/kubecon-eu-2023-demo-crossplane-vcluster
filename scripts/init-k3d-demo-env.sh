#!/bin/bash
MYDIR=$(dirname $0)
k3d cluster delete cf-kubecon23-demo
k3d cluster create cf-kubecon23-demo
k3d kubeconfig get cf-kubecon23-demo > /tmp/k3d-cf-kubecon23-demo.config
export KUBECONFIG=/tmp/k3d-cf-kubecon23-demo.config
helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
# https://github.com/cf-kubecon23-demo/cf-kubecon23-demo/issues/2121
helm install --repo https://argoproj.github.io/argo-helm --create-namespace --namespace argocd argocd argo-cd --version 5.21.0  --set "configs.cm.application\.resourceTrackingMethod=annotation" --wait
kubectl -n argocd apply -f $MYDIR/../argocd-applications