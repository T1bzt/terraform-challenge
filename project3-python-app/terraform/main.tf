module "network" {
  source      = "../../modules/network"

}

module "ec2" {
  source      = "../../modules/ec2"
  depends_on = [module.network.aws_internet_gateway]
  vpc_security_group_ids =   [
    module.network.ec2_security_group_id
  ]
  subnet_id = module.network.subnet_id
}

module "rds" {
  source      = "../../modules/rds"
  vpc_id = module.network.vpc_id
  private_subnet_id = module.network.private_subnet_id
}

output "http_hostname" {
  value = module.ec2.http_hostname
}