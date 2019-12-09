module "database" {
  source           = "./modules/database/"
  environment_name = "${var.environment_name}"
  db_username      = "${var.db_username}"
  db_password      = "${var.db_password}"
/* 
  vpc_id           = module.network.vpc_id
  db_subnet_group  = module.network.db_subnet_group_name
*/
}

module "compute" {
  source             = "./modules/compute/"
  environment_name   = "${var.environment_name}"
  vpc_id             = "${var.vpc_id}"
  vpc_public_subnets = "${var.vpc_public_subnets}"
  ec2_key            = "${var.ec2_key}"
  ec2_ami            = "${var.ec2_ami}"
/*   
  vpc_id           = module.network.vpc_id
  public_subnets   = module.network.public_subnets
  environment_name = var.environment_name
  efs_host         = module.efs.efs_host
  dns_root         = var.dns_root
  seeder_host      = module.seeder.seeder_host 
*/
}