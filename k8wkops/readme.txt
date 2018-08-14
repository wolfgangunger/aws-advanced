
See also
https://aws.amazon.com/de/blogs/compute/kubernetes-clusters-aws-kops/

install kops:

curl -LO https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv ./kops-linux-amd64 /usr/local/bin/kops


###
create s3 bucket
aws s3api create-bucket --bucket kubernetes-aws-unw
#versioning
aws s3api put-bucket-versioning --bucket kubernetes-aws-unw --versioning-configuration Status=Enabled

export KOPS_STATE_STORE=s3://kubernetes-aws-unw

kops create cluster \
--name kubernetes-aws-unw \
--zones us-west-2a \
--state s3://kubernetes-aws-unw \
--yes


