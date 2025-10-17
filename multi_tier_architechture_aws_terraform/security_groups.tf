#ALB Security Group
resource "aws_security_group" "alb_sec_group" {
  name   = var.alb_sec_group.name
  vpc_id = aws_vpc.multi_tier.id
  description = var.alb_sec_group.description

  ingress {
    description      = "Allow HTTP Traffic" 
    from_port        = 80
    to_port          = 80
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
  tags = {
    name = var.alb_sec_group.name
  }
}

#Web Tier Security Group
resource "aws_security_group" "web_sec_group" {
  name   = var.web_sec_group.name
  vpc_id = aws_vpc.multi_tier.id
  description = var.web_sec_group.description

  ingress {
    description      = "Allow HTTP Traffic" 
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [ aws_security_group.alb_sec_group.id]

  }

  ingress {
    description      = "Allow SSH Traffic" 
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] #Allow specific IP based on your requirement

  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    name = var.web_sec_group.name
  }
}

# APP ALB Security Group
resource "aws_security_group" "alb_int_sec_group" {
  name   = var.alb_int_sec_group.name
  vpc_id = aws_vpc.multi_tier.id
  description = var.alb_int_sec_group.description

  ingress {
    description      = "Allow HTTP Traffic" 
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["10.0.1.0/24", "10.0.2.0/24"]
    security_groups = [aws_security_group.web_sec_group.id]

  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    name = var.alb_int_sec_group.name
  }
}

# App Tier Security Group
resource "aws_security_group" "app_sec_group" {
  name   = var.app_sec_group.name
  vpc_id = aws_vpc.multi_tier.id
  description = var.app_sec_group.description

  ingress {
    description      = "Allow HTTP Traffic" 
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [ aws_security_group.alb_int_sec_group.id]

  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    name = var.app_sec_group.name
  }
}

# DB Tier Security Group
resource "aws_security_group" "db_sec_group" {
  name   = var.db_sec_group.name
  vpc_id = aws_vpc.multi_tier.id
  description = var.db_sec_group.description

  ingress {
    description      = "Allow MySQL Traffic" 
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [ aws_security_group.app_sec_group.id]

  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    name = var.db_sec_group.name
  }
}

