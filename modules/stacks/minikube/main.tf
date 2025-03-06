
resource "minikube_cluster" "docker" {
  driver       = var.driver
  cluster_name = var.cluster_name
  addons = var.addons
}