resource "google_compute_forwarding_rule" "credhub-forwarding-rule" {
  name        = "${var.env_id}-concourse-credhub"
  target      = "${google_compute_target_pool.target-pool.self_link}"
  port_range  = "8844"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.concourse-address.address}"
}

resource "google_compute_forwarding_rule" "uaa-forwarding-rule" {
  name        = "${var.env_id}-concourse-uaa"
  target      = "${google_compute_target_pool.target-pool.self_link}"
  port_range  = "8443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.concourse-address.address}"
}
