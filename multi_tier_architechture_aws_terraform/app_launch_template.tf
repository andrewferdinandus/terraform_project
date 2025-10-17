resource "aws_launch_template" "app" {
  
    name = var.app_launch_template.name
    image_id = var.app_launch_template.ami
    instance_type = var.app_launch_template.instance_type
    key_name = var.app_launch_template.key_name
   
    network_interfaces {
    device_index                  = 0
    security_groups               = [aws_security_group.app_sec_group.id]
    associate_public_ip_address   = var.app_launch_template.associate_public_ip_address 
    delete_on_termination         = var.app_launch_template.delete_on_termination

  }
  tag_specifications {
        resource_type = "instance"
        tags = {
        Name = var.app_launch_template.name
        }
    }

  
}

resource "aws_autoscaling_group" "app_tier_auto" {
  name = var.auto_scale_app.name
  vpc_zone_identifier = [
    aws_subnet.private_app["0"].id,  
    aws_subnet.private_app["1"].id,  
  ]
  desired_capacity   = var.auto_scale_app.desired_capacity
  max_size           = var.auto_scale_app.max_size
  min_size           = var.auto_scale_app.min_size
  target_group_arns  = [aws_lb_target_group.inlbr_target_group.arn]
  health_check_type  = var.auto_scale_app.health_check_type
  health_check_grace_period = var.auto_scale_app.health_check_grace_period
  

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = var.app_launch_template.strategy
    preferences {
      min_healthy_percentage = 90
    }
    
  }

    tag {
        key                 = var.auto_scale_app.key
        value               = var.app_launch_template.name
        propagate_at_launch = var.app_launch_template.propagate_at_launch
    }

}
