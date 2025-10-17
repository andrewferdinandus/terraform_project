output "lb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.web-alb.dns_name
}