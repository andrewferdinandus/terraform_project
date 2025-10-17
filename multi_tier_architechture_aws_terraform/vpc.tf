resource "aws_vpc" "multi_tier" {
  cidr_block       = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true

  tags = {
    Name = var.main_vpc.name
  }
}
