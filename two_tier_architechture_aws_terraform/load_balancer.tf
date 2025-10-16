resource "aws_lb_target_group" "lbr_target_group" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.two_tier.id

  health_check {
    path                = "/"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

    tags = {
        Name = "Two Tier LB Target Group"
    }

}

resource "aws_lb_target_group_attachment" "app" {
  count            = length(aws_instance.app_servers) 
  target_group_arn = aws_lb_target_group.lbr_target_group.arn
  target_id        = aws_instance.app_servers[count.index].id
  port             = 80
}

locals {
  public_subnet_ids = [for s in aws_subnet.public : s.id]
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = local.public_subnet_ids[0]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = local.public_subnet_ids[1]
  route_table_id = aws_route_table.public.id
}


resource "aws_lb" "two-tier-lb" {
  name               = var.app_lb.name
  internal           = var.app_lb.internal
  load_balancer_type = var.app_lb.load_balancer_type
  security_groups    = [aws_security_group.lbr_sec_group.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.two-tier-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lbr_target_group.arn
  }
}
