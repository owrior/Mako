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

variable "webserver" {
    type = object({
      firstname = string
      lastname = string
      username = string
      password = string
      email = string
      role = string
    })
}

variable "vpc_network_name" {
    type = string
}