Aha! Got it now — you're asking:

> **“What system-level info can we see about our running Docker container, app, and Kubernetes environment?”**  
Not just from inside the app, but more broadly as developers/operators. Let's go 🔍

---

## 🔹 **Container-Level Info (via Docker/Kubernetes)**

### 🐳 From Docker (before deploying)
If you're testing locally or want to inspect the image:

```bash
docker inspect alexeiguriev/c-web-server:latest
```

This gives:
- Image layers
- Exposed ports
- Entrypoint
- Env variables
- File system mounts
- CMD, etc.

### 🧾 From inside a running Pod:

```bash
kubectl exec -it <pod-name> -- /bin/sh
```

(if using Alpine, or `bash` for Debian)

Once inside:
```bash
ps aux                   # See processes
top                     # Live resource usage
df -h                   # Disk usage
cat /proc/cpuinfo       # CPU details
cat /proc/meminfo       # RAM info
hostname                # Container hostname
```

---

## 🔹 **Pod-Level Info**

### 📦 Get detailed pod info

```bash
kubectl describe pod <pod-name>
```

Shows:
- Node it’s running on
- Image name
- Resource requests/limits
- Events (like restarts, errors)
- IP address

### 🧠 See logs from the container

```bash
kubectl logs <pod-name>
```

---

## 🔹 **Service-Level Info**

```bash
kubectl get svc
kubectl describe svc c-app
```

Tells you:
- What ports are exposed
- Cluster IP
- NodePort (if used)
- What selectors it uses to route traffic to pods

---

## 🔹 **Deployment-Level Info**

```bash
kubectl get deploy
kubectl describe deploy c-app
```

Gives:
- Number of replicas
- Current pod status
- Strategy (rolling update, etc.)
- Linked pods

---

## 🔹 **Node Info**

```bash
kubectl get nodes -o wide
kubectl describe node minikube
```

You’ll see:
- Kubernetes version
- OS version
- CPU/memory capacity
- Labels & taints
- Allocated pods/resources

---

## 🔹 **Cluster Info**

```bash
kubectl cluster-info
```

Shows services like:
- Kubernetes API
- DNS
- Dashboard (if enabled)

---

## 🔹 **Helm Release Info**

```bash
helm list
helm status c-web
```

Shows:
- Deployed chart
- Values used
- Revision history
- Resources created (pods, services, etc.)

---

## 🔹 Bonus: Visual Tools

- `kubectl get all` — See everything running
- [Lens](https://k8slens.dev/) — GUI for Kubernetes clusters
- `k9s` — Terminal-based UI for Kubernetes (very cool)

---

Let me know if you want a **script or alias set** to automate collecting all this in one go — it’s really useful for debugging or sharing system snapshots.