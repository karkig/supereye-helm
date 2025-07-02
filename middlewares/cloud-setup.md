
# Helm  Instructions


## 🧪 Helm

### Install
````bash
sudo su
sudo apt update
sudo apt install -y git
curl -sfL https://get.k3s.io | sh -
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# Set kubeconfig globally for all users
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' | sudo tee /etc/profile.d/k3s.sh
chmod +x /etc/profile.d/k3s.sh
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
source ~/.bashrc
echo 'k83 installed successfully'
cd /opt/
git clone https://github.com/karkig/supereye-helm.git
echo 'cloned successfully'
cd supereye-helm
helm install supereye-core supereye-core
helm install emqx emqx

echo 'helm installed successfully'

````

### uninstall
````bash

helm uninstall emqx
````


````bash

helm upgrade emqx ./emqx -f ./emqx/values.yaml
````


```bash

kubectl rollout restart deploy
```

```bash
 cd ..
 zip -r helm-manager.zip helm-manager
 mv helm-manager.zip /Users/Kailash.Karki/Desktop/helm-manager.zip
```
