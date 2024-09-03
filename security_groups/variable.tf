variable "vpc_id" {
    type = string
}

variable "public_subnet_ids" {
    type    = list(string)
}

variable "public_subnet_cidr_block" {
    description = "all the public subnet cidr_blocks"
}