#!/bin/sh

# Store build time
#date > /etc/vagrant_box.build_time

# Set up sudo
echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant

# Install vagrant key and configure SSH
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

sed -i "/[# ]*UseDNS[ \t].*/d" /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/sshd_config

# NFS used for file syncing
#apt-get --yes install nfs-common

# Re-enable root user and set password to 'vagrant'
printf "vagrant\nvagrant\n" | passwd root
passwd -u root

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" | tee /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y docker-ce=17.06.1*
