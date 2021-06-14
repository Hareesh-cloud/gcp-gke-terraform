resource "google_container_cluster" "default" {
  name        = var.name
  project     = var.project
  description = "Demo GKE Cluster"
  location    = var.location

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "default" {
  name       = "${var.name}-node-pool"
  project    = var.project
  location   = var.location
  cluster    = google_container_cluster.default.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
# Create build and run
resource "kubernetes_service" "vault-lb" {
  metadata {
    name = "vault"
    labels = {
      app = "vault"
    }
  }

  spec {
    type                        = "LoadBalancer"
    load_balancer_ip            = google_compute_address.vault.address
    load_balancer_source_ranges = var.vault_source_ranges
    external_traffic_policy     = "Local"

    selector = {
      app          = "vault"
      vault-active = "true"
    }

    port {
      name        = "vault-port"
      port        = 443
      target_port = 8200
      protocol    = "TCP"
    }
  }
}

