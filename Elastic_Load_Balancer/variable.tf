variable "public_subnet_ids" {
    type    = list(string)
}

variable "public_security_group_id" {
}

variable "vpc_id" {
    type = string
}

variable "Availability_Zone" {
    type = list(string)
}
