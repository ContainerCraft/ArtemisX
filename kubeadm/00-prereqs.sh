#!/bin/bash -ex
GHUSER="usrbinkat"
LOCAL_USER="usrbinkat"
LOCAL_HOSTNAME="qotom"
LOCAL_HOME="${HOME}"

run () {

 #start_qemu_guest_agent
  sshd_setup
  dependencies_fedora
  dependencies_core

}

start_qemu_guest_agent () {

  sudo dnf update -y
  sudo dnf install -y qemu-guest-agent
  sudo systemctl enable --now qemu-guest-agent

}

sshd_setup () {
PUBKEYS="$(curl -L https://github.com/${GHUSER}.keys)"

  sudo dnf update -y
  sudo dnf install -y openssh-server
  sudo sed -i 's/^#PermitRootLogin\ prohibit-password/PermitRootLogin\ prohibit-password/g' /etc/ssh/sshd_config
  sudo systemctl enable --now sshd

  sudo mkdir -p  /root/.ssh                     /home/${LOCAL_USER}/.ssh 
  sudo touch     /root/.ssh/authorized_keys     ${LOCAL_HOME}/.ssh/authorized_keys
  sudo chmod 600 /root/.ssh/authorized_keys     ${LOCAL_HOME}/.ssh/authorized_keys

  sudo rm -rf /root/{anaconda-ks.cfg,original-ks.cfg}
  sudo echo ${PUBKEYS} >> /root/.ssh/authorized_keys
  sudo echo ${PUBKEYS} >> ${LOCAL_HOME}/.ssh/authorized_keys

  sudo chown ${LOCAL_USER}:${LOCAL_USER} -R ${LOCAL_HOME}
  sudo chown root:root                   -R /root

}

dependencies_fedora () {

  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  sudo sed -i 's/$releasever/33/g' /etc/yum.repos.d/docker-ce.repo

  sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
  sudo grubby --update-kernel=ALL --args 'ipv6.disable=1 setenforce=0 cgroup_memory=1 cgroup_enable=cpuset cgroup_enable=memory systemd.unified_cgroup_hierarchy=0 intel_iommu=on iommu=pt rd.driver.pre=vfio-pci pci=realloc'

  sudo dnf update -y
  sudo dnf remove -y podman container-selinux zram-generator-defaults
  sudo dnf -y install git socat ethtool ebtables docker-ce docker-ce-cli containerd.io conntrack-tools
  sudo dnf -y install git vi vim tmux htop lnav neofetch @virtualization
  sudo dnf -y groupinstall "Container Management"

  sudo echo 'unix_sock_group = "libvirt"' > /etc/libvirt/libvirtd.conf
  sudo echo 'unix_sock_rw_perms = "0770"' > /etc/libvirt/libvirtd.conf
  sudo touch /etc/systemd/zram-generator.conf
  sudo cp -f /etc/containerd/config.toml /etc/containerd/config.toml.bak
  sudo cp -f etc/containerd/config.toml /etc/containerd/config.toml

  sudo systemctl stop swap-create@zram0
  sudo systemctl disable firewalld
  sudo systemctl enable  docker
  sudo systemctl enable  containerd
  sudo systemctl enable  libvirtd
  sudo usermod -aG libvirt ${LOCAL_USER}

}

dependencies_core () {

  sudo hostnamectl set-hostname ${LOCAL_HOSTNAME}
  sudo git clone https://github.com/containercraft/artemis.git /root/artemis

}

run
