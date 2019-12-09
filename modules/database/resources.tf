resource "aws_db_instance" "wp-mysql" {
  name                  = "wordpress_database"
  identifier            = "wp-terraform-db"
  
  allocated_storage     = 20
  max_allocated_storage = 100

  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  parameter_group_name  = "default.mysql5.7"

  username              = "${var.db_username}"
  password              = "${var.db_password}"

  skip_final_snapshot   = true
}