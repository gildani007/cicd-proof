variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version that the minikube VM will use (ex: v1.2.3, 'stable' for v1.30.0, 'latest' for v1.30.0). Defaults to 'stable'."
}

variable "driver" {
  type        = string
  description = "Driver is one of the following - Windows: (hyperv, docker, virtualbox, vmware, qemu2, ssh)"
}


variable "cluster_name" {
  type        = string
  description = "The name of the minikube cluster"
}

variable "addons" {
  description = "List of addons to create"
  type        = list(string)
  default     = []
}
