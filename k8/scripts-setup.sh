#!/bin/bash
# script designed for ubuntu 
#### installing aws cli, docker, kubectl

## root
sudo -i
swapoff --all
kubeadm init --pod-network-cidr=10.244.0.0/16
su ubuntu
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#setup network-cidrsetup network:
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/canal.yaml --validate=false



