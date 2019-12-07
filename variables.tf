variable "environment_name" {
}

variable "username" {
}

variable "password" {
}

# AMI - Amazon Linux 2 AMI (HVM) (64-bit x86)
variable "ami" {
    type    = "map"
    default = {
        "amazon-linux2-x86" = "ami-0119aa4d67e59007c"
        "amazon-linux2-arm" = "ami-0247d2faede737e91"
    }
}

#variable "region" {
#  type = "string"
#  default = "us-east-1"
#}
#
#"${lookup(var.ami, var.region)}"