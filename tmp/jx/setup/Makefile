
export S3_BUCKET=kops-state-demo-jenkinsx-ntt-krasi
export KOPS_STATE_STORE=s3://$$S3_BUCKET
# export AWS_AVAILABILITY_ZONES="$(aws ec2 describe-availability-zones --query 'AvailabilityZones[].ZoneName' --output text | awk -v OFS="," '$1=$1')"
export export AWS_AVAILABILITY_ZONES=us-west-2a,us-west-2b,us-west-2c
export AWS_REGION=us-west-2
export K8SCLUSTER_NAME=nttdata-demo-jx-cluster

echo-export:
	echo $$S3_BUCKET
	echo $$KOPS_STATE_STORE
	echo $$AWS_AVAILABILITY_ZONES
	echo $$K8SCLUSTER_NAME

all-s3-bucket: create-s3-bucket version-s3-bucket list-s3-bucket

create-s3-bucket:
	aws s3api create-bucket --bucket $$S3_BUCKET --region $$AWS_REGION --create-bucket-configuration LocationConstraint=$$AWS_REGION

version-s3-bucket:
	aws s3api put-bucket-versioning --bucket $$S3_BUCKET --versioning-configuration Status=Enabled

list-s3-bucket:
	aws s3api list-buckets  --query "Buckets[?Name=='$$S3_BUCKET'].Name | [0]" --out text

create-aws-cluster:
	jx create cluster aws -n=$$K8SCLUSTER_NAME --zones us-west-2a --verbose