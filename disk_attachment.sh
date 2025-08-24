#!/bin/bash

# Enable error handling
set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Ensure pipeline errors are caught

# Log file
LOG_FILE="/var/log/elasticsearch-disk-setup.log"

# Redirect stdout and stderr to log file
exec > >(tee -a "$LOG_FILE") 2>&1

DISK_NAME="elasticsearch-disk"
DEVICE_PATH="/dev/disk/by-id/google-${DISK_NAME}"
MOUNT_PATH="/mnt/elasticsearch-data"
ZONE="us-central1-a"

echo "[$(date)] Starting disk de-attachemnt script..."

# Function for error handling
error_exit() {
    echo "[$(date)] ERROR: $1"
    exit 1
}
# Get the instance URL using gcloud
INSTANCE_URL=$(gcloud compute disks describe "$DISK_NAME" \
  --zone="$ZONE" \
  --format="value(users)")
# Extract the instance name from the URL (last part after '/')
OLD_INSTANCE_NAME=$(basename "$INSTANCE_URL")

# Check if the disk is attached to an old instance
if [ -n "$OLD_INSTANCE_NAME" ]; then
  echo "Disk is attached to: $OLD_INSTANCE_NAME. Detaching..."
  gcloud compute instances detach-disk "$OLD_INSTANCE_NAME" \
    --disk="$DISK_NAME" \
    --zone="$ZONE" \
    --quiet || error_exit "Failed to de attach dist  ${DISK_NAME} from instant  ${OLD_INSTANCE_NAME}"
else
  echo "Disk is not attached to any instance."
fi
 sleep 10
# Step 2: Wait until disk is detached (users field is empty)
echo "Waiting for disk to be fully detached..."
while true; do
  USERS=$(gcloud compute disks describe "$DISK_NAME" \
    --zone="$ZONE" \
    --format="value(users)")

  if [ -z "$USERS" ]; then
    echo "Disk successfully detached."
    break
  fi

  echo "Disk still in use. Waiting 5 seconds..."
  sleep 3
done

echo "[$(date)] Attaching persistent disk..."
gcloud compute instances attach-disk "$(hostname)" \
  --disk="${DISK_NAME}" \
  --device-name="$DISK_NAME" \
  --zone="${ZONE}" \
  --quiet || error_exit "Failed to attach disk ${DISK_NAME}"

echo "[$(date)] Waiting for device to be ready..."
while [ ! -e "$DEVICE_PATH" ]; do
  sleep 20
done

# Format the disk only if not already formatted
if ! blkid "$DEVICE_PATH"; then
  echo "[$(date)] Formatting disk..."
  mkfs.ext4 -F "$DEVICE_PATH" || error_exit "Failed to format disk ${DEVICE_PATH}"
fi

mkdir -p "$MOUNT_PATH" || error_exit "Failed to create mount directory"

# Add to /etc/fstab using UUID
UUID=$(blkid -s UUID -o value "$DEVICE_PATH") || error_exit "Failed to get UUID of ${DEVICE_PATH}"

grep -q "$UUID" /etc/fstab || echo "UUID=$UUID $MOUNT_PATH ext4 discard,defaults,nofail 0 2" >> /etc/fstab

sudo systemctl daemon-reload || error_exit "Failed to reload systemd daemon"
mount -a || error_exit "Failed to mount filesystem"
chmod 777 "$MOUNT_PATH" || error_exit "Failed to set permissions on ${MOUNT_PATH}"

sudo sysctl -w vm.max_map_count=262144 || error_exit "Failed to set vm.max_map_count"
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf || error_exit "Failed to update sysctl.conf"
sudo sysctl -p || error_exit "Failed to reload sysctl settings"

echo "[$(date)] Disk setup completed successfully!"
