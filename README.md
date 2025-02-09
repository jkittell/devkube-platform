# DevKube Platform

A GitOps-managed Kubernetes platform using Flux v2. This repository contains the infrastructure and application configurations for a development Kubernetes environment.

## 🚀 Features

- GitOps with Flux v2
- Ingress with NGINX and cert-manager
- Monitoring stack with:
  - Grafana
  - Prometheus
  - Tempo for tracing
  - Redis for caching
- MinIO for S3-compatible storage

## 📋 Prerequisites

- Kubernetes cluster 
- kubectl installed and configured
- Flux CLI installed
- GitHub account and personal access token

## 🔧 Installation

### 1. Install Flux CLI

```bash
brew install fluxcd/tap/flux
```

### 2. Bootstrap Flux

1. Export your GitHub credentials:
```bash
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>
```

2. Check your cluster compatibility:
```bash
flux check --pre
```

3. Bootstrap Flux with your repository:
```bash
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=devkube-platform \
  --branch=main \
  --path=clusters/base \
  --personal
```

### 3. Verify Installation

Check that Flux components are running:
```bash
kubectl get pods -n flux-system
```

## 🔄 Making Changes

1. Clone the repository:
```bash
git clone https://github.com/$GITHUB_USER/devkube-platform.git
cd devkube-platform
```

2. Make your changes to the configuration files

3. Commit and push:
```bash
git add .
git commit -m "your meaningful commit message"
git push
```

Flux will automatically detect and apply changes within its default sync interval (1 minute).

To force immediate reconciliation:
```bash
flux reconcile kustomization dev -n flux-system
```

## 📁 Repository Structure

```
clusters/
├── base/                    # Base configurations
│   ├── ingress/            # NGINX Ingress and cert-manager
│   ├── monitoring/         # Monitoring stack
│   │   ├── grafana/       # Grafana dashboards and config
│   │   ├── prometheus/    # Prometheus configuration
│   │   └── tempo/         # Distributed tracing
│   └── storage/           # Storage configurations
│       └── minio/         # MinIO S3 storage
└── overlays/              # Environment-specific overlays
    └── dev/              # Development environment
```

## 🛠 Troubleshooting

1. Check Flux system logs:
```bash
flux logs -n flux-system
```

2. Check reconciliation status:
```bash
flux get kustomizations -A
```

3. View resource health:
```bash
flux get all -A
```

## 📚 Additional Resources

- [Flux Documentation](https://fluxcd.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [cert-manager Documentation](https://cert-manager.io/docs/)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
