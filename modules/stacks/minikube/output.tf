output "client_certificate" {
  description = "client certificate used in cluster"
  sensitive = true
  value = minikube_cluster.docker.client_certificate
}

output "client_key" {
  description = "client key for cluster"
  sensitive = true
  value = minikube_cluster.docker.client_key
}

output "cluster_ca_certificate" {
  description = "certificate authority for cluster"
  sensitive = true
  value = minikube_cluster.docker.cluster_ca_certificate
}

output "host" {
  description = "the host name for the cluster"
  value = minikube_cluster.docker.host
}