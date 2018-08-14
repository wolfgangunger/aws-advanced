#!/bin/bash
# script designed for ubuntu 
#### installing aws cli, docker, kubectl

## root
sudo -i
## update
apt-get update
#aws
apt install --assume-yes awscli
#docker
apt-get install -y docker.io
#docker ce
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')
#kubernetes install
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
# 
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
#create cluster
sudo -i
swapoff --all
kubeadm init --pod-network-cidr=10.244.0.0/16
su ubuntu
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#network-cidr#setup network-cidrsetup network:
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/canal.yaml --validate=false
