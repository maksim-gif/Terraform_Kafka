resource "vkcs_networking_secgroup" "kafka_secgroup" {
  name        = "kafka-secgroup-${var.lastname}"
  description = "Security group for Kafka VM"
}

resource "vkcs_networking_secgroup_rule" "ssh_ingress" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.kafka_secgroup.id
  # ethertype удален - теперь по умолчанию IPv4
}

resource "vkcs_networking_secgroup_rule" "kafka_ingress" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 29092
  port_range_max    = 29092
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.kafka_secgroup.id
}

resource "vkcs_networking_secgroup_rule" "zookeeper_ingress" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22181
  port_range_max    = 22181
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.kafka_secgroup.id
}

resource "vkcs_networking_secgroup_rule" "icmp_ingress" {
  direction         = "ingress"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.kafka_secgroup.id
}
