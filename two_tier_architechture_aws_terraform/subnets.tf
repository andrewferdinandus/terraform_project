locals {
  public_defs = {
    for idx, cidr in var.public_subnet_cidrs :
    idx => { cidr = cidr, az = var.azs[idx] }
  }

  private_defs = {
    for idx, cidr in var.private_subnet_cidrs :
    idx => { cidr = cidr, az = var.azs[idx] }
  }
}

# Public subnets
resource "aws_subnet" "public" {
  for_each                = local.public_defs
  vpc_id                  = aws_vpc.two_tier.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${each.key + 1}"
    Tier = "public"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  for_each          = local.private_defs
  vpc_id            = aws_vpc.two_tier.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "Private Subnet ${each.key + 1}"
    Tier = "private"
  }
}


resource "aws_db_subnet_group" "db_subnets" {
  name       = var.db_subnets.name
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name = var.db_subnets.name
  }
}