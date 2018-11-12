# Creates Global External HTTP Load Balancer
# Usefull links:
#   https://cloud.google.com/community/tutorials/modular-load-balancing-with-terraform
#   https://cloud.google.com/load-balancing/docs/https/
#   https://github.com/GoogleCloudPlatform/terraform-google-lb-http

# Global forwarding rules route traffic by IP address to a load balancing configuration
# consisting of: target proxy, URL map, and one or more backend services.
resource "google_compute_global_forwarding_rule" "reddit-lb" {
  name       = "reddit-forwarding-rule"
  target     = "${google_compute_target_http_proxy.reddit-proxy.self_link}"
  port_range = "80"
}

# Target proxies terminate HTTP(S) connections from clients.
# Used by Global forwarding rules.
resource "google_compute_target_http_proxy" "reddit-proxy" {
  name    = "reddit-http-proxy"
  url_map = "${google_compute_url_map.reddit-urlmap.self_link}"
}

# URL maps define matching patterns for URL-based routing of requests to the appropriate backend services.
# Used by Target proxies.
resource "google_compute_url_map" "reddit-urlmap" {
  name        = "reddit-url-map"
  description = "Reddit application URL map"

  default_service = "${google_compute_backend_service.reddit-backend.self_link}"
}

# Backend service direct incoming traffic to one or more attached backends.
# Used by URL maps.
resource "google_compute_backend_service" "reddit-backend" {
  name        = "reddit-backend-service"
  description = ""
  port_name   = "puma"
  protocol    = "HTTP"
  timeout_sec = 4
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.reddit-app.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.reddit-health-check.self_link}"]
}

# HttpHealthCheck resource defines how individual VMs should be checked for health, via HTTP.
# Used by Backend service.
resource "google_compute_http_health_check" "reddit-health-check" {
  name         = "reddit-health-check"
  request_path = "/"

  timeout_sec        = 1
  check_interval_sec = 1

  port = 9292
}

# Group of Instances (described in main.tf).
# Used by Backend service.
resource "google_compute_instance_group" "reddit-app" {
  name        = "reddit-servers-group"
  description = "Reddit application instance group"

  instances = ["${google_compute_instance.app.*.self_link}"]

  named_port {
    name = "puma"
    port = "9292"
  }

  zone = "${var.zone}"
}
