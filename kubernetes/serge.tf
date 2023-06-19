resource "kubernetes_namespace" "serge_ai" {
  depends_on = [
    time_sleep.wait_for_kubernetes
  ]

  metadata {
    name = "serge-ai"
  }
}

resource "kubernetes_service" "serge_ai_svc" {
  metadata {
    name      = "serge-ai-svc"
    namespace = "serge-ai"

    labels = {
      app = "serge"
    }
  }

  spec {
    selector = {
      app = "serge"
    }

    port {
      name       = "8008"
      port       = 8008
      target_port = 8008
    }

    port {
      name       = "9124"
      port       = 9124
      target_port = 9124
    }
  }
}

resource "kubernetes_deployment" "serge" {
  depends_on = [
    time_sleep.wait_for_ingress_controller,
    kubernetes_namespace.serge_ai
  ]
  metadata {
    name      = "serge"
    namespace = "serge-ai"

    labels = {
      app = "serge"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "serge"
      }
    }

    template {
      metadata {
        labels = {
          app = "serge"
        }
      }

      spec {
        container {
          name  = "serge"
          image = "ghcr.io/nsarrazin/serge:main"

          port {
            container_port = 8008
          }

          port {
            container_port = 9124
          }

          resources {
            requests = {
              cpu    = "1000m"
              memory = "2048Mi"
            }

            limits = {
              cpu    = "3000m"
              memory = "6144Mi"
            }
          }

          volume_mount {
            name       = "datadb"
            mount_path = "/data/db"
          }

          volume_mount {
            name       = "weights"
            mount_path = "/usr/src/app/weights"
          }
        }

        restart_policy = "Always"

        volume {
          name = "datadb"

          persistent_volume_claim {
            claim_name = "datadb"
          }
        }

        volume {
          name = "weights"

          persistent_volume_claim {
            claim_name = "weights"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "weights" {
  depends_on = [
    kubernetes_storage_class.do_spaces_storage_class,
    kubernetes_namespace.serge_ai
  ]
  metadata {
    name      = "weights"
    namespace = "serge-ai"

    labels = {
      app = "serge"
    }
  }

  spec {
    storage_class_name = "do-spaces-storage-class"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "64Gi"
      }
    }
  }
}


resource "kubernetes_persistent_volume_claim" "datadb" {
  depends_on = [
    kubernetes_storage_class.do_spaces_storage_class,
    kubernetes_namespace.serge_ai
  ]
  metadata {
    name      = "datadb"
    namespace = "serge-ai"

    labels = {
      app = "serge"
    }
  }

  spec {
    storage_class_name = "do-spaces-storage-class"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "16Gi"
      }
    }
  }
}

resource "kubernetes_ingress_v1" "serge_ai_ingress" {
  depends_on = [
    time_sleep.wait_for_ingress_controller,
    kubernetes_namespace.serge_ai
  ]
  metadata {
    name      = "serge-ai-ingress"
    namespace = "serge-ai"
    
    annotations = {
      "cert-manager.io/cluster-issuer"   = "letsencrypt-prod"

      "haproxy.org/cors-allow-methods"  = "PUT, GET, POST, OPTIONS, DELETE"
    }
  }
  
  spec {
    ingress_class_name = "haproxy"
    rule {
      host = "chat.${var.domain}"
      
      http {
        path {
          path     = "/"
          
          backend {
            service {
              name = kubernetes_service.serge_ai_svc.metadata.0.name
              port {
                number = 8008
              }
            }
          }
        }
      }
    }
    
    tls {
      hosts       = ["chat.${var.domain}"]
      secret_name = "serge-tls"
    }
  }
}

data "kubernetes_service_v1" "serge_ai_ingress" {
  depends_on = [
    time_sleep.wait_for_ingress_controller
  ]
  metadata {
    name = "haproxy-controller-kubernetes-ingress"
    namespace = "haproxy-controller"
  }
}

resource "digitalocean_record" "chat" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "chat"
  value  = data.kubernetes_service_v1.serge_ai_ingress.status.0.load_balancer.0.ingress.0.ip
}
