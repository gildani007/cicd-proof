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

variable "values" {
  type    = map(any)
  default = {
    key1 = "default_value1"
    key2 = "default_value2"
  }
}

variable "helm_values" {
  type        = any
  description = "Helm values as a map"
}

variable "environment_name" {
  description = "The target environment for the application"
  default     = "unset"
}