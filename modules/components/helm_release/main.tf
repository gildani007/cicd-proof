# main.tf

resource "helm_release" "helm_resource" {
  name       = var.release_name
  namespace  = var.namespace
  chart      = var.chart
  values     = [yamlencode(var.values)]
}

