###################### External Load Balancer #################
#External ALB
resource "aws_lb" "web-alb" {
  name               = var.alb_external.name
  internal           = var.alb_external.internal
  load_balancer_type = var.alb_external.load_balancer_type
  security_groups    = [aws_security_group.alb_sec_group.id]
  subnets            = [for subnet in aws_subnet.public_web : subnet.id]

  tags = {
    Environment = var.alb_external.name
  }
}

resource "aws_lb_target_group" "exlbr_target_group" {
  name     = var.ext_lb_target_grp.name
  port     = var.ext_lb_target_grp.port
  protocol = var.ext_lb_target_grp.protocol
  vpc_id   = aws_vpc.multi_tier.id

  health_check {
    path                = var.ext_lb_target_grp.path
    matcher             = var.ext_lb_target_grp.matcher
    healthy_threshold   = var.ext_lb_target_grp.healthy_threshold
    unhealthy_threshold = var.ext_lb_target_grp.unhealthy_threshold
    interval            = var.ext_lb_target_grp.interval
    timeout             = var.ext_lb_target_grp.timeout
  }

    tags = {
        Name = var.ext_lb_target_grp.name
    }

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = var.ext_lb_listener.port
  protocol          = var.ext_lb_listener.protocol

  default_action {
    type             = var.ext_lb_listener.type
    target_group_arn = aws_lb_target_group.exlbr_target_group.arn
  }
}

###################### Internal Load Balancer #################
#Internal ALB
resource "aws_lb" "app-alb" {
  name               = var.alb_internal.name
  internal           = var.alb_internal.internal
  load_balancer_type = var.alb_internal.load_balancer_type
  security_groups    = [aws_security_group.alb_int_sec_group.id]
  subnets            = [for subnet in aws_subnet.private_app : subnet.id]

  tags = {
    Environment = var.alb_internal.name
  }
}

resource "aws_lb_target_group" "inlbr_target_group" {
  name     = var.int_lb_target_grp.name
  port     = var.int_lb_target_grp.port
  protocol = var.int_lb_target_grp.protocol
  vpc_id   = aws_vpc.multi_tier.id

  health_check {
    path                = var.int_lb_target_grp.path
    matcher             = var.int_lb_target_grp.matcher
    healthy_threshold   = var.int_lb_target_grp.healthy_threshold
    unhealthy_threshold = var.int_lb_target_grp.unhealthy_threshold
    interval            = var.int_lb_target_grp.interval
    timeout             = var.int_lb_target_grp.timeout
  }

    tags = {
        Name = var.int_lb_target_grp.name
    }

}

resource "aws_lb_listener" "backend_end" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = var.int_lb_listener.port
  protocol          = var.int_lb_listener.protocol

  default_action {
    type             = var.int_lb_listener.type
    target_group_arn = aws_lb_target_group.inlbr_target_group.arn
  }
}

