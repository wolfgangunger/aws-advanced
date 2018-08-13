#!/bin/bash
export S3_BUCKET=kops-state-demo-jenkinsx-ungerw
export KOPS_STATE_STORE=s3://kops-state-demo-jenkinsx-ungerw

#create versioned s3 bucket, needed for kops
aws s3api create-bucket --bucket $S3_BUCKET --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
aws s3api put-bucket-versioning --bucket $S3_BUCKET --versioning-configuration Status=Enabled

#create the cluster using jx
jx create cluster aws -n=nttdata-jenkinsx-demo --zones us-west-2a --verbose