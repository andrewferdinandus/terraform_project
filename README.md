# 🌩️ Multi-Tier AWS Architecture with Terraform

This project demonstrates how to deploy a **highly available and scalable three-tier architecture** on **AWS** using **Terraform**.  
It automates the provisioning of networking, compute, security, load balancing, and database layers across multiple Availability Zones (AZs).

---

## 🏗️ Architecture Summary

This Terraform setup builds a **multi-tier AWS environment** following production best practices:
Internet
│
[Internet Gateway]
│
[External ALB] → [Web Auto Scaling Group]
│
[Internal ALB] → [App Auto Scaling Group]
│
[Amazon RDS MySQL - DB Subnet Group]

---

## 🧩 Core Components

| Layer | Resources | Description |
|-------|------------|-------------|
| **Networking** | VPC, Subnets (Public, Private App, Private DB), Route Tables, NAT Gateways | Provides isolated and secure network zones |
| **Web Tier** | External ALB, Launch Template, Auto Scaling Group | Public-facing tier serving HTTP traffic |
| **Application Tier** | Internal ALB, Launch Template, Auto Scaling Group | Private tier running internal app workloads |
| **Database Tier** | Amazon RDS (MySQL), DB Subnet Group | Managed database in private subnets |
| **Security** | Tier-based Security Groups | Enforces least-privilege communication between layers |
| **High Availability** | Multi-AZ (us-east-1a & us-east-1b) | Ensures fault tolerance across zones |

---

## 🗂️ Terraform File Structure

```text
├── provider.tf # AWS provider configuration
├── variables.tf # Input variables with defaults
├── vpc.tf # Main VPC creation
├── subnets.tf # Public, App, and DB subnets
├── internetgateway.tf # Internet Gateway and public routes
├── natgateway.tf # NAT Gateways and private route tables
├── security_group.tf # Security groups for all tiers
├── loadbalancer.tf # ALBs (External & Internal) and target groups
├── web_launch_template.tf # Web Launch Template + Auto Scaling Group
├── app_launch_template.tf # App Launch Template + Auto Scaling Group
├── db_instance.tf # Amazon RDS MySQL instance
├── userdata.sh # EC2 initialization script
└── output.tf # Outputs (ALB DNS, VPC ID, etc.)
```
---

## ⚙️ How to Deploy

### 1️⃣ Initialize Terraform
```bash
terraform init
```

2️⃣ Validate configuration

```bash
terraform validate
```

3️⃣ Review plan

```bash
terraform plan 
```

4️⃣ Apply configuration

```bash
terraform apply 
```

5️⃣ Destroy environment

```bash
terraform destroy
```

## 🔐 Security Group Rules Overview
| Security Group      | Ingress                                       | Egress | Description              |
| ------------------- | --------------------------------------------- | ------ | ------------------------ |
| **ALB SG**          | 80/tcp from `0.0.0.0/0`                       | All    | Public web access        |
| **Web SG**          | 80/tcp from ALB SG<br>22/tcp from `0.0.0.0/0` | All    | Web server access        |
| **Internal ALB SG** | 80/tcp from Web Tier                          | All    | App load balancer access |
| **App SG**          | 80/tcp from Internal ALB SG                   | All    | App instances            |
| **DB SG**           | 3306/tcp from App SG                          | All    | MySQL database           |




## 🌐 Network CIDR Configuration
| Subnet Type             | CIDR Block                   | Availability Zones      |
| ----------------------- | ---------------------------- | ----------------------- |
| **VPC**                 | `10.0.0.0/16`                | us-east-1a / us-east-1b |
| **Public Web Subnets**  | `10.0.1.0/24`, `10.0.2.0/24` | Web Tier                |
| **Private App Subnets** | `10.0.3.0/24`, `10.0.4.0/24` | App Tier                |
| **Private DB Subnets**  | `10.0.5.0/24`, `10.0.6.0/24` | Database Tier           |


## 📊 Architecture Visualization
This diagram illustrates traffic flow from the Internet → External ALB → Web Tier → Internal ALB → App Tier → Database Subnet Group (RDS).

## 🚀 Key Highlights

✅ Fully automated multi-AZ deployment

✅ Tiered security group model

✅ Private subnets with NAT gateways

✅ Launch Templates + Auto Scaling Groups

✅ Dual load balancers (External + Internal)

✅ RDS MySQL with private endpoint

✅ Reusable modular Terraform design


## 👤 Author
**Andrew Ferdinandus** <br>
💻 Senior Linux / Systems Engineer <br>
📍 New Zealand <br>
🔗 [GitHub Profile](https://github.com/andrewferdinandus)  |  [LinkedIn](https://www.linkedin.com/in/andrew-ferdinandus/)

