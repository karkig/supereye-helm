#!/bin/bash
set -euo pipefail  # Exit on error, undefined variable, or pipeline failure
LOG_FILE="/var/log/setup_script.log"

# Redirect stdout and stderr to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Trap function for errors
trap 'echo "[ERROR] Command failed at line $LINENO. Exit status: $?"; exit 1' ERR

echo "[INFO] Starting setup process..."

# Switch to root user
echo "[INFO] Switching to root user..."

# Attach disk using custom script
echo "[INFO] Attaching disk..."
#bash disk_attachment.sh || { echo "[ERROR] Disk attachment failed"; exit 1; }
sleep 10
# Install K3s
echo "[INFO] Installing K3s..."
curl -sfL https://get.k3s.io | bash - || { echo "[ERROR] Failed to install K3s"; exit 1; }

# Install Helm
echo "[INFO] Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash || { echo "[ERROR] Failed to install Helm"; exit 1; }

# Set KUBECONFIG for root user permanently
echo "[INFO] Setting KUBECONFIG for root..."
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' | tee -a /root/.bashrc || { echo "[ERROR] Failed to update root .bashrc"; exit 1; }

# Apply changes in current shell
echo "[INFO] Applying bashrc changes..."
source /root/.bashrc || { echo "[ERROR] Failed to source .bashrc"; exit 1; }

# Set KUBECONFIG explicitly for current session
echo "[INFO] Exporting KUBECONFIG for current session..."
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml || { echo "[ERROR] Failed to export KUBECONFIG"; exit 1; }

sleep 5

# Helm installations
echo "[INFO] Installing Helm charts..."
helm install supereye-core supereye-core || { echo "[ERROR] Helm install for supereye-core failed"; exit 1; }
helm install emqx emqx || { echo "[ERROR] Helm install for emqx failed"; exit 1; }
helm install elasticsearch elasticsearch || { echo "[ERROR] Helm install for elasticsearch failed"; exit 1; }
helm install alert-dashboard alert-dashboard || { echo "[ERROR] Helm install for alert-dashboard failed"; exit 1; }
source /root/.bashrc
echo "[INFO] Helm installed successfully"
