variable "vpc_id" {
    type = string
}

variable "public_subnet_ids" {
    type    = list(string)
}

variable "public_subnet_cidr_block" {
    description = "all the public subnet cidr_blocks"
}

variable "private_subnet_cidr_block" {
    description = "all the private subnet cidr_blocks"
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "default_network_acl_id" {
    description = "default network access controller id for our custom vpc"
}