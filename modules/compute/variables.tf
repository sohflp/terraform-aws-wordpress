variable "environment_name" {
}

variable "vpc_id" {
}

variable "vpc_public_subnet_ids" {
    type = list(string)
}

variable "vpc_app_subnet_ids" {
    type = list(string)
}

variable "alb_security_group" {
}

variable "ec2_security_group" {
}

variable "ec2_key" {
}

variable "ec2_ami" {
}

variable "db_username" {
}

variable "db_password" {
}

variable "db_schema" {
}

variable "db_endpoint" {
}