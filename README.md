# Project: terraform-aws-wordpress
Wordpress deploy in AWS via Terraform

# Best Practices
HashiCorp doesn't recommend the use of access variables in the scripts, for this reason we should access the AWS account via AWS CLI using the default profile configured in the same machine.
