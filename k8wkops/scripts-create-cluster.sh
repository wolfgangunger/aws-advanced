#!/bin/bash

#create s3 bucket
aws s3api create-bucket --bucket kubernetes-aws-unw
#versioning
aws s3api put-bucket-versioning --bucket kubernetes-aws-unw --versioning-configuration Status=Enabled

export KOPS_STATE_STORE=s3://kubernetes-aws-unw

kops create cluster \
--name k8.unw.aws.de.altemista.cloud \
--zones us-west-2a \
--state s3://kubernetes-aws-unw \
--yes


