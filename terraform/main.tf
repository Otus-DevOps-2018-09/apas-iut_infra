provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata" "default" {
  #Add project level ssh public key
  metadata {
    ssh-keys = "appuser1:${file(var.public_key_path)} appuser2:${file(var.public_key_path)} appuser3:${file(var.public_key_path)}"
  }
}

resource "google_compute_instance" "app" {
  name         = "reddit-app${count.index+1}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]
  count        = "${var.vm_instances_number}"

  # set public key
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  # set boot disk
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # set network interface
  network_interface {
    # network to connect interface to
    network = "default"

    # use ephemeral IP for access from Internet
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Name of the network where rule is active
  network = "default"

  # Allowed type of access
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Allowed addresses
  source_ranges = ["0.0.0.0/0"]

  # Rule is applicable for the instances with folowing tags
  target_tags = ["reddit-app"]
}
