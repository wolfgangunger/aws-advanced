github:
https://github.com/wolfgangunger/aws-advanced
https://github.com/wolfgangunger/aws-advanced/tree/master/k8wkops

See also
https://aws.amazon.com/de/blogs/compute/kubernetes-clusters-aws-kops/

Preconditions:
install aws-cli, kops on your local (linux will work perfect) machine

steps: 
-aws configure for your cluster region 
-create s3 bucket
-create cluster
-create dashboard
-create user + rolebinding for dashboard

------------------------------- create k8 cluster --------------------------
#create s3 bucket
aws s3api create-bucket --bucket kubernetes-aws-unw --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1
#versioning
aws s3api put-bucket-versioning --bucket kubernetes-aws-unw --versioning-configuration Status=Enabled

export KOPS_STATE_STORE=s3://kubernetes-aws-unw

kops create cluster \
--name k8.unw.aws.de.altemista.cloud \
--zones us-west-2a \
--state s3://kubernetes-aws-unw \
--yes

#create dashboard, see scripts-dashboard.sh

delete cluster :
kops delete cluster --state=s3://kubernetes-aws-unw --yes --name k8.unw.aws.de.altemista.cloud

------------------------------ preconditions --------
install kops:

curl -LO https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv ./kops-linux-amd64 /usr/local/bin/kops

create ssh public key:
ssh-keygen -t rsa -b 4096 -C <mail>
kops create secret --name k8.unw.aws.de.altemista.cloud sshpublickey admin -i ~/.ssh/id_rsa.pub
