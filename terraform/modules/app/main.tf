resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # set public key
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  # set boot disk
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  # set network interface
  network_interface {
    # network to connect interface to
    network = "default"

    # use ephemeral IP for access from Internet
    access_config {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }
}

# External IP address of the instance
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

# Set firewall rule for instance access
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Name of the network where rule is active
  network = "default"

  # Allowed type of access
  allow {
    protocol = "tcp"
    ports    = "${var.fw_app_port}"
  }

  # Allowed addresses
  source_ranges = ["0.0.0.0/0"]

  # Rule is applicable for the instances with folowing tags
  target_tags = ["reddit-app"]
}
