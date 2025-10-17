resource "aws_launch_template" "web" {
  
    name = var.web_launch_template.name
    image_id = var.web_launch_template.ami
    instance_type = var.web_launch_template.instance_type
    key_name = var.web_launch_template.key_name
   
    network_interfaces {
    device_index                  = 0
    security_groups               = [aws_security_group.web_sec_group.id]
    associate_public_ip_address   = var.web_launch_template.associate_public_ip_address 
    delete_on_termination         = var.web_launch_template.delete_on_termination

  }
  tag_specifications {
        resource_type = "instance"
        tags = {
        Name = var.web_launch_template.name
        }
    }

    user_data = filebase64("user_data.sh")
}

resource "aws_autoscaling_group" "web_tier_auto" {
  name = var.auto_scale_web.name
  vpc_zone_identifier = [
    aws_subnet.public_web["0"].id,  
    aws_subnet.public_web["1"].id,  
  ]
  desired_capacity   = var.auto_scale_web.desired_capacity
  max_size           = var.auto_scale_web.max_size
  min_size           = var.auto_scale_web.min_size
  target_group_arns  = [aws_lb_target_group.exlbr_target_group.arn]
  health_check_type  = var.auto_scale_web.health_check_type
  health_check_grace_period = var.auto_scale_web.health_check_grace_period
  

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = var.web_launch_template.strategy
    preferences {
      min_healthy_percentage = 90
    }
    
  }

    tag {
        key                 = var.auto_scale_web.key
        value               = var.web_launch_template.name
        propagate_at_launch = var.web_launch_template.propagate_at_launch
    }

}
