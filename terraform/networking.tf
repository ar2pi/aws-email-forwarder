module "vpc" {
  source = "./modules/aws-vpc"

  env          = var.env
  service_name = var.service_name

  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = false
  enable_ipv6        = false
}
