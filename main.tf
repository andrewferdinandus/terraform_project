# Create a VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Dev VPC"
  }
}

#Internet gateway to routr traffic
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "Dev igw"
  }
}

#Routing table to forward all traffic to igw
resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
    
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  tags = {
    Name = "Dev Route Table"
  }
}

#Create Subnet under VPC "dev-vpc"
resource "aws_subnet" "dev-sub-1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"
  #setup in a specific availability zone if needed
  availability_zone = "us-east-1b"

  tags = {
    Name = "Dev Subnet 1"
  }
}

# Associate the route table with the Dev subnet 1 
resource "aws_route_table_association" "route-dev-sub1" {
  subnet_id      = aws_subnet.dev-sub-1.id
  route_table_id = aws_route_table.dev-route-table.id
}

# Create security group and allow ports 22,80,443
resource "aws_security_group" "dev-sec-group" {
  name   = "Dev Security Group"
  vpc_id = aws_vpc.dev-vpc.id

  ingress {
    description  = "Allow HTTPS Traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH Traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   tags = {
    Name = "Allow Web and SSH"
  }
}

#Create a Network Interface Card
resource "aws_network_interface" "Dev-vm-nic1" {
  subnet_id       = aws_subnet.dev-sub-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.dev-sec-group.id]

}

#Create EIP and attache to NIC
resource "aws_eip" "dev-ins-eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.Dev-vm-nic1.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_internet_gateway.dev-gw ]
}

#Create instance
resource "aws_instance" "webdev-instance" {
  ami = "ami-0360c520857e3138f"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  key_name = "dev-web"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.Dev-vm-nic1.id
  }
  
  user_data = <<'EOF'
    #!/bin/bash
    set -e
    (yum -y update || dnf -y update)
    (yum -y install httpd || dnf -y install httpd)
    systemctl enable --now httpd
    echo 'Project Success!!' > /var/www/html/index.html
    EOF

  tags = {
    Name = "Development Web Server"
  }
}