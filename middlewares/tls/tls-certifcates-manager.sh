#!/bin/bash
echo "Starting certification setup..."
helm repo add jetstack https://charts.jetstack.io
helm repo update
sleep 5
helm uninstall cert-manager --namespace cert-manager -i gnore-not-found
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.14.3


kubectl get pods -n cert-manager

echo "--- Certificate manager Installed --- "
