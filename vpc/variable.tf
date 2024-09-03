variable "my_custom_vpc_cidr_block" {
    description = "CIDR for my custom VPC"
    type = string
    default = "192.168.0.0/16"
}

variable "Availability_Zone" {
    description = "Information about the Availability Zone"
    type = list(string)
    default = ["eu-west-2a"]
}

variable "public_subnet_CIDRs" {
    description = "CIDRs for the public subnet"
    type = list(string)
    default = ["192.168.1.0/24"]
}

variable "private_subnet_CIDRs" {
    description = "CIDRs for the private subnet"
    type = list(string)
    default = []
}
