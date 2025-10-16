variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_cfg" {
  description = "Common settings for app instances"
  type = object({
    ami           : string
    instance_type : string
    name          : string
    key_name      : string
    user_data_file: string
  })
  default = {
    ami            = "ami-0341d95f75f311023"
    instance_type  = "t2.micro"
    name           = "application-fleet"
    key_name       = "dev-web"
    user_data_file = "userdata.sh"
  }
}

variable "app_lb" {
  description = "Application LoadBalancer"
  type = object({
    name = string
    internal = bool
    load_balancer_type = string
  })
  default = {
    name = "tier-two-listener"
    internal = false
    load_balancer_type = "application"
  }
}

variable "db_subnets" {
  type = object({
    name = string
  })
  default = {
    name = "database-subnet"
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

