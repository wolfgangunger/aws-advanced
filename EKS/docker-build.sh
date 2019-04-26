#!/bin/sh
mvn clean install && docker build -f src/main/docker/Dockerfile -t 016973021151.dkr.ecr.eu-west-1.amazonaws.com/ungerw:spring-boot .