resource "azurerm_lb_rule" "concourse-uaa" {
  name                = "${var.env_id}-concourse-uaa"
  resource_group_name = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id     = "${azurerm_lb.concourse.id}"

  frontend_ip_configuration_name = "${var.env_id}-concourse-frontend-ip-configuration"
  protocol                       = "TCP"
  frontend_port                  = 8443
  backend_port                   = 8443

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.concourse.id}"
  probe_id                = "${azurerm_lb_probe.concourse-uaa.id}"
}

resource "azurerm_lb_probe" "concourse-uaa" {
  name                = "${var.env_id}-concourse-uaa"
  resource_group_name = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id     = "${azurerm_lb.concourse.id}"
  protocol            = "TCP"
  port                = 8443
}

resource "azurerm_lb_rule" "concourse-credhub" {
  name                = "${var.env_id}-concourse-credhub"
  resource_group_name = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id     = "${azurerm_lb.concourse.id}"

  frontend_ip_configuration_name = "${var.env_id}-concourse-frontend-ip-configuration"
  protocol                       = "TCP"
  frontend_port                  = 8844
  backend_port                   = 8844

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.concourse.id}"
  probe_id                = "${azurerm_lb_probe.concourse-credhub.id}"
}

resource "azurerm_lb_probe" "concourse-credhub" {
  name                = "${var.env_id}-concourse-credhub"
  resource_group_name = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id     = "${azurerm_lb.concourse.id}"
  protocol            = "TCP"
  port                = 8844
}

resource "azurerm_network_security_rule" "uaa" {
  name                        = "${var.env_id}-uaa"
  priority                    = 205
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.bosh.name}"
  network_security_group_name = "${azurerm_network_security_group.bosh.name}"
}
