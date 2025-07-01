resource "kubernetes_ingress_v1" "monitoring_ingress" {
  metadata {
    name      = "monitoring-ingress"
    namespace = "demo-monitoring"

    annotations = {
      "alb.ingress.kubernetes.io/scheme"                   = "internal"
      "alb.ingress.kubernetes.io/target-type"              = "ip"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/load-balancer-attributes" = "idle_timeout.timeout_seconds=60"
      "alb.ingress.kubernetes.io/group.name"               = "monitoring"
      "alb.ingress.kubernetes.io/group.order"              = "10"
      "alb.ingress.kubernetes.io/subnets"                  = join(",", local.private_subnet_ids)
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/grafana"
          path_type = "Prefix"
          backend {
            service {
              name = "kube-prometheus-stack-grafana"
              port {
                number = 80
              }
            }
          }
        }

        path {
          path      = "/prometheus"
          path_type = "Prefix"
          backend {
            service {
              name = "kube-prometheus-stack-prometheus"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.prometheus_stack,
    null_resource.wait_for_alb_controller,
    aws_ec2_tag.internal_elb_tag,
    aws_ec2_tag.cluster_tag
  ]
}

