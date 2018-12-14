output "vpc_source_ranges" {
  value = "${google_compute_firewall.firewall_ssh.source_ranges}"
}
