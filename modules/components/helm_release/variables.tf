variable "release_name" {
  type        = string
  description = "The Helm release name"
}

variable "namespace" {
  type        = string
  description = "The namespace for the Helm release"
}

variable "chart" {
  type        = string
  description = "The Helm chart path"
}

variable "values" {
  type        = any
  description = "Helm values as a map"
}

