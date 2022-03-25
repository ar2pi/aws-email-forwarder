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

# resource "aws_subnet" "private_subnets" {
#   count = length(var.azs)

#   vpc_id     = module.vpc.vpc_id
#   cidr_block = var.private_subnets[count.index]
#   tags = {
#     Name = "${local.service_env}-subnet-private${count.index + 1}-${var.azs[count.index]}"
#   }
# }

# resource "aws_subnet" "public_subnets" {
#   count = length(var.azs)

#   vpc_id     = module.vpc.vpc_id
#   cidr_block = var.public_subnets[count.index]
#   tags = {
#     Name = "${local.service_env}-subnet-public${count.index + 1}-${var.azs[count.index]}"
#   }
# }

# resource "aws_route_table" "private" {
#   count = length(var.azs)

#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name = "${local.service_env}-nat-public${count.index + 1}-${var.azs[count.index]}"
#   }
# }
