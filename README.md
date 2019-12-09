# Project: terraform-aws-wordpress
Wordpress deploy in AWS via Terraform (DNX Mentoring).

# Modules
There are 2 main modules in this project:
* Compute
* Database

# Compute
The following resources are provisioned by this module:
* Auto Scaling Group
* Launch Configuration
* Security Groups
* Application Load Balancer
* Listener (and Listener Rules)

# Database
* RDS (MySQL)
* Security Groups

# Security
HashiCorp doesn't recommend the use of access variables in the scripts, for this reason we should access the AWS account via AWS CLI using the default profile configured in the local machine.

# Variables
Create a file with the name wordpress.auto.tfvars to auto-populate the mandatory input variables.