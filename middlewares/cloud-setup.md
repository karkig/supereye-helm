
# Helm  Instructions


## 🧪 Helm

### Install
````bash
sudo apt update
sudo apt install -y git
curl -sfL https://get.k3s.io | sh -
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
source ~/.bashrc
git clone https://github.com/karkig/supereye-helm.git
cd cd supereye-helm/supereye-core
helm install supereye-core supereye-core

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
