Github:
AWS
https://github.com/wolfgangunger/aws-advanced
https://github.com/wolfgangunger/aws-advanced/tree/master/ECS-Fargate

Spring Microservice
https://github.com/wolfgangunger/ungerw-spring-boot-docker


Overview 
-Build App (Maven)	
-Docker Build:
docker build -f src/main/docker/Dockerfile -t 01.....dkr.ecr.us-west-1.amazonaws.com/ecs-example-repository:spring-boot .
-ECR Login
$(aws ecr get-login --no-include-email --region us-west-1)
-Docker push:
 docker push 01....dkr.ecr.us-west-1.amazonaws.com/ecs-example-repository:spring-boot

Installation by CloudFormation:
-VPC & Infrastructure, ALBs,  
-ECS Cluster
-Service


