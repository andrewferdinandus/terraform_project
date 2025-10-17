
locals {
  public_web_defs = {
    for idx, cidr in var.public_web_subnet_cidrs :
    idx => { cidr = cidr, az = var.azs[idx] }
  }

  private_app_defs = {
    for idx, cidr in var.private_app_subnet_cidrs :
    idx => { cidr = cidr, az = var.azs[idx] }
  }

   private_db_defs = {
    for idx, cidr in var.private_db_subnet_cidrs :
    idx => { cidr = cidr, az = var.azs[idx] }
  }

}

# Public Web Subnets
resource "aws_subnet" "public_web" {
  for_each                = local.public_web_defs
  vpc_id                  = aws_vpc.multi_tier.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true #just for ssh from public

  tags = {
    Name = "Public Web Subnet ${tonumber(each.key) + 1}"
    Tier = "Web Tier"
  }
}

# Private App Subnets
resource "aws_subnet" "private_app" {
  for_each                = local.private_app_defs
  vpc_id                  = aws_vpc.multi_tier.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = "Private App Subnet ${tonumber(each.key) + 1}"
    Tier = "App Tier"
  }
}

# Private DB Subnets
resource "aws_subnet" "private_db" {
  for_each                = local.private_db_defs
  vpc_id                  = aws_vpc.multi_tier.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.db_subnets.name} ${tonumber(each.key) + 1}"
    Tier = "DB Tier"
  }
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = var.db_subnets.name
  subnet_ids = [for subnet in aws_subnet.private_db : subnet.id]

  tags = {
    Name = var.db_subnets.name
  }
}
