#!/bin/bash
echo "Cleaning old ingress-nginx..."

kubectl delete deployment -n ingress-nginx --i gnore-not-found
kubectl delete ns ingress-nginx --i gnore-not-found
kubectl delete clusterrole ingress-nginx --i gnore-not-found
echo "deleting in progress..."

kubectl delete clusterrolebinding ingress-nginx --i gnore-not-found
kubectl delete ingressclass nginx --i gnore-not-found
kubectl delete validatingwebhookconfiguration ingress-nginx-admission --i gnore-not-found

echo "Waiting for cleanup..."
sleep 2

echo "Installing fresh ingress-nginx via Helm..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
echo "update done "

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=NodePort \
  --set controller.service.nodePorts.http=30080 \
  --set controller.service.nodePorts.https=30443
echo "Ingress controller Installed "

