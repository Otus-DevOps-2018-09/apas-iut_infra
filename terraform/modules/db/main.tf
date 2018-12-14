resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-db"]

  # set public key
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  # set boot disk
  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  # set network interface
  network_interface {
    # network to connect interface to
    network = "default"

    # use ephemeral IP for access from Internet
    access_config {}
  }
}

# Set firewall rule for db access
resource "google_compute_firewall" "firewall_mongo" {
  name = "allow-mongo-default"

  # Name of the network where rule is active
  network = "default"

  # Allowed type of access
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # Allowed source instances
  source_tags = ["reddit-app"]

  # Rule is applicable for the instances with folowing tags
  target_tags = ["reddit-db"]
}
