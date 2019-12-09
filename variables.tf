variable "environment_name" {
}

variable "vpc_id" {
}

variable "vpc_public_subnets" {
    type = list(string)
}

variable "ec2_key" {
}

# AMI - Amazon Linux 2 AMI (HVM) (64-bit x86)
variable "ec2_ami" {
    type    = "map"
    default = {
        "amazon-linux2-x86" = "ami-0119aa4d67e59007c"
        "amazon-linux2-arm" = "ami-0247d2faede737e91"
    }
}

variable "db_username" {
}

variable "db_password" {
}

#variable "region" {
#  type = "string"
#  default = "us-east-1"
#}
#
#"${lookup(var.ami, var.region)}"