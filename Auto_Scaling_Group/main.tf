resource "aws_autoscaling_group" "My-ASG" {
    name = "My-ASG"
    max_size = 3
    min_size = 1
    desired_capacity = 2
    default_cooldown     = 120

    launch_template {
        id = var.launch_template_id
        version = "$Latest"
    }

    vpc_zone_identifier = var.public_subnet_ids
    load_balancers = [var.Load_Balancer_name]
}

resource "aws_autoscaling_policy" "My-ASG-Scaling-Policy" {
    name = "My-ASG-Scaling-Policy"
    autoscaling_group_name = aws_autoscaling_group.My-ASG.name
    adjustment_type        = "ChangeInCapacity"
    policy_type            = "TargetTrackingScaling"
    //scaling_adjustment     = 1  # Increase the desired capacity by 1 instance
    target_tracking_configuration {
        target_value            = 60
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
    }
}