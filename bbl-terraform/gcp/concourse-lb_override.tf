resource "google_compute_firewall" "firewall-concourse" {
  name    = "${var.env_id}-concourse-open"
  network = "${google_compute_network.bbl-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "2222", "8443", "8844"]
  }

  target_tags = ["concourse"]
}
