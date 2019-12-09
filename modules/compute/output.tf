output "ec2_security_group" {
  value = "${aws_security_group.sg-wp-ec2.id}"
}

output "alb_endpoint" {
  value = "${aws_alb.wp-alb.dns_name}"
}