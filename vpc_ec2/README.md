# AWS VPC Infrastructure with EC2 using Terraform

This Terraform configuration provisions a complete AWS network environment including a custom VPC, subnet, routing, security group, and a web server instance running Apache.

## 🚀 Overview
This project demonstrates Infrastructure as Code (IaC) using Terraform to deploy a basic development environment on AWS.
It automates the creation of:

- A Virtual Private Cloud (VPC)
- Internet Gateway (IGW)
- Route Table and Subnet
- Security Group allowing web and SSH traffic
- Elastic IP (EIP)
- Network Interface (ENI)
- EC2 instance with Apache web server
Once deployed, you’ll have a working web server accessible over the internet.

## 📦 Resources Created
Resource Type	            Name / Description
VPC	                      Creates a custom VPC (10.0.0.0/16)
Internet Gateway	        Enables internet access for the VPC
Route Table	              Routes traffic to the Internet Gateway
Subnet	                  A public subnet in us-east-1b (10.0.1.0/24)
Route Table Association	  Associates subnet with route table
Security Group	          Allows inbound ports 22, 80, and 443
Network Interface (ENI)	  Attached to the subnet and EC2 instance
Elastic IP	              Associates a public IP with the ENI
EC2 Instance	            Ubuntu-based web server running Apache2

## ⚙️ User Data (Web Server Setup)
When the EC2 instance is created, the following script runs automatically:

#!/bin/bash

sudo apt update

sudo apt install apache2 -y

sudo systemctl enable apache2

sudo systemctl start apache2

sudo bash -c 'echo Project Success!! >> /var/www/html/index.html'


It installs Apache, enables it on boot, and creates a test web page at /var/www/html/index.html.

## 🧩 Prerequisites

Before deploying, ensure you have:
AWS Account
Terraform ≥ 1.0 installed
AWS CLI configured (aws configure)
An existing Key Pair in your AWS region (update the key name in the code → key_name = "dev-web")

### ⚡ How to Use
Clone the repository
git clone https://github.com/your-username/terraform-aws-vpc-webserver.git

*cd terraform-aws-vpc-webserver*

### Initialize Terraform:
*terraform init*

### Preview the changes:
*terraform plan*

### Apply the configuration:
*terraform apply --auto-approve*

### Get the public IP:
*terraform output*

### Access your web server
Open a browser and visit:
http://<your-elastic-ip>

### 🧹 Cleanup
To avoid incurring AWS charges, destroy the infrastructure when done:
*terraform destroy*

### 🧠 Notes

The AMI ID (ami-0360c520857e3138f) is region-specific — ensure it’s valid for your AWS region.
The Apache start command in the script has a typo (spache2) — fix to apache2 before applying.
You can adjust subnet CIDRs, region, or instance type as per your environment.

### 📘 Author

#### Andrew Ferdinandus
Senior Linux Engineer
[LinkedIn](https://www.linkedin.com/in/andrew-ferdinandus/)


