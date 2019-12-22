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

  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
  vpc_security_group_ids = ["${var.rds_security_group}"]

  skip_final_snapshot    = true

  tags = {
    Environment = "${var.environment_name}"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = "${var.vpc_subnet_group}"

  tags = {
    Name        = "DB Subnet Group",
    Environment = "${var.environment_name}"
  }
}