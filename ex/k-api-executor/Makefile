IMAGE_NAME=py-executor-k8s
TAG=latest

POD=api-deployment-665698866b-vx5jm
MINIKUBE_IP=$(shell minikube ip)
API_SERVICE_PORT=30001

.PHONY: build deploy

deploy:
	kubectl apply -f api-configmap.yaml

	kubectl apply -f api-deployment.yaml
	kubectl apply -f api-service.yaml
	
	kubectl apply -f executor-deployment.yaml
	kubectl apply -f executor-service.yaml

build:
	docker build -t api-image ./api
	docker build -t executor-image ./executor

build-deploy: build deploy

rebuild: clean build-deploy

setup:
	eval $(minikube docker-env)

clean:
	kubectl delete -f api-deployment.yaml || true
	kubectl delete -f api-service.yaml || true
	docker rmi -f api-image || true

	kubectl delete -f executor-deployment.yaml || true
	kubectl delete -f executor-service.yaml || true
	docker rmi -f executor-image || true
	
	kubectl delete -f api-configmap.yaml

logs:
	kubectl logs $(POD)

test:
	kubectl exec -it $(POD) -- curl -X POST -d "Test from minikube host" http://localhost:8081

curl-pod:
	kubectl exec -it $(POD) -- curl -X POST -d "Test from minikube host" http://localhost:8081

curl-service:
	curl -X POST -d "Test from minikube host"  http://api-service.default.svc.cluster.local:8081/
	
curl-service-node:
	curl -X POST -d "Test from minikube host"  http://$(MINIKUBE_IP):$(API_SERVICE_PORT)/

execpod:
	kubectl exec -it $(POD) -- bash

port-pod-forward:
	kubectl port-forward $(POD) 8081:8081
port-forward-service:
	kubectl port-forward service/api-service 8081:8081
