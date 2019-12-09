#############################################
#   EC2, LAUNCH CONFIG and AUTO SCALING
#############################################

resource "aws_launch_template" "wp-launchconfig" {
  name = "wordpress_launchconfig"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  disable_api_termination = false
  instance_type           = "t2.micro"
#  image_id                = data.aws_ami.base_image.id
  image_id                = "${var.ec2_ami["amazon-linux2-x86"]}"
  key_name                = "${var.ec2_key}"
  vpc_security_group_ids  = ["${aws_security_group.sg-wp-ec2.id}"]

  user_data = base64encode(data.template_file.userdata.rendered)

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Terraform   = "true"
      Environment = "${var.environment_name}"
    }
  }
}

resource "aws_autoscaling_group" "wp-autoscaling" {
  health_check_type         = "EC2"
  health_check_grace_period = 300
  vpc_zone_identifier       = "${var.vpc_public_subnets}"
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1

  launch_template {
    id      = "${aws_launch_template.wp-launchconfig.id}"
#    version = "$Latest"
  }

  tags = [
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment_name}"
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscaling_policy" "wp-asgpolicy" {
  name                   = "WordPress Web ASG Policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 360
  autoscaling_group_name = "${aws_autoscaling_group.wp-autoscaling.name}"
}

#############################################
#   SECURITY GROUPS
#############################################

resource "aws_security_group" "sg-wp-alb" {
  name   = "WordPress - ALB (Public)"
#  vpc_id = var.vpc_id

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_security_group" "sg-wp-ec2" {
  name   = "WordPress - ALB to EC2"
#  vpc_id = var.vpc_id

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    security_groups = ["${aws_security_group.sg-wp-alb.id}"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

#############################################
#   ALB, TARGET GROUPS and LISTENERS
#############################################

resource "aws_alb" "wp-alb" {
  name               = "wordpress-alb"
  load_balancer_type = "application"
  subnets            = "${var.vpc_public_subnets}"
  security_groups    = ["${aws_security_group.sg-wp-alb.id}"]
  internal           = false

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_alb_target_group" "wp-targetgroup" {
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/health.html"
    port                = "80"
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_alb_listener" "wp-alb-listener" {
  load_balancer_arn = "${aws_alb.wp-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.wp-targetgroup.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "wp-alb-listener_rule" {
  depends_on   = [aws_alb_target_group.wp-targetgroup]
  listener_arn = "${aws_alb_listener.wp-alb-listener.arn}"
  priority     = "10"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.wp-targetgroup.id}"
  }

  condition {
    field  = "path-pattern"
    values = ["/"]
  }
}

resource "aws_autoscaling_attachment" "wp-asg-alb-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.wp-targetgroup.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.wp-autoscaling.name}"
}
