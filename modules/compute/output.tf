output "alb_endpoint" {
  value = "${aws_alb.wp-alb.dns_name}"
}