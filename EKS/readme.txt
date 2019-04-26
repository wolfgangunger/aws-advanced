required
aws cli
eksctl
aws-iam-authenticator
https://docs.aws.amazon.com/de_de/eks/latest/userguide/install-aws-iam-authenticator.html
helm

choco install eksctl -y
choco install awscli -y
choco install kubernetes-cli -y
choco install kubernetes-helm -y
choco install maven -y
choco install jdk8 -params 'installdir=c:\\java8'


--steps---
Create a Docker repository using ECR
aws ecr create-repository --region=eu-west-1 --repository-name ungerw

---create cluster:
eksctl create cluster --name=ungerw --nodes=3 --node-type=m5.large --region eu-west-1
eksctl create cluster --name=ungerw --nodes-min=3 --nodes-max=5 --region eu-west-1


----Check the cluster:
kubectl get nodes
kubectl get clusterroles

--update--
aws eks update-kubeconfig --name=ungerw --region=eu-west-1
---
Show the list of kubernetes contexts and select one:
kubectl config get-contexts
kubectl config use-context ungerw
--
Create a namespace and switch to it:
kubectl create namespace ungerw
kubectl config set-context $(kubectl config current-context) --namespace=ungerw

---install dashboard----------
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl proxy --port=8080 --address='0.0.0.0' --disable-filter=true &

get token:
aws-iam-authenticator token -i ungerw
aws-iam-authenticator token -i ungerw --token-only

open in browser:
http://localhost:8080/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/.

---------------
Java / Spring Part

Build Spring Project:
mvn clean install -DskipTests

Build Docker Image:
docker build -f src/main/docker/Dockerfile -t 016973021151.dkr.ecr.eu-west-1.amazonaws.com/ungerw:spring-boot .

Docker Login
$(aws ecr get-login --no-include-email --region eu-west-1)

Docker push:
docker push 016973021151.dkr.ecr.eu-west-1.amazonaws.com/ungerw:spring-boot

--- Deployment of Service: 
kubectl create -f k8s/deployment.yaml
kubectl create -f k8s/deployment-elb.yaml

kubectl get pods
kubectl describe pod spring-boot
kubectl logs -f spring-boot
get IP:
kubectl get svc

---get URL ---
kubectl get service spring-boot
kubectl get service spring-boot -o wide
kubectl get service spring-boot-elb
kubectl get service spring-boot-elb -o wide
http://abfc98d05683c11e9996f0a6f13019ea-1104569167.eu-west-1.elb.amazonaws.com/spring-docker/hello

------helm---------
https://helm.sh/docs/using_helm/#installing-helm
https://eksworkshop.com/helm_root/helm_intro/

kubectl create -f helm/rbac-config.yaml

helm repo update
helm search
helm search nginx
helm repo add bitnami https://charts.bitnami.com/bitnami

Create the Helm Chart:
cd helm
helm create spring-boot

helm install --name spring-boot-helm spring-boot

kubectl get svc spring-boot -o jsonpath="{.status.loadBalancer.ingress[*].hostname}"; echo

---tiller
https://github.com/helm/helm/blob/master/docs/quickstart.md
https://raw.githubusercontent.com/helm/helm/master/docs/rbac.md

helm init --service-account tiller --history-max 200

---- clean up ---
Delete Pod / Service :
kubectl delete all -l app=spring-boot

Ingresses:
kubectl get ingresses.extensions --all-namespaces
kubectl delete ingresses.extensions-n <namespace> <ing-anme>
kubectl delete ingresses.extensions -n ungerw spring-boot


Delete the EKS cluster using eksctl:
eksctl delete cluster --name=ungerw

* [AWS EKS Workshop](https://eksworkshop.com/)
* [Setting up Amazon EKS: What you must know](https://medium.com/@dmaas/setting-up-amazon-eks-what-you-must-know-9b9c39627fbc)
* [AWS Cost Savings by Utilizing Kubernetes Ingress with Classic ELB](https://akomljen.com/aws-cost-savings-by-utilizing-kubernetes-ingress-with-classic-elb/)
* [How to setup NGINX ingress controller on AWS clusters](https://medium.com/kokster/how-to-setup-nginx-ingress-controller-on-aws-clusters-7bd244278509)
* [Kubectl aliases Sebastian Daschner](https://github.com/sdaschner/ibm-cloud-tools/tree/master/kubectl)
* [Kubernetes Ingress with AWS ALB Ingress Controller](https://aws.amazon.com/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/)
* [AWS Ingress Controller](https://github.com/aws-samples/aws-workshop-for-kubernetes/blob/master/04-path-security-and-networking/405-ingress-controllers/readme.adoc)
* [Learning Kubernetes on EKS by Doing](https://medium.com/devopslinks/learning-kubernetes-on-eks-by-doing-part-4-ingress-on-eks-6c5e5a34920b)
* [How auth works in EKS with IAM Users](http://marcinkaszynski.com/2018/07/12/eks-auth.html)
* [Helm 2.x without Tiller | Jenkins X](https://jenkins-x.io/news/helm-without-tiller/)
* [Using Helm without Tiller](https://blog.giantswarm.io/what-you-yaml-is-what-you-get/)
* [90 Days AWS EKS in Production](https://kubedex.com/90-days-of-aws-eks-in-production/)
* [Tinder’s move to Kubernetes](https://medium.com/@tinder.engineering/tinders-move-to-kubernetes-cda2a6372f44)
* [Configure RBAC In Your Kubernetes Cluster](https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/)
* [Helm RBAC Tiller](https://github.com/helm/helm/blob/master/docs/rbac.md)
* [Setup AWS EKS Cluster using Terraform](https://www.esentri.com/building-a-kubernetes-cluster-on-aws-eks-using-terraform_part2/)
* [Deploy a full EKS cluster with Terraform](https://github.com/WesleyCharlesBlake/terraform-aws-eks)
* [Introducing Horizontal Pod Autoscaler for Amazon EKS](https://aws.amazon.com/blogs/opensource/horizontal-pod-autoscaling-eks/)
* [Amazon ECR](https://aws.amazon.com/ecr/?nc1=h_ls)
* [Easy AWS EKS cluster provisioning and user access](https://medium.com/solo-io/easy-aws-eks-cluster-provisioning-and-user-access-5e3cdc01dfc6)
* [Managing User or IAM Roles for your cluster](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html)