#!/bin/bash

# Name of the Google Cloud persistent disk to attach
DISK_NAME="elasticsearch-disk"

# Path to the disk device (Google Cloud creates symlinks under /dev/disk/by-id)
DEVICE_PATH="/dev/disk/by-id/google-${DISK_NAME}"

# Directory where the disk will be mounted
MOUNT_PATH="/mnt/elasticsearch-data"

# Zone where your VM instance and disk are located
ZONE="us-central1-a"

# Step 1: Attach the persistent disk to the current instance
echo "Attaching persistent disk..."
gcloud compute instances attach-disk $(hostname) \
  --disk=${DISK_NAME} \
  --device-name=$DISK_NAME \
  --zone=${ZONE} \
  --quiet || echo "Disk might already be attached."

# Step 2: Wait until the device path becomes available
echo "Waiting for device to be ready..."
while [ ! -e $DEVICE_PATH ]; do
  sleep 2
done

# Step 3: Check if the disk is already formatted
# If not, format the disk with the ext4 filesystem
if ! blkid $DEVICE_PATH; then
  echo "Formatting disk..."
  mkfs.ext4 -F $DEVICE_PATH
fi

# Step 4: Create the mount point directory if it doesn't exist
mkdir -p $MOUNT_PATH

# Step 5: Get the UUID of the disk for persistent mounting in /etc/fstab
UUID=$(blkid -s UUID -o value $DEVICE_PATH)

# Add an entry to /etc/fstab only if it doesn't already exist
grep -q "$UUID" /etc/fstab || echo "UUID=$UUID $MOUNT_PATH ext4 discard,defaults,nofail 0 2" >> /etc/fstab

# Reload systemd daemon in case any mount changes were made
sudo systemctl daemon-reload

# Step 6: Mount all filesystems as per /etc/fstab
mount -a

# Set full permissions on the mount path (for Elasticsearch to write data)
chmod 777 $MOUNT_PATH

# Step 7: Increase vm.max_map_count (required by Elasticsearch for mmap operations)
sudo sysctl -w vm.max_map_count=262144

# Make the vm.max_map_count setting permanent by adding it to sysctl.conf
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# Reload sysctl settings
sudo sysctl -p
