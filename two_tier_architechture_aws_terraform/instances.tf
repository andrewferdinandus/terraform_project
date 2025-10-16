locals {
  app_subnets = [for s in aws_subnet.public : s.id]
}

resource "aws_instance" "app_servers" {
    count           = length(local.app_subnets)
    ami             = var.instance_cfg.ami
    instance_type   = var.instance_cfg.instance_type
    subnet_id       = local.app_subnets[count.index]
    security_groups = [ aws_security_group.app_sec_group.id ]
    key_name        = var.instance_cfg.key_name
    user_data_base64       = filebase64("userdata.sh")

  tags = {
    Name            = "${var.instance_cfg.name}-${count.index + 1}"
  }
}


resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "db_user"
  password             = var.db_master_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  db_subnet_group_name    = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids  = [aws_security_group.db_sec_group.id]
  publicly_accessible     = false

  multi_az                = false        
  deletion_protection     = false
  

  tags = {
    Name = "Database Server"
  }
}

