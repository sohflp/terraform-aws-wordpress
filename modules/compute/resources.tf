#############################################
#   LAUNCH CONFIG and AUTO SCALING
#############################################

resource "aws_launch_configuration" "wp-launchconfig" {
  name = "wordpress_launchconfig"

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  instance_type           = "t2.micro"
  image_id                = "${var.ec2_ami["amazon-linux2-x86"]}"
  key_name                = "${var.ec2_key}"
  security_groups         = ["${var.ec2_security_group}"]

  user_data_base64 = "${base64encode(data.template_file.userdata.rendered)}"
}

resource "aws_autoscaling_group" "wp-autoscaling" {
  health_check_type         = "EC2"
  health_check_grace_period = 300
  vpc_zone_identifier       = "${var.vpc_subnet_group}"
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 2
  launch_configuration      = "${aws_launch_configuration.wp-launchconfig.name}"

  tags = [
    {
      key                 = "Environment"
      value               = "${var.environment_name}"
      propagate_at_launch = true
    }
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
#   ALB, TARGET GROUPS and LISTENERS
#############################################

resource "aws_alb" "wp-alb" {
  name               = "wordpress-alb"
  load_balancer_type = "application"
  subnets            = "${var.vpc_subnet_group}"
  security_groups    = ["${var.alb_security_group}"]
  internal           = false

  tags = {
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