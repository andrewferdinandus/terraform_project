output "lb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.two-tier-lb.dns_name
}