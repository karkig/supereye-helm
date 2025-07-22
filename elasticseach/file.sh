lsblk
sudo mkfs.ext4 -F /dev/sdb
sudo mkdir -p /mnt/elasticsearch-data
sudo mount /dev/sdb /mnt/elasticsearch-data
sudo chmod 777 /mnt/elasticsearch-data
sudo blkid /dev/sdb

echo 'UUID=abc123... /mnt/elasticsearch-data ext4 discard,defaults,nofail 0 2' | sudo tee -a /etc/fstab
