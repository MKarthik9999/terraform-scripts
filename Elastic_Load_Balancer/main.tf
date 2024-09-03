resource "aws_elb" "My-Elastic-Load-Balancer" {
    name = "My-Elastic-Load-Balancer"
    subnets = var.public_subnet_ids
    cross_zone_load_balancing = true
    connection_draining       = true
    connection_draining_timeout = 120
    security_groups = [var.public_security_group_id]
    listener {
        instance_port     = 80
        instance_protocol = "HTTP"
        lb_port           = 80
        lb_protocol       = "HTTP"
    }

    health_check {
        target              = "HTTP:80/index.html"
        interval            = 30
        timeout             = 5
        unhealthy_threshold = 2
        healthy_threshold   = 10
    }

    tags = {
        Name = "My-Classic-ELB"
    }
}

output "My-Load_Balancer_name" {
    value = aws_elb.My-Elastic-Load-Balancer.name
}