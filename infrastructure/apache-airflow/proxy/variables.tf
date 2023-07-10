variable "machine" {
    type = object({
      micro = string
      small = string
    })
}

variable "zone" {
    type = object({
      default = string
      alternative = string
      alternative1 = string
    })
}

variable "image" {
    type = string
    description = "VM OS system image"
}

variable "vpc_network_name" {
    type = string
}

variable "frontend_instance_address" {
    type = string
}