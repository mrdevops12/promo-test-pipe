resource "null_resource" "wait_for_alb_controller" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for ALB controller pod to become Ready..."
      kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=aws-load-balancer-controller -n kube-system --timeout=300s
    EOT
  }

  depends_on = [helm_release.alb_controller]
}

