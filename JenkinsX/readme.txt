
create bucket
aws s3api create-bucket --bucket kops-state-demo-jenkinsx-ntt
enable versioning (if not enabled yet)
aws s3api put-bucket-versioning --bucket kops-state-demo-jenkinsx-ntt --versioning-configuration Status=Enabled


Step3 Eport env settings
export S3_BUCKET=kops-state-demo-jenkinsx-ntt
export KOPS_STATE_STORE=s3://$S3_BUCKET
export PATH=$PATH:/home/osboxes/.jx/bin

Step 4:
jx create cluster aws -n=bmw-workshop-demo-jx --zones us-west-2a --verbose

SSH public key must be specified when running with AWS 
(create with kops create secret --name demo-jx-mba.cluster.k8s.local sshpublickey admin -i ~/.ssh/id_rsa.pub)
ssh-keygen -t rsa -b 4096 -C <mail>

cluster löschen
kops delete cluster --state=s3://kops-state-demo-jenkinsx-ntt --yes --name bmw-workshop-demo-jx.cluster.k8s.local

