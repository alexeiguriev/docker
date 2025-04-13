### Preflight steps
### Docker login

```
docker login
```


### ✅ Apply the manifests:

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### ✅ Verify:

```
kubectl get pods
kubectl get svc
```

### 🌐 Access the App (on Minikube):

```
minikube service c-app
```

Or if using Docker Desktop Kubernetes, run:

```
kubectl get svc c-app
```

Look for the NodePort and access it via:

```
http://localhost:<nodePort>
```



### Test

```
curl -v http://localhost:<nodePort>
```