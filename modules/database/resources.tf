resource "aws_db_instance" "wp-mysql" {
  name                   = "${var.db_schema}"
  username               = "${var.db_username}"
  password               = "${var.db_password}"
  
  allocated_storage      = 20
  max_allocated_storage  = 100

  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  parameter_group_name   = "default.mysql5.7"

  vpc_security_group_ids = ["${aws_security_group.sg-wp-rds.id}"]

  skip_final_snapshot    = true

  tags = {
    Environment = "${var.environment_name}"
  }
}

resource "aws_security_group" "sg-wp-rds" {
  name   = "WordPress - EC2 to RDS"
  vpc_id = "${var.vpc_id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    security_groups = ["${var.ec2_security_group}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.environment_name}"
  }
}