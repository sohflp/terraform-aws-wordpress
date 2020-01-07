variable "environment_name" {
}

variable "vpc_id" {
}

variable "vpc_subnet_ids" {
    type = list(string)
}

variable "rds_security_group" {
}

variable "db_username" {
}

variable "db_password" {
}

variable "db_schema" {
}