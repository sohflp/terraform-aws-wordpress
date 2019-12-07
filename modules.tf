module "database" {
  source           = "./modules/database/"
  environment_name = "${var.environment_name}"
  username         = "${var.username}"
  password         = "${var.password}"
/* 
  vpc_id           = module.network.vpc_id
  db_subnet_group  = module.network.db_subnet_group_name
*/
}

module "compute" {
  source           = "./modules/compute/"
/*   
  vpc_id           = module.network.vpc_id
  public_subnets   = module.network.public_subnets
  environment_name = var.environment_name
  efs_host         = module.efs.efs_host
  dns_root         = var.dns_root
  seeder_host      = module.seeder.seeder_host 
*/
}