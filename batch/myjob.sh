#!/bin/bash
echo "Args: $@"
#env
echo "jobId: $AWS_BATCH_JOB_ID"
DATE=$(date +%Y%m%d)
echo $DATE
echo "Hello "$1" Date :"$DATE
pwd
echo "aws friends" >> test.txt
ls
aws s3 cp test.txt s3://ungerw-batch-bucket/
echo "File copied"
echo "Job done"
