### Preflight steps
### Docker login

```
docker login
```

Let’s go! 🚀 Here's a clean step-by-step to run your **C web server application** using **Helm** now that your environment is ready.

---

### ✅ Step 1: Verify cluster is running

Just to be sure:

```bash
minikube status
kubectl get nodes
```

Make sure the node is `Ready`.

---

### ✅ Step 2: Verify your Docker image exists on Docker Hub

If you haven’t pushed the latest yet:

```bash
docker build -t alexeiguriev/c-web-server:latest .
docker push alexeiguriev/c-web-server:latest
```

(Replace with your Docker Hub username if needed)

---

### ✅ Step 3: Install the Helm chart

From the root of your project:

```bash
helm upgrade --install c-web helm/c-app \
  --set image.repository=alexeiguriev/c-web-server \
  --set image.tag=latest
```

---

### ✅ Step 4: Check that it’s running

```bash
kubectl get pods
kubectl get svc
```

You should see:
- A pod for your deployment
- A service called `c-web`

---

### ✅ Step 5: Access the app

Use Minikube to get the service URL:

```bash
minikube service c-web --url
```

Then run:

```bash
curl $(minikube service c-web --url)
```

You should see:

```text
Hello from C!
```

---

Let me know what you get from each step and I’ll help you troubleshoot or celebrate 🥳