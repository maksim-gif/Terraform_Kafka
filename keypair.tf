resource "vkcs_compute_keypair" "kafka_keypair" {
  name       = "keypair-terraform"
  public_key = file("~/.ssh/id_rsa.pub") # Укажите путь к вашему публичному ключу
}
