.PHONY: deploy clean
NAMESPACE ?= lgu-test

KUBECTL = kubectl -n $(NAMESPACE)
MINIKUBE = minikube -n $(NAMESPACE)

deploy:
	@echo "Starting deployment process..."
	# Create the namespace if it doesn't exist
	$(KUBECTL) create namespace $(NAMESPACE) || true
	$(KUBECTL) apply -f mongo-configmap.yaml
	$(KUBECTL) apply -f mongo-secret.yaml
	$(KUBECTL) apply -f mongo-deployment.yaml
	$(KUBECTL) apply -f mongo-express.yaml
	@echo "Deployment process completed."

redeploy:
	@echo "Redeploying MongoDB and Mongo Express..."
	$(KUBECTL) delete -f mongo-deployment.yaml || true
	$(KUBECTL) delete -f mongo-express.yaml || true
	$(KUBECTL) apply -f mongo-deployment.yaml
	$(KUBECTL) apply -f mongo-express.yaml
	@echo "Redeployment process completed."


delete:
	@echo "Starting cleanup process..."
	# Remove the MongoDB resources
	$(KUBECTL) delete -f mongo-secret.yaml || true
	$(KUBECTL) delete -f mongo-deployment.yaml || true
	$(KUBECTL) delete -f mongo-express.yaml || true
	$(KUBECTL) delete -f mongo-configmap.yaml || true
	# Remove the namespace if it is empty
	$(KUBECTL) delete namespace $(NAMESPACE) || true
	@echo "Cleanup process completed."


logs:
	@echo "Fetching logs for mongo-express pod..."
	$(KUBECTL) logs -l app=mongo-express --tail=100
status:
	@echo "Checking status of MongoDB and Mongo Express pods..."
	$(KUBECTL) get pods -l app=mongo
	$(KUBECTL) get pods -l app=mongo-express
describe:
	@echo "Describing MongoDB and Mongo Express deployments..."
	$(KUBECTL) describe deployment mongo-deployment
	$(KUBECTL) describe deployment mongo-express-deployment
restart:
	@echo "Restarting MongoDB and Mongo Express deployments..."
	$(KUBECTL) rollout restart deployment/mongo-deployment
	$(KUBECTL) rollout restart deployment/mongo-express-deployment

run:
	$(MINIKUBE) service mongo-express-service
