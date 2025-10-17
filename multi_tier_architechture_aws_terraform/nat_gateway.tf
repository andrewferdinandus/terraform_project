# NAT GW for each per AZ
resource "aws_eip" "nat" {
  for_each = aws_subnet.public_web
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  for_each      = aws_subnet.public_web
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id  
  depends_on    = [
    aws_internet_gateway.multi_tier_igw
  ]
}

resource "aws_route_table" "private_route" {
  for_each = aws_nat_gateway.nat_gw
  vpc_id   = aws_vpc.multi_tier.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
  }
}

# Associate each private subnet to its AZ's private route table
resource "aws_route_table_association" "private_app" {
  for_each       = aws_subnet.private_app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route[each.key].id
}

resource "aws_route_table_association" "private_db" {
  for_each       = aws_subnet.private_db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route[each.key].id
}