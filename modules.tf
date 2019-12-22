module "security" {
  source             = "./modules/security/"
  environment_name   = "${var.environment_name}"
  vpc_id             = "${var.vpc_id}"
}

module "database" {
  source             = "./modules/database/"
  environment_name   = "${var.environment_name}"
  vpc_id             = "${var.vpc_id}"
  vpc_subnet_group   = "${var.vpc_public_subnets}"
  rds_security_group = "${module.security.rds_security_group}"
  db_schema          = "${var.db_schema}"
  db_username        = "${var.db_username}"
  db_password        = "${var.db_password}"
}

module "compute" {
  source             = "./modules/compute/"
  environment_name   = "${var.environment_name}"
  vpc_id             = "${var.vpc_id}"
  vpc_subnet_group   = "${var.vpc_public_subnets}"
  alb_security_group = "${module.security.alb_security_group}"
  ec2_security_group = "${module.security.ec2_security_group}"
  ec2_key            = "${var.ec2_key}"
  ec2_ami            = "${var.ec2_ami}"
  db_schema          = "${var.db_schema}"
  db_username        = "${var.db_username}"
  db_password        = "${var.db_password}"
  db_endpoint        = "${module.database.db_endpoint}"
}