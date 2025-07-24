#!/bin/bash

DISK_NAME="elasticsearch-disk"
DEVICE_PATH="/dev/disk/by-id/google-${DISK_NAME}"
MOUNT_PATH="/mnt/elasticsearch-data"
ZONE="us-central1-a"

echo "Attaching persistent disk..."
gcloud compute instances attach-disk $(hostname) \
  --disk=${DISK_NAME} \
  --device-name=$DISK_NAME \
  --zone=${ZONE} \
  --quiet || echo "Disk might already be attached."

echo "Waiting for device to be ready..."
while [ ! -e $DEVICE_PATH ]; do
  sleep 2
done

# Format the disk only if not already formatted
if ! blkid $DEVICE_PATH; then
  echo "Formatting disk..."
  mkfs.ext4 -F $DEVICE_PATH
fi

mkdir -p $MOUNT_PATH

# Add to /etc/fstab using UUID
UUID=$(blkid -s UUID -o value $DEVICE_PATH)
grep -q "$UUID" /etc/fstab || echo "UUID=$UUID $MOUNT_PATH ext4 discard,defaults,nofail 0 2" >> /etc/fstab
sudo systemctl daemon-reload
mount -a
chmod 777 $MOUNT_PATH
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

