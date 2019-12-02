resource "aws_instance" "wordpress" {
  ami           = "ami-009281f19e36b3eb9"
  instance_type = "t2.micro"
}