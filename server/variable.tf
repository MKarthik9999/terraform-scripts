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
  type    = list(string)
  # Add any additional constraints if necessary
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_cidr_block" {
  description = "all the public subnet cidr_blocks"
}

variable "public_security_group_id" {
  
}

variable "private_security_group_id" {
  
}
