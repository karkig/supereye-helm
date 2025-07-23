sudo su
sh disk_attachment.sh
curl -sfL https://get.k3s.io | sh -
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' | sudo tee /etc/profile.d/k3s.sh
chmod +x /etc/profile.d/k3s.sh
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sleep 5
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
#source ~/.bashrc
echo 'k83 installed successfully'
helm install supereye-core supereye-core
helm install emqx emqx
helm install alert-dashboard alert-dashboard
echo 'helm installed successfully'
source /etc/profile