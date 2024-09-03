locals {
        ingress_rules = [
            {
                from_port =80
                to_port= 80
                //description = "HTTP"
            },
            {
                from_port =443
                to_port= 443
                //description = "HTTPS"
            },
            {
                from_port =1024
                to_port= 65535
                //description = "Ephimeral ports needs to be opened"
            }
            
        ]
        egress_rules = [
            {
                from_port =80
                to_port= 80
                //description = "HTTP"
            },
            {
                from_port =443
                to_port= 443
                //description = "HTTPS"
            },
            {
                from_port =1024
                to_port= 65535
                //description = "Ephimeral ports needs to be opened"
            }
        ]
}

resource "aws_network_acl" "my_custom_vpc_public_NACL" {
    vpc_id      = var.vpc_id
    tags = {
        Name = "my_custom_vpc_public_NACL"
    }
    # Inbound Rules

    ingress {
        rule_no       = 100
        protocol      = "tcp"
        action        = "allow"
        cidr_block    = "217.8.17.66/32"
        from_port     = 22
        to_port       = 22
    }

    dynamic "ingress" {
    for_each = local.ingress_rules
    content {
        rule_no       = 200 + ingress.key
        protocol      = "tcp"
        action        = "allow"
        cidr_block    = "0.0.0.0/0"
        from_port     = ingress.value.from_port
        to_port       = ingress.value.to_port
        }
    }

    # Outbound Rules
    dynamic "egress" {
        for_each = var.private_subnet_cidr_block//aws_subnet.private_subnet

        content {
            rule_no       = 100 + egress.key
            protocol      = "tcp"
            action        = "allow"
            cidr_block    = egress.value
            from_port     = 22
            to_port       = 22
        }
    }

    dynamic "egress" {
    for_each = local.egress_rules
    content {
        rule_no       = 200 + egress.key
        protocol      = "tcp"
        action        = "allow"
        cidr_block    = "0.0.0.0/0"
        from_port     = egress.value.from_port
        to_port       = egress.value.to_port
        }
    }
    
}

resource "aws_network_acl_association" "my_custom_vpc_public_NACL" {
    network_acl_id = aws_network_acl.my_custom_vpc_public_NACL.id
    count = length(var.public_subnet_ids)
    subnet_id = var.public_subnet_ids[count.index]
}

resource "aws_default_network_acl" "default" {
    default_network_acl_id = var.default_network_acl_id
    count       = length(var.private_subnet_ids)
    tags = {
        Name = "my_custom_vpc_private_NACL"
    }

    dynamic "ingress" {
        for_each = var.public_subnet_cidr_block

        content {
            rule_no       = 100 + ingress.key
            protocol      = "tcp"
            action        = "allow"
            cidr_block    = ingress.value
            from_port     = 22
            to_port       = 22
        }
    }

    dynamic "ingress" {
        for_each = var.public_subnet_cidr_block

        content {
            rule_no       = 200 + ingress.key
            protocol      = "tcp"
            action        = "allow"
            cidr_block    = ingress.value
            from_port     = 3306
            to_port       = 3306
        }
    }

    ingress {
        rule_no       = 300
        protocol      = "tcp"
        action        = "allow"
        cidr_block    = "0.0.0.0/0"
        from_port     = 1024
        to_port       = 65535
    }

    # Define outbound rules



    dynamic "egress" {
        for_each = var.public_subnet_cidr_block

        content {
            rule_no       = 100 + egress.key
            protocol      = "tcp"
            action        = "allow"
            cidr_block    = egress.value
            from_port     = 22
            to_port       = 22
        }
    }



    dynamic "egress" {
        for_each = var.public_subnet_cidr_block

        content {
            rule_no       = 200 + egress.key
            protocol      = "tcp"
            action        = "allow"
            cidr_block    = egress.value
            from_port     = 3306
            to_port       = 3306
        }
    }
    egress {
        rule_no       = 300
        protocol      = "tcp"
        action        = "allow"
        cidr_block    = "0.0.0.0/0"  # Allow all outbound traffic for HTTP
        from_port     = 80
        to_port       = 80
    }

    egress {
        rule_no       = 400
        protocol      = "tcp"
        action        = "allow"
        cidr_block    = "0.0.0.0/0"  # Allow all outbound traffic for HTTPS
        from_port     = 443
        to_port       = 443
    }
    egress {
        rule_no       = 500
        protocol      = "tcp"
        action        = "allow"
        cidr_block    = "0.0.0.0/0"  # Allow all outbound traffic
        from_port     = 1024
        to_port       = 65535
    }
}