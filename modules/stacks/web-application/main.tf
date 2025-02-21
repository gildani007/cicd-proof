resource "kubernetes_namespace" "web-application-namespace" {
  metadata {
    name = "${var.namespace}-${var.environment_name}"
  }
}

module "helm_release" {
  source = "../../components/helm_release"

  release_name  = var.release_name
  namespace     = kubernetes_namespace.web-application-namespace.metadata[0].name
  chart         = var.chart
  values        = var.helm_values

}
