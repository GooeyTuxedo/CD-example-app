# Kubernetes Cluster

data "digitalocean_sizes" "main" {
  filter {
    key    = "slug"
    values = ["s-4vcpu-8gb"]
  }
}

data "digitalocean_kubernetes_versions" "main" {
  version_prefix = "1.26."
}

resource "digitalocean_tag" "k8s_challenge" {
  name = "k8s-challenge"
}

resource "digitalocean_tag" "k8s_worker" {
  name = "k8s-worker"
}

resource "kubernetes_secret" "do_spaces_creds" {
  metadata {
    name = "do-spaces-creds"
    namespace = "kube-system"
  }

  data = {
    access-key-id     = base64encode(var.do_spaces_access_id)
    secret-access-key = base64encode(var.do_spaces_secret_key)
  }
}

resource "digitalocean_spaces_bucket" "k8s_bucket" {
  name   = "k8s-pretty-bucket"
  region = "sfo3"
}

resource "kubernetes_storage_class" "do_spaces_storage_class" {
  depends_on = [
    time_sleep.wait_for_kubernetes
  ]

  metadata {
    name = "do-spaces-storage-class"
  }

  storage_provisioner   = "dobs.csi.digitalocean.com"
  parameters            = {
    bucket              = digitalocean_spaces_bucket.k8s_bucket.name
    region              = digitalocean_spaces_bucket.k8s_bucket.region
    endpoint            = "https://${digitalocean_spaces_bucket.k8s_bucket.region}.digitaloceanspaces.com"
    access-key-id       = kubernetes_secret.do_spaces_creds.data.access-key-id
    secret-access-key   = kubernetes_secret.do_spaces_creds.data.secret-access-key
    signature-version   = "2"
    object-acl          = "private"
    caching             = "true"
    sse                 = "true"
    sse-kms-key-id      = "KMS_KEY_ID"
    sse-customer-key    = "CUSTOMER_KEY"
    sse-customer-key-md5= "CUSTOMER_KEY_MD5"
  }

  reclaim_policy = "Retain"
}

resource "digitalocean_project" "k8s_challenge_1" {
  name        = "k8s-challenge-1"
  description = "A project for exploring provisioning a kubernetes cluster with Terraform."
  purpose     = "Web Application"
  environment = "Development"
  is_default  = true
}

variable "domain" {
  type = string
}

resource "digitalocean_domain" "default" {
  name = var.domain
}

resource "digitalocean_vpc" "k8s_challenge_vpc" {
  name     = "k8s-challenge-vpc"
  region   = "sfo3"
  ip_range = "10.10.10.0/24"
}

resource "digitalocean_kubernetes_cluster" "k8s_challenge_1" {
  name     = "k8s-challenge-1"
  region   = "sfo3"
  version  = data.digitalocean_kubernetes_versions.main.latest_version
  vpc_uuid = digitalocean_vpc.k8s_challenge_vpc.id
  tags     = [digitalocean_tag.k8s_challenge.id]

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "worker-pool"
    size       = element(data.digitalocean_sizes.main.sizes, 0).slug
    node_count = 1

    tags = [digitalocean_tag.k8s_worker.id]
  }
}

variable "admin_public_ip" {
  type = string
}

resource "digitalocean_firewall" "k8s_challenge_fw" {
  name = "k8s-challenge-fw"

  tags = [digitalocean_tag.k8s_challenge.id]

  inbound_rule {
    protocol              = "tcp"
    port_range            = "6443"
    source_addresses      = [var.admin_public_ip]
    source_kubernetes_ids = [digitalocean_kubernetes_cluster.k8s_challenge_1.id]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "time_sleep" "wait_for_kubernetes" {

  depends_on = [
    digitalocean_kubernetes_cluster.k8s_challenge_1
  ]

  create_duration = "20s"
}

