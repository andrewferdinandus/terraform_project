## Internet Gateway
resource "aws_internet_gateway" "two_tier_igw" {
  vpc_id = aws_vpc.two_tier.id

  tags = {
    Name = "Internet Gateway"
  }
}

#Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.two_tier.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.two_tier_igw.id
  }
  
  tags = {
    Name = "Public Route Table"
  }

}

#Associate Route Table with public subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}


