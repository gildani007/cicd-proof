include {
  path = find_in_parent_folders("root.hcl")
}

dependency "minikube" {
  config_path = "../../infra/minikube" # Path to the other module

  mock_outputs = {
    client_certificate = "mock_client_certificate_data" 
    client_key = "mock_client_key_data" 
    cluster_ca_certificate = "mock_cluster_ca_certificate_data"
    host = "mock_host_data"
  }
}

inputs = {
  client_certificate = dependency.minikube.outputs.client_certificate
  client_key = dependency.minikube.outputs.client_key
  cluster_ca_certificate = dependency.minikube.outputs.cluster_ca_certificate
  host = dependency.minikube.outputs.host
}
