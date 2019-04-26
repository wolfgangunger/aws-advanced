DOCKER_ORCHESTRATOR=kubernetes

all: chmod build run logs

deploy-k8s: package
	kubectl apply -f k8s/deployment.yaml

delete-micro-pod:
	kubectl delete pod spring-boot
	kubectl delete svc spring-boot
	kubectl delete ingress spring-boot

chmod:
	chmod +x *.sh

build: 
	./docker-build.sh

build-and-push: build push

awslogin:
	aws ecr get-login --region eu-west-1

push:
	docker push 016973021151.dkr.ecr.eu-west-1.amazonaws.com/ungerw:spring-boot

run:
	./docker-start.sh

clean:
	./docker-stop.sh

logs: 
	docker logs -f micro

curl:
	curl -i http://localhost:8080/spring-docker/hello

curl-loop:
	while true; do curl -i http://localhost:50080/spring-docker/hello; sleep 1; done

show:
	firefox http://localhost:50080/spring-docker/hello

package:
	mvn clean package

redeploy: package
	./redeploy-curl.sh

compose-up:
	docker-compose up -d

compose-down:
	docker-compose down

deploy-stack:
	docker stack deploy --compose-file docker-compose.yml micro-stack

port-forward:
	kubectl -n default port-forward svc/micro-pod 38080:80
	firefox http://localhost:38080/spring-docker/hello