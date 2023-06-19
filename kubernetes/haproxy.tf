resource "kubernetes_namespace" "haproxy_controller" {
  depends_on = [
    time_sleep.wait_for_cert_manager
  ]

  metadata {
    name = "haproxy-controller"
  }
}

resource "helm_release" "haproxy_controller" {
  depends_on = [
    kubernetes_namespace.haproxy_controller
  ]

  name      = "haproxy-controller"
  namespace = "haproxy-controller"

  repository = "https://haproxytech.github.io/helm-charts"
  chart      = "kubernetes-ingress"

# Configure the DigitalOcean load balancer
  values = [<<EOT
controller:
  replicaCount: 1
  ingressClassResource:
    default: true
  configAnnotations:
    syslog-server: "address:stdout, format: raw, facility:daemon"
  logging:
    level: debug
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/do-loadbalancer-name: "${var.domain}"
      service.beta.kubernetes.io/do-loadbalancer-protocol: "http2"
      service.beta.kubernetes.io/do-loadbalancer-tls-ports: "443"
      service.beta.kubernetes.io/do-loadbalancer-tls-passthrough: "true"
    loadBalancerIP: null
EOT
  ]
}

resource "time_sleep" "wait_for_ingress_controller" {

  depends_on = [
    helm_release.haproxy_controller
  ]

  create_duration = "30s"
}
