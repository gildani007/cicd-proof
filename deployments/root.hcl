# Root-level Terragrunt configuration file (root.hcl)
# This file defines various local variables, remote state configuration,
# and Terraform module sources for managing infrastructure deployments.

locals {
  # Get the parent directory where Terragrunt is executed
  root_deployments_dir = get_parent_terragrunt_dir()

  # Get the relative path between the current terragrunt.hcl file and the path specified in its include block
  relative_deployment_path = path_relative_to_include()
  
  # Split the relative path into its components for further processing
  deployment_path_components = compact(split("/", local.relative_deployment_path))

  # Extract the stack name from the deployment path
  # Assumes the stack name is the second component of the path (e.g., `production/web-application` → `web-application`)
  stack = local.deployment_path_components[1]

  # Generate a list of possible configuration directories
  # This includes every directory from root_deployments_dir to the current deployment path
  possible_config_dirs = [
    for i in range(0, length(local.deployment_path_components) + 1) :
    join("/", concat(
      [local.root_deployments_dir],
      slice(local.deployment_path_components, 0, i)
    ))
  ]

  # Generate a list of possible YAML configuration file paths
  # This supports both .yml and .yaml file extensions
  possible_config_paths = flatten([
    for dir in local.possible_config_dirs : [
      "${dir}/config.yml",
      "${dir}/config.yaml"
    ]
  ])

  # Load all existing YAML configuration files and convert them to an HCL map
  file_configs = [
    for path in local.possible_config_paths :
    yamldecode(file(path)) if fileexists(path)
  ]

  # Merge all loaded configuration maps, where deeper configurations override higher ones
  merged_config = merge(local.file_configs...)
}

# Pass the merged configuration to Terraform as environment variables prefixed with TF_VAR_
inputs = local.merged_config

# Define remote state configuration
remote_state {
  backend = "local" # Using local backend for state storage
  config = {
    path = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/terraform.tfstate"
  }

  # Auto-generate a backend.tf file for Terraform to configure the backend
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

# Define Terraform source path for the stack module
terraform {
  source = "${local.root_deployments_dir}/..//modules/stacks/${local.stack}"
}