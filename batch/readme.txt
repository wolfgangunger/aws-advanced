Github:
https://github.com/wolfgangunger/aws-advanced/
https://github.com/wolfgangunger/aws-advanced/tree/master/batch
Tutorial:
https://aws.amazon.com/de/blogs/compute/creating-a-simple-fetch-and-run-aws-batch-job/



Steps:
-create IAM role (Batch_Role)
-create ECR repo
-build docker image 
docker build -t 016973021151.dkr.ecr.eu-west-1.amazonaws.com/ungerw:fetch_and_run .
optional: check images
docker images
login and push image:
$(aws ecr get-login --no-include-email --region eu-west-1)
docker push 016973021151.dkr.ecr.eu-west-1.amazonaws.com/ungerw:fetch_and_run

-create job script (myjob.sh)
upload to s3 :
aws s3 cp myjob.sh s3://<bucket>/myjob.sh

-create compute environment
-create Job queue

-create Job definition
Key=BATCH_FILE_TYPE, Value=script
Key=BATCH_FILE_S3_URL, Value=s3://ungerw-batch-bucket/myjob.sh  

-create Job:
command : myjob.sh 'AWS Friends'

