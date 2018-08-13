#!/bin/bash

export S3_BUCKET=kops-state-demo-jenkinsx-ungerw
export KOPS_STATE_STORE=s3://$$S3_BUCKET
export export AWS_AVAILABILITY_ZONES=us-west-1a,us-west-1b,us-west-1c
export AWS_REGION=us-west-1
export K8SCLUSTER_NAME=ungerw-demo-jx-cluster

echo-export:
	echo $$S3_BUCKET
	echo $$KOPS_STATE_STORE
	echo $$AWS_AVAILABILITY_ZONES
	echo $$K8SCLUSTER_NAME

#create s3-bucket: 
create-s3-bucket version-s3-bucket list-s3-bucket

#create-s3-bucket:
aws s3api create-bucket --bucket $$S3_BUCKET --region $$AWS_REGION --create-bucket-configuration LocationConstraint=$$AWS_REGION

#version-s3-bucket:
aws s3api put-bucket-versioning --bucket $$S3_BUCKET --versioning-configuration Status=Enabled

#list-s3-bucket:
aws s3api list-buckets  --query "Buckets[?Name=='$$S3_BUCKET'].Name | [0]" --out text

#create-aws-cluster:
jx create cluster aws -n=$$K8SCLUSTER_NAME --zones us-west-2a --verbose