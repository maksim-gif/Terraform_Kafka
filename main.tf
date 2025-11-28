data "vkcs_compute_flavor" "compute" {
  name = var.compute_flavor
}

# Используем ваш вариант поиска образа Ubuntu 22.04
data "vkcs_images_image" "compute" {
  visibility  = "public"
  most_recent = true
  properties = {
    mcs_os_distro  = "ubuntu"
    mcs_os_version = "22.04"
  }
}

resource "vkcs_compute_instance" "kafka_vm" {
  name              = "Ubuntu-${var.lastname}"
  flavor_id         = data.vkcs_compute_flavor.compute.id
  key_pair          = vkcs_compute_keypair.kafka_keypair.name  
  security_groups   = ["default", vkcs_networking_secgroup.kafka_secgroup.name]
  availability_zone = var.availability_zone_name

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 20
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.kafka_network.id
  }

  depends_on = [
    vkcs_networking_network.kafka_network,
    vkcs_networking_subnet.kafka_subnet,
    vkcs_networking_router_interface.kafka_interface
  ]
}

resource "vkcs_networking_floatingip" "kafka_fip" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "kafka_fip_assoc" {
  floating_ip = vkcs_networking_floatingip.kafka_fip.address
  instance_id = vkcs_compute_instance.kafka_vm.id
}

output "instance_fip" {
  description = "Floating IP address of the Kafka VM"
  value       = vkcs_networking_floatingip.kafka_fip.address
}

output "instance_name" {
  description = "Name of the created VM"
  value       = vkcs_compute_instance.kafka_vm.name
}

output "connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ubuntu@${vkcs_networking_floatingip.kafka_fip.address}"
}

# Дополнительный вывод для отладки
output "image_info" {
  description = "Information about the used image"
  value       = "Using image: ${data.vkcs_images_image.compute.name} (ID: ${data.vkcs_images_image.compute.id})"
}
