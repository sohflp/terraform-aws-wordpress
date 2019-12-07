resource "aws_db_instance" "mysql" {
  name                  = "wordpress_db"
  
  allocated_storage     = 20
  max_allocated_storage = 100

  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  parameter_group_name  = "default.mysql5.7"

  username              = "${var.username}"
  password              = "${var.password}"

  skip_final_snapshot   = true
}