terraform {
  required_version = "~> 1.4.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.27.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

data "digitalocean_kubernetes_cluster" "k8s_challenge_1" {
  depends_on = [
    time_sleep.wait_for_kubernetes
  ]
  name = "k8s-challenge-1"
}

variable "do_token" {
  type      = string
  sensitive = true
}

variable "do_spaces_access_id" {
  type = string
}

variable "do_spaces_secret_key" {
  type      = string
  sensitive = true
}

variable "do_spaces_endpoint" {
  type = string
}

provider "digitalocean" {
  token             = var.do_token
  spaces_access_id  = var.do_spaces_access_id
  spaces_secret_key = var.do_spaces_secret_key
  spaces_endpoint   = var.do_spaces_endpoint
}

provider "helm" {
  kubernetes {
    host = data.digitalocean_kubernetes_cluster.k8s_challenge_1.endpoint
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.k8s_challenge_1.kube_config[0].cluster_ca_certificate
    )

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "doctl"
      args = ["kubernetes", "cluster", "kubeconfig", "exec-credential",
      "--version=v1beta1", data.digitalocean_kubernetes_cluster.k8s_challenge_1.id]
    }
  }
}

provider "kubernetes" {
  host = data.digitalocean_kubernetes_cluster.k8s_challenge_1.endpoint
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.k8s_challenge_1.kube_config[0].cluster_ca_certificate
  )

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "doctl"
    args = ["kubernetes", "cluster", "kubeconfig", "exec-credential",
    "--version=v1beta1", data.digitalocean_kubernetes_cluster.k8s_challenge_1.id]
  }
}

provider "kubectl" {
  host = data.digitalocean_kubernetes_cluster.k8s_challenge_1.endpoint
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.k8s_challenge_1.kube_config[0].cluster_ca_certificate
  )

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "doctl"
    args = ["kubernetes", "cluster", "kubeconfig", "exec-credential",
    "--version=v1beta1", data.digitalocean_kubernetes_cluster.k8s_challenge_1.id]
  }
}
