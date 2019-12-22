output "alb_security_group" {
    value = "${aws_security_group.sg-wp-alb.id}"
}

output "ec2_security_group" {
    value = "${aws_security_group.sg-wp-ec2.id}"
}

output "rds_security_group" {
    value = "${aws_security_group.sg-wp-rds.id}"
}