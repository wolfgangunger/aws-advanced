Github:
AWS
https://github.com/wolfgangunger/aws-advanced
https://github.com/wolfgangunger/aws-advanced/tree/master/

launch ec2 instance as k8 master

preconditions (see below):
docker, kubelet, kubeadm, kubectl

---
install k8 cluster:
su 
sudo -i

swapoff --all
kubeadm init --pod-network-cidr=10.244.0.0/16
kubeadm init 
(will generate join command, like : 
kubeadm join 172.31.27.246:6443 --token rziq1g.afsbx5vixawn0fwj --discovery-token-ca-cert-hash sha256:2617d81b9d951d9b5c399068bc5b7bbcbe9c2f036cb41f1f494d03ea59894007


setup kubectl
(sudo ubuntu)
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes
NAME               STATUS     ROLES     AGE       VERSION
ip-172-31-40-255   NotReady   master    4m        v1.10.0

setup network:
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/canal.yaml
(kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/canal.yaml --validate=false)


Nodes:
We need to install docker and install kubelet, kubectl and kubeadm on all nodes that will join the cluster.

join nodes:
swapoff --all
kubeadm join 172.31.27.246:6443 --token rziq1g.afsbx5vixawn0fwj --discovery-token-ca-cert-hash sha256:2617d81b9d951d9b5c399068bc5b7bbcbe9c2f036cb41f1f494d03ea59894007

check if nodes were registered
kubectl get nodes
NAME               STATUS    ROLES     AGE       VERSION
ip-172-31-39-203   Ready     <none>    1m        v1.10.0
ip-172-31-40-255   Ready     master    17m       v1.10.0


Dashboard:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl proxy

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/.


---
installing docker + aws:

sudo su
----- aws machine - 
todo 
----- ubuntu - 
sudo su
sudo -i

docker 
apt-get update
apt-get install -y docker.io

docker ce:
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

(apt-get install aws-cli)
apt install awscli


... optional :
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

sudo apt-get update && sudo apt-get install -y --allow-unauthenticated docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')




---------------
installing kubelet kubeadm kubectl:
apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
