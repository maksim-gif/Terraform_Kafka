data "vkcs_networking_network" "extnet" {
  name = "ext-net"
}

resource "vkcs_networking_network" "kafka_network" {
  name           = "kafka-network-${var.lastname}"
  admin_state_up = true
}

resource "vkcs_networking_subnet" "kafka_subnet" {
  name       = "kafka-subnet-${var.lastname}"
  network_id = vkcs_networking_network.kafka_network.id
  cidr       = "192.168.199.0/24"
  # ip_version удален - теперь по умолчанию IPv4
}

resource "vkcs_networking_router" "kafka_router" {
  name                = "kafka-router-${var.lastname}"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "kafka_interface" {
  router_id = vkcs_networking_router.kafka_router.id
  subnet_id = vkcs_networking_subnet.kafka_subnet.id
}
