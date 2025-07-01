resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "demo-monitoring"
  }
}

