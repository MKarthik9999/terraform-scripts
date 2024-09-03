resource "aws_security_group" "Web_server_SG" {
    name        = "EC2-webserver-SG-1"
    description = "Security Group for EC2 Instances"
    vpc_id = var.vpc_id
    ingress {
        from_port   = 80
        protocol    = "TCP"
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]   # allowing internet traffic to reach from internet
    }

    ingress {
        from_port   = 22
        protocol    = "TCP"
        to_port     = 22
        cidr_blocks = ["217.8.17.66/32"]  #Provide the Ip address from which Ip we want to SSH
    }

    egress {
        from_port   = 0
        protocol    = "-1"
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "Private_server_SG" {
    name        = "Private-webserver-SG-1"
    description = "Security Group for Private Instances"
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.public_subnet_ids

        content {
            protocol      = "tcp"
            cidr_blocks    = var.public_subnet_cidr_block
            from_port     = 22
            to_port       = 22
        }
    }

    dynamic "ingress" {
        for_each = var.public_subnet_ids

        content {
            protocol      = "tcp"
            cidr_blocks    = var.public_subnet_cidr_block
            from_port     = 3306
            to_port       = 3306
        }
    }

    egress {
        from_port   = 0
        protocol    = "-1"
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "public_security_group" {
    value = aws_security_group.Web_server_SG.id
}

output "private_security_group" {
    value = aws_security_group.Private_server_SG.id
}