resource "aws_db_instance" "mysql_db" {
  allocated_storage    = var.db_instance.allocated_storage
  db_name              = var.db_instance.db_name
  engine               = var.db_instance.engine
  engine_version       = var.db_instance.engine_version
  instance_class       = var.db_instance.instance_class
  username             = var.db_instance.username
  password             = var.db_master_password
  parameter_group_name = var.db_instance.parameter_group_name
  skip_final_snapshot  = var.db_instance.skip_final_snapshot

  db_subnet_group_name    = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids  = [aws_security_group.db_sec_group.id]
  publicly_accessible     = var.db_instance.publicly_accessible

  multi_az                = var.db_instance.multi_az    
  deletion_protection     = var.db_instance.deletion_protection
  

  tags = {
    Name = var.db_instance.name
  }
}