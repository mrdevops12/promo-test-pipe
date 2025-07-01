resource "helm_release" "prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "56.6.2"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false

  values = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.monitoring]
}

