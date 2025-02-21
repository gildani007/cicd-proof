# cicd-proof
Iac project with terragrunt terraform and helm

<![endif]-->

# Project Documentation

## Overview

This project utilizes **Terragrunt** to manage **Terraform** configurations for deploying applications in multiple environments (**production** and **staging**). The folder structure is designed to separate environments and modularize Terraform configurations using the **Terragrunt** approach.

----------

## Setup Environment

### 1. Install Docker

For macOS, use the link below and choose the correct version based on the processor chip (**Intel** or **Apple Silicon**):

-   [Docker Desktop for macOS](https://docs.docker.com/desktop/setup/install/mac-install/)

For other versions, refer to this link:

-   [Docker Engine Installation](https://docs.docker.com/engine/install/)

### 2. Install Minikube

To install the latest Minikube **stable release** on **ARM64 macOS** using **binary download**:

```
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-arm64
```

```
sudo install minikube-darwin-arm64 /usr/local/bin/minikube
```

For other versions, check this link:

-   [Minikube Installation](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)

Verify the installation:

```
minikube kubectl version
```

### 3. Start Minikube

```
minikube start
```

### 4. Install Ingress Controller

```
minikube addons enable ingress
```

Enable **DNS Addon**:

```
minikube addons enable ingress-dns
```

### 5. Install Kubectl

For **macOS Apple Silicon**:

```
curl -LO https://dl.k8s.io/release/v1.32.0/bin/darwin/arm64/kubectl
```

For **Intel macOS**:

```
curl -LO "https://dl.k8s.io/release/v1.32.0/bin/darwin/amd64/kubectl"
```

For other versions, refer to this link:

-   [Kubectl Installation](https://kubernetes.io/docs/tasks/tools/)

Run these commands to grant permissions and move to a directory in **PATH**:

```
chmod +x kubectl
```

```
sudo mv kubectl /usr/local/bin/kubectl
```

### 6. Install Terragrunt

-   Install from: [Terragrunt Installation](https://terragrunt.gruntwork.io/docs/getting-started/install/)
-   **Version used in this project:** `0.53.2`

### 7. Install Terraform

-   Install from: [Terraform Installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
-   **Version used in this project:** `1.6.6`

### 8. Install Helm

1.  Download the desired version
2.  Unpack it:

<![if !supportLists]>`3.` <![endif]>`tar -zxvf helm-v3.0.0-linux-amd64.tar.gz`

4.  Move the binary to a directory in **PATH**:

<![if !supportLists]>`5.` <![endif]>`mv linux-amd64/helm /usr/local/bin/helm`

-   **Version used in this project:** `3.12.3`

----------

## Folder Structure

```
.
```

```
├── charts/                    # Helm charts for Kubernetes deployments
│   ├── mychart/               # Active Helm chart
```

```
│       ├── Chart.yaml         # Chart metadata
```

```
│       ├── templates/         # Kubernetes manifests as Helm templates
```

```
│       │   ├── deployment.yaml
```

```
│       │   ├── ingress.yaml
```

```
│       │   └── service.yaml
```

```
│       └── values.yaml        # Configurable values for Helm chart
```

```
│
```

```
├── deployments/               # Environment-specific configurations
```

```
│   ├── config.yml             # Global deployment configuration
```

```
│   ├── production/            # Production environment
```

```
│   │   ├── config.yml         # Environment-specific configuration
```

```
│   │   └── web-application/   # Terragrunt directory for production
```

```
│   │       ├── config.yml
```

```
│   │       ├── terraform.tfstate
```

```
│   │       ├── terraform.tfstate.backup
```

```
│   │       └── terragrunt.hcl
```

```
│   ├── root.hcl               # Root-level Terragrunt configuration
```

```
│   ├── staging/               # Staging environment
```

```
│   │   ├── config.yml
```

```
│   │   └── web-application/   # Terragrunt directory for staging
```

```
│   │       ├── config.yml
```

```
│   │       └── terragrunt.hcl
```

```
│
```

```
├── modules/                   # Reusable Terraform modules
```

```
│   ├── components/            # Specific components
```

```
│   │   └── helm_release/      # Helm release management
```

```
│   │       ├── main.tf
```

```
│   │       ├── providers.tf
```

```
│   │       └── variables.tf
```

```
│   ├── stacks/                # Application stack definitions
```

```
│   │   └── web-application/   # Web application stack
```

```
│   │       ├── main.tf
```

```
│   │       ├── providers.tf
```

```
│   │       └── variables.tf
```

----------

## Running Terragrunt

Since the project follows a **Terragrunt** structure, execution is done within the environment-specific `web-application` directory.

### Running in Production

```
cd deployments/production/web-application
```

```
terragrunt run-all plan
```

```
terragrunt run-all apply
```

### Running in Staging

```
cd deployments/staging/web-application
```

```
terragrunt run-all plan
```

```
terragrunt run-all apply
```

### Minikube Tunnel

tunnel creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP

```
minikube tunnel
```

### Add the DNS Record

```
echo "127.0.0.1 s-myapp.local" | sudo tee -a /etc/hosts
```

```
echo "127.0.0.1 p-myapp.local" | sudo tee -a /etc/hosts
```

----------

## Helm Deployment

The **Helm charts** are located under the `charts/` directory. To manually deploy a Helm release, run:

```
helm upgrade --install my-app charts/mychart -f charts/mychart/values.yaml
```

----------

## Best Practices

-   Always run `terragrunt plan` before applying changes.
-   Maintain separate configurations for **staging** and **production** to prevent accidental changes.
-   Use `root.hcl` for defining shared settings across environments.
-   Keep the `charts/` directory up to date with versioned **Helm releases**.
-   Regularly back up `terraform.tfstate` files to prevent state corruption.

----------

## Terragrunt and Terraform State Management

-   In **production**, state files should be stored in **S3** or another **remote and secured location**.
-   Use a database like **DynamoDB** to lock the state file during changes to avoid conflicts.

More information can be found here.

[https://terragrunt.gruntwork.io/docs/features/state-backend/](https://terragrunt.gruntwork.io/docs/features/state-backend/)

----------
