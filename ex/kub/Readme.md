# 🚀 C Web Server on Kubernetes (Helm + Minikube)

This project helps you learn Kubernetes in the context of a C development workflow. It builds a lightweight HTTP server in C, containerizes it, and deploys it via Helm onto a local Minikube cluster.

---

## 🧠 Study Goals (4-Week Plan)

### ✅ Week 1: Core Kubernetes Concepts
- [x] Learn Kubernetes basics (pods, deployments, services)
- [x] Build and containerize a C app
- [x] Deploy it with `kubectl` or Helm

### ✅ Week 2: Deployments & Configs
- [ ] Set up ConfigMap and environment variables
- [ ] Practice rolling updates
- [ ] Debug using `kubectl logs` and `exec`

### ✅ Week 3: Networking & Observability
- [ ] Add a second C service and enable inter-service communication
- [ ] Use persistent volume for output logs
- [ ] Monitor CPU/memory with `metrics-server`

### ✅ Week 4: CI/CD & Real-World Practice
- [ ] Write Helm chart
- [x] Deploy with Helm locally (Minikube)
- [ ] Add GitHub Actions-based CI/CD

---

## 📂 Project Structure
kubernetes-c-dev-study/
├── app/
│   └── main.c                  # Minimal C web server
│
├── Dockerfile                  # Builds C app into container
│
├── helm/
│   └── c-app/
│       ├── Chart.yaml          # Helm chart metadata
│       ├── values.yaml         # Default values for templates
│       └── templates/
│           ├── deployment.yaml # Deployment template
│           └── service.yaml    # Service template
│
├── k8s/                        # (Optional) raw Kubernetes YAMLs
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
│
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions for local CI/CD
│
└── README.md                   # Docs + learning checklist



---

## 🔧 Requirements

- [Minikube](https://minikube.sigs.k8s.io/)
- [Docker](https://docs.docker.com/get-docker/)
- [Helm](https://helm.sh/)
- (Optional) [Act](https://github.com/nektos/act) for running GitHub Actions locally

---
