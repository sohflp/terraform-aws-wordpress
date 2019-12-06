resource "aws_instance" "wordpress" {
  ami           = "${var.ami["amazon-linux2-x86"]}"
  instance_type = "t2.micro"
  key_name      = "webserver"
}