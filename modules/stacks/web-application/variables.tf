variable "release_name" {
  type        = string
  description = "The Helm release name"
  default     = "unset"
}

variable "namespace" {
  type        = string
  description = "The namespace for the Helm release"
  default     = "unset"
}

variable "chart" {
  type        = string
  description = "The Helm chart path"
  default     = "unset"
}

variable "helm_values" {
  type        = any
  description = "Helm values as a map"
}

variable "environment_name" {
  description = "The target environment for the application"
  default     = "unset"
}