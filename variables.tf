variable "pve_config" {
  type = map(object({
      endpoint = string
      username = string
      password = string
      node_name = string
    }))
  description = "Proxmox VE connection configuration"
}

#variable "pve_endpoint" {
#  type = string
#  default = "https://192.168.88.2:8006/"
#}
#
#variable "pve_username" {
#  type = string
#  default = "root@pam"
#}
#
#variable "pve_password" {
#  type = string
#  sensitive = true
#}
