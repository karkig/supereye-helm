#!/bin/bash
echo "Starting certification setup..."
kubectl delete certificaterequest supereye-tls-1 --ignore-not-found
kubectl delete certificate supereye-tls --ignore-not-found
kubectl delete secret supereye-tls --ignore-not-found
kubectl delete challenge -A --selector=cert-manager.io/certificate-name=supereye-tls --ignore-not-found
kubectl delete ingress super-eye-ingress --ignore-not-found
sleep 2
kubectl apply -f ingress.yaml
echo "Ingress Applied Installed "
