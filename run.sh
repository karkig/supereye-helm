sudo su

# Attach disk (your custom script)
sh disk_attachment.sh

# Install K3s
curl -sfL https://get.k3s.io | sh -

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Set KUBECONFIG for root user permanently
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' | tee -a /root/.bashrc

# Apply changes in current shell
source /root/.bashrc

# Optional: also set it for current session explicitly
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

sleep 5

# If you also want for normal user (not just root), uncomment below:
# echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc

# Helm installations
helm install supereye-core supereye-core
helm install emqx emqx
helm install elasticsearch elasticsearch
helm install alert-dashboard alert-dashboard

echo 'Helm installed successfully'
