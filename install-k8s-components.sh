#!/bin/bash

set -e

# installing prerequisite tools
apt-get install -y \
	vim curl apt-transport-https \
	git wget software-properties-common \
	lsb-release ca-certificates gpg

# disable swap and load modules
swapoff -a
modprobe overlay
modprobe br_netfilter

# update kernel networking
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# installing gpg key for containerd
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install/configure/restart containerd
apt-get update && apt-get install -y containerd.io
containerd config default | tee /etc/containerd/config.toml
sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml
systemctl restart containerd

# download public signing key for kube tools
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# adding k8s apt repo
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# install k8s tools
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# add control-plane to etc/hosts
echo "$(nslookup control-plane-0 | grep Address: | awk '{ print $2 }' | tail -n 1) k8scp" >> /etc/hosts

echo "$(nslookup control-plane-1 | grep Address: | awk '{ print $2 }' | tail -n 1) k8scp" >> /etc/hosts

echo "$(nslookup control-plane-2 | grep Address: | awk '{ print $2 }' | tail -n 1) k8scp" >> /etc/hosts

# download lab resources
wget https://cm.lf.training/LFS258/LFS258_V2024-03-14_SOLUTIONS.tar.xz --user=$lab_user --password=$lab_password
tar -xvf LFS258_V2024-03-14_SOLUTIONS.tar.xz
