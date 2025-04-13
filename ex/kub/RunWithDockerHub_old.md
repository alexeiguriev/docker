Great move! Deploying via Docker Hub is the next step toward a real-world setup 🚀  
Here’s a clean breakdown of how to switch from **Minikube-local image** to **Docker Hub-pushed image**:

---

### ✅ **Step 1: Tag & Push to Docker Hub**

Assuming your Docker Hub username is `yourusername`, run:

```bash
# Build the Docker image
docker build -t alexeiguriev/c-web-server:latest .

# Log in to Docker Hub
docker login

# Push the image
docker push alexeiguriev/c-web-server:latest
```

> Replace `yourusername` with your actual Docker Hub account name.

---

### ✅ **Step 2: Update Helm values**

Update the image config in your Helm `values.yaml`:

#### 📄 `helm/c-app/values.yaml`

```yaml
image:
  repository: alexeiguriev/c-web-server
  tag: latest
  pullPolicy: IfNotPresent
```

Or override via command line:

```bash
helm upgrade --install c-web helm/c-app \
  --set image.repository=alexeiguriev/c-web-server \
  --set image.tag=latest
```

---

### ✅ **Step 3: Ensure Minikube can pull from Docker Hub**

If your Docker Hub image is **public**, you're good.

If it's **private**, you need to create a Kubernetes secret:

```bash
kubectl create secret docker-registry regcred \
  --docker-username=alexeiguriev \
  --docker-password=DockerPassword123 \
  --docker-email=alexeiguriev1@gmail.com
```

Then reference it in your `deployment.yaml`:

```yaml
spec:
  template:
    spec:
      imagePullSecrets:
        - name: regcred
```

---

### ✅ **Step 4: Redeploy with Helm**

```bash
helm uninstall c-web
helm install c-web helm/c-app \
  --set image.repository=alexeiguriev/c-web-server \
  --set image.tag=latest
```

---

### ✅ **Step 5: Access it**

```bash
minikube service c-web --url
```

---

Want me to update the Helm chart's `deployment.yaml` to optionally use `imagePullSecrets`?