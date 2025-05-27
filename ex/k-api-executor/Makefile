IMAGE_NAME=py-executor-k8s
TAG=latest

POD=api-deployment-665698866b-vx5jm
MINIKUBE_IP=$(shell minikube ip)
API_SERVICE_PORT=30001

.PHONY: build deploy

# make helm-install STAGE=prod
helm-install:
ifeq ($(STAGE),prod)
	helm install ax-app ./helm/ax-app -f ./helm/ax-app/values-prod.yaml
else
	helm install ax-app ./helm/ax-app
endif

	
helm-uninstall:
	helm uninstall ax-app

	
helm-template:
	helm template  ax-app ./helm/ax-app


deploy:
	kubectl apply -f k8s/api-configmap.yaml

	kubectl apply -f k8s/api-deployment.yaml
	kubectl apply -f k8s/api-service.yaml

	kubectl apply -f k8s/executor-deployment.yaml
	kubectl apply -f k8s/executor-service.yaml

build:
	docker build -t api-image ./api
	docker build -t executor-image ./executor

build-deploy: build deploy

rebuild: clean build-deploy

setup:
	eval $(minikube docker-env)

clean:
	kubectl delete -f k8s/api-deployment.yaml || true
	kubectl delete -f k8s/api-service.yaml || true
	docker rmi -f api-image || true

	kubectl delete -f k8s/executor-deployment.yaml || true
	kubectl delete -f k8s/executor-service.yaml || true
	docker rmi -f executor-image || true

	kubectl delete -f k8s/api-configmap.yaml

# Usage: make log APP=api|executor
log:
ifeq ($(APP),api)
	kubectl logs deployment/api-deployment
else ifeq ($(APP),executor)
	kubectl logs deployment/executor-deployment
else
	kubectl logs deployment/api-deployment
endif



curl-pod:
	kubectl exec -it $(POD) -- curl -X POST -d "Test from minikube host" http://localhost:8081

curl-service:
	curl -X POST -d "Test from minikube host"  http://api-service.default.svc.cluster.local:8081/
	
curl-service-node:
	curl -X POST -d "test msg from host"  http://$(MINIKUBE_IP):$(API_SERVICE_PORT)/

curl: curl-service-node
test: curl

execpod:
	kubectl exec -it $(POD) -- bash

port-pod-forward:
	kubectl port-forward $(POD) 8081:8081
port-forward-service:
	kubectl port-forward service/api-service 8081:8081
