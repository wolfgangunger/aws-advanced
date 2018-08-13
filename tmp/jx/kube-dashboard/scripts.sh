#!/bin/bash

#install dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl apply -f kubernetes-dashboard.yaml

kubectl create -f createUser.yaml
kubectl create -f roleBinding.yaml

#proxy
kubectl proxy

#show-dashboard:
firefox http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login

#get-token:
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')	


