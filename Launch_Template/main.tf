resource "aws_launch_template" "My_LT" {
    name = "My-LT"
    description = "My Application Launch Template"

    image_id = var.ami
    instance_type = var.instance_type
    key_name = "karthik"
    
    network_interfaces {
        associate_public_ip_address = true
        subnet_id = var.public_subnet_ids[0]
        security_groups = [var.public_security_group_id]
    }

    block_device_mappings {
        device_name = "/dev/xvda"
        ebs {
            volume_size = 8
            volume_type = "gp2"
            delete_on_termination = true
        }
    }

    user_data = base64encode(<<EOF
#!/bin/bash
# Use this for your user data (script from top to bottom)
# Install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF
    )
}

output "launch_template_id" {
    value = aws_launch_template.My_LT.id
}