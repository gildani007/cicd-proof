# Project Documentation of cicd-proof 

## Overview

This project utilizes **Terragrunt** to manage **Terraform** configurations for deploying applications in multiple environments (**production** and **staging**). The folder structure is designed to separate environments and modularize Terraform configurations using the **Terragrunt** approach.


## Folder Structure

```
├── charts/                    # Helm charts for Kubernetes deployments
│   ├── mychart/               # Active Helm chart
│       ├── Chart.yaml         # Chart metadata
│       ├── templates/         # Kubernetes manifests as Helm templates
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   └── service.yaml
│       └── values.yaml        # Configurable values for Helm chart
│
├── deployments/               # Environment-specific configurations
│   ├── config.yml             # Global deployment configuration
│   ├── production/            # Production environment
│   │   ├── config.yml         # Environment-specific configuration
│   │   └── web-application/   # Terragrunt directory for production
│   │       ├── config.yml
│   │       └── terragrunt.hcl
│   ├── root.hcl               # Root-level Terragrunt configuration
│   ├── staging/               # Staging environment
│   │   ├── config.yml
│   │   └── web-application/   # Terragrunt directory for staging
│   │       ├── config.yml
│   │       └── terragrunt.hcl
│
├── modules/                   # Reusable Terraform modules
│   ├── components/            # Specific components
│   │   └── helm_release/      # Helm release management
│   │       ├── main.tf
│   │       ├── providers.tf
│   │       └── variables.tf
│   ├── stacks/                # Application stack definitions
│   │   └── web-application/   # Web application stack
│   │       ├── main.tf
│   │       ├── providers.tf
│   │       └── variables.tf
```
----------

### Charts

The **Helm charts** are located under the `charts/` directory.
The chart that being used in this project contains nginx deployment, service and ingress.
The deployment contain livenessProbe and readinessProbe to prevent the service to send requests when pod can't repspond. 
The charts are bening used by a shared module under component named helm_release.

----------

### Deployments

The **Deployments** are located in the `deployments/` directory, which contains subfolders for each environment.

Each environment folder includes its respective Terragrunt deployment configuration.

----------

### modules

The **modules** are located in the `modules/` directory, which contains 2 subfolders:
1. **components** which contains the shared terraform modules, in our case helm_release.
2. **stacks** which contains the terraform stacks which are being used by the terragrunt deployments.

----------

## Terragrunt Configuration Files

### `terragrunt.hcl`

Each deployment stack contains a minimal `terragrunt.hcl` file that includes the root configuration:

```hcl
include {
  path = find_in_parent_folders("root.hcl")
}
```

This approach centralizes configuration while allowing stack-specific overrides.

### `config.yml`

Stack-specific variables are stored in YAML files. For example, a web application configuration might contain:

```yaml
release_name: "web-app"
chart: "../../../charts/mychart"
namespace: "basic"

helm_values:
  service:
    type: ClusterIP
  ingress:
    enabled: true
    className: "nginx"
    hosts:
      - host: p-myapp.local
        paths:
          - path: /
            pathType: Prefix
```

These variables are automatically loaded and passed to Terraform.

### `root.hcl`

The root configuration handles:

1. Configuration merging
2. Remote state management
3. Module sourcing

## Key Components

### 1. Configuration Merging

Terragrunt aggregates configuration from all applicable `config.yml` files in the directory hierarchy:

```hcl
locals {
  # Get the parent directory where Terragrunt is executed
  root_deployments_dir = get_parent_terragrunt_dir()

  # Get the relative path between the current terragrunt.hcl file and root
  relative_deployment_path = path_relative_to_include()
  
  # Split the path into components
  deployment_path_components = compact(split("/", local.relative_deployment_path))

  # Extract the stack name (e.g., `production/web-application` → `web-application`)
  stack = local.deployment_path_components[1]

  # Generate a list of all possible configuration directories in the hierarchy
  possible_config_dirs = [
    for i in range(0, length(local.deployment_path_components) + 1) :
    join("/", concat(
      [local.root_deployments_dir],
      slice(local.deployment_path_components, 0, i)
    ))
  ]

  # Generate paths for possible YAML config files
  possible_config_paths = flatten([
    for dir in local.possible_config_dirs : [
      "${dir}/config.yml",
      "${dir}/config.yaml"
    ]
  ])

  # Load and decode all existing YAML configurations
  file_configs = [
    for path in local.possible_config_paths :
    yamldecode(file(path)) if fileexists(path)
  ]

  # Merge configurations, with deeper (more specific) configs overriding higher ones
  merged_config = merge(local.file_configs...)
}

# Pass the merged configuration to Terraform
inputs = local.merged_config
```

This configuration cascade enables:
- Environment-wide settings at higher levels
- Stack-specific overrides at lower levels
- DRY (Don't Repeat Yourself) infrastructure configuration

### 2. Remote State Management

For development, we use local state files:

```hcl
remote_state {
  backend = "local"
  config = {
    path = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/terraform.tfstate"
  }

  # Auto-generate a backend.tf file
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}
```

For production environments, it's recommended to use remote state with locking:

```hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "terraform-states-us-east-1-385940"
    region  = "us-east-1"
    encrypt = true

    dynamodb_table = "terraform-states-us-east-1-385940-locks"
    key            = "${dirname(local.relative_deployment_path)}/${local.stack}.tfstate"

    # IAM Role Configuration
    role_arn = "arn:aws:iam::xxxxxxxxxxx:role/cicd_proof_role"
  }
}
```

### 3. Module Sourcing

Terragrunt automatically locates the correct Terraform modules:

```hcl
terraform {
  source = "${local.root_deployments_dir}/..//modules/stacks/${local.stack}"
}
```
----------

## Setup Environment
Ensure that you have sudo or administrator privileges before setting up the environment.

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
Set up Ingress on Minikube with the NGINX Ingress Controller
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
```
tar -zxvf helm-v3.0.0-linux-amd64.tar.gz
```
4.  Move the binary to a directory in **PATH**:
```
mv linux-amd64/helm /usr/local/bin/helm
```

-   **Version used in this project:** `3.12.3`

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

### DNS Record
Add DNS record to your local hosts file

```
echo "127.0.0.1 s-myapp.local" | sudo tee -a /etc/hosts
```

```
echo "127.0.0.1 p-myapp.local" | sudo tee -a /etc/hosts
```

### Minikube Tunnel

Tunnel creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP

```
minikube tunnel
```

### Test Access

Production environment:

Open you browser and navigate to http://p-myapp.local

Staging environment:

Open you browser and navigate to http://s-myapp.local

### Cleanup project
```
cd deployments/<environment-name>/web-application
```


```
terragrunt destroy
```

## Advanced Usage

### Adding New Environments

To add a new environment (e.g., staging, production):
1. Create a new directory under `deployments/`
2. Add environment-specific `config.yml` file with common variables
3. Create stack subdirectories as needed

### Adding New Stacks

To add a new stack type:
1. Create the module under `modules/stacks/[new-stack]`
2. Create deployment directories as needed
3. Ensure `terragrunt.hcl` files reference the root configuration

## Best Practices

1. **Environment Variables**: Define environment-wide settings (like AWS region) in environment-level `config.yml` files.
2. **State Management**: Use remote state backends with locking for production environments.
3. **Module Versioning**: Consider pinning module versions in production deployments.
4. **Variable Documentation**: Document expected variables in each module's README.


