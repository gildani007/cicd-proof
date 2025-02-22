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
  type        = any
  description = "Helm values as a map"
}

