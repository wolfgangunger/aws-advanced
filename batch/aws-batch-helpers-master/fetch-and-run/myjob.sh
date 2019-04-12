#!/bin/bash

date
echo "Args: $@"
#env
echo "jobId: $AWS_BATCH_JOB_ID"
##gzip
#sudo yum install gzip

#aws s3 cp s3://apache-www-bucket/20190401_businesses.json.gz s3://los-dev-test1/
#aws s3 cp s3://apache-www-bucket/20190401_businesses.json.gz /tmp/file.json.gz
aws s3 cp s3://apache-www-bucket/20190401_businesses.json.gz - | gzip -d | aws s3 cp --expected-size=$((1024*1024*1024 * 15)) - s3://los-dev-test1/20190401_businesses.json
sleep $1
pwd
touch test.txt
ls
#gzip
ls

aws s3 cp test.txt s3://los-dev-test1/


echo "File copied"
