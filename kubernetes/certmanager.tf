resource "kubernetes_namespace" "cert_manager" {

  depends_on = [
    time_sleep.wait_for_kubernetes
  ]

  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {

  depends_on = [
    kubernetes_namespace.cert_manager
  ]

  name      = "cert-manager"
  namespace = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  # Install Kubernetes CRDs
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "time_sleep" "wait_for_cert_manager" {

  depends_on = [
    helm_release.cert_manager
  ]

  create_duration = "10s"
}

resource "kubernetes_secret" "do_token" {
  metadata {
    name = "do-token"
    namespace = "cert-manager"
  }
  data = {
    token = var.do_token
  }
  type = "Opaque"
}

variable "admin_email" {
  type = string
}

# Create a ClusterIssuer
resource "kubectl_manifest" "letsencrypt_prod" {
  depends_on = [
    time_sleep.wait_for_cert_manager
  ]

  yaml_body = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    email: "${var.admin_email}"
    server: "https://acme-v02.api.letsencrypt.org/directory"
    privateKeySecretRef:
      name: "letsencrypt-prod"
    solvers:
    - selector: {}
      dns01:
        digitalocean:
          tokenSecretRef:
            name: "do-token"
            key: "token"
EOF
}

# resource "kubectl_manifest" "letsencrypt_staging" {
#   depends_on = [
#     time_sleep.wait_for_cert_manager
#   ]

#   yaml_body = <<EOF
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: letsencrypt-staging
#   namespace: cert-manager
# spec:
#   acme:
#     email: "${var.admin_email}"
#     server: "https://acme-staging-v02.api.letsencrypt.org/directory"
#     privateKeySecretRef:
#       name: "letsencrypt-staging"
#     solvers:
#     - selector: {}
#       http01:
#         ingress:
#           class: "haproxy"
# EOF
# }

resource "time_sleep" "wait_for_clusterissuer" {

  depends_on = [
    kubectl_manifest.letsencrypt_prod
  ]

  create_duration = "30s"
}
