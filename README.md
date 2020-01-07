# Project: terraform-aws-wordpress
Wordpress deploy in AWS via Terraform (DNX Mentoring).

# Modules
There are 4 main modules in this project:
* Network
* Security
* Compute
* Database

# Network
The following resources are provisioned by this module:
* Custom VPC
* Subnets
* * Public
* * Application (Private)
* * Data (Private)

# Security
The following resources are provisioned by this module:
* Security Groups
* * Internet Firewall
* * Web Server
* * DB

# Compute
The following resources are provisioned by this module:
* Auto Scaling Group
* Launch Configuration
* Application Load Balancer
* Listener (and Listener Rules)

# Database
The following resources are provisioned by this module:
* RDS (MySQL)

# AWS Access
HashiCorp doesn't recommend the use of access variables in the scripts, for this reason we should access the AWS account via AWS CLI using the default profile configured in the local machine.

# Input Variables
Create a file with the name wordpress.auto.tfvars to auto-populate the mandatory input variables.