variable "username" {
  type        = string
  description = "OpenStack username"
}

variable "password" {
  type        = string
  description = "OpenStack password"
  sensitive   = true
}

variable "project_id" {
  type        = string
  description = "OpenStack project ID"
}

variable "region" {
  type        = string
  description = "OpenStack region"
  default     = "RegionOne"
}

variable "vkcs_auth_url" {
  type        = string
  description = "OpenStack auth URL"
  default     = "https://infra.mail.ru:35357/v3/"
}

variable "compute_flavor" {
  type    = string
  default = "STD2-2-4"
}

variable "key_pair_name" {
  type    = string
  default = "keypair-terraform"
}

variable "availability_zone_name" {
  type    = string
  default = "MS1"
}

variable "lastname" {
  type    = string
  default = "Panyutin"
}
