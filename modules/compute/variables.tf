variable "environment_name" {
}

variable "vpc_id" {
}

variable "vpc_public_subnets" {
    type = list(string)
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