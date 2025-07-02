sudo su
curl -sfL https://get.k3s.io | sh -
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
source ~/.bashrc
echo 'k83 installed successfully'
helm install supereye-core supereye-core
helm install emqx emqx
helm install alert-dashboard alert-dashboard
echo 'helm installed successfully'
