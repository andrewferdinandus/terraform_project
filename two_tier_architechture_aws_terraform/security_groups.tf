#LBR Security Group
resource "aws_security_group" "lbr_sec_group" {
  name   = "LBR Security Group"
  vpc_id = aws_vpc.two_tier.id
  description = "Allow HTTP/HTTPS from internet to ALB"

  ingress {
    description      = "Allow HTTP Traffic" 
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    description      = "Allow HTTPS Traffic" 
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#Application Security Group
resource "aws_security_group" "app_sec_group" {
  name   = "APP Security Group"
  vpc_id = aws_vpc.two_tier.id
  description = "Allow app traffic from ALB; restrict management access"

#Allow based on your target group. if it is 80 or 443. In this example I allow bith 80/443 for testing purpose
  ingress {
    description      = "Allow HTTPS Traffic" 
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lbr_sec_group.id]
  }

  ingress {
    description      = "Allow HTTP Traffic" 
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lbr_sec_group.id]
  }

  #This is OPTIONAL: You can use your methd of connection to ssh. This is just an example
  ingress {
    description      = "Allow SSH Traffic" 
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress  {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }

}

#RDS Security Group
resource "aws_security_group" "db_sec_group" {
  name   = "DB Security Group"
  vpc_id = aws_vpc.two_tier.id
  description = "Allow DB from app tier only"

  ingress {
    description      = "Allow MySQL Traffic" 
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [aws_security_group.app_sec_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }

}