output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "vpc_public_subnets" {
    value = "${data.aws_subnet_ids.public.ids}"
}

output "vpc_app_subnets" {
    value = "${data.aws_subnet_ids.app.ids}"
}

output "vpc_data_subnets" {
    value = "${data.aws_subnet_ids.data.ids}"
}