variable "ami" {
    description = "Amazon Machine Image"
    type = string
    default = "ami-027d95b1c717e8c5d"
}

variable "instance_type" {
    description = "Amazon Machine Image Instance Type"
    type = string
    default = "t2.micro"
}

variable "public_subnet_ids" {
    description = "My custom VPC subnet ID's"
    type    = list(string)
}

variable "public_security_group_id" {
    description = "My public Security Group ID"
}

variable "private_security_group_id" {
    description = "My private Security Group ID"
}