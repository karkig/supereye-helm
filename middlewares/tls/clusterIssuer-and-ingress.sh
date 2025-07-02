#!/bin/bash
echo "Starting certification setup..."
kubectl delete certificate supereye-tls --ignore-not-found
kubectl delete challenge -A --selector=cert-manager.io/certificate-name=supereye-tls --ignore-not-found
kubectl delete ingress super-eye-ingress --ignore-not-found

helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl delete ClusterIssuer  letsencrypt-prod --ignore-not-found
kubectl apply -f cluster-issuer.yaml
sleep 2
kubectl get certificate -A
echo "Ingress Applied Installed "
