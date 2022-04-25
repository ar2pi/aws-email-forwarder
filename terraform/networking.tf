module "vpc" {
  source = "./modules/aws-vpc"

  name = local.service_env

  cidr            = var.vpc_cidr
  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway     = var.vpc_enable_nat_gateway
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_ipv6          = true
}
