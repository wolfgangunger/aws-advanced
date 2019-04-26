#!/bin/sh
docker kill spring-boot
docker rm spring-boot
docker run -d -p 50080:8080 -p 50048:4848 --name spring-boot 016973021151.dkr.ecr.eu-west-1.amazonaws.com/ungerw:spring-boot