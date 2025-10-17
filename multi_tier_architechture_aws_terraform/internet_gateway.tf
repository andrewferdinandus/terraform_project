## Internet Gateway
resource "aws_internet_gateway" "multi_tier_igw" {
  vpc_id = aws_vpc.multi_tier.id
  tags = {
    Name = "Internet Gateway"
  }
}

#Public Route Table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.multi_tier.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.multi_tier_igw.id
  }
  
  tags = {
    Name = "Public Route Table"
  }

}

#Associate Route Table with public subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public_web
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route.id
}