sudo su
sudo apt update
sudo apt install -y git
cd /opt/
git clone https://github.com/karkig/supereye-helm.git
cd supereye-helm
sh disk_attachment.sh
sh run.sh