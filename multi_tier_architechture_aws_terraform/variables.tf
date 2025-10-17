variable "region" {
  default = "us-east-1"
}

variable "main_vpc" {
  type = object({
    name = string
    enable_dns_hostnames = bool
    enable_dns_support = bool

  })
  default = {
    name = "Multi Tier VPC"
    enable_dns_hostnames = true
    enable_dns_support = true
  }
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_web_subnet_cidrs" {
  description = "Public Web Subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "Private App Subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "Private DB Subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "db_subnets" {
  type = object({
    name = string
  })
  default = {
    name = "database subnet"
  }
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}


variable "web_launch_template" {
  type = object({
    name = string
    ami = string
    instance_type = string
    key_name = string
    propagate_at_launch = bool
    strategy = string
    associate_public_ip_address = bool 
    delete_on_termination        = bool
   
  })
  default = {
    name = "web_template"
    ami = "ami-0341d95f75f311023"
    instance_type = "t2.micro"
    key_name = "dev-web"
    propagate_at_launch = true
    strategy = "Rolling"
    associate_public_ip_address = true 
    delete_on_termination        = true
  }
}

variable "alb_external" {
  type = object({
    name = string
    internal = bool
    load_balancer_type = string
    Environment = string
    
  })
  default = {
    name = "alb-external"
    internal = false
    load_balancer_type = "application"
    Environment = "production"
  }
}

variable "ext_lb_target_grp" {
  type = object({
    name = string
    port = number
    protocol = string
    path = string
    matcher = string
    healthy_threshold = number
    unhealthy_threshold = number
    interval = number
    timeout = number
  })
  default = {
    name = "ext-target-group"
    port = 80
    protocol = "HTTP"
    path = "/"
    matcher = "200-399"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
  }
}

variable "ext_lb_listener" {
  type = object({
    name = string
    port = string
    protocol = string
    type = string
  })
  default = {
    name = "Ext LB Listerner"
    port = "80"
    protocol = "HTTP"
    type   = "forward"
  }
}

variable "auto_scale_web" {
  type = object({
    name = string
    desired_capacity = number
    max_size = number
    min_size = number
    health_check_type = string
    health_check_grace_period = number
    key = string
  })
  default = {
    name = "web_asg"
    desired_capacity = 2
    max_size = 4
    min_size = 2
    health_check_type = "ELB"
    health_check_grace_period = 90
    key = "Name"
  }
}

variable "app_launch_template" {
  type = object({
    name = string
    ami = string
    instance_type = string
    key_name = string
    propagate_at_launch = bool
    strategy = string
    associate_public_ip_address = bool 
    delete_on_termination        = bool
   
  })
  default = {
    name = "app_template"
    ami = "ami-0341d95f75f311023"
    instance_type = "t2.micro"
    key_name = "dev-web"
    propagate_at_launch = true
    strategy = "Rolling"
    associate_public_ip_address = false 
    delete_on_termination        = true
  }
}

variable "alb_internal" {
  type = object({
    name = string
    internal = bool
    load_balancer_type = string
    Environment = string
    
  })
  default = {
    name = "alb-internal"
    internal = true
    load_balancer_type = "application"
    Environment = "production"
  }
}


variable "int_lb_target_grp" {
  type = object({
    name = string
    port = number
    protocol = string
    path = string
    matcher = string
    healthy_threshold = number
    unhealthy_threshold = number
    interval = number
    timeout = number
  })
  default = {
    name = "inlb-target-group"
    port = 80
    protocol = "HTTP"
    path = "/"
    matcher = "200-399"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
  }
}


variable "int_lb_listener" {
  type = object({
    name = string
    port = string
    protocol = string
    type = string
  })
  default = {
    name = "Int LB Listerner"
    port = "80"
    protocol = "HTTP"
    type   = "forward"
  }
}

variable "auto_scale_app" {
  type = object({
    name = string
    desired_capacity = number
    max_size = number
    min_size = number
    health_check_type = string
    health_check_grace_period = number
    key = string
  })
  default = {
    name = "app_asg"
    desired_capacity = 2
    max_size = 4
    min_size = 2
    health_check_type = "ELB"
    health_check_grace_period = 90
    key = "Name"
  }
}

variable "alb_sec_group" {
  type = object({
    name = string
    description = string

  })
  default = {
    name = "ALB SG"
    description = "ALB Security Group"
  }
}

variable "alb_int_sec_group" {
  type = object({
    name = string
    description = string

  })
  default = {
    name = "ALB Internal SG"
    description = "ALB Internal Security Group"
  }
}

variable "web_sec_group" {
  type = object({
    name = string
    description = string

  })
  default = {
    name = "WEB SG"
    description = "WEB Security Group"
  }
}

variable "app_sec_group" {
  type = object({
    name = string
    description = string

  })
  default = {
    name = "APP SG"
    description = "APP Security Group"
  }
}

variable "db_sec_group" {
  type = object({
    name = string
    description = string

  })
  default = {
    name = "DB SG"
    description = "DB Security Group"
  }
}

variable "db_master_password" {
  type      = string
  sensitive = true

  validation {
    # 8–41 printable ASCII, no spaces; must NOT contain / @ "
    condition     = length(var.db_master_password) >= 8 && length(var.db_master_password) <= 41 && can(regex("^[!-~]+$", var.db_master_password)) && !can(regex("[/@\"]", var.db_master_password))
    error_message = "Use 8–41 printable ASCII chars, no spaces, and do not include / @ \"."
  }
}

variable "db_instance" {
    type = object({
      name = string
      allocated_storage = number
      db_name = string
      engine = string
      engine_version = string
      instance_class = string
      username = string
      parameter_group_name = string
      skip_final_snapshot = bool
      publicly_accessible = bool
      multi_az = bool
      deletion_protection = bool
    })
    default = {
      name = "Database Server"
      allocated_storage    = 10
      db_name              = "mydb"
      engine               = "mysql"
      engine_version       = "8.0"
      instance_class       = "db.t3.micro"
      username             = "db_user"
      parameter_group_name = "default.mysql8.0"
      skip_final_snapshot  = true
      publicly_accessible     = false
      multi_az                = false        
      deletion_protection     = false
    }
  
}