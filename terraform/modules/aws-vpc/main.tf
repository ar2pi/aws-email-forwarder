locals {
  vpc_name = "${var.service_name}-${var.env}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = var.cidr
  azs  = var.azs

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_ipv6        = var.enable_ipv6
  enable_nat_gateway = var.enable_nat_gateway
}
