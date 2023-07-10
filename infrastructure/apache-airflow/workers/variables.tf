variable "machine" {
    type = object({
      micro = string
      small = string
    })
}

variable "zone" {
    type = string
}

variable "instance_name" {
    type = string
}

variable "image" {
    type = string
    description = "VM OS system image"
}

variable "vpc_network_name" {
    type = string
}

variable "backend_instance_address" {
    type = string
}