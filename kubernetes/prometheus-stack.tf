resource "kubernetes_namespace" "kube_prometheus_stack" {
  depends_on = [
    time_sleep.wait_for_ingress_controller
  ]

  metadata {
    name = "kube-prometheus-stack"
  }
}

variable "grafana_admin_password" {
  type = string
  sensitive = true
}

# resource "kubernetes_secret" "grafana_admin_password" {
#   metadata {
#     name = "grafana-admin-password"
#     namespace = "kube-prometheus-stack"
#   }
#   data = {
#     password = var.grafana_admin_password
#   }
#   type = "Opaque"
# }

resource "helm_release" "kube_prometheus_stack" {
  depends_on = [
    kubernetes_namespace.kube_prometheus_stack
  ]

  name      = "kube-prometheus-stack"
  namespace = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [<<EOT
grafana:
  adminPassword: ${var.grafana_admin_password}
  ingress:
    enabled: true
    annotations: {
      "cert-manager.io/cluster-issuer": "letsencrypt-prod",
      "haproxy.org/cors-allow-methods": "PUT, GET, POST, OPTIONS, DELETE"
    }
    hosts:
      - "grafana.${var.domain}"
    tls:
      - secretName: grafana-tls
        hosts:
        - "grafana.${var.domain}"
  ingressClassName: haproxy
  EOT
  ]
}

data "kubernetes_service_v1" "cluster_lb" {
  depends_on = [
    time_sleep.wait_for_ingress_controller
  ]
  metadata {
    name = "haproxy-controller-kubernetes-ingress"
    namespace = "haproxy-controller"
  }
}

resource "digitalocean_record" "grafana" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "grafana"
  value  = data.kubernetes_service_v1.cluster_lb.status.0.load_balancer.0.ingress.0.ip
}
